Installation guide

Pre-requisites

- docker-compose 1.9.0+
- valid vizix license

1. cd vizix-kafka
2. $ docker login

2.1. optional
   sudo rm -rf kafka mongo mysql zookeeper

2. set docker-compose env variables

   docker-compose config

3. pull containers
   docker-compose pull

4. run basic containers
   docker-compose up -d mosquitto
   docker-compose up -d mysql
   docker-compose up -d mongo

5. start zookeeper and kafka
   docker-compose up -d zookeeper
   sleep 10
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

8. run services setup
   
   docker-compose up -d services
   docker-compose exec services bash

   # docker-compose exec services bash

   cd /
   ./run.sh install kafka

8.1. restart services

   ./restart-service.sh services 

10. run ui
    docker-compose up -d ui      

10.1. run services 
    docker-compose up -d services

11. open vizix ui in web brower http://localhost

12. load vizix license

13. update connection settings (mostly hostnames)
    - kafka 
    - mongo 
    - mqtt
    - services
    - sql

    ### open google docs

14. load kafka cache
    docker-compose up -d console-bridges

    docker-compose exec console-bridges bash

    cd app
    cp cacheLoaderTool.conf.template cacheLoaderTool.conf
    vi cacheLoaderTool.conf

    # update REST_HOST="services"

    ./cacheLoaderTool.sh

15. enable kafka and restart services
    # edit docker-compose.yml 
    # set VIZIX_KAFKA_ENABLED to "true"
    # set REST_API_KEY to "3T3BVTMTSG"

    docker-compose stop services
    docker-compose rm -f services
    docker-compose up -d services

16. run thingjoiner, cepprocessor and mongodao
    docker-compose up -d thingjoiner
    docker-compose up -d rulesprocessor
    docker-compose up -d mongoinjector

17. run alebridge
    docker-compose up -d alebridge

18. send test blink
    docker-compose exec console-bridges bash

    touch aledata.txt

    # file content
    CS,-118.443969,34.048092,0.0,20.0,ft
    LOC, 00:00:00,TEST0001,30,50,0,LR5,x3ed9371
