var db = require('../db.js');
var express = require('express');
const auth = require('../auth.js');
var bodyParser = require('body-parser');
var passenger = require('./passenger.js');

var app = express();
var jsonParser = bodyParser.json();

const router = new express.Router()

//driver
router.post('/driver_route', auth.auth, jsonParser,function (req, res) {
    var uid = auth.uid;
    //read json
    const fs = require('fs');
    let rawdata = fs.readFileSync('C:\\hitchhike\\server_nodejs\\pair\\test.json');
    let data = JSON.parse(rawdata);
    // passengerList = passengerList.sort(function(a, b){
    //     return a.time < b.time ? 1 : -1
    // })
    res.send(data);    
});
module.exports = router;