#!/usr/bin/env bash

# This works for mac os, please adapt it if you use another os

CPU=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr '%' ' ')
MEMORY=$(top -l 1 | grep "PhysMem" | awk '{print $2}' | tr 'M' ' ')
PROCESSES=$(top -l 1 | grep "Processes" | awk '{print $2}')
THREADS=$(top -l 1 | grep "Processes" | awk '{print $10}')

echo "{\"cpu\": \"$CPU\", \"memory\": \"$MEMORY\", \"processes\": \"$PROCESSES\", \"threads\": \"$THREADS\"}";