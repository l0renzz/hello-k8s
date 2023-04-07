# hello-k8s

This service aims to return the latest configured name at the / path and set a new name using the /name/yourName path.

In summary:

- **/** returns the latest configured name
- **/name/yourName** sets a new name

## Prerequisites

Before starting, please ensure that you have the following installed on your system:

- Minikube
- Docker
- (Optional) Fswatch

## Getting Started

To start the service, first ensure that the script ./deploy is executable by running in the root project the command:

```
chmod +x ./deploy.sh
```

Once the script is executable, you can run it by executing the following command:

```
./deploy.sh
```

This script will start Minikube and build a Docker image that contains the hello-k8s service written in Go. The service includes tests that verify its functionality and are tested every time the service is deployed.

Once the deployment is complete, you can obtain the URL to access the service by running in a new terminal the following command:

```
minikube service hello-k8s --url
```

Once you have obtained the URL, you can paste it into your browser's address bar to view the latest configured name.

To set a new name, you can use a curl command to send a POST request to the /name/yourName path in a new terminal. For example, you can use the following command to set the name "Lorenzo":

```
curl -X POST http://127.0.0.1:51435/name/Lorenzo (Change http://127.0.0.1:51435 with your URL)
```

This will update the configured name to "Lorenzo".

If fswatch is installed on the host machine, every time a change is made within the hello-k8s service, a new deployment will automatically start. This will update the Docker image with a new version, run the tests again, and deploy the new version.
