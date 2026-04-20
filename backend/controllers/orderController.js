const OrderModel = require('../models/orderModel');

class OrderController {
    static async placeOrder(req, res) {
        try {
            const { restaurant_id, total_price, delivery_address, items } = req.body;
            const userId = req.user.id;
            const orderId = await OrderModel.create(userId, restaurant_id, total_price, delivery_address, items);
            res.status(201).json({ orderId, message: 'Order placed successfully' });
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    static async getHistory(req, res) {
        try {
            const history = await OrderModel.getByUserId(req.user.id);
            res.json(history);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    static async getOrderDetails(req, res) {
        try {
            const details = await OrderModel.getDetails(req.params.id);
            res.json(details);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    // Admin Methods
    static async getAllPending(req, res) {
        try {
            const orders = await OrderModel.getAll();
            res.json(orders);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    static async updateStatus(req, res) {
        try {
            await OrderModel.updateStatus(req.params.id, req.body.status);
            res.json({ message: 'Order status updated' });
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }
}

module.exports = OrderController;
