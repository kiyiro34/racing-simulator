# racing-simulator



## Getting started

Create a .env at the project root like this one, to expose the ports to use: 

```text
export API_PORT=8080
export INTERFACE_PORT=3000
```

Then run the docker compose with the command : 

```shell
docker-compose --env-file .env up --build 
```