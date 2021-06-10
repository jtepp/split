const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onWrite(async (event, context) => {

    var title;
    var body;

    if (event.after.get("isAn")) {
        title = "Announcement"
        body = event.after.get("from") + " " + event.after.get("memo")
    } else if (event.after.get("isRequest")) {
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
        title = "Payment received"
        body = event.after.get("from") + " sent you $" + event.after.get("amount").toFixed(2)

    }


    event.after.get("fcm").array.forEach(async tkn => {
        let message = {
            notification: {
                title: title,
                body: body
            },
            token: tkn
        }
        let response = await admin.messaging().send(message)
        console.log(response)
    });



})