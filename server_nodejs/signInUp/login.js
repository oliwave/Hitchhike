var db = require('../db.js');
var express = require('express');
//var getToken = require('./jwt.js');
const router = new express.Router()

router.get('/login/:uid/:pwd', function (req, res) {
    var uid = req.params.uid;
    var pwd = req.params.pwd;
    //var token = getToken;
    const sql = `select * from user where uid = '${uid}' AND pwd = '${pwd}' `
    db.query(sql, function (err, result) {
        if (err) {
            console.log(err);
        }
        if(result.length > 0){
            console.log(result);
            //send records as a response
            res.status(200);
            res.send("success");
            //res.send(token);
        }
        else{
            res.status(401);
            res.send("fail");
        }
    });
});
module.exports = router;