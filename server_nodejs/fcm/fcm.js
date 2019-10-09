const admin = require('firebase-admin')

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    databaseURL: 'https://hitchhike-44f58.firebaseio.com'
});

// 這個註冊的 token 是從手機端的 FCM SDKs 傳來的.
//let registrationToken = 'e3SZXZnimco:APA91bEuBrZ1AeihGh-nTWYxyYxjcy_Dbb9YHv7m_HxMPAwdHbeZTvAwUqB0lfjvGjsQc5zdqEPxCVnDUn04fsjxPogCt-bcfnAC0pYlLy-eMImxCzF6ouSNEIY6TqQ-IcLpLEZZw4Dm';

// 對這個已註冊 token 的手機裝置傳送訊息
admin.messaging().send(message)
    .then((response) => {
        // Response 是一個字串型別的 message ID.
        console.log('Successfully sent message:', response);
    })
    .catch((error) => {
        console.log('Error sending message:', error);
    });

module.exports = admin;