#!/bin/bash
docker-compose up --build -d
echo -e "\033[33mremoving dangling images"
docker image prune -f 