## docker-compose
Prerequisites: Docker, docker-compose  
Create a POC environment to see Tsunami in action,  
running three containers:

1. Jupyter (unauthenticated-jupyter-notebook)
2. Tsunami
3. Notifier (Alpine) - Slack notification

To set up the Tsunami image, you should build it locally, as mentioned in the [official Tsunami repository](https://github.com/google/tsunami-security-scanner/tree/master).

The Tsunami container will be created as Jupyter comes up.   
The Notifier container only starts after Tsunami's container has run successfully.  
A shared volume named "tsunami_logs" is created to share Tsunami's output file with the Notifier.  
To enable the Notifier, create a file named `.env` that includes two variables: SLACK_TOKEN and SLACK_CHANNEL. The Notifier will not work without correct values.  
Run `docker-compose up` to create the environment, and wait for the Notifier to output logs and expect a Slack notification.  
To destroy the environment, run `docker-compose down`.
