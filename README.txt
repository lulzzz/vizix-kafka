Installation guide

1. cd vizix-kafka
2. $ docker login
     # username/pass: mojixcloudops/35c-CWN-7mL-akt

3. pull container
   docker-compose pull

4. run basic containers
   docker-compose up -d mysql
   docker-compose up -d mongo
   docker-compose up -d mosquitto
