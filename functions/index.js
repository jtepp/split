const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onCreate(async (documentSnapshot, context) => { // use onUpdate for opting
    try {
        var title;
        var body;
        var snd = "default"
        const dataObject = documentSnapshot.data();
        console.log("Payment created");
        const type = dataObject["type"]
        console.log("data fine");
        if (dataObject["isAn"] || type == "announcement") {
            let memo = dataObject["memo"]
            title = "Announcement"
            body = dataObject["from"] + " " + memo
            if (memo.includes("join") || memo.includes("create")) {
                snd = "join.mp3"
            } else if (memo.includes("left") || memo.includes("remove")) {
                snd = "leave.mp3"
            } else if (memo.includes("Admin")) {
                snd = "admin.mp3"
            }
        } else if (dataObject["isGM"] || type == "groupmessage") {
            snd = "pay.mp3"
            title = "from " + dataObject["from"]
            body = dataObject["memo"]
        } else if (dataObject["isRequest"] || type == "request") {
            snd = "req.mp3"
            title = "Request received"
            let reqFrom = dataObject["reqfrom"]
            console.log("REQFROM: " + reqFrom.toString())
            if (reqFrom.length == 1) {
                body = dataObject["to"] + " requested $" + Number(dataObject["amount"]).toFixed(2) + " from you"
            } else if (reqFrom.length == 2) {
                body = dataObject["to"] + " requested $" + Number(dataObject["amount"]).toFixed(2) + " ($" + Number(dataObject["amount"] / reqFrom.length).toFixed(2) + " each), split between you and 1 other"
            } else {
                body = dataObject["to"] + " requested $" + Number(dataObject["amount"]).toFixed(2) + " ($" + Number(dataObject["amount"] / reqFrom.length).toFixed(2) + " each), split between you and " + (reqFrom.length - 1) + " others"
                // body = dataObject["to"] + " requested $" + Number(dataObject["amount"]).toFixed(2) + ", split between you and " + (reqFrom.length - 1) + " others"
            }
        } else {
            snd = "pay.mp3"
            title = "Payment received"
            body = dataObject["from"] + " sent you $" + Number(dataObject["amount"]).toFixed(2)

        }

        if (!dataObject["isAn"] && !dataObject["isGM"]) {
            if ((dataObject["memo"] || "") != "") {
                body += " for " + dataObject["memo"]
            }
        }

        dataObject["fcm"].forEach(async tkn => {
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
        console.log("ERROR: " + e)
    }

})