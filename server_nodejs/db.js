var mysql = require('mysql');
const db = mysql.createConnection({
    user: 'ncnuim',
    password: 'hitchhike105213',
    server: '127.0.0.1',
    database: 'hitchhike'
});

 //connect to your database
db.connect((err) => {
    if(err){
        console.log(err);
    }
    console.log("Mysql Connected...");
});
module.exports = db;