# Tsunami Security Scanner - Gloat Home Task

This repository demonstrates a use case for the "tsunami-security-scanner," integrated into a flow/automation.  
While an application is running, Tsunami will perform a network scan on the inputted server IPv4, identifying vulnerabilities.

There are 2 examples,  
a local POC environment deployed by [docker-compose](/docker-compose/README.md)  
and a [Kubernetes Helm chart](/kubernetes/README.md)

## Steps Taken to Achieve the Solution
I approached the task by building solutions step by step, integrating Tsunami into different platforms. The following steps outline my approach:

I started by exploring the "tsunami-security-scanner" repository and understanding its purpose.
I followed the "Quick Start" guide to run Tsunami within a Docker container locally.  

Notes about "tsunami-security-scanner":

* In "Pre-alpha" stage and under development, Major API changes are expected.
* High memory usage, (required up to 10GB)  
* The app can injest only 1 IPv4 address - Therefore, a long loop is expected if many addresses are inputed.

To see Tsunami in action, I created a Docker Compose file that replicates the environment in the Quick Start guide. This environment includes an unauthenticated Jupyter container, Tsunami, and a Notifier container that receives Tsunami's logs through a shared volume. At this stage, Tsunami still runs on a single IP address and creates log files with fixed names.

Next, I moved on to Kubernetes. I set up a Kubernetes cluster using Kind and a managed cloud cluster, running a single node on my machine. To scan multiple IP addresses, I wrote an entrypoint script to override Tsunami's entrypoint, looping over the IP addresses insert at `values.yaml` . As the scan is executed once and then exits, I created a Kubernetes CronJob to run Tsunami as an init container, followed by the Notifier as the main container, ensuring that the Notifier runs only after the scan is completed. In a similar logic to the Docker Compose setup, an "emptyDir" volume is created to share files between them.

I've chosen to run Tsunami and the Notfier as a CronJob for these reasons:  
* By running the scan schedule basis, you get notified for relevant vulnerabilities at the scan time.  
* As mentioned above, Tsunami uses a high amount of memory.  
It scans a known number of IPv4 addresses inputed and the time it takes to run is finite.  

Notes for Possible Improvements:
* Validation for IP addresses input.  
* Use a secret manager for Slack credentials instead of using values.
* Implement new entrypoint scripts with multi-threading (Python) or utilize the Kubernetes SDK for Tsunami scan job creation in parallel (not recommended due to high memory usage).  
* Use PVC if deployed at cloud managed clusters.  
* Check for Slack msg length to avoid possible issues.  
* Gitops - instead of installing the chart "manually", work with a gitops repo.  
