const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotificationOnPayment = functions.firestore.document("houses/{houseid}/payments/{paymentid}").onWrite(async (event, context) => {

    var title;
    var body;
    var snd = "default"
    const type = event.after.get("type");
    const edits = event.after.get("edits") || {}
    const lastEdit = edits[Object.keys(edits).reverse()[0]]
    let composer = lastEdit.match(/(.+?) (changed:|opted)/)[1]
    let reqFrom = event.after.get("reqfrom")
    let to = event.after.get("to") || ""
    let from = event.after.get("from") || ""
    var typeFix = "unknown"

    if (Object.keys(edits).length > 0) { // announce edits
        let fcms = []
        await admin.firestore().collection("houses/" + context.params.houseid + "/members").get().then(function (querySnapshot) {

            querySnapshot.forEach(function (doc) {
                let data = doc.data()
                if (type == "request" || event.after.get("isRequest")) { // request edit
                    title = "Request Edited"

                    // fcms should be everyone in reqfrom
                    if (reqFrom.includes(data.name)) {
                        fcms.push(data.fcm)
                        // also include to
                    } else if (to == data.name) {
                        fcms.push(data.fcm)
                    }
                } else { // payment edit
                    title = "Payment Edited"

                    // fcms should be to
                    if (to == data.name) {
                        fcms.push(data.fcm)
                        // also include from
                    } else if (from == data.name) {
                        fcms.push(data.fcm)
                    }
                }
                // remove composer of edit
                if (data.name.trim() == composer.trim()) {
                    fcms = removeItemOnce(fcms, data.fcm)
                }
            })
        })
        fcms.forEach(async tkn => {
            let message = {
                notification: {
                    title: title,
                    body: lastEdit
                },
                token: tkn,
                apns: {
                    payload: {
                        aps: {
                            sound: "admin.mp3",
                        }
                    }
                }
            }
            if (tkn != undefined) {
                let response = await admin.messaging().send(message)
                console.log(response)
            }
        });
    } else { // normal body
        if (event.after.get("isAn") || type == "announcement") {
            typeFix = "announcement"
            event.after.get("id")

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

        } else if (event.after.get("isGM") || type == "groupmessage") {
            typeFix = "groupmessage"
            snd = "pay.mp3"
            title = "from " + event.after.get("from")
            body = event.after.get("memo")

        } else if (event.after.get("isRequest") || type == "request") {
            typeFix = "request"
            snd = "req.mp3"
            title = "Request received"
            let amount = event.after.get("amount").toFixed(2)
            console.log("REQFROM: " + reqFrom.toString())
            if (reqFrom.length == 1) {
                body = event.after.get("to") + " requested $" + amount + " from you"
            } else if (reqFrom.length == 2) {
                body = event.after.get("to") + " requested $" + amount + " ($" + Number(amount / reqFrom.length).toFixed(2) + " each), split between you and 1 other"
            } else {
                body = event.after.get("to") + " requested $" + amount + " ($" + Number(amount / reqFrom.length).toFixed(2) + " each), split between you and " + (reqFrom.length - 1) + " others"
            }
        } else if (type != "unknown") {
            typeFix = "payment"
            snd = "pay.mp3"
            title = "Payment received"
            body = event.after.get("from") + " sent you $" + event.after.get("amount").toFixed(2)

        }
        if (!event.after.get("isAn") && !event.after.get("isGM")) { // add memo to body
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
            if (!event.after.get("mute")) {
                let response = await admin.messaging().send(message)
                console.log(response)
            }
        });

        if (type == undefined) {
            admin.firestore().doc("houses/" + context.params.houseid + "/payments/" + context.params.paymentid).update({
                "type": typeFix,
                "mute": true
            })
        }
    }

})

function removeItemOnce(arr, value) {
    var index = arr.indexOf(value);
    if (index > -1) {
        arr.splice(index, 1);
    }
    return arr;
}