const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onWrite(async (event, context) => {
    const db = admin.firestore()

    let isAn = event.after.get('isAn') || false
    console.log("isAn: " + isAn)
    if (!isAn) { //not announcment
        let isReq = event.after.get('isRequest') || false
        console.log("isReq: " + isReq)

        if (isReq) { //is request

            console.log("\n\nISREQUEST\n\n")

            let reqFrom = event.after.get("reqFrom") || []
            console.log("reqFrom: " + reqFrom.toString())

            let to = event.after.get('to') || ""
            console.log("to: " + to)

            let amount = event.after.get('amount') || 0
            console.log("amount: " + amount)

            //go thru all names and send notification if they match and have FCM
            db.collection("houses/" + context.params.houseid + "/payments").listDocuments()
                .then((documents) => {
                    documents.forEach((doc) => {
                        doc.get()
                            .then((docSnap) => {
                                let data = docSnap.data()
                                console.log("data: " + data)
                                if ((data["FCM"] || "") != "") {
                                    if (reqFrom.includes(data["name"])) { //user name in reqFrom
                                        //send notification
                                        let title = "Request received"
                                        let content = `${to} has requested $${amount.toFixed(2)}, split between you and ${reqFrom.length - 1} others`
                                        let message = {
                                            notification: {
                                                title: title,
                                                body: content
                                            },
                                            token: data["FCM"]
                                        }
                                        let response = await admin.messaging().send(message)
                                        console.log("response: " + response)
                                    }
                                }
                            })
                    })
                })





        } else { //pray is pay

            console.log("\n\nISPAYMENT\n\n")

            let to = event.after.get('to') || ""
            console.log("to: " + to)

            let from = event.after.get('from') || ""
            console.log("from: " + from)

            let amount = event.after.get('amount') || 0
            console.log("amount: " + amount)

            //go thru all names and send notification if they match and have FCM
            db.collection("houses/" + context.params.houseid + "/payments").listDocuments()
                .then((documents) => {
                    documents.forEach((doc) => {
                        doc.get()
                            .then((docSnap) => {
                                let data = docSnap.data()
                                console.log("data: " + data)
                                if ((data["FCM"] || "") != "") {
                                    if (data["name"] == to) {
                                        //send notification
                                        let title = "Payment received"
                                        let content = `${from} sent you $${amount.toFixed(2)}`
                                        let message = {
                                            notification: {
                                                title: title,
                                                body: content
                                            },
                                            token: data["FCM"]
                                        }
                                        let response = await admin.messaging().send(message)
                                        console.log("response: " + response)
                                    }
                                }
                            })
                    })
                })

        }



    } else { //is announcement 

        console.log("\n\nISANNOUNCEMENT\n\n")

        let from = event.after.get('from') || ""
        console.log("from: " + from)

        let memo = event.after.get('memo') || ""
        console.log("memo: " + memo)

        db.collection("houses/" + context.params.houseid + "/payments").listDocuments()
            .then((documents) => {
                documents.forEach((doc) => {
                    doc.get()
                        .then((docSnap) => {
                            let data = docSnap.data()
                            console.log("data: " + data)
                            if ((data["FCM"] || "") != "") {

                                //goes to everyone

                                // if (data["name"] == to) { 
                                //send notification
                                let title = "Announcement"
                                let content = `${from} ${memo}`
                                let message = {
                                    notification: {
                                        title: title,
                                        body: content
                                    },
                                    token: data["FCM"]
                                }
                                let response = await admin.messaging().send(message)
                                console.log("response: " + response)
                                // }
                            }
                        })
                })
            })

    }



})