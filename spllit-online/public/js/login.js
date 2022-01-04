const nameField = document.getElementById('login-name');
const idField = document.getElementById('login-id');
const demoButton = document.getElementById('demo-button');
const loginButton = document.getElementById('login-button');
var db;

// once the page is loaded, set up firebase
document.addEventListener('DOMContentLoaded', function () {
    db = firebase.firestore()
})

demoButton.addEventListener('click', () => {
    findHome('demo', 'demo')
})

function findHome(name, id) {
    // find home in firestore that has a member with the name and id
    const member = db.collectionGroup('members')
        .where('name', '==', name)
        .get()
    // if found, set name, id, and houseId in local storage
    // then redirect to home page
    // if not found, show alert

    member.then(snapshot => {
        if (snapshot.empty) {
            alert('Member not found')
        } else {
            const data = snapshot.docs[0].data()
            localStorage.setItem('name', data.name)
            localStorage.setItem('myId', data.id)
            localStorage.setItem('houseId', data.home)
            window.location.href = 'main'
        }
    })

}