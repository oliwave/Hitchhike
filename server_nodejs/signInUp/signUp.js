var db = require('../db.js');
var express = require('express');
var crypto = require('crypto');
var mailer = require('./mailer.js');
var bodyParser = require('body-parser')

var app = express();
var jsonParser = bodyParser.json();

const router = new express.Router()
// use post
router.post('/signUp', jsonParser,function (req, res) {
    var uid = req.body.uid;
    var pwd = req.body.pwd;
    var name = req.body.name;
    var gender = req.body.gender;
    var birthday = req.body.birthday;
    const sql = `INSERT INTO user (uid, pwd, name, gender, birthday) VALUES ('${uid}', '${pwd}', '${name}', '${gender}', '${birthday}')`;
    db.query(sql, function (err, result) {
        if (err) {
            res.send({"status": "fail"});
            console.log(err);
        }
        else {
            res.send({"status": "success"});
        }
    });
});

//verify ncnu and send emails
router.post('/verify', jsonParser,function (req, res) {
    var uid = req.body.uid;
    email = "s" + uid +"@mail1.ncnu.edu.tw";
    const sql = `select * from user where uid = '${uid}'`;
    db.query(sql, function (err, result) {
        if (err) {
            console.log(err);
        }
        if (result.length > 0) {
            res.send({"status": "fail"});
        }
        else{
            //sent mail
            mailer.mail(email);
            // hash sixNum
            let hashedSixNum = crypto.createHash('sha256').update(mailer.sixNum)
            .digest('hex');
            res.send({"hash": hashedSixNum});
        }
    });
});
//exports router
module.exports = router;