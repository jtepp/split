const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onWrite(async (event, context) => {

    let fcm = event.after.get("fcm")

    let message = {
        notification: {
            title: "Update",
            content: "Check the app!"
        },
        token: fcm
    }
    let response = await admin.messaging().send(message)
    console.log(response)


})