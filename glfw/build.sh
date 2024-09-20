#!/bin/bash

docker build -f $1.dockerfile -t glfw:3.4-$1 .