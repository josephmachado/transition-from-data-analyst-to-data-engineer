# List available commands
default:
    just --list

# Docker compose up
up:
    docker compose up -d --build

# Docker compose down
down:
    docker compose down -v

sh:
  docker exec -ti sde-workshop bash

nb:
  open http://localhost:8888

# Restart docker containers
restart:
  just down 
  just up
