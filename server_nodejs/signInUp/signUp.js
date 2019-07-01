var db = require('../db.js');
var express = require('express');
var crypto = require('crypto');
var mailer = require('./mailer.js');
const router = new express.Router()
// use post
router.get('/signUp/:uid/:pwd/:name', function (req, res) {
    var uid = req.params.uid;
    var pwd = req.params.pwd;
    var name = req.params.name;
    const sql = `INSERT INTO user (uid, pwd, name) VALUES ('${uid}', '${pwd}', '${name}')`;
    db.query(sql, function (err, result) {
        if (err) {
            res.send("fail");
            console.log(err);
        }
        else {
            res.send("success");
        }
    });
});

//verify ncnu and send emails
router.get('/verify/:uid', function (req, res) {
    var uid = req.params.uid;
    email = "s" + uid +"@mail1.ncnu.edu.tw";
    const sql = `select * from user where uid = '${uid}'`;
    db.query(sql, function (err, result) {
        if (err) {
            console.log(err);
        }
        if (result.length > 0) {
            res.send("fail");
        }
        else{
            //sent mail
            mailer.mail(email);
            // hash sixNum
            let hashedSixNum = crypto.createHash('sha256').update(mailer.sixNum)
            .digest('base64');
            res.send(hashedSixNum);
        }
    });
});
//exports router
module.exports = router;