const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const authRoutes = require("./routes/authRoutes");
const errorHandler = require("./middleware/errorHandler");

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(
  cors({
    origin: "*", // For demo (allow all)
    // origin: "http://localhost:5000",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
    credentials: false,
  })
);
app.options(/.*/, cors());
// Mount routes
app.use("/api", authRoutes);

// Handle 404
app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    status: 404,
    message: "Route not found",
  });
});

app.use(errorHandler);

app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});
