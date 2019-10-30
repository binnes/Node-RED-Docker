FROM node:lts as build

RUN apt-get update \
  && apt-get install -y build-essential python perl-modules

RUN deluser --remove-home node \
  && groupadd --gid 1000 nodered \
  && useradd --gid nodered --uid 1000 --shell /bin/bash --create-home nodered

USER 1000

RUN mkdir -p /home/nodered/.node-red

WORKDIR /home/nodered/.node-red

COPY ./package.json /home/nodered/.node-red/
RUN npm install

## Release image
FROM node:lts-slim

RUN apt-get update && apt-get install -y perl-modules

RUN deluser --remove-home node \
  && groupadd --gid 1000 nodered \
  && useradd --gid nodered --uid 1000 --shell /bin/bash --create-home nodered

USER 1000

RUN mkdir -p /home/nodered/.node-red

WORKDIR /home/nodered/.node-red

COPY ./server.js /home/nodered/.node-red/
COPY ./settings.js /home/nodered/.node-red/
COPY ./flows.json /home/nodered/.node-red/
COPY ./flows_cred.json /home/nodered/.node-red/
COPY ./package.json /home/nodered/.node-red/
COPY --from=build /home/nodered/.node-red/node_modules /home/nodered/.node-red/node_modules

USER 0

RUN chgrp -R 0 /home/nodered/.node-red \
  && chmod -R g=u /home/nodered/.node-red

USER 1000

ENV PORT 1880
ENV NODE_ENV=production
ENV NODE_PATH=/home/nodered/.nodered/node_modules
EXPOSE 1880

CMD ["node", "/home/nodered/.node-red/server.js", "/home/nodered/.node-red/flows.json"]
