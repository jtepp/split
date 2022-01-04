import {
    Payment,
    Request,
    Announcement,
    Groupmessage,
    Member
} from "/js/classes.js"

const myId = localStorage.getItem('myId') || null
const name = localStorage.getItem('name') || null
const houseId = localStorage.getItem('houseId') || null
const activityContainer = document.getElementById('activity-container')
var db;
var memberArray;
var paymentArray

if (!(myId && name && houseId)) { // if not logged in
    // show popup to go back to login page
    boot()
}





// once the page is loaded, set up firebase
document.addEventListener('DOMContentLoaded', function () {
    db = firebase.firestore()


    db.collection(`houses/${houseId}/members`).onSnapshot(snapshot => {
        memberArray = []
        snapshot.forEach(doc => {
            memberArray.push(new Member(doc.data(), doc.id))
        })

    }, err => {
        boot()
    })
    db.collection(`houses/${houseId}/payments`).orderBy('time', 'asc')
        .onSnapshot(snapshot => {
            paymentArray = []
            activityContainer.innerHTML = ''
            snapshot.docs.forEach(doc => {
                switch (doc.data().type) {
                    case 'payment':
                        paymentArray.push(new Payment(doc.data(), doc.id))
                        break;
                    case 'request':
                        paymentArray.push(new Request(doc.data(), doc.id))
                        break;
                    case 'announcement':
                        paymentArray.push(new Announcement(doc.data(), doc.id))
                        break;
                    case 'groupmessage':
                        paymentArray.push(new Groupmessage(doc.data(), doc.id))
                        break;
                    default:
                        break;

                }

            })
            paymentArray.forEach(payment => {
                activityContainer.prepend(payment.cell())
            })
            fixPayments()
        }, err => {
            console.log(err)
            boot()
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

function fixPayments() {
    for (let child of activityContainer.children) {
        if (child.getAttribute('type') == 'groupmessage') {
            if (child.previousElementSibling && child.getAttribute('senderId') && child.previousElementSibling.getAttribute('senderId') && child.getAttribute('senderId') == child.previousElementSibling.getAttribute('senderId')) {
                child.previousElementSibling.setAttribute('consecutive', '')
            }
        }
    }
    document.querySelectorAll('.member-img-container+.name-text').forEach(name => {
        if (memberArray) {
            let indexOfMember = memberArray.map(m => m.name).indexOf(name.textContent)
            if (indexOfMember != -1 && name.previousSibling && memberArray[indexOfMember].image != "") {
                name.previousSibling.querySelector('img').setAttribute('src', "data:image/jpeg;base64, " + memberArray[indexOfMember].image)
            }
        }
    })

    document.body.onclick = (e) => {
        if (e.target.classList.contains('chevron')) { // click on chevron to toggle memo
            e.target.parentElement.classList.toggle('open-memo');
        } else if (e.target.classList.contains('cell-inner-amount') && e.target.parentElement.parentElement.getAttribute('type') == "request") { // click on amount to toggle show each
            e.target.classList.toggle('show-each');
            updateShowEach(e.target);

        }
    }
}

function boot() {
    window.location.href = '/'
    window.localStorage.removeItem('myId')
    window.localStorage.removeItem('name')
    window.localStorage.removeItem('houseId')
}
document.getElementById('sign-out-button').onclick = boot