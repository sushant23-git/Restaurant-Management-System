const express = require('express');
const router = express.Router();
const RestaurantController = require('../controllers/restaurantController');
const { authenticateToken, authorizeAdmin } = require('../middleware/authMiddleware');

// Public
router.get('/', RestaurantController.getAll);
router.get('/search', RestaurantController.search);
router.get('/:id/menu', RestaurantController.getMenu);

// Admin Only
router.post('/', authenticateToken, authorizeAdmin, RestaurantController.create);
router.put('/:id', authenticateToken, authorizeAdmin, RestaurantController.update);
router.delete('/:id', authenticateToken, authorizeAdmin, RestaurantController.delete);

module.exports = router;
