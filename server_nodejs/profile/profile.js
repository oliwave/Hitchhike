var db = require('../db.js');
var express = require('express');
const auth = require('../auth.js');
var bodyParser = require('body-parser')

var app = express();
var jsonParser = bodyParser.json();

const router = new express.Router()

//pwd
router.post('/profilePwd', auth.auth, jsonParser,function (req, res) {
    var uid = auth.uid;
    var pwd = req.body.pwd;
    const sql = `UPDATE user SET pwd = '${pwd}' WHERE uid = '${uid}' `
    db.query(sql, function (err, result) {
        if (err) {
            res.send({"status": fail});
            console.log(err);
        }
        else {
            console.log(result);
            res.send({"status": success});
        }
    });
});

//name
router.post('/profileName', auth.auth, jsonParser,function (req, res) {
    var uid = auth.uid;
    var name = req.body.name;
    const sql = `UPDATE user SET name = '${name}' WHERE uid = '${uid}' `
    db.query(sql, function (err, result) {
        if (err) {
            res.send({"status": fail});
            console.log(err);
        }
        else {
            console.log(result);
            res.send({"status": success});
        }
    });
});

//photo
router.post('/profilePhoto', auth.auth, jsonParser,function (req, res) {
    var uid = auth.uid;
    var photo = req.body.photo;
    const sql = `UPDATE user SET photo = '${photo}' WHERE uid = '${uid}' `
    db.query(sql, function (err, result) {
        if (err) {
            res.send({"status": fail});
            console.log(err);
        }
        else {
            console.log(result);
            res.send({"status": success});
        }
    });
});

//department
router.post('/profileDepartment', auth.auth, jsonParser,function (req, res) {
    var uid = auth.uid;
    var department = req.body.department;
    const sql = `UPDATE user SET department = '${department}' WHERE uid = '${uid}' `
    db.query(sql, function (err, result) {
        if (err) {
            res.send({"status": fail});
            console.log(err);
        }
        else {
            console.log(result);
            res.send({"status": success});
        }
    });
});

//carNum
router.post('/profileCarNum', auth.auth, jsonParser,function (req, res) {
    var uid = auth.uid;
    var carNum = req.body.carNum;
    const sql = `UPDATE user SET car_num = '${carNum}' WHERE uid = '${uid}' `
    db.query(sql, function (err, result) {
        if (err) {
            res.send({"status": fail});
            console.log(err);
        }
        else {
            console.log(result);
            res.send({"status": success});
        }
    });
});
module.exports = router;