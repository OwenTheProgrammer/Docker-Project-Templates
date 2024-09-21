#!/bin/bash

docker build -f $1.dockerfile --target export --output=./bin/$1 .