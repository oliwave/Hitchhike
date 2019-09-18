var db = require('../db.js');
var express = require('express');
var getToken = require('./jwt.js');
var bodyParser = require('body-parser')

var app = express();
var jsonParser = bodyParser.json();

const router = new express.Router()

router.post('/login',  jsonParser, function (req, res) {
    var uid = req.body.uid;
    var pwd = req.body.pwd;
    var token = getToken(uid);
    const sql = `select * from user where uid = '${uid}' AND pwd = '${pwd}' `
    db.query(sql, function (err, result) {
        if (err) {
            console.log(err);
        }
        if(result.length > 0){
            //send records as a response
            res.status(200);
            // res.send("success");
            res.send({"jwt": token});
        }
        else{
            res.status(401);
            res.send({"status": "fail"});
        }
    });
});
module.exports = router;