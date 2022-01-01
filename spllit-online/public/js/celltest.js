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
    constructor(data) {
        Post.call(this, data)
        this.amount = data.amount;
        this.from = data.from;
        this.to = data.to;
        this.edits = data.edits;
    }
}

class Request {
    constructor(data) {
        Post.call(this, data)
        this.amount = data.amount;
        this.reqfrom = data.reqfrom;
        this.to = data.to;
        this.edits = data.edits;
        this.includeSelf = data.includeSelf;
    }
}

class Announcement {
    constructor(data) {
        Post.call(this, data)
        this.from = data.from;
    }
}

class Groupmessage {
    constructor(data) {
        Post.call(this, data)
        this.from = data.from;
    }
}