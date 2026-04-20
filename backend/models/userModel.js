const db = require('../../config/db');

class UserModel {
    static async findByEmail(email) {
        const [rows] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        return rows[0];
    }

    static async create(userData) {
        const { full_name, email, password, role } = userData;
        const [result] = await db.query(
            'INSERT INTO users (full_name, email, password, role) VALUES (?, ?, ?, ?)',
            [full_name, email, password, role || 'user']
        );
        return result.insertId;
    }

    static async getAll() {
        const [rows] = await db.query('SELECT user_id, full_name, email, role, created_at FROM users');
        return rows;
    }
}

module.exports = UserModel;
