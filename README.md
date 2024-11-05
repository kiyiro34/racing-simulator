# racing-simulator



## Getting started

Create a .env file directly at the project root like this one, to expose the 2 ports to use for the components: 

```text
export API_PORT=8080
export INTERFACE_PORT=3000
```

Then, run the docker compose with the command : 

```shell
docker-compose --env-file .env up --build 
```

Then go the url to use the simulator

```text
http://localhost:INTERFACE_PORT
```

INTERFACE_PORT is the value you chose for the .env variable, 3000 for example