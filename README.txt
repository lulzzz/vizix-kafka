Installation guide

Pre-requisites

- docker-compose 1.9.0+
- valid vizix license

1. cd vizix-kafka
2. $ docker login
     # username/pass: mojixcloudops/35c-CWN-7mL-akt

3. pull container
   docker-compose pull

4. run basic containers
   docker-compose up -d mosquitto
   docker-compose up -d mysql
   docker-compose up -d mongo

5. start zookeeper and kafka
   docker-compose up -d zookeeper
   # wait 10 secs
   docker-compose up -d kafka

6. init mongo db
   docker-compose exec mongo sh
   
   mongo
   
   use admin
   db.system.users.remove({})
   db.system.version.remove({})
   db.dropUser("admin")
   db.createRole( { role: "executeFunctions", privileges: [ { resource: { anyResource: true }, actions: [ "anyAction" ] } ], roles: [] } )
   db.createUser({ user: "admin", pwd: "control123!", roles: ["userAdminAnyDatabase", "executeFunctions"] })
   
7. create kafka topics
   docker-compose exec kafka bash

   cd /app/kafka/bin


7. run services
   docker-compose up -d services

8. populate db
   docker-compose exec services bash

   cd /
   ./run.sh install retail kafka

9. run ui
   docker-compose up -d ui      

10. open vizix ui in web brower http://localhost

11. load vizix license

12. update connection settings (mostly hostnames)
    - kafka 
    - mongo 
    - mqtt
    - services
    - sql

