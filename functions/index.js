const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onCreate(async (documentSnapshot, context) => { // use onUpdate for opting
    try {
        var title;
        var body;
        var snd = "default"
        const type = documentSnapshot.get("type")
        if (documentSnapshot.get("isAn") || type == "announcement") {
            let memo = documentSnapshot.get("memo")
            title = "Announcement"
            body = documentSnapshot.get("from") + " " + memo
            if (memo.includes("join") || memo.includes("create")) {
                snd = "join.mp3"
            } else if (memo.includes("left") || memo.includes("remove")) {
                snd = "leave.mp3"
            } else if (memo.includes("Admin")) {
                snd = "admin.mp3"
            }
        } else if (documentSnapshot.get("isGM") || type == "groupmessage") {
            snd = "pay.mp3"
            title = "from " + documentSnapshot.get("from")
            body = documentSnapshot.get("memo")
        } else if (documentSnapshot.get("isRequest") || type == "request") {
            snd = "req.mp3"
            title = "Request received"
            let reqFrom = documentSnapshot.get("reqfrom")
            console.log("REQFROM: " + reqFrom.toString())
            if (reqFrom.length == 1) {
                body = documentSnapshot.get("to") + " requested $" + documentSnapshot.get("amount").toFixed(2) + " from you"
            } else if (reqFrom.length == 2) {
                body = documentSnapshot.get("to") + " requested $" + documentSnapshot.get("amount").toFixed(2) + " ($" + Number(documentSnapshot.get("amount") / reqFrom.length).toFixed(2) + " each), split between you and 1 other"
            } else {
                body = documentSnapshot.get("to") + " requested $" + documentSnapshot.get("amount").toFixed(2) + " ($" + Number(documentSnapshot.get("amount") / reqFrom.length).toFixed(2) + " each), split between you and " + (reqFrom.length - 1) + " others"
                // body = documentSnapshot.get("to") + " requested $" + documentSnapshot.get("amount").toFixed(2) + ", split between you and " + (reqFrom.length - 1) + " others"
            }
        } else {
            snd = "pay.mp3"
            title = "Payment received"
            body = documentSnapshot.get("from") + " sent you $" + documentSnapshot.get("amount").toFixed(2)

        }

        if (!documentSnapshot.get("isAn") && !documentSnapshot.get("isGM")) {
            if ((documentSnapshot.get("memo") || "") != "") {
                body += " for " + documentSnapshot.get("memo")
            }
        }

        documentSnapshot.get("fcm").forEach(async tkn => {
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

    } catch (e) {
        console.log(e)
    }

})