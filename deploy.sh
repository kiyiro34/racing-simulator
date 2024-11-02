#!/bin/bash

LOGFILE="deploy.log"

stop_and_clean() {
  echo -e "\nStopping services and cleaning up..." | tee -a "$LOGFILE"
  
  docker-compose down >> "$LOGFILE" 2>&1

  echo "Cleanup done. All services stopped." | tee -a "$LOGFILE"
  exit 0
}

# We load the env file
if [ -f ".env" ]; then
  echo "Loading environment variables from .env file..." | tee -a "$LOGFILE"
  set -o allexport
  source .env
  set +o allexport
else
  echo ".env file not found. Please create one with the required variables." | tee -a "$LOGFILE"
  exit 1
fi

WORKDIR=$(pwd)

if [ -z "${API_REPO}" ] || [ -z "${INTERFACE_REPO}" ]; then
  echo "Error: Please define all the variables" | tee -a "$LOGFILE"
  exit 1
fi

echo "Cloning repositories..." | tee -a "$LOGFILE"
./clone.sh >> "$LOGFILE" 2>&1
if [ $? -ne 0 ]; then
  echo "Error: Clone script failed." | tee -a "$LOGFILE"
  stop_and_clean
fi

echo "Starting services with docker-compose up..." | tee -a "$LOGFILE"
docker-compose --env-file .env up -d --build >> "$LOGFILE" 2>&1
if [ $? -ne 0 ]; then
  echo "Error: Failed to start services with docker-compose." | tee -a "$LOGFILE"
  stop_and_clean
fi

echo "Checking if all services are running..." | tee -a "$LOGFILE"
sleep 10

containers=$(docker ps --filter "status=running" --format "{{.Names}}: {{.Status}}")
if [ -z "$containers" ]; then
  echo "Error: No containers are running. Please check the logs for issues." | tee -a "$LOGFILE"
  stop_and_clean
else
  echo "All services are running:" | tee -a "$LOGFILE"
  echo "$containers" | tee -a "$LOGFILE"
fi

echo "Deployment is running. Press CTRL+C to stop the services." | tee -a "$LOGFILE"

trap 'stop_and_clean' SIGINT

while true; do
  sleep 1
done
