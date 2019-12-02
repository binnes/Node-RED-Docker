# Node-RED-Docker

Template project for running Node-RED in Docker

The code in this repository is to provide a starting project for Node-RED, where the aim is to run in a production, cloud based environment.  There have been a few modifications over the standard Node-RED released code.

## How to use this project

1. using a standard install of Node-RED with the [projects](https://nodered.org/docs/user-guide/projects/) feature enabled, clone a fork of this repository
2. develop your Node-RED application
3. when you are ready to release it use the Dockerfile in this repository to build your application

See the tutorials [here](https://github.com/binnes/Node-RED-container-prod)

## Changes from a standard Node-RED install

### Node-RED Editor

In a production system the Node-RED editor should be disabled.  However, in this project the editor has been moved from the root (**/**) endpoint to the **/admin** endpoint to allow the application to be examined within the container.

It is recommended that the editor be disabled for any production workload.  This is achieved by modifying the **settings.js** file to change the **httpAdminRoot** property from **"/admin"** to **false** : `**httpAdminRoot: false,**`

For more details about configuring the runtime using the **settings.js** file see the [configuration section](https://nodered.org/docs/user-guide/runtime/configuration) of the Node-RED documentation.

### Health endpoints

When running containers within a managed cloud environment, it is often useful to provide some endpoints within the container, so the cloud management system can verify the container is still alive and responding to requests.

This project adds the Health Checking capability from [CloudNativeJS.io](https://www.cloudnativejs.io).  The integration has be done in the **server.js** file by adding the following lines of code:

```JavaScript
var health = require('@cloudnative/health-connect');

var healthcheck = new health.HealthChecker();
app.use('/live', health.LivenessEndpoint(healthcheck));
app.use('/ready', health.ReadinessEndpoint(healthcheck));
app.use('/health', health.HealthEndpoint(healthcheck));
```
