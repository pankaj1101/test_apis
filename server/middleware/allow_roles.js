const allowRoles = (...allowedRoles) => {
    return (req, res, next) => {
        if (!allowedRoles.includes(req.user.role)) {
            return res.status(403).json({
                message: "Access denied: You are not allowed",
                role: req.user.role,
                allowed: allowedRoles,
            });
        }
        next();
    };
};

module.exports = allowRoles;