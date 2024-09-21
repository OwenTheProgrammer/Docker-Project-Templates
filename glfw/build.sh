#!/bin/bash

docker build -f $1.dockerfile --target final -t glfw:3.4-$1 .