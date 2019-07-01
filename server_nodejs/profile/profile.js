var db = require('../db.js');
var express = require('express');
const router = new express.Router()

//pwd
router.get('/profilePwd/:uid/:pwd', function (req, res) {
    var uid = req.params.uid;
    var pwd = req.params.pwd;
    const sql = `UPDATE user SET pwd = '${pwd}' WHERE uid = '${uid}' `
    db.query(sql, function (err, result) {
        if (err) {
            res.send("fail");
            console.log(err);
        }
        else {
            console.log(result);
            res.send("success");
        }
    });
});

/*
router.get('/profileName/:uid/:name', function (req, res) {
    var uid = req.params.uid;
    var name = req.params.name;
    const sql = `UPDATE user SET pwd = '${pwd}' WHERE uid = '${uid}' `
    db.query(sql, function (err, result) {
        if (err) {
            res.send("fail");
            console.log(err);
        }
        else {
            console.log(result);
            res.send("success");
        }
    });
});
*/
module.exports = router;