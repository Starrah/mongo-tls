db = Mongo().getDB("admin")
db.createUser(
  {
    user: "rotateCertificates",
    pwd:  "$PASSWD",
    roles: [ { role: "hostManager", db: "admin" } ]
  }
)
