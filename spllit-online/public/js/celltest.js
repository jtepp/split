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
    constructor(post) {
        Post.call(this, post)
        this.amount = post.amount;
        this.from = post.from;
        this.to = post.to;
        this.edits = post.edits;
    }

}

class Request {
    constructor(post) {
        Post.call(this, post)
        this.amount = post.amount;
        this.reqfrom = post.reqfrom;
        this.to = post.to;
        this.edits = post.edits;
    }
}

class Announcement {
    constructor(post) {
        Post.call(this, post)
        this.from = post.from;
    }
}

class Groupmessage {
    constructor(post) {
        Post.call(this, post)
        this.from = post.from;
    }
}