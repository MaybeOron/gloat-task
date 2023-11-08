# tsunami

A Helm chart for deploying tsunami-security-scanner

Prerequisites: Helm, kubectl, Kubernetes cluster, Docker Image registry

The default images from "develeapoc" dockerhub registery can be used.  
To build the images locally:
- Tsunami: clone [official Tsunami repository](https://github.com/google/tsunami-security-scanner/tree/master) and build via `docker build -t .`
- Notifier: [dockerfile](/docker-compose/local-notifier-dockerfile)

You can set Slack channel and token values using the command line or integrate them with a secret store solution, as they are required for notifications to be sent. The "tsunami" variable specifies the IPs to be scanned, and resources can be changed for optimization or left as default.  

`jupyter_deployment.yaml` includes a deployment and a ClusterIP service.  
Insert the service's IP address at the chart's `values.yaml` to easly scan it.  

To install the chart, run:
```
helm install tsunami ./tsunami --namespace tsunami --create-namespace
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| notifier | object | `{"image":"develeapoc/notifier:latest","resources":{"limits":{"cpu":"1","memory":"100Mi"},"requests":{"cpu":"0.2","memory":"50Mi"}},"slack":{"channel":"channel-placeholder","token":"token-placeholder"}}` | Configuration for the notifier  |
| notifier.image | string | `"develeapoc/notifier:latest"` | Image and tag configuration |
| notifier.resources | object | `{"limits":{"cpu":"1","memory":"100Mi"},"requests":{"cpu":"0.2","memory":"50Mi"}}` | resources block |
| notifier.slack | object | `{"channel":"channel-placeholder","token":"token-placeholder"}` | Slack configuration block |
| notifier.slack.channel | string | `"channel-placeholder"` | channel to post results to  |
| notifier.slack.token | string | `"token-placeholder"` | Token place holder, should be stored at a secret store, here for tests only and should not be saved to git / gitops repo. |
| tsunami | object | `{"cron_schedule":"1 * * * *","image":"develeapoc/tsunami:latest","ips":"127.0.0.1 127.0.0.2 10.99.215.204","resources":{"limits":{"cpu":"1","memory":"2Gi"},"requests":{"cpu":"0.2","memory":"1Gi"}}}` | Configuration block for tsunami  |
| tsunami.cron_schedule | string | `"1 * * * *"` | configure cron schedule for tsunami cronjob |
| tsunami.image | string | `"develeapoc/tsunami:latest"` | Image and tag configuration |
| tsunami.ips | string | `"127.0.0.1 127.0.0.2 10.99.215.204"` | whitespace separated list of IPv4 addresses |
| tsunami.resources | object | `{"limits":{"cpu":"1","memory":"2Gi"},"requests":{"cpu":"0.2","memory":"1Gi"}}` | resources block |

----------------------------------------------