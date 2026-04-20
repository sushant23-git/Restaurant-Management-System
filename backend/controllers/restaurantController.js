const RestaurantModel = require('../models/restaurantModel');

class RestaurantController {
    static async getAll(req, res) {
        try {
            const restaurants = await RestaurantModel.getAll();
            res.json(restaurants);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    static async search(req, res) {
        try {
            const restaurants = await RestaurantModel.search(req.query);
            res.json(restaurants);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    static async getMenu(req, res) {
        try {
            const menu = await RestaurantModel.getMenu(req.params.id);
            res.json(menu);
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    // Admin Methods
    static async create(req, res) {
        try {
            const id = await RestaurantModel.create(req.body);
            res.status(201).json({ id, message: 'Restaurant created' });
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    static async update(req, res) {
        try {
            await RestaurantModel.update(req.params.id, req.body);
            res.json({ message: 'Restaurant updated' });
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }

    static async delete(req, res) {
        try {
            await RestaurantModel.delete(req.params.id);
            res.json({ message: 'Restaurant deleted' });
        } catch (err) {
            res.status(500).json({ message: err.message });
        }
    }
}

module.exports = RestaurantController;
