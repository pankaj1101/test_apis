const jwt = require("jsonwebtoken");
const { JWT_SECRET } = require("../config/jwtConfig");

// Middleware to authenticate user using JWT
// This middleware checks if the request contains a valid JWT token
const authMiddleware = (req, res, next) => {
  // Get token from request headers
  const token = req.header("Authorization");

  // Check if token exists
  if (!token) {
    const error = new Error("Access denied. No token provided.");
    error.statusCode = 401;
    error.name = "NoTokenError";
    return next(error);
  }

  try {
    // Verify token
    const decoded = jwt.verify(token.replace("Bearer ", ""), JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    error.statusCode = 401;
    next(error);
  }
};

module.exports = authMiddleware;
