const UserModel = require('../models/userModel');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
require('dotenv').config();

class AuthController {
    static async register(req, res) {
        try {
            const { full_name, email, password, role } = req.body;
            const existingUser = await UserModel.findByEmail(email);
            if (existingUser) return res.status(400).json({ message: 'Email already exists' });

            const hashedPassword = await bcrypt.hash(password, 10);
            await UserModel.create({ full_name, email, password: hashedPassword, role });

            res.status(201).json({ message: 'User registered successfully' });
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    static async login(req, res) {
        try {
            const { email, password } = req.body;
            const user = await UserModel.findByEmail(email);
            if (!user) return res.status(400).json({ message: 'Invalid email or password' });

            const isMatch = await bcrypt.compare(password, user.password);
            if (!isMatch) return res.status(400).json({ message: 'Invalid email or password' });

            const token = jwt.sign(
                { id: user.user_id, role: user.role, name: user.full_name },
                process.env.JWT_SECRET,
                { expiresIn: '24h' }
            );

            res.json({
                token,
                user: { id: user.user_id, name: user.full_name, email: user.email, role: user.role }
            });
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }
}

module.exports = AuthController;
