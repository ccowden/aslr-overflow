#!/bin/sh

ulimit -c 0

for run in `jot 800 1`
do
  printf \\r$run
  #./client >> $1 &
  #clientPID=$!
  #( sleep 200; kill $clientPID 2> /dev/null ) &
  #wait $clientPID
  timeout -s 9 60 ./client >> $1
  sleep 2
done
