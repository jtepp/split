class Post {
    constructor(data) {
        this.id = data.id;
        this.amount = data.amount;
        this.by = data.by;
        this.fcm = data.fcm;
        this.to = data.to;
        this.time = data.time;
        this.type = data.type;
        this.memo = data.memo;
        this.reqfrom = data.reqfrom;
        this.from = data.from;
        this.edits = data.edits;
    }
}

class Payment {
    constructor(post) {
        this.id = post.id;
        this.amount = post.amount;
        this.by = post.by;
        this.fcm = post.fcm;
        this.from = post.from;
        this.memo = post.memo;
        this.time = post.time;
        this.to = post.to;
        this.type = post.type;
        this.edits = post.edits;
    }

}

class Request {
    constructor(post) {
        this.id = post.id;
        this.amount = post.amount;
        this.by = post.by;
        this.fcm = post.fcm;
        this.reqfrom = post.reqfrom;
        this.memo = post.memo;
        this.time = post.time;
        this.to = post.to;
        this.type = post.type;
        this.edits = post.edits;
    }
}

class Announcement {
    constructor(post) {
        this.id = post.id;
        this.by = post.by;
        this.from = post.from;
        this.memo = post.memo;
        this.time = post.time;
        this.type = post.type;
        this.fcm = post.fcm;
    }
}

class Groupmessage {
    constructor(post) {
        this.id = post.id;
        this.by = post.by;
        this.from = post.from;
        this.memo = post.memo;
        this.time = post.time;
        this.type = post.type;
        this.fcm = post.fcm;
    }

}