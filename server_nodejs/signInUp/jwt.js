const jwt = require('jsonwebtoken');
var db = require('../db.js');

function getToken(uid) {
    const token = jwt.sign(uid, 'thisismynewcourse');
    return token;
}
module.exports = getToken;