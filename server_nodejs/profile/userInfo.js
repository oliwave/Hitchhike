var db = require('../db.js');
var express = require('express');
const auth = require('../auth.js');
var bodyParser = require('body-parser');

var app = express();

const router = new express.Router();

router.post('/userInfo', auth.auth, function (req, res) {
    var uid = auth.uid;
    const sql = `SELECT * from user where uid=${uid}`
    db.query(sql, function (err, result) {
        if (err) {
            res.send({ "status": "fail" });
            console.log(err);
        }
        else {
            res.send({
                "uid": result[0].uid,
                "pwd": result[0].pwd,
                "name": result[0].name,
                "photo": result[0].photo,
                "gender": result[0].gender,
                "department": result[0].department,
                "birthday": result[0].birthday,
                "star": result[0].star,
                "score": result[0].score,
                "d_rank": result[0].d_rank,
                "p_rank": result[0].p_rank,
                "car_num": result[0].car_num,
                "d_times": result[0].d_times,
                "p_times": result[0].p_times,
                "token": result[0].token
            })
        }
    });
});

// fcm token get, store to database
router.post('/fcmToken', auth.auth, function (req, res) {
    var uid = auth.uid;
    var fcmToken = req.body.fcmToken;
    const sql = `UPDATE user SET token = '${fcmToken}' WHERE uid = '${uid}' `
    db.query(sql, function (err, result) {
        if (err) {
            res.send({"status": "fail"});
            console.log(err);
        }
        else {
            console.log(result);
            res.send({"status": "success"});
        }
    });
});

module.exports = router;