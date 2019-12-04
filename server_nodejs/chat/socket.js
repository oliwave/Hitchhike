var db = require('../db.js');
const express = require('express');
const app = express();

const server = require('http').Server(app);
const io = require('socket.io')(server);
const router = new express.Router();

let onlineUserMap = {};
// 當有新建立的 socket 連線
router.socketConnection = function(){

    io.on('connection', auth.auth, (socket) => {
        var uid = auth.uid;
        // 對 onlineUserMap 新增一筆上線紀錄
        onlineUserMap[uid] = socket.id;
    
        const sql = `SELECT hasNewMessage from user where uid=${uid}`
        db.query(sql, (err, result) => {
            if (err) {
                console.log(err);
            } else {
                // 若該用戶有新訊息(去user檢查hasNewMessage欄位檢查是否為 1)
                if (result[0].hasNewMessage == 1) {
                    //去 unread資料表將自己全部訊息select出來
                    getUnreadMessages(uid, socket.id);
                };
            };
        });
    
        // 接收 sendMessage 事件
        socket.on('sendMessage', auth.auth, (roomId, content) => {
            var uid = auth.uid;
            // 去 room 資料表找出一樣有 roomId 的資料
            sql = `SELECT * from room where roomId=${roomId}`
            db.query(sql, (err, result) => {
                if (err) {
                    console.log(err);
                } else {
                    // other用來記錄對方uID
                    var other;
                    if (uid == result[0].uid1) {
                        other = result[0].uid2;
                    } else {
                        other = result[0].uid1;
                    };
    
                    setMessages(uid, roomId, content);
                    // 對方在線 => 直接將收到的訊息放在 newMessage 事件中 發送
                    if (onlineUserMap[other] != null) {
                        io.to(onlineUserMap[other]).emit('newMessage', content, function () {
                            // set message status = 1 and set hasNewMessage = 0
                            sql = `UPDATE user SET hasNewMessage=0 where uid=${uid}`
                            db.query(sql, (err, result) => {
                                if (err) {
                                    console.log(err);
                                } else {
                                    sql = `UPDATE message SET status=1 where uid=${uid} and roomId=${roomId}`
                                    db.query(sql, (err, result) => {
                                        if (err) {
                                            console.log(err);
                                        } else {
                                            // console.log(result);
                                        };
                                    });
                                };
                            });
                        });
                    }
                };
            });
        });
        socket.on('ack')
    });
}

//去 unread資料表將自己全部訊息select出來
function getUnreadMessages(uid, socketId) {
    sql = `SELECT * from message where uid=${uid} and status = 0`
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // 放在 previousMessages 事件中 發送
            io.to(socketId).emit('previousMessages', result);
        };
    });
};
// 儲存該訊息到message 資料表中
// unread 0 read 1
function setMessages(uid, roomId, content) {
    sql = `INSERT INTO message SET text=${content}, status = 0 where uid=${uid} and roomId=${roomId}`
    `INSERT INTO message(uid, roomId, time, text, status) VALUES (${uid}, ${roomId}, '0', ${content},'0')`
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // 改hasNewMessage的狀態//////////////////////////////////////////////
            sql = `UPDATE user SET hasNewMessage=1 where uid=${uid}`
            db.query(sql, (err, result) => {
                if (err) {
                    console.log(err);
                } else {
                    // 放在 previousMessages 事件中 發送
                    io.to(socketId).emit('previousMessages', result);
                };
            });
        };
    });
}
module.exports = router;
// location event
