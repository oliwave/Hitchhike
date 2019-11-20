var db = require('../db.js');
var express = require('express');
const auth = require('../auth.js');
var bodyParser = require('body-parser');
var axios = require('axios');
var admin = require('../fcm/fcm.js');

var app = express();
var jsonParser = bodyParser.json();

const router = new express.Router();

var passengerList = [];
var pairMapDone = {};

//passenger
router.post('/passenger_route', auth.auth, jsonParser, function (req, res) {
    var uid = auth.uid;
    var originY = req.body.originY;
    var originX = req.body.originX;
    var destinationY = req.body.destinationY;
    var destinationX = req.body.destinationX;
    var originName = req.body.originName;
    var destinationName = req.body.destinationName;
    passengerList.push({
        "passenger": uid,
        "originY": originY,
        "originX": originX,
        "destinationY": destinationY,
        "destinationX": destinationX,
        "originName": originName,
        "destinationName": destinationName,
    });

    res.send('success');

});

//driver
router.post('/driver_route', auth.auth, jsonParser, async function (req, res) {
    var uid = auth.uid;
    var originX_D = req.body.originX;
    var originY_D = req.body.originY;
    var destinationX_D = req.body.destinationX;
    var destinationY_D = req.body.destinationY;
    var registrationToken;
    //map
    var pairMap = {};

    for (let i = 0; i < passengerList.length; i++) {
        var totalTime = 0;
        var originX_P = passengerList[i].originX;
        var originY_P = passengerList[i].originY;
        var destinationX_P = passengerList[i].destinationX;
        var destinationY_P = passengerList[i].destinationY;
        // space = %2C
        //  "|"  = %7C
        var url = `https://maps.googleapis.com/maps/api/directions/json?origin=${originX_D}%2C${originY_D}&destination=${destinationX_D}%2C${destinationY_D}&waypoints=${originX_P}%2C${originY_P}%7C${destinationX_P}%2C${destinationY_P}&language=zh-TW&key=AIzaSyAGGrLwvvLN3W92yY3zrDcP8P9BPXieqyY`
        try {
            // get google map data
            pairMap[passengerList[i].passenger] = await getData(url)
            // get totalTime
            for (let j = 0; j < 3; j++) {
                totalTime += pairMap[passengerList[i].passenger].routes[0].legs[j].duration.value
            }
            // add totalTime into passengerList
            passengerList[i]['time'] = totalTime
        }
        catch (e) {
            console.log(e)
        }
    }
    // sort passengerList by totalTime
    passengerList = passengerList.sort(function (a, b) {
        return a.time > b.time ? 1 : -1
    })

    // take driver token
    const sql = `SELECT token from user where uid=${uid}`
    db.query(sql, function (err, result) {
        if (err) {
            res.send({ "status": "fail" });
            console.log(err);
        }
        else {
            //?
            registrationToken = result[0].token;

            var message = {
                "data": {
                    "type": "orderConfirmation",
                    "totalTime": passengerList[0].time,
                    "passengerStartName": passengerList[0].originName,
                    "passengerEndName": passengerList[0].destinationName,
                },
                "token": registrationToken
            };
            //console.log(passengerList);
            //res.send(passengerList[0]);
            pairMapDone[uid] = {
                "passenger": passengerList[0].passenger,
                "route": pairMap[passengerList[0].passenger]
            };
            admin.messaging().send(message);
        }
    });
});

//orderConfirmation
router.post('/orderConfirmation', auth.auth, jsonParser, function (req, res) {
    var uid = auth.uid;
    var status = req.body.status;
    if (status == "fail") {
        res.send("fail");
    }
    if (status == "success") {
        var passengerUid = pairMapDone[uid].passenger;
        
        // driver
        const sql = `SELECT * from user where uid=${uid}`
        db.query(sql, function (err, result) {
            if (err) {
                res.send({ "status": "fail" });
                console.log(err);
            }
            else {
                registrationDriverToken = result[0].token;
                carNum = result[0].car_num;
                
                const sql = `SELECT * from user where uid= ${passengerUid}`
                db.query(sql, function (err, result) {
                    if (err) {
                        res.send({ "status": "fail" });
                        console.log(err);
                    }
                    else {
                        registrationPassengerToken = result[0].token;
                        
                        var message = {
                            "data": {
                                "type": "paired",
                                // TODO : 需要後端傳回該配對的人是否為朋友
                                "isFriend": false,
                                "avatar": "testAvatar",
                                "roomId": "testRoom",
                                "carDescripition": "notInDB",
                                //
                                "carNum": carNum,
                                "duration": passengerList[0].time,
                                "startName": passengerList[0].originName,
                                "endName": passengerList[0].destinationName,
                                "northeastLat" : pairMap[passengerUid].routes[0].bounds.northeast.lat,
                                "northeastLng" : pairMap[passengerUid].routes[0].bounds.northeast.lng,
                                "southwestLat" : pairMap[passengerUid].routes[0].bounds.southwest.lat,
                                "southwestLng" : pairMap[passengerUid].routes[0].bounds.southwest.lng,
                                "legs": pairMap[passengerUid].routes[0].legs
                            },
                            "token": [registrationDriverToken, registrationPassengerToken]
                        };
                        passengerList.filter( passengerList => passengerList.uid !== uid );
                        pairMapDone.filter( pairMapDone => pairMapDone.passenger != uid );
                        admin.messaging().send(message);
                    }
                });
            }
        });
    }
});

// google map api request
const getData = async url => {
    try {
        const response = await axios.get(url);
        const data = response.data;
        console.log(data);
        return data;
    } catch (error) {
        console.log(error);
    }
};
module.exports = router;