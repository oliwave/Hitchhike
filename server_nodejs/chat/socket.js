const express = require('express')
const jwt = require('jsonwebtoken')

const app = express()

const socketIO = require('socket.io')
const http = require('http')
const server = http.createServer(app)
const io = socketIO(server)

const db = require('../db.js')
const auth = require('../auth.js')

let onlineUserMap = {}

io.use((socket, next) => {
    if (socket.handshake.query && socket.handshake.query.token) {
        jwt.verify(socket.handshake.query.token, 'ncnuIM', function (err, decoded) {
            if (err) return next(new Error('Authentication error'))
            socket.uid = decoded
            next()
        })
    } else {
        next(new Error('Authentication error'))
    }
})

// 當有新建立的 socket 連線
socketConnection = function () {

    io.on('connection', (socket) => {
        console.log('\nA new socket connection')
        console.log(`User socket ID : ${socket.id}`)
        console.log(`User ID : ${socket.uid}`)
        console.log('%s sockets connected', io.engine.clientsCount, '\n')

        var uid = socket.uid
        // 對 onlineUserMap 新增一筆上線紀錄
        onlineUserMap[uid] = socket.id

        const sql = `SELECT hasNewMessage from user where uid='${uid}'`
        db.query(sql, (err, result) => {
            if (err) {
                console.log(err)
            } else {

                // 若該用戶有新訊息(去user檢查hasNewMessage欄位檢查是否為 1)
                if (result[0].hasNewMessage == 1) {
                    //去 unread資料表將自己全部訊息select出來
                    getUnreadMessages(uid, socket.id)
                }
            }
        })

        // 接收 sendMessage 事件
        socket.on('sendMessage', (data) => {

            content = JSON.parse(data)

            // 去 room 資料表找出一樣有 roomId 的資料
            sql = `SELECT * from room where roomId='${content.room}'`
            db.query(sql, (err, result) => {
                if (err) {
                    console.log(err)
                } else {
                    // other用來記錄對方uID
                    var other
                    if (uid == result[0].uid1) {
                        other = result[0].uid2
                    } else {
                        other = result[0].uid1
                    }

                    setMessages(other, content)

                    // 對方在線 => 直接將收到的訊息放在 newMessage 事件中 發送
                    if (onlineUserMap[other] != null) {
                        io.to(onlineUserMap[other]).emit('newMessage', content, () => {
                            console.log('The callback has been called!')
                            // set message status = 1 and set hasNewMessage = 0
                            sql = `UPDATE user SET hasNewMessage=0 where uid='${other}'`
                            db.query(sql, (err, result) => {
                                if (err) {
                                    console.log(err)
                                }
                            })

                            // To find an unique message.
                            sql = `UPDATE message SET status=1 where uid='${other}' and
                             roomId='${content.room}' and time='${content.time}'`
                            db.query(sql, (err, result) => {
                                if (err) {
                                    console.log(err)
                                }
                            })

                        })
                    }
                }
            })
        })

        socket.on('driverPosition', (data) => {
            
        })

        // socket.on('ack', (_) => {

        // })

        socket.on('disconnect', (_) => {
            console.log(`${socket.id} drop the socket connection!`)

            // Kill the user in onlineUserMap
            let targetUid = getKeyByValue(onlineUserMap, socket.id)

            delete onlineUserMap[targetUid]
        })
    })
}

//去 unread 資料表將自己全部訊息 select 出來
const getUnreadMessages = (uid, socketId) => {
    sql = `SELECT * from message where uid='${uid}' and status = 0`
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err)
        } else {
            // 放在 previousMessages 事件中 發送
            io.to(socketId).emit('previousMessages', result)

            sql = `UPDATE message SET status=1 where uid='${uid}' and status = 0`
            db.query(sql, (err, result) => {
                if (err) {
                    console.log(err)
                }
            })
        }
    })
}

// 儲存該訊息到 message 資料表中
// unread 0 read 1
const setMessages = (uid, content) => {
    // `INSERT INTO message SET text=${content}, status = 0 where uid=${uid} and roomId=${roomId}`
    sql = `INSERT INTO message(uid, roomId, time, text, status) VALUES 
        ('${content.uid}', '${content.room}', '${content.time}', '${content.text}', 0)`

    db.query(sql, (err, result) => {
        if (err) {
            console.log(err)
        } else {
            // 改 hasNewMessage 的狀態
            sql = `UPDATE user SET hasNewMessage=1 where uid='${uid}'`
            db.query(sql, (err, result) => {
                if (err) {
                    console.log(err)
                }
            })
        }
    })
}

const getKeyByValue = (object, value) => {
    return Object.keys(object).find(key => object[key] === value)
}

server.listen(8080, () => {
    console.log('Socket Server is running!\n')
})

module.exports = {
    socketConnection
}