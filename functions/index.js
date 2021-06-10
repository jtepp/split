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
        body = event.after.get("to") + " requested $" + event.after.get("amount").toFixed(2)
    } else {
        title = "Payment received"
        body = event.after.get("from") + " sent you $" + event.after.get("amount").toFixed(2)

    }



    let message = {
        notification: {
            title: title,
            body: body
        },
        token: "dOA3ab8BD0Ysp2ovfjwAPo:APA91bEcsAR3ecJ-8LouirdNvF5l1QbPQkvYM9uMUfaXmJialdMyfH1pIZKRU7avGfMgAKglKwIMdbCmh7fkcq13xQiHQ-TCiH48edrWVz9AEA17zQBkGoWu_6a_5qZ-Zc17oKFtAtsN"
    }
    let response = await admin.messaging().send(message)
    console.log(response)


})