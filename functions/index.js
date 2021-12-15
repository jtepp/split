const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onCreate(async (event, context) => { // use onUpdate for opting

    var title;
    var body;
    var snd = "default"

    if (event.after.get("isAn")) {
        let memo = event.after.get("memo")
        title = "Announcement"
        body = event.after.get("from") + " " + memo
        if (memo.includes("join") || memo.includes("create")) {
            snd = "join.mp3"
        } else if (memo.includes("left") || memo.includes("remove")) {
            snd = "leave.mp3"
        } else if (memo.includes("Admin")) {
            snd = "admin.mp3"
        }

    } else if (event.after.get("isGM")) {
        snd = "pay.mp3"
        title = "from " + event.after.get("from")
        body = event.after.get("memo")

    } else if (event.after.get("isRequest")) {
        snd = "req.mp3"
        title = "Request received"
        let reqFrom = event.after.get("reqfrom")
        console.log("REQFROM: " + reqFrom.toString())
        if (reqFrom.length == 1) {
            body = event.after.get("to") + " requested $" + event.after.get("amount").toFixed(2) + " from you"
        } else if (reqFrom.length == 2) {
            body = event.after.get("to") + " requested $" + event.after.get("amount").toFixed(2) + ", split between you and " + (reqFrom.length - 1) + " other"
        } else {
            body = event.after.get("to") + " requested $" + event.after.get("amount").toFixed(2) + ", split between you and " + (reqFrom.length - 1) + " others"
        }
    } else {
        snd = "pay.mp3"
        title = "Payment received"
        body = event.after.get("from") + " sent you $" + event.after.get("amount").toFixed(2)

    }

    if (!event.after.get("isAn") && !event.after.get("isGM")) {
        if ((event.after.get("memo") || "") != "") {
            body += " for " + event.after.get("memo")
        }
    }

    event.after.get("fcm").forEach(async tkn => {
        let message = {
            notification: {
                title: title,
                body: body
            },
            token: tkn,
            apns: {
                payload: {
                    aps: {
                        sound: snd,
                    }
                }
            }
        }
        let response = await admin.messaging().send(message)
        console.log(response)
    });



})