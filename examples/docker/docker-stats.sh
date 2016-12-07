#!/bin/bash

IMAGES=$(docker images | wc -l);
RUNNING=$(docker ps --filter status=running | wc -l);
STOPPED=$(docker ps --filter status=exited | wc -l);

echo "{\"images\": \"$IMAGES\", \"running\": \"$RUNNING\", \"stopped\": \"$STOPPED\"}";