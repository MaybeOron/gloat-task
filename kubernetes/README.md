## Kubernetes - Helm
Prerequisites: Helm, kubectl, Kubernetes cluster, Docker Image registry

The default images from "develeapoc" dockerhub registery can be used.  
To build the images locally:
- Tsunami: clone [official Tsunami repository](https://github.com/google/tsunami-security-scanner/tree/master) and build via `docker build -t .`
- Notifier: [dockerfile](../docker-compose/local-notifier-dockerfile)

You can set Slack channel and token values using the command line or integrate them with a secret store solution, as they are required for notifications to be sent. The "tsunami" variable specifies the IPs to be scanned, and resources can be changed for optimization or left as default.  

`jupyter_deployment.yaml` includes a deployment and a ClusterIP service.  
Insert the service's IP address at the chart's `values.yaml` to easly scan it.  


To install the chart, run:
```
helm install tsunami ./tsunami --namespace tsunami --create-namespace
```
For further information regarding the chart - [README.md](/kubernetes/tsunami/README.md)
