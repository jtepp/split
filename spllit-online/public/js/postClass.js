export default class Post {
    constructor(data) {
        this.id = data.id;
        this.by = data.by;
        this.fcm = data.fcm;
        this.time = data.time;
        this.type = data.type;
        this.memo = data.memo;
    }
}

export class Payment extends Post {
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

export class Request extends Post {
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

export class Announcement extends Post {
    constructor(data) {
        super(data)
        this.from = data.from;
    }

    cell() {
        let postCell = document.createElement('div');
        postCell.classList.add('post-cell');
        postCell.classList.add('announcement-post-cell');
        postCell.setAttribute('id', this.id);
        postCell.setAttribute('time', unixToTime(this.time));
        postCell.setAttribute('date', unixToDate(this.time));
        postCell.setAttribute('type', this.type);

        let announcementInner = document.createElement('div');
        announcementInner.classList.add('announcement-inner');

        let announcementInnerLeft = document.createElement('span');
        announcementInnerLeft.classList.add('announcement-inner-left');
        announcementInnerLeft.innerText = this.from;

        announcementInner.appendChild(announcementInnerLeft);

        let announcementInnerRight = document.createElement('span');
        announcementInnerRight.classList.add('announcement-inner-right');
        announcementInnerRight.innerHTML = "&nbsp;" + this.memo;

        announcementInner.appendChild(announcementInnerRight);

        postCell.appendChild(announcementInner);

        return postCell;
    }
}

export class Groupmessage extends Post {
    constructor(data) {
        super(data)
        this.from = data.from;
        this.reqfrom = data.reqfrom;
    }

    cell() {
        let gmPostCell = document.createElement('div');
        gmPostCell.classList.add('groupmessage-post-cell');
        gmPostCell.setAttribute('type', this.type);
        gmPostCell.setAttribute('senderId', this.by);

        //me
        if (this.by == myId) {
            gmPostCell.setAttribute('me', '');
        }

        let gmInnerLeft = document.createElement('div');
        gmInnerLeft.classList.add('gm-inner-left');
        gmInnerLeft.setAttribute('sender', this.from);

        let gmMemberImg = document.createElement('img');
        gmMemberImg.classList.add('gm-member-img');
        gmMemberImg.setAttribute('draggable', 'false');
        gmMemberImg.setAttribute('src', "https://www.gravatar.com/avatar");

        gmInnerLeft.appendChild(gmMemberImg);
        gmPostCell.appendChild(gmInnerLeft);

        let gmInnerRight = document.createElement('div');
        gmInnerRight.classList.add('gm-inner-right');
        gmInnerRight.setAttribute('id', this.id);
        gmInnerRight.setAttribute('time', unixToTime(this.time));
        gmInnerRight.setAttribute('date', unixToDate(this.time));

        let gmInnerRightP = document.createElement('p');
        gmInnerRightP.innerText = this.memo;

        gmInnerRight.appendChild(gmInnerRightP);
        gmPostCell.appendChild(gmInnerRight);

        return gmPostCell;
    }
}

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