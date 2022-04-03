# WIS2-GlobalBroker-NodeRed

From the project for running Node-RED in Docker by binnes (https://github.com/binnes/Node-RED-Docker)

The code in this repository is to provide basic reference of a Global Broker as defined in the (upcoming) technical specification of WIS2.

## How to use this project

1. This is the source code of the container `golfvert/wis2globalbrokernodered`
2. The above container provides what is necessary to make a broker (eg. Mosquitto) a Global Broker for WIS2
3. After getting the container, you will have to change de definition of:
* the originating center (each originating center will require one docker container)
* the associated broker
* two other brokers

Considering how NodeRed works, it is rather difficult (impossible?) to make dynamic the brokers configurations as well as the number of Global Brokers to connect to.
However, by looking at the flows, it should be rather straightforward to do what is necessary to adapt to the exact use case.

This is not production ready, just a tool to show what WIS2 and here the Global Broker part will work.
