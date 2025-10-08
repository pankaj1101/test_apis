// middlewares/errorHandler.js
const errorHandler = (err, req, res, next) => {
  const statusCode = err.statusCode || 500;

  res.status(statusCode).json({
    success: false,
    status: statusCode,
    message: err.customMessage || err.message || "Something went wrong",
    error: {
      name: err.name,
      details: err.message,
    },
  });
};
module.exports = errorHandler;
