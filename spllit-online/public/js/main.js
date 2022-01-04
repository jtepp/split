import {
    Payment,
    Request,
    Announcement,
    Groupmessage
} from "/js/postClass.js"

const myId = localStorage.getItem('myId') || null
const name = localStorage.getItem('name') || null
const houseId = localStorage.getItem('houseId') || null
const activityContainer = document.getElementById('activity-container')
var db;
var memberArray;
var paymentArray

if (!(myId && name && houseId)) { // if not logged in
    // show popup to go back to login page
    window.location.href = 'login'
}

// db.collection(`houses/${houseId}/members`).onSnapshot(snapshot => {
//     memberArray = []
//     snapshot.forEach(doc => {
//         memberArray.push(doc.data())
//     })
//     console.log(memberArray)
// })



// once the page is loaded, set up firebase
document.addEventListener('DOMContentLoaded', function () {
    db = firebase.firestore()

    db.collection(`houses/${houseId}/payments`).orderBy('time', 'asc')
        .onSnapshot(snapshot => {
            paymentArray = []
            activityContainer.innerHTML = ''
            snapshot.docs.forEach(doc => {
                switch (doc.data().type) {
                    case 'payment':
                        paymentArray.push(new Payment(doc.data()))
                        break;
                    case 'request':
                        paymentArray.push(new Request(doc.data()))
                        break;
                    case 'announcement':
                        paymentArray.push(new Announcement(doc.data()))
                        break;
                    case 'groupmessage':
                        paymentArray.push(new Groupmessage(doc.data()))
                        break;
                    default:
                        break;

                }

            })
            paymentArray.forEach(payment => {
                activityContainer.prepend(payment.cell())
            })
            fixConsecAddClick()
        }, err => {
            console.log(err)
        })


})

function updateShowEach(element) {
    let amount = element.getAttribute('amount');
    let members = element.parentElement.querySelector(".cell-inner-right").children.length;
    if (element.classList.contains('show-each') && members > 1) {
        element.innerText = "$" + (amount / members).toFixed(2) + " each";
    } else {
        element.innerText = "$" + (amount * 1).toFixed(2);
    }
}

function fixConsecAddClick() {
    for (let child of document.body.children) {
        if (child.getAttribute('type') == 'groupmessage') {
            if (child.nextElementSibling && child.getAttribute('senderId') && child.nextElementSibling.getAttribute('senderId') && child.getAttribute('senderId') == child.nextElementSibling.getAttribute('senderId')) {
                child.nextElementSibling.setAttribute('consecutive', '')
            }
        }
    }

    document.body.onclick = (e) => {
        if (e.target.classList.contains('chevron')) { // click on chevron to toggle memo
            e.target.parentElement.classList.toggle('open-memo');
        } else if (e.target.classList.contains('cell-inner-amount') && e.target.parentElement.parentElement.getAttribute('type') == "request") { // click on amount to toggle show each
            e.target.classList.toggle('show-each');
            updateShowEach(e.target);

        }
    }
}