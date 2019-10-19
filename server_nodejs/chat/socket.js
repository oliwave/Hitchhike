var db = require('../db.js');
const express = require('express');
const app = express();
const auth = require('../auth.js');

const server = require('http').Server(app);
const io = require('socket.io')(server);

let onlineUserMap = {};
// 當有新建立的 socket 連線
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
                if (uid == result[0].user1Id) {
                    other = result[0].user2Id;
                } else {
                    other = result[0].user1Id;
                };

                // 對方不在線 => 儲存該訊息到unread 資料表中，等待聊天對象再次上線
                if (onlineUserMap[other] == null) {
                    setUnreadMessages(uid, roomId, content);
                // 對方在線 => 直接將收到的訊息放在 newMessage 事件中 發送
                } else {
                    // 若沒回應則存入db///////////////////////////////////////////////////////////////
                    io.to(onlineUserMap[other]).emit('newMessage', content);
                }
                
            };
        });
    });
    socket.on('ack', )
}); 

//去 unread資料表將自己全部訊息select出來
function getUnreadMessages(uid, socketId) {
    sql = `SELECT * from unread where uid=${uid}`
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // 放在 previousMessages 事件中 發送
            io.to(socketId).emit('previousMessages', result);
        };
    });
};
// 儲存該訊息到unread 資料表中
function setUnreadMessages(uid, roomId, content) {
    sql = `UPDATE unread SET text=${content} where uid=${uid} and roomId=${roomId}`
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            // 放在 previousMessages 事件中 發送
            io.to(socketId).emit('previousMessages', result);

            // 改hasNewMessage的狀態//////////////////////////////////////////////
            sql = `UPDATE unread SET hasNewMessage=1 where uid=${uid}`
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
// location event
