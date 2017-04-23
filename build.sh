#!/usr/bin/env bash
set -e

if [ "$#" -ne 1 ]; then
    echo "Please provide version number"
    exit 1;
fi

VERSION=$1

echo "Building gossed binaries"
for GOOS in darwin linux windows; do
    for GOARCH in 386 amd64; do
        FILE=gossed-${VERSION}-${GOOS}-${GOARCH}
        if [ -f ${FILE} ]; then
            rm ${FILE}
        fi
        echo "Building ${FILE}"
        go build -o ${FILE}
    done
done
echo "Done"

echo "Building gossed docker image"
docker build -t benas/gossed:${VERSION} .
echo "Done"