const db = require('../../config/db');

class MenuModel {
    static async create(data) {
        const { restaurant_id, category_id, name, description, price, image_url } = data;
        const [result] = await db.query(
            'INSERT INTO menu_items (restaurant_id, category_id, name, description, price, image_url) VALUES (?, ?, ?, ?, ?, ?)',
            [restaurant_id, category_id, name, description, price, image_url]
        );
        return result.insertId;
    }

    static async update(id, data) {
        const { category_id, name, description, price, image_url, is_available } = data;
        await db.query(
            'UPDATE menu_items SET category_id=?, name=?, description=?, price=?, image_url=?, is_available=? WHERE item_id=?',
            [category_id, name, description, price, image_url, is_available, id]
        );
    }

    static async delete(id) {
        await db.query('DELETE FROM menu_items WHERE item_id = ?', [id]);
    }

    static async getCategories() {
        const [rows] = await db.query('SELECT * FROM categories');
        return rows;
    }
}

module.exports = MenuModel;
