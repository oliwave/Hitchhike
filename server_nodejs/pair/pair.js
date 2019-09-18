var db = require('../db.js');
var express = require('express');
const auth = require('../auth.js');
var bodyParser = require('body-parser');
var axios = require('axios');

var app = express();
var jsonParser = bodyParser.json();

const router = new express.Router();

var passengerList = [];

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
    console.log(passengerList);
    res.send(passengerList[0]);
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