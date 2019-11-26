const jwt = require('jsonwebtoken');

const auth = (req, res, next) => {
    try {
        const token = req.header('Authorization');
        const decode = jwt.verify(token, 'ncnuIM');
        exports.uid = decode;
        next();
    } catch (e) {
        res.status(401);
        res.send("fail");
    }

}
exports.auth = auth;