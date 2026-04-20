const db = require('../../config/db');

class OrderModel {
    static async create(userId, restaurantId, totalPrice, deliveryAddress, items) {
        const connection = await db.getConnection();
        try {
            await connection.beginTransaction();

            const [orderResult] = await connection.query(
                'INSERT INTO orders (user_id, restaurant_id, total_price, delivery_address) VALUES (?, ?, ?, ?)',
                [userId, restaurantId, totalPrice, deliveryAddress]
            );
            const orderId = orderResult.insertId;

            for (const item of items) {
                await connection.query(
                    'INSERT INTO order_items (order_id, item_id, quantity, price_at_time) VALUES (?, ?, ?, ?)',
                    [orderId, item.item_id, item.quantity, item.price]
                );
            }

            await connection.commit();
            return orderId;
        } catch (err) {
            console.error('[DB ERROR] Order Creation Failed:', err);
            await connection.rollback();
            throw err;
        } finally {
            connection.release();
        }
    }

    static async getByUserId(userId) {
        const [rows] = await db.query(
            'SELECT o.*, r.name as restaurant_name FROM orders o JOIN restaurants r ON o.restaurant_id = r.restaurant_id WHERE o.user_id = ? ORDER BY o.created_at DESC',
            [userId]
        );
        return rows;
    }

    static async getDetails(orderId) {
        const [items] = await db.query(
            'SELECT oi.*, m.name as item_name FROM order_items oi JOIN menu_items m ON oi.item_id = m.item_id WHERE oi.order_id = ?',
            [orderId]
        );
        return items;
    }

    static async getAll() {
        const [rows] = await db.query(
            'SELECT o.*, u.full_name as customer_name, r.name as restaurant_name FROM orders o JOIN users u ON o.user_id = u.user_id JOIN restaurants r ON o.restaurant_id = r.restaurant_id ORDER BY o.created_at DESC'
        );
        return rows;
    }

    static async updateStatus(orderId, status) {
        await db.query('UPDATE orders SET status = ? WHERE order_id = ?', [status, orderId]);
    }
}

module.exports = OrderModel;
