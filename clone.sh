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

#We check the urls
if [ -z "${API_REPO}" ] || [ -z "${INTERFACE_REPO}" ]; then
  echo "Error: Please define all the variables"
  exit 1
fi

# We clone
if [ ! -d "$WORKDIR/api" ]; then
  echo "Cloning API 1..."
  git clone ${API_REPO} api
else
  echo "API 1 repository already exists, pulling latest changes..."
  cd api && git pull && cd $WORKDIR
fi

if [ ! -d "$WORKDIR/interface" ]; then
  echo "Cloning API 2..."
  git clone ${INTERFACE_REPO} interface
else
  echo "API 2 repository already exists, pulling latest changes..."
  cd interface && git pull && cd $WORKDIR
fi
