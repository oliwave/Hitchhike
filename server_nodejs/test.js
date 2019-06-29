var express = require('express');
var app = express();
var mysql = require('mysql');
//config for your database
//server port :8080   local port :3000
app.listen(8080, function () {
    console.log('Server is running!');
});

const db = mysql.createConnection({
    user: 'root',
    password: '',
    server: '127.0.0.1',
    database: 'test'
});

 //connect to your database
db.connect((err) => {
    if(err){
        console.log(err);
    }
    console.log("Mysql Connected...");
});

app.get('/login/:name/:pwd', function (req, res) {
    var name = req.params.name;
    var pwd = req.params.pwd;
    console.log(name);
    console.log(pwd);
    db.query(`select * from user where name = '${name}' AND pwd = '${pwd}' `, function (err, result) {
        if (err) {
            console.log(err);
        }
        if(result.length > 0){
            console.log(result);
            //send records as a response
            res.status(200);
            res.send("success");
        }
        else{
            res.status(401);
            res.send("fail");
        }
    });
});