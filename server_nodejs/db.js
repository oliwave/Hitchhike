var mysql = require('mysql');
const db = mysql.createConnection({
    user: 'ncnuim',
    password: 'hitchhike105213',
    host: 'localhost',
    database: 'hitchhike'
});

 //connect to your database
db.connect((err) => {
    if(err){
        console.log(err);
    }
    else{
        console.log("Mysql Connected...");
    }
});
module.exports = db;