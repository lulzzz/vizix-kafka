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

## 6. Start and init basic containers



```
# Start mosquitto, mysql and mongo 
docker-compose up -d mosquitto mysql mongo

# init mongo
docker-compose exec mongo mongo admin /scripts/init-mongo.js

# Start kafka and zookeeper
docker-compose up -d zookeeper
sleep 10
docker-compose up -d kafka
```

## 7. Start services installation mode
Note: before doing this step verify that VIZIX_KAFKA_ENABLED is set to false in docker-compose.yml. 

```
docker-compose up -d services
# create kafka topics
docker-compose exec services /run.sh kafka createTopics
# popdb
docker-compose exec services /run.sh install
```

Now restart services and start ui so we can do initial setup in vizix platform 
```
./restart-service.sh services
docker-compose up -d ui
```

## 8. Do setup in UI.

- open http://localhost
- Load vizix license
- Follow google document for next steps 
url: https://docs.google.com/document/d/1eLrwlqj8GruVMUeco0GhCDM8aLgICxVdZCOaHHAFjK8/edit#heading=h.dgwjw9jckso1

## 9. Load kafka cache
```
docker-compose exec services /run.sh kafka loadCache
```

## 10. Enable kafka and restart services
Edit docker-compose.yml 
- set VIZIX_KAFKA_ENABLED to "true"

```
docker-compose config
./restart-service.sh services
```

## 11. Start thingjoiner, cepprocessor and mongodao
```
docker-compose up -d thingjoiner
docker-compose up -d rulesprocessor
docker-compose up -d mongoinjector
```

## 12. Start alebridge
```
docker-compose up -d alebridge
```
## 13. Send test blink
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
   sudo rm -rf volume
