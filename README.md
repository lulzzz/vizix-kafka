# Installation guide

## 1. Pre-requisites

- docker-compose 1.9.0+
- valid vizix license

## 2. Enter to vizix-kafka directory 

```
cd vizix-kafka
```
	
## 3. Login to docker

```
docker login
```

## 4. Set appropiate variables in .env file
set values for:
- VIZIX_SERVICES_IMAGE
- VIZIX_BRIDGES_IMAGE
- VIZIX_UI_IMAGE
- KAFKA_ADDRESS
- ZOOKEEPER_ADDRESS

execute:
```
docker-compose config
```

## 5. Pull containers
```
docker-compose pull
```

## 6. Start basic containers
```
docker-compose up -d mosquitto mysql mongo
```

## 7. Start zookeeper and kafka
```
docker-compose up -d zookeeper
sleep 10
docker-compose up -d kafka
```

## 8. Init mongo db
```
docker-compose exec mongo mongo
```
```
use admin;
db.system.users.remove({});
db.system.version.remove({});
db.dropUser("admin");
db.createRole( { role: "executeFunctions", privileges: [ { resource: { anyResource: true }, actions: [ "anyAction" ] } ], roles: [] } );
db.createUser({ user: "admin", pwd: "control123!", roles: ["userAdminAnyDatabase", "executeFunctions"] });
exit;
```
   
## 9. Create kafka topics
```
docker-compose exec kafka /scripts/create-topics.sh
```

## 10. Make initial popdb and make initial setup in vizix platform
Important Note: We are goint to initiate services with no kafka support. 
Verify that VIZIX_KAFKA_ENABLED variable is set to false in docker-compose.yml

```
docker-compose up -d services
docker-compose exec services /run.sh install kafka
```

Now restart services so we can do initial setup in vizix platform 
```
./restart-service.sh services
```

## 11. Start UI
```
docker-compose up -d ui
```

## 12. open vizix ui in web brower http://localhost

- Load vizix license
- Follow google document for next steps 
url: https://docs.google.com/document/d/1eLrwlqj8GruVMUeco0GhCDM8aLgICxVdZCOaHHAFjK8/edit#heading=h.dgwjw9jckso1

## 13. Load kafka cache
```
docker-compose up -d console-bridges
docker-compose exec console-bridges bash
```
```
cd app
cp cacheLoaderTool.conf.template cacheLoaderTool.conf
vi cacheLoaderTool.conf
```
Update REST_HOST to "services"

Update apropiate apikey. go to mysql execute query to find it.
query to use is generally: select apikey, username from user0;

Update also .yml file in all bridges


Execute:
```
./cacheLoaderTool.sh
```

## 14. Enable kafka and restart services
Edit docker-compose.yml 
- set VIZIX_KAFKA_ENABLED to "true"
- set REST_API_KEY to "3T3BVTMTSG"
```
./restart-service.sh services
```

## 15. Start thingjoiner, cepprocessor and mongodao
```
docker-compose up -d thingjoiner
docker-compose up -d rulesprocessor
docker-compose up -d mongoinjector
```

## 16. Start alebridge
    docker-compose up -d alebridge

## 17. Send test blink
```
docker-compose exec console-bridges bash
```

create aledata.txt inside /app folder with the following content:
```
CS,-118.443969,34.048092,0.0,20.0,ft
LOC, 00:00:00,TEST0001,30,50,0,LR5,x3ed9371
```

Edit alebridge.sh and replace "localhost" with "alebridge"

and finally send blink
```
./aledata.sh
```

# Optional Commands

## Remove volumes
   sudo rm -rf kafka mongo mysql zookeeper