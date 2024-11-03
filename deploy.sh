LOGFILE="deploy.log"

#cleaning function
stop_and_clean() {
  echo -e "\nStopping services and cleaning up..." | tee -a "$LOGFILE"
  
  # Stop docker-compose services
  docker-compose down >> "$LOGFILE" 2>&1
  
  echo "Cleanup done. All services stopped." | tee -a "$LOGFILE"
  exit 0
}
trap 'stop_and_clean' SIGINT

$if [ -f ".env" ]; then
  echo "Loading environment variables from .env file..." | tee -a "$LOGFILE"
  set -o allexport
  source .env
  set +o allexport
else
  echo ".env file not found. Please create one with the required variables." | tee -a "$LOGFILE"
  exit 1
fi

# We check variables
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

# We run the services in the docker compose
echo "Starting services with docker-compose up..." | tee -a "$LOGFILE"
docker-compose --env-file .env up --build | tee -a "$LOGFILE" &

COMPOSE_PID=$!
while kill -0 $COMPOSE_PID 2> /dev/null; do
  sleep 1
done

# We clean compose and containers on exit event
stop_and_clean
