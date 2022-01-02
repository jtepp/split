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
const dd = {
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
}
const testData = [
    new Payment(dd)
]