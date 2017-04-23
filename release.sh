#!/usr/bin/env bash
set -e

if [ "$#" -ne 1 ]; then
    echo "Please provide a release version number"
    exit 1;
fi

VERSION=$1

function tag {
    echo "Tagging release v${VERSION}"
    git tag -a v${VERSION} -m "version ${VERSION}"
    git push origin v${VERSION}
    echo "Done"
}

function build_binaries {
    echo "Building binaries for version ${VERSION}"
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
}

function build_docker {
    echo "Building docker image v${VERSION} (and latest)"
    docker build -t benas/gossed .
    docker build -t benas/gossed:${VERSION} .
    echo "Done"

    echo "Pushing docker images v${VERSION} (and latest) to docker hub"
    docker push benas/gossed
    docker push benas/gossed:${VERSION}
    echo "Done"
}

function main {
    tag
    build_binaries
    build_docker
}

main