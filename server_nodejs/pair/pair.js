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
    var time = req.body.time;
    passengerList.push({
        "passenger": uid,
        "originY": originY,
        "originX": originX,
        "destinationY": destinationY,
        "destinationX": destinationX,
        "originName": originName,
        "destinationName": destinationName,
        "time": time
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
    var pairMap = {};

    for (let i = 0; i < passengerList.length; i++) {
        var originX_P = passengerList[i].originX;
        var originY_P = passengerList[i].originY;
        var destinationX_P = passengerList[i].destinationX;
        var destinationY_P = passengerList[i].destinationY;
        // space = %2C         "|" = %7C
        var url = `https://maps.googleapis.com/maps/api/directions/json?origin=${originX_D}%2C${originY_D}&destination=${destinationX_D}%2C${destinationY_D}&waypoints=${originX_P}%2C${originY_P}%7C${destinationX_P}%2C${destinationY_P}&language=zh-TW&key=AIzaSyAGGrLwvvLN3W92yY3zrDcP8P9BPXieqyY`
        try{
            pairMap[passengerList[i].passenger] = await getData(url)
        }
        catch(e){
            //console.log(e)
        }
    }
    passengerList = passengerList.sort(function (a, b) {
        return a.time > b.time ? 1 : -1
    })
    res.send(pairMap[105213028]);
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