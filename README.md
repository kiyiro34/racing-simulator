# racing-simulator

The racing-simulator project enables users to simulate drone races on a given circuit. It consists of a Spring Boot REST API, a Spring Boot WebSocket for real-time communication, and a user interface powered by a Node.js server.

## How to clone correctly

To clone the project with all its submodules easily, run the git command : 

 ```shell
 git clone --recurse-submodules git@github.com:kiyiro34/racing-simulator.git
 ```

 If you encounter any error while cloning submodules, you can clone them separatly in the the new project folder.
 Use the differents modules url and name in the `.gitmodules` file, to clone them in the project with the correct folder name.

## How to run

Create a .env file directly at the project root like this one, to expose the 2 ports to use for the components: 

```text
export API_PORT=8080
export INTERFACE_PORT=3000
```

Then, run the docker compose with the command : 

```shell
docker-compose --env-file .env up --build 
```

Finally, go to your localhost on the chosen port to use the simulator : 

```text
http://localhost:INTERFACE_PORT
```

INTERFACE_PORT is the value you chose for the .env variable, 3000 for example