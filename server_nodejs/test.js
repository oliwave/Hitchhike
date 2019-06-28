var express=require('express');
var app=express();
app.get('/getUser',function(req,res){
    var sql=require('mysql');
 
    //config for your database
    var config={
        user:'localhost',
        password:'',
        server:'127.0.0.1',   //這邊要注意一下!!
        database:'hitchhike'
    };
 
    //connect to your database
    sql.connect(config,function (err) {
        if(err) console.log(err);
 
        //create Request object
        var request=new sql.Request();
        request.query('select * from user',function(err,recordset){
            if(err) console.log(err);
            console.log("OK");
            //send records as a response
            res.send(recordset);
        });
    });
});
var server=app.listen(8080,function(){
    console.log('Server is running!');
});