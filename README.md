# Node-RED-Docker

Template project for running Node-RED in Docker

## Setting up a minishift pipeline

### To deploy gogs:
`oc new-project gogs`
`oc new-app -f https://raw.githubusercontent.com/eformat/gogs-openshift-docker/master/gogs-persistent.yaml`
wait until running `oc status`
`oc exec $(oc get pods | grep postgres | awk '{print $1}') env | grep POSTGRES`
`oc create configmap gogs --from-file=appini=<(oc exec $(oc get pods | grep gogs | awk '{print $1}') -- cat /etc/gogs/conf/app.ini)`
`oc set volume dc/gogs --add --name=config-volume -m /etc/gogs/conf/ --source='{"configMap":{"name":"gogs","items":[{"key":"appini","path":"app.ini"}]}}'`

### To deploy the Node-RED app and Mosquitto:
`oc new-project nodered-sample`
`
