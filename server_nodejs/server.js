var express = require('express');
var login = require('./signInUp/login.js');
var signUp = require('./signInUp/signUp.js');
var profile = require('./profile/profile.js');
var pair = require('./pair/pair.js');
var userInfo = require('./profile/userInfo.js');
var socket = require('./chat/socket.js').socketConnection
var app = express();

// app.use(socket);
app.use(login);
app.use(signUp);
app.use(profile);
app.use(pair);
app.use(userInfo);

socket()

//server port :8080   local port :3000
app.listen(3000, function () {
    console.log('Server is running!');
});