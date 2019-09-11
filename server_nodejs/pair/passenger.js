var db = require('../db.js');
var express = require('express');
const auth = require('../auth.js');
var bodyParser = require('body-parser');

var app = express();
var jsonParser = bodyParser.json();

const router = new express.Router();

//passenger
router.post('/passenger_route', auth.auth, jsonParser,function (req, res) {
    var uid = auth.uid;
    
    //read json
    const fs = require('fs');
    let rawdata = fs.readFileSync('C:\\hitchhike\\server_nodejs\\pair\\test.json');
    let data = JSON.parse(rawdata);
    var passengerList = data;
    //write json
    passengerList.push({passenger:uid});
    let writeData = JSON.stringify(passengerList);
    fs.writeFileSync('C:\\hitchhike\\server_nodejs\\pair\\test.json',writeData);
    
    res.send('success');
    exports.passengerList = passengerList;
});

exports.router = router;