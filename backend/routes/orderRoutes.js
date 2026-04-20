const express = require('express');
const router = express.Router();
const OrderController = require('../controllers/orderController');
const { authenticateToken, authorizeAdmin } = require('../middleware/authMiddleware');

// User Routes
router.post('/', authenticateToken, OrderController.placeOrder);
router.get('/history', authenticateToken, OrderController.getHistory);
router.get('/:id', authenticateToken, OrderController.getOrderDetails);

// Admin Routes
router.get('/admin/all', authenticateToken, authorizeAdmin, OrderController.getAllPending);
router.put('/:id/status', authenticateToken, authorizeAdmin, OrderController.updateStatus);

module.exports = router;
