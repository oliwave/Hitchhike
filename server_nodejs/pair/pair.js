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
        "uid": uid,
        "originY": originY,
        "originX": originX,
        "destinationY": destinationY,
        "destinationX": destinationX,
        "originName": originName,
        "destinationName": destinationName,
    });

    console.log(`New passenger ${uid}, we have ${passengerList.length} passengers.`)

    res.send({ 'statusCode': 'success' });

});

//driver
router.post('/driver_route', auth.auth, jsonParser, async function (req, res) {
    
    var uid = auth.uid;
    var originX_D = req.body.originX;
    var originY_D = req.body.originY;
    var destinationX_D = req.body.destinationX;
    var destinationY_D = req.body.destinationY;
    var pairMap = {} // map
    let promiseDirectionList = []
    let driverOriginalTime = 0
    let driverUrl = `https://maps.googleapis.com/maps/api/directions/json?origin=${originY_D}%2C${originX_D}&destination=${destinationY_D}%2C${destinationX_D}&language=zh-TW&key=AIzaSyAGGrLwvvLN3W92yY3zrDcP8P9BPXieqyY`
    
    promiseDirectionList.push(getData(driverUrl))

    console.log(`New driver ${uid}`)

    for (let i in passengerList) {
        var totalTime = 0;
        var originX_P = passengerList[i].originX;
        var originY_P = passengerList[i].originY;
        var destinationX_P = passengerList[i].destinationX;
        var destinationY_P = passengerList[i].destinationY;
        // space = %2C
        //  "|"  = %7C
        var url = `https://maps.googleapis.com/maps/api/directions/json?origin=${originY_D}%2C${originX_D}&destination=${destinationY_D}%2C${destinationX_D}&waypoints=${originY_P}%2C${originX_P}%7C${destinationY_P}%2C${destinationX_P}&language=zh-TW&key=AIzaSyAGGrLwvvLN3W92yY3zrDcP8P9BPXieqyY`

        console.log(`The Directions api is : ${url}`)

        try {
            // Get google map data, and insert the direction to corresponding passenger
            promiseDirectionList.push(getData(url))
        }
        catch (e) {
            console.log(e)
        }
    }

    // Wait all of directions in the list.
    let directionList = await Promise.all(promiseDirectionList)

    for (let i in directionList) {
        if (i == 0) { // The first element in directionList is driver's original travel.
            driverOriginalTime = directionList[i].routes[0].legs[0].duration.value

            // TEST
            console.log('Driver has only one leg : ', directionList[i].routes[0].legs[1])
        } else {
            let index = i - 1 // Let index start from 0.

            // Get google map data, and insert the direction to the corresponding passenger.
            pairMap[passengerList[index].uid] = directionList[i]

            // get totalTime
            for (let j = 0; j < 3; j++) {
                totalTime += pairMap[passengerList[index].uid].routes[0].legs[j].duration.value
            }

            // add totalTime into passengerList
            passengerList[index]['time'] = totalTime
        }
    }

    // sort passengerList by totalTime
    let bestPassenger = passengerList.sort(function (a, b) {
        return a.time > b.time ? 1 : -1
    })[0]

    // Take driver token
    let driver = await getUserFromUID(uid)

    console.log(`passenger travel time is ${bestPassenger.time}, and driver original time is ${driverOriginalTime}`)

    var message = {
        "data": {
            "type": "orderConfirmation",
            "costTime": `${bestPassenger.time - driverOriginalTime}`,
            "passengerStartName": bestPassenger.originName,
            "passengerEndName": bestPassenger.destinationName,
        },
        "token": driver.token
    };

    let messageID = await admin.messaging().send(message);

    console.log('The message id is ', messageID)
    console.log('The pairing Fcm Message has been sent!')

    pairMapDone[uid] = {
        "passenger": bestPassenger,
        "driver": driver,
        "route": pairMap[bestPassenger.uid].routes[0],
    };

    // Remove the most suitable passenger from passengerList.
    passengerList = passengerList.filter(passenger => passenger.uid !== bestPassenger.uid);

    // TEST
    console.log(`length of passenger list is ${passengerList.length}`)
});

//orderConfirmation
router.get('/orderConfirmation/:status', auth.auth, jsonParser, async function (req, res) {
    var uid = auth.uid;
    var status = req.params.status
    if (status == "fail") {
        // If driver don't like the system recommended pairing,
        // push the passenger back to the passengerList 
        passengerList.push(pairMapDone[uid].passenger)

        // TEST
        console.log(`length of passenger list is ${passengerList.length}`)

        res.send("fail");
    }
    if (status == "success") {
        let driver = pairMapDone[uid].driver
        let passenger = await getUserFromUID(pairMapDone[uid].passenger.uid)

        // let roomId = driverAndPassenger[0].roomId // Create the roomId and insert it to room table

        var message = {
            "data": {
                "type": "paired",
                "driverId": uid,
            },
            "tokens": [driver.token, passenger.token]
        };

        let messageID = await admin.messaging().sendMulticast(message);

        console.log('The message id is ', messageID)
        console.log('Order confirmation Fcm message has been sent!')

        pairMapDone[uid].info = {
            "type": "paired",
            // TODO : 需要後端傳回該配對的人是否為朋友
            "isFriend": 'false',
            "avatar": driver.photo,
            "roomId": "testRoom",
            "carDescripition": driver.car_descripition,
            //
            "carNum": driver.car_num,
            "duration": pairMapDone[uid].passenger.time,
            "startName": pairMapDone[uid].passenger.originName,
            "endName": pairMapDone[uid].passenger.destinationName,
            "northeastLat": pairMapDone[uid].route.bounds.northeast.lat,
            "northeastLng": pairMapDone[uid].route.bounds.northeast.lng,
            "southwestLat": pairMapDone[uid].route.bounds.southwest.lat,
            "southwestLng": pairMapDone[uid].route.bounds.southwest.lng,
            "legs": pairMapDone[uid].route.legs
        }

        delete pairMapDone[uid].route
    }
});

router.post('/fetchPairedData', auth.auth, jsonParser, (req, res) => {
    let uid = req.body.uid

    console.log('The driver id is ', uid)

    res.send(pairMapDone[uid].info)
})

const getUserFromUID = (uid) => {
    const sql = `SELECT * from user where uid= '${uid}'`

    return new Promise((resolve, reject) => {
        db.query(sql, (err, result) => {
            if (err) {
                res.send({ "status": "fail" });
                console.log(err);
                reject(err)
            } else {
                resolve(result[0])
            }
        })
    })
}

// google map api request
const getData = async url => {
    try {
        const response = await axios.get(url);
        const data = response.data;
        // console.log(data);
        return data;
    } catch (error) {
        console.log(error);
    }
};

// if user is wait for pair now
router.post('/userState', auth.auth, function (req, res) {
    var uid = auth.uid;
    if (pairMapDone[uid] == uid) {
        res.send({ "state": true });
    }
    for (let i = 0; i < passengerList.length; i++) {
        if (passengerList[i].passenger == uid) {
            res.send({ "state": true });
        };
    };
    res.send({ "state": false });
});

module.exports = router;