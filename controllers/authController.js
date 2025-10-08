const jwt = require("jsonwebtoken");
const users = require("../models/userModel");
const refreshTokens = require("../models/tokenStore");
const { JWT_SECRET, JWT_REFRESH_SECRET } = require("../config/jwtConfig");

// Generate Access Token
const generateAccessToken = (user) => {
  return jwt.sign(
    {
      id: user.id,
      name: user.name,
      mobile: user.mobile,
      role: "admin",
      permissions: ["read", "write", "update", "delete"],
    },
    JWT_SECRET,
    { expiresIn: "1m" }
  );
};

// Generate Refresh Token
const generateRefreshToken = (user) => {
  return jwt.sign({ id: user.id, mobile: user.mobile }, JWT_REFRESH_SECRET, {
    expiresIn: "2m",
  });
};

// Login Controller
const login = (req, res, next) => {
  try {
    const { mobile, password } = req.body;

    console.log(`${mobile} ${password}`);
    
    if (!mobile || !password) {
      const error = new Error("Mobile number and password are required");
      error.statusCode = 400;
      throw error;
    }

    const user = users.find(
      (u) => u.mobile === mobile && u.password === password
    );

    if (!user) {
      const error = new Error("Invalid mobile number or password");
      error.statusCode = 400;
      throw error;
    }

    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);

    // Save refresh token
    refreshTokens.push(refreshToken);

    return res.status(200).json({
      message: "Login successful",
      data: {
        id: user.id,
        name: user.name,
        mobile: user.mobile,
        email: user.email,
        role: user.role,
        profileImage: user.profileImage,
        address: user.address,
        createdAt: user.createdAt,
      },
      access_token: accessToken,
      refresh_token: refreshToken,
    });
  } catch (error) {
    console.log(`line 71 :: ${error}`);
    next(error);
  }
};

// Refresh Token Controller
const refreshToken = (req, res) => {
  const { refresh_token } = req.body;

  if (!refresh_token) {
    return res.status(400).json({ message: "Refresh token is required" });
  }

  if (!refreshTokens.includes(refresh_token)) {
    return res.status(403).json({ message: "Invalid refresh token" });
  }
  try {
    // Verify token
    jwt.verify(refresh_token, JWT_REFRESH_SECRET, (err, user) => {
      if (err)
        return res
          .status(403)
          .json({ message: "Invalid or expired refresh token" });

      // Generate new access token
      const newAccessToken = generateAccessToken(user);

      return res.json({
        access_token: newAccessToken,
      });
    });
  } catch (error) {
    error.statusCode = 500;
    next(error);
  }
};

// Get user by ID
const getUserById = (req, res) => {
  try {
    const userId = parseInt(req.query.id);
    const user = users.find((u) => u.id === userId);

    if (!user) {
      const error = Error("User not found");
      error.statusCode = 404;
      throw error;
    }

    return res.status(200).json({
      success: true,
      status: 200,
      message: "User fetched successfully",
      data: {
        id: user.id,
        name: user.name,
        mobile: user.mobile,
        email: user.email,
        role: user.role,
        profileImage: user.profileImage,
        address: user.address,
        createdAt: user.createdAt,
      },
    });
  } catch (error) {
    error.statusCode = 500;
    next(error);
  }
};

// Logout Controller
const logout = (req, res) => {
  const { refresh_token } = req.body;

  if (!refresh_token) {
    return res
      .status(400)
      .json({ message: "Refresh token is required for logout" });
  }

  const index = refreshTokens.indexOf(refresh_token);

  if (index === -1) {
    return res
      .status(400)
      .json({ message: "Refresh token not found or already invalidated" });
  }

  // Remove the token from the store
  refreshTokens.splice(index, 1);

  return res.json({ message: "Logout successful. Refresh token invalidated." });
};

module.exports = { login, refreshToken, getUserById, logout };
