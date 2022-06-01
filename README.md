# WIS2-GlobalBroker-NodeRed

The code in this repository is to provide basic reference of a Global Broker as defined in the (upcoming) technical specification of WIS2.
The repo has been cloned from the official NodeRed repository.

## What is here ?

1. This is the source code of the container `golfvert/wis2globalbrokernodered` and the required files to run the deduplication software in front of a Global Broker
2. configuration files to run the container available at `golfvert/wis2globalbrokernodered`

## What does it do ?

1. Listen to subscribed topics from WIS2Node and other Global Brokers (one subscription per container)
2. Look at the `id` in the message. 
3. Through a redis request check if that `id` has already been seen in the last 15 minutes. If yes, simply discard the message
4. If not, publish the message to the attached Global Broker
5. It also provides prometheus metrics available at http://@IP:1880/metrics

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
Copy & Paste the subsciber_mqtt_1 to get one container per WIS2Node or other Global Brokers to subscribe to. Do NOT subscribe to the local Global Broker.
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

## How to modify it ?

This is a fork from the official Node-Red repo. Follow official documentation to tweak it to your needs.
