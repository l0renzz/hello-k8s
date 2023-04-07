#!/bin/bash

SERVICE_PATH="services/hello-k8s"
IMAGE_NAME="hello-k8s-go"

# Used to avoid multiple deploys due to changes occurring too closely together, wait  time can be decreased or increased
debounce() {
  local wait_time=30

  # Execute command only if wait time passed
  if [ "$(date +%s)" -ge "$((${LAST_RUN:-0} + $wait_time))" ]; then
    LAST_RUN=$(date +%s)
    echo -e "\033[36mNew change detected, performing a new deploy...\033[0m"
    deploy update
  fi
}

# Build image and deploy
deploy() {
  VERSION=$(docker image ls | grep $IMAGE_NAME | awk '{print $2}' | sort -r | head -n 1)
  if [ -z "$VERSION" ]; then
      NEW_VERSION="1.0.0"
  else
      VERSION_NUMBER=$(echo $VERSION | awk -F '.' '{print $NF}')
      NEXT_VERSION=$(($VERSION_NUMBER+1))
      NEW_VERSION=$(echo $VERSION | sed "s/\.[0-9]*$/.$NEXT_VERSION/")
  fi

  echo -e "\033[32m\n\nBuilding Docker image $IMAGE_NAME with version $NEW_VERSION...\033[0m"
  eval $(minikube docker-env)
  docker build -t $IMAGE_NAME:$NEW_VERSION ./$SERVICE_PATH
  if [ $? -ne 0 ]; then
    echo -e "\033[31mError during bundling, check above error and try again...\033[0m"
  else
    if [ "$1" = "first" ]; then
      echo -e "\033[32m\nDeploying in k8s...\033[0m"
      kubectl apply -f hello-k8s.yaml
    else
      echo -e "\033[32m\nUpdating new image...\033[0m"
      kubectl set image deployment/hello-k8s hello-k8s=$IMAGE_NAME:$VERSION
    fi
    echo -e "\033[33m\n\n######################################\033[0m"
    echo -e "\033[33mDeploy completed:\033[0m"
    echo -e "1 - Open another terminal and execute \033[33m'minikube service hello-k8s --url'\033[0m to get URL"
    echo -e "2 - Open the URL in the browser to check the last name"
    echo -e "2 - To set a new name, make a curl request to the path /name/yourName (e.g. curl -X POST http://yourIP:yourPort/name/Lorenzo)"
    echo -e "\033[33m######################################\033[0m"
  fi
}


# Check if Minikube is installed
if ! command -v minikube &> /dev/null
then
    echo -e "\033[31mMinikube is not installed. Please install it before running this script.\033[0m"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo -e "\033[31mDocker is not installed. Please install it before running this script.\033[0m"
    exit 1
fi
echo -e "\033[33mMinikube and Docker installed, we can proceed...\033[0m"

echo -e "\033[32m\n\nStarting minikube...\033[0m"
minikube start --driver=docker
deploy first

# Recursive changes check
if command -v fswatch >/dev/null 2>&1; then
  echo -e "\033[33m\n\n######################################\033[0m"
  echo -e "\033[33mWaiting changes to perform a deploy...\033[0m"
  echo -e "If you update hello-k8s, a new deploy will begin..."
  echo -e "\033[33m######################################\033[0m"
  fswatch -r -l 5 "$SERVICE_PATH" | while read; do
    debounce
  done
else
  echo -e "\033[33m\n\nTo enable auto deploy, please install fswatch.\033[0m"
fi