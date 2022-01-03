// in main there will be an array of members where image data is available

class Post {
    constructor(data) {
        this.id = data.id;
        this.by = data.by;
        this.fcm = data.fcm;
        this.time = data.time;
        this.type = data.type;
        this.memo = data.memo;
    }
}

class Payment extends Post {
    constructor(data) {
        super(data)
        this.amount = data.amount;
        this.from = data.from;
        this.to = data.to;
        this.edits = data.edits;
    }

    cell() {
        let postCell = document.createElement('div');
        postCell.classList.add('post-cell');
        postCell.classList.add('basic-post-cell');
        postCell.setAttribute('id', this.id);
        postCell.setAttribute('time', unixToTime(this.time));
        postCell.setAttribute('date', unixToDate(this.time));
        postCell.setAttribute('type', this.type);

        let cellInner = document.createElement('div');
        cellInner.classList.add('cell-inner');

        let cellInnerLeft = document.createElement('div');
        cellInnerLeft.classList.add('cell-inner-left');

        let singleMemberContLeft = document.createElement('div');
        singleMemberContLeft.classList.add('single-member-container');

        let singleMemberLeft = document.createElement('div');
        singleMemberLeft.classList.add('single-member');

        let memberImgLeft = document.createElement('img');
        memberImgLeft.setAttribute('draggable', 'false');
        memberImgLeft.setAttribute('src', "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200");
        memberImgLeft.classList.add('member-img');
        singleMemberLeft.appendChild(memberImgLeft);

        let nameTextLeft = document.createElement('div');
        nameTextLeft.classList.add('name-text');
        nameTextLeft.classList.add('vertical-center');

        let nameTextLeftP = document.createElement('p');
        nameTextLeftP.innerText = this.from;
        nameTextLeft.appendChild(nameTextLeftP);

        singleMemberLeft.appendChild(nameTextLeft);
        singleMemberContLeft.appendChild(singleMemberLeft);
        cellInnerLeft.appendChild(singleMemberContLeft);

        cellInner.appendChild(cellInnerLeft);

        let arrowCont = document.createElement('div');
        arrowCont.classList.add('vertical-center');

        let arrowImg = document.createElement('img');
        arrowImg.setAttribute('draggable', 'false');
        arrowImg.setAttribute('src', "res/sfs/arrow.right.png");
        arrowImg.classList.add('sfs');
        arrowImg.classList.add('arrow');
        arrowCont.appendChild(arrowImg);
        cellInner.appendChild(arrowCont);

        let cellInnerRight = document.createElement('div');
        cellInnerRight.classList.add('cell-inner-right');


        let singleMemberContRight = document.createElement('div');
        singleMemberContRight.classList.add('single-member-container');

        let singleMemberRight = document.createElement('div');
        singleMemberRight.classList.add('single-member');

        let memberImgRight = document.createElement('img');
        memberImgRight.setAttribute('draggable', 'false');
        memberImgRight.setAttribute('src', "https://www.gravatar.com/avatar");
        memberImgRight.classList.add('member-img');
        singleMemberRight.appendChild(memberImgRight);

        let nameTextRight = document.createElement('div');
        nameTextRight.classList.add('name-text');
        nameTextRight.classList.add('vertical-center');

        let nameTextRightP = document.createElement('p');
        nameTextRightP.innerText = this.to;
        nameTextRight.appendChild(nameTextRightP);

        singleMemberRight.appendChild(nameTextRight);
        singleMemberContRight.appendChild(singleMemberRight);
        cellInnerRight.appendChild(singleMemberContRight);

        let cellInnerAmount = document.createElement('div');
        cellInnerAmount.classList.add('cell-inner-amount');
        cellInnerAmount.setAttribute('amount', this.amount);
        cellInnerAmount.innerText = "$" + this.amount.toFixed(2);

        cellInner.appendChild(cellInnerRight);

        cellInner.appendChild(cellInnerAmount);

        let cellInnerMemo = document.createElement('div');
        cellInnerMemo.classList.add('cell-inner-memo');
        cellInnerMemo.setAttribute('type', this.type);
        cellInnerMemo.innerText = this.memo;

        let chevronImg = document.createElement('img');
        chevronImg.setAttribute('draggable', 'false');
        chevronImg.setAttribute('src', "res/sfs/chevron.down.png");
        chevronImg.classList.add('sfs');
        chevronImg.classList.add('chevron');

        postCell.appendChild(cellInner);
        postCell.appendChild(cellInnerMemo);
        postCell.appendChild(chevronImg);

        return postCell;
    }
}

class Request extends Post {
    constructor(data) {
        super(data)
        this.amount = data.amount;
        this.reqfrom = data.reqfrom;
        this.to = data.to;
        this.edits = data.edits;
        this.includeSelf = data.includeSelf;
    }

    cell() {
        let postCell = document.createElement('div');
        postCell.classList.add('post-cell');
        postCell.classList.add('basic-post-cell');
        postCell.setAttribute('id', this.id);
        postCell.setAttribute('time', unixToTime(this.time));
        postCell.setAttribute('date', unixToDate(this.time));
        postCell.setAttribute('type', this.type);

        let cellInner = document.createElement('div');
        cellInner.classList.add('cell-inner');

        let cellInnerLeft = document.createElement('div');
        cellInnerLeft.classList.add('cell-inner-left');

        let singleMemberContLeft = document.createElement('div');
        singleMemberContLeft.classList.add('single-member-container');

        let singleMemberLeft = document.createElement('div');
        singleMemberLeft.classList.add('single-member');

        let memberImgLeft = document.createElement('img');
        memberImgLeft.setAttribute('draggable', 'false');
        memberImgLeft.setAttribute('src', "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200");
        memberImgLeft.classList.add('member-img');
        singleMemberLeft.appendChild(memberImgLeft);

        let nameTextLeft = document.createElement('div');
        nameTextLeft.classList.add('name-text');
        nameTextLeft.classList.add('vertical-center');

        let nameTextLeftP = document.createElement('p');
        nameTextLeftP.innerText = this.to;
        nameTextLeft.appendChild(nameTextLeftP);

        singleMemberLeft.appendChild(nameTextLeft);
        singleMemberContLeft.appendChild(singleMemberLeft);
        cellInnerLeft.appendChild(singleMemberContLeft);

        cellInner.appendChild(cellInnerLeft);

        let arrowCont = document.createElement('div');
        arrowCont.classList.add('vertical-center');

        let arrowImg = document.createElement('img');
        arrowImg.setAttribute('draggable', 'false');
        arrowImg.setAttribute('src', "res/sfs/arrow.left.png");
        arrowImg.classList.add('sfs');
        arrowImg.classList.add('arrow');
        arrowCont.appendChild(arrowImg);
        cellInner.appendChild(arrowCont);

        let cellInnerRight = document.createElement('div');
        cellInnerRight.classList.add('cell-inner-right');

        this.reqfrom.forEach(name => {
            let singleMemberContRight = document.createElement('div');
            singleMemberContRight.classList.add('single-member-container');

            let singleMemberRight = document.createElement('div');
            singleMemberRight.classList.add('single-member');

            let memberImgRight = document.createElement('img');
            memberImgRight.setAttribute('draggable', 'false');
            memberImgRight.setAttribute('src', "https://www.gravatar.com/avatar");
            memberImgRight.classList.add('member-img');
            singleMemberRight.appendChild(memberImgRight);

            let nameTextRight = document.createElement('div');
            nameTextRight.classList.add('name-text');
            nameTextRight.classList.add('vertical-center');

            let nameTextRightP = document.createElement('p');
            nameTextRightP.innerText = name;
            if (this.reqfrom.lastIndexOf(name) == this.reqfrom.length - 1) {
                nameTextRightP.setAttribute("more-tag", " + " + (this.reqfrom.length - 1) + " more");
            }
            nameTextRight.appendChild(nameTextRightP);

            singleMemberRight.appendChild(nameTextRight);
            singleMemberContRight.appendChild(singleMemberRight);
            cellInnerRight.appendChild(singleMemberContRight);
        })

        cellInner.appendChild(cellInnerRight);

        let cellInnerAmount = document.createElement('div');
        cellInnerAmount.classList.add('cell-inner-amount');
        cellInnerAmount.setAttribute('amount', this.amount);
        cellInnerAmount.innerText = "$" + this.amount.toFixed(2);


        cellInner.appendChild(cellInnerAmount);

        let cellInnerMemo = document.createElement('div');
        cellInnerMemo.classList.add('cell-inner-memo');
        cellInnerMemo.setAttribute('type', this.type);
        cellInnerMemo.innerText = this.memo;

        let chevronImg = document.createElement('img');
        chevronImg.setAttribute('draggable', 'false');
        chevronImg.setAttribute('src', "res/sfs/chevron.down.png");
        chevronImg.classList.add('sfs');
        chevronImg.classList.add('chevron');

        postCell.appendChild(cellInner);
        postCell.appendChild(cellInnerMemo);
        postCell.appendChild(chevronImg);

        return postCell;
    }
}

class Announcement extends Post {
    constructor(data) {
        super(data)
        this.from = data.from;
    }
}

class Groupmessage extends Post {
    constructor(data) {
        super(data)
        this.from = data.from;
        this.reqfrom = data.reqfrom;
    }
}

const testData = [
    new Payment({
        id: 11,
        by: "aaa",
        fcm: ["bbb"],
        time: 1641071000,
        type: "payment",
        memo: "test",
        amount: 6.3,
        from: "aaa",
        to: "bbb",
        edits: ["aaa changed: Amount from 1.00 to 6.30"]
    }),
    new Request({
        id: 12,
        by: "aaa",
        fcm: ["bbb"],
        time: 1641071000,
        type: "request",
        memo: "test",
        amount: 22,
        reqfrom: ["aaa", "bbb"],
        to: "ccc",
        edits: ["aaa changed: Amount from 1.00 to 22.00"]
    })

]

function unixToTime(unix) {
    const d = new Date(1641112010 * 1000);

    const options = {
        hour: '2-digit',
        minute: '2-digit'
    };
    const time = new Intl.DateTimeFormat('en-US', options).format;

    return time(d);
}

function unixToDate(unix) {
    const d = new Date(1641112010 * 1000);

    const options = {
        month: 'numeric',
        day: 'numeric',
        year: '2-digit'
    };

    const date = new Intl.DateTimeFormat('en-US', options).format;

    return date(d);
}

testData.forEach(post => {
    document.body.appendChild(post.cell())
})

document.body.onclick = (e) => {
    if (e.target.classList.contains('chevron')) { // click on chevron to toggle memo
        e.target.parentElement.classList.toggle('open-memo');
    } else if (e.target.classList.contains('cell-inner-amount') && e.target.parentElement.parentElement.getAttribute('type') == "request") { // click on amount to toggle show each
        e.target.classList.toggle('show-each');
        updateShowEach(e.target);

    }
}

function updateShowEach(element) {
    let amount = element.getAttribute('amount');
    let members = element.parentElement.querySelector(".cell-inner-right").children.length;
    if (element.classList.contains('show-each')) {
        element.innerText = "$" + (amount / members).toFixed(2) + " each";
    } else {
        element.innerText = "$" + (amount * 1).toFixed(2);
    }
}