const functions = require("firebase-functions");
const admin = require("firebase-admin")
admin.initializeApp(functions.config().firebase)

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onWrite((event, context) => {



    
})