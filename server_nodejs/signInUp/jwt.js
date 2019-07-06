const jwt = require('jsonwebtoken');

function getToken(){

    const token = jwt.sign(/*user uid*/ , 'thisismynewcourse');
    return token;
}
module.exports = getToken();