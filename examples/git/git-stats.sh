#!/bin/bash

FOLDER=$1
cd ${FOLDER}

BRANCHES=$(git branch -a | wc -l);
TAGS=$(git tag -l | wc -l);
REVERTS=$(git log --oneline | grep 'revert' | wc -l);

echo "{\"branches\": \"$BRANCHES\", \"tags\": \"$TAGS\", \"reverts\": \"$REVERTS\"}";

