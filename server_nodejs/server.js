var express = require('express');
var login = require('./signInUp/login.js');
var signUp = require('./signInUp/signUp.js');
var profile = require('./profile/profile.js');
var pair = require('./pair/pair.js');
var userInfo = require('./profile/userInfo.js');
var app = express();

app.use(login);
app.use(signUp);
app.use(profile);
app.use(pair);
app.use(userInfo);

//server port :8080   local port :3000
app.listen(3000, function () {
    console.log('Server is running!');
});