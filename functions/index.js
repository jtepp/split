const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onWrite(async (event, context) => {

    var title;
    var body;
    const data = event.after.data()

    console.log("RIGHTHERE " + JSON.stringify(event.after.data()))
    if (data["isAn"]) {
        title = "Announcement"
        body = data["from"] + " " + data["memo"]
    } else if (data["isRequest"]) {
        title = "Request received"
        body = data["to"] + " requested $" + data["amount"].toFixed(2) / data["reqFrom"].length
    } else {
        title = "Payment received"
        body = data["from"] + " sent you $" + data["amount"].toFixed(2)

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