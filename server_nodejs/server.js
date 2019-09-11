var express = require('express');
var login = require('./signInUp/login.js');
var signUp = require('./signInUp/signUp.js');
var profile = require('./profile/profile.js');
var passenger = require('./pair/passenger.js');
var driver = require('./pair/driver.js');
var app = express();

app.use(login);
app.use(signUp);
app.use(profile);
app.use(passenger.router);
app.use(driver);

//server port :8080   local port :3000
app.listen(3000, function () {
    console.log('Server is running!');
});