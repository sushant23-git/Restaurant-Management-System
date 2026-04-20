const db = require('../../config/db');

class RestaurantModel {
    static async getAll() {
        const [rows] = await db.query('SELECT * FROM restaurants');
        return rows;
    }

    static async search(query) {
        const { location, cuisine, minRating } = query;
        let sql = 'SELECT * FROM restaurants WHERE 1=1';
        const params = [];

        if (location) {
            sql += ' AND location LIKE ?';
            params.push(`%${location}%`);
        }
        if (cuisine) {
            sql += ' AND cuisine LIKE ?';
            params.push(`%${cuisine}%`);
        }
        if (minRating) {
            sql += ' AND rating >= ?';
            params.push(minRating);
        }

        const [rows] = await db.query(sql, params);
        return rows;
    }

    static async findById(id) {
        const [rows] = await db.query('SELECT * FROM restaurants WHERE restaurant_id = ?', [id]);
        return rows[0];
    }

    static async getMenu(restaurantId) {
        const [rows] = await db.query(
            'SELECT m.*, c.name as category_name FROM menu_items m JOIN categories c ON m.category_id = c.category_id WHERE m.restaurant_id = ?',
            [restaurantId]
        );
        return rows;
    }

    // Admin Methods
    static async create(data) {
        const { name, description, location, cuisine, image_url } = data;
        const [result] = await db.query(
            'INSERT INTO restaurants (name, description, location, cuisine, image_url) VALUES (?, ?, ?, ?, ?)',
            [name, description, location, cuisine, image_url]
        );
        return result.insertId;
    }

    static async update(id, data) {
        const { name, description, location, cuisine, image_url } = data;
        await db.query(
            'UPDATE restaurants SET name=?, description=?, location=?, cuisine=?, image_url=? WHERE restaurant_id=?',
            [name, description, location, cuisine, image_url, id]
        );
    }

    static async delete(id) {
        await db.query('DELETE FROM restaurants WHERE restaurant_id = ?', [id]);
    }
}

module.exports = RestaurantModel;
