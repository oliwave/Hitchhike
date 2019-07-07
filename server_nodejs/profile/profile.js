var db = require('../db.js');
var express = require('express');
const auth = require('../auth.js');
const router = new express.Router()

//pwd
router.get('/profilePwd/:pwd', auth.auth, function (req, res) {
    var uid = auth.uid;
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

//name
router.get('/profileName/:name', auth.auth, function (req, res) {
    var uid = auth.uid;
    var name = req.params.name;
    const sql = `UPDATE user SET name = '${name}' WHERE uid = '${uid}' `
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

//photo
router.get('/profilePhoto/:photo', auth.auth, function (req, res) {
    var uid = auth.uid;
    var photo = req.params.photo;
    const sql = `UPDATE user SET photo = '${photo}' WHERE uid = '${uid}' `
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

//department
router.get('/profileDepartment/:department', auth.auth, function (req, res) {
    var uid = auth.uid;
    var department = req.params.department;
    const sql = `UPDATE user SET department = '${department}' WHERE uid = '${uid}' `
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

//carNum
router.get('/profileCarNum/:carNum', auth.auth, function (req, res) {
    var uid = auth.uid;
    var carNum = req.params.carNum;
    const sql = `UPDATE user SET car_num = '${carNum}' WHERE uid = '${uid}' `
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
module.exports = router;