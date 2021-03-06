#!/bin/bash
set -ev
echo "current git hash:"
git rev-parse --short HEAD
BUILD_COMMAND="./gradlew clean assemble && ./gradlew check  --info && ./gradlew publish -x check --info"
docker run --rm -v `pwd .`:/build -e GITHUB_TOKEN=$GITHUB_TOKEN -e BINTRAY_USER=$BINTRAY_USER -e BINTRAY_API_KEY=$BINTRAY_API_KEY -e MAVEN_CENTRAL_USER=$MAVEN_CENTRAL_USER -e MAVEN_CENTRAL_PASSWORD=$MAVEN_CENTRAL_PASSWORD -w /build openjdk:8u131-jdk bash -c "${BUILD_COMMAND}"
