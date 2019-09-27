FROM node:lts as build

RUN apt-get update
RUN apt-get install -y build-essential python

RUN groupadd nodered \
  && useradd --gid nodered --shell /bin/bash --create-home nodered

USER nodered

RUN mkdir -p /home/nodered/.node-red

WORKDIR /home/nodered/.node-red

COPY ./package.json /home/nodered/.node-red/
RUN npm install

## Release image
FROM node:lts-slim

RUN groupadd nodered \
  && useradd --gid nodered --shell /bin/bash --create-home nodered

USER nodered

RUN mkdir -p /home/nodered/.node-red

WORKDIR /home/nodered/.node-red

COPY ./server.js /home/nodered/.node-red/
COPY ./settings.js /home/nodered/.node-red/
COPY ./flows.json /home/nodered/.node-red/
COPY ./package.json /home/nodered/.node-red/
COPY --from=build /home/nodered/.node-red/node_modules /home/nodered/.node-red/node_modules

ENV PORT 1880
ENV NODE_ENV=production
ENV NODE_PATH=/home/nodered/.nodered/node_modules
EXPOSE 1880

CMD ["node", "/home/nodered/.node-red/server.js", "/home/nodered/.node-red/flows.json"]
