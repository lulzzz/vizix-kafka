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

   cd /scripts/
   ./create-topics.sh

8. run services
   docker-compose up -d services

9. populate db
   docker-compose exec services bash

   cd /
   ./run.sh install retail kafka

10. run ui
    docker-compose up -d ui      

11. open vizix ui in web brower http://localhost

12. load vizix license

13. update connection settings (mostly hostnames)
    - kafka 
    - mongo 
    - mqtt
    - services
    - sql

14. load kafka cache
    docker-compose up -d console

    docker-compose exec console bash

    cp cacheLoaderTool.conf.template cacheLoaderTool.conf
    vi cacheLoaderTool.conf

    # update REST_HOST="services"

    ./cacheLoaderTool.sh

15. enable kafka and restart services
    # edit docker-compose.yml 
    # set VIZIX_KAFKA_ENABLED to "true"

    docker-compose stop services
    docker-compose rm -f services
    docker-compose up -d services

16. run thingjoiner, cepprocessor and mongodao
    docker-compose up -d thingjoiner
    docker-compose up -d cepprocessor
    docker-compose up -d mongodao

17. run alebridge
    docker-compose up -d alebridge

18. send test blink
    docker-compose exec console bash
