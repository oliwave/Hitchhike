var nodemailer = require('nodemailer');
function mail(emailAddr){
    //server secure: true
    //port: 465(SSL) 587(TSL) 25
    //https://accounts.google.com/DisplayUnlockCaptcha
    let transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        secure: false,
        port: 587,
        auth: {
            user: 'moviemovie010203@gmail.com',
            pass: 'movie1234'
        },
        tls: {
            rejectUnauthorized: false
        }
    });
    
    let HelperOptions = {
        from: 'moviemovie@gmail.com',
        to: emailAddr,
        subject: 'hitchhike',
        text: exports.sixNum = createSixNum()
    };
    transporter.sendMail(HelperOptions, (error, info) => {
        if (error) {
            return console.log(error);
        }
        console.log("The message was sent!");
        console.log(info);
    });
    
    function createSixNum() {
        var Num = "";
        for (var i = 0; i < 6; i++) {
            Num += Math.floor(Math.random() * 10);
        }
        return Num;
    }
}
exports.mail = mail;
