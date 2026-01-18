const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/auth.middleware');

router.post('/login', authController.login);
router.post('/refresh-token', authController.refreshToken);
router.get('/dashboard_overview', authMiddleware, authController.dashboardOverview);
router.get('/recent_transaction', authMiddleware, authController.recentTransaction);
router.get('/get-user/', authMiddleware, authController.getUserById);
router.post('/logout', authController.logout);

module.exports = router;
