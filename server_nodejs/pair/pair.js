const axios = require('axios');
const express = require('express');
const bodyParser = require('body-parser');
const crypto = require('crypto')

const db = require('../db.js');
const auth = require('../auth.js');
const admin = require('../fcm/fcm.js');

const app = express();
const jsonParser = bodyParser.json();

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

        admin.messaging().sendMulticast(message);

        console.log('Order confirmation Fcm message has been sent!')

        let data = await createRoom(uid, pairMapDone[uid].passenger.uid)

        console.log('Driver photot is ', driver.photo)

        pairMapDone[uid].info = {
            'type': 'paired',
            'isFriend': data.isFriend,
            'roomId': data.room,
            'avatar': driver.photo,
            'carDescripition': driver.car_descripition,
            'carNum': driver.car_num,
            'duration': pairMapDone[uid].passenger.time,
            'pairedTime': Date.now(),
            'startName': pairMapDone[uid].passenger.originName,
            'endName': pairMapDone[uid].passenger.destinationName,
            'northeastLat': pairMapDone[uid].route.bounds.northeast.lat,
            'northeastLng': pairMapDone[uid].route.bounds.northeast.lng,
            'southwestLat': pairMapDone[uid].route.bounds.southwest.lat,
            'southwestLng': pairMapDone[uid].route.bounds.southwest.lng,
            'legs': pairMapDone[uid].route.legs
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

// This helper method will know if they are friend or not.
const createRoom = async (driverId, passengerId) => {
    let room = await new Promise((resolve, reject) => {
        let sql = `select roomId from room where (uid1='${driverId}' or uid2='${driverId}')
        and (uid1='${passengerId}' or uid2='${passengerId}')`

        db.query(sql, (err, result) => {
            if (err) {
                console.log(err)
            } else {
                // Driver and passenger are friend or not.
                if (result.length > 0) {
                    resolve(result[0].roomId)
                } else {
                    resolve(null)
                }
            }
        })
    })

    let isFriend = room != null

    if (!isFriend) {
        room = crypto.createHash('sha256', 'ncnuIM').update(driverId + passengerId).digest('hex')

        sql = `INSERT INTO room(roomId, uid1, uid2) VALUES 
                    ('${room}', '${driverId}', '${passengerId}')`

        // Create a room for them.
        db.query(sql, (err, result) => {
            if (err) console.log(err)
        })
    }

    return {room, isFriend}
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