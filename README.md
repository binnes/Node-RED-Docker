# WIS2-GlobalBroker-NodeRed

From the project for running Node-RED in Docker by binnes (https://github.com/binnes/Node-RED-Docker)

The code in this repository is to provide basic reference of a Global Broker as defined in the (upcoming) technical specification of WIS2.

## What is here ?

1. This is the source code of the container `golfvert/wis2globalbrokernodered` and the required files to run the deduplication software in front of a Global Broker
2. configuration files to run the container available at `golfvert/wis2globalbrokernodered`

## How to use it ?

Download 2 files:
- publisher.env
- docker-compose.yaml

and to edit:

### Step 1: Edit publisher.env
This file contains the required information to connect to the Global Broker. 
```
MQTT_PUB_HOST=GlobalBroker_IPAddr
MQTT_PUB_PORT=GlobalBroker_Port
MQTT_PUB_USER=
MQTT_PUB_PASSWD=
```

### Step 2: Edit docker-compose.yaml
Cpoy & Paste the subsciber_mqtt_1 to get one container per WIS2Node or other Global Brokers to subscribe to. Do NOT subscribe to the local Global Broker.
- Change the name of the container (make sure it is unique!)
- Change all MQTT_SUB_* to connect to the remote broker and to the topic from that source. In the example below `wis2/a/origin/FRA/#` will subscribe to all topic from France according to WIS2 agreed topic hierarchy.
- Change ports 1st 1880:1880, 2nd 1881:1880,...

```
  subscriber_mqtt_1:
    container_name: subscriber_mqtt_1
    image: golfvert/wis2globalbrokernodered
    env_file:
      - ./publisher.env
    environment:
      - TZ=Europe/Paris
      - MQTT_SUB_HOST=Broker_IPAddr   # WIS2Node broker
      - MQTT_SUB_PORT=Broker_Port
      - MQTT_SUB_USER=
      - MQTT_SUB_PASSWD=
      - MQTT_SUB_TOPIC=Topic_to_sub   # e.g. wis2/a/origin/FRA/#
    ports:
      - "1880:1880"
    networks:
      - wis2relay
    depends_on:
      - redis
 ```

When done, save the docker-compose.yaml and start it with `docker compose up -d`

It will subscribe to all "remote" destinations (WIS2node(s), other Global Brokers) and will publish to the local Global Broker.

This is not production ready, just a tool to show how WIS2 and in particular the Global Broker part will work.
