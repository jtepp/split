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

class Payment {
    function (data) {
        Post.prototype.constructor.call(this, data);
        this.amount = data.amount;
        this.from = data.from;
        this.to = data.to;
        this.edits = data.edits;
    }
}

class Request {
    constructor(data) {
        Post.prototype.constructor.call(this, data)
        this.amount = data.amount;
        this.reqfrom = data.reqfrom;
        this.to = data.to;
        this.edits = data.edits;
        this.includeSelf = data.includeSelf;
    }
}

class Announcement {
    constructor(data) {
        Post.prototype.constructor.call(this, data)
        this.from = data.from;
    }
}

class Groupmessage {
    constructor(data) {
        Post.prototype.constructor.call(this, data)
        this.from = data.from;
    }
}

const testData = [
    new Payment({
        id: 1,
        by: "aaa",
        fcm: ["bbb"],
        time: 1641071000,
        type: "payment",
        memo: "test",
        amount: 6.3,
        from: "aaa",
        to: "bbb",
        edits: ["aaa changed: Amount from 1.00 to 6.30"]
    })
]

/*
<div class="post-cell" id="1">
        <!-- before is time and after is date -->
        <div class="cell-inner-left"></div>
        <!-- after is arrow -->
        <div class="cell-inner-right"></div>
        <div class="cell-inner-amount"></div>
        <div class="cell-inner-memo"></div>
    </div>
*/