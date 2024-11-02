stop_and_clean() {
  echo -e "\nStopping services and cleaning up..."

  docker-compose down

  echo "Cleanup done. All services stopped."
  exit 0
}

# We load the env file
if [ -f ".env" ]; then
  echo "Loading environment variables from .env file..."
  set -o allexport
  source .env
  set +o allexport
else
  echo ".env file not found. Please create one with the required variables."
  exit 1
fi

WORKDIR=$(pwd)

if [ -z "${API_REPO}" ] || [ -z "${INTERFACE_REPO}" ] ||; then
  echo "Error: Please define all the variables"
  exit 1
fi

./clone.sh

echo "Building projects..."


echo "Starting services with docker-compose up..."
docker-compose --env-file .env up -d --build
echo "Checking if all services are running..."
# We wait for all containers to start
sleep 10

containers=$(docker ps --filter "status=running" --format "{{.Names}}: {{.Status}}")
if [ -z "$containers" ]; then
  echo "Error: No containers are running. Please check the logs for issues."
  stop_and_clean
else
  echo "All services are running:"
  echo "$containers"
fi

echo "Deployment is running. Press CTRL+C to stop the services."

trap 'stop_and_clean' SIGINT

while true; do
  sleep 1
done
