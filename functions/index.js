const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onWrite(async (event, context) => {


    let message = {
        notification: {
            title: "Update",
            body: "Check the app!"
        },
        token: "dOA3ab8BD0Ysp2ovfjwAPo:APA91bEcsAR3ecJ-8LouirdNvF5l1QbPQkvYM9uMUfaXmJialdMyfH1pIZKRU7avGfMgAKglKwIMdbCmh7fkcq13xQiHQ-TCiH48edrWVz9AEA17zQBkGoWu_6a_5qZ-Zc17oKFtAtsN"
    }
    let response = await admin.messaging().send(message)
    console.log(response)


})