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

//name
router.get('/profileName/:uid/:name', function (req, res) {
    var uid = req.params.uid;
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
router.get('/profilePhoto/:uid/:photo', function (req, res) {
    var uid = req.params.uid;
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
router.get('/profileDepartment/:uid/:department', function (req, res) {
    var uid = req.params.uid;
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
router.get('/profileCarNum/:uid/:carNum', function (req, res) {
    var uid = req.params.uid;
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