#!/usr/bin/env bash

while sleep 2; do
 echo $[ ( $RANDOM % 100 )  + 1 ];
done