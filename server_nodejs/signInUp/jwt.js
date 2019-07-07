const jwt = require('jsonwebtoken');
var db = require('../db.js');

function getToken(uid) {
    const token = jwt.sign(uid, 'ncnuIM');
    return token;
}
module.exports = getToken;