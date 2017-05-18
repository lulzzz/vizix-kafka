//use admin;
db.system.users.remove({});
db.system.version.remove({});
db.dropUser("admin");
db.createRole( { role: "executeFunctions", privileges: [ { resource: { anyResource: true }, actions: [ "anyAction" ] } ], roles: [] } );
db.createUser({ user: "admin", pwd: "control123!", roles: ["userAdminAnyDatabase", "executeFunctions"] });