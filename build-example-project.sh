#/bin/bash

IMAGE=android-ndk-and-rustc:for-example-project

docker build . -t $IMAGE
docker run -v $PWD/c-example-project:/project $IMAGE
