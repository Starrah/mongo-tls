const { customAlphabet } = require("./nanoid.js")
const nanoid = customAlphabet('useandom26T198340PX75pxJACKVERYMINDBUSHWOLFGQZbfghjklqvwyzrict')
const { writeFileSync } = require("fs")

db = db.getSiblingDB("admin")
// delete old user
try { db.dropUser("rotateCertificates") } catch (e) {}
const password = nanoid()
// create new user
db.createUser({
    user: "rotateCertificates",
    pwd: password,
    roles: [ { role: "hostManager", db: "admin" } ]
})
// write new user's password to file
writeFileSync("/mongo.user.rotateCertificates.pwd", password, {mode: 0o600})

db.rotateCertificates('Reload certificate on container start')
process.exit(0)
