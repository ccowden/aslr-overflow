#!/bin/sh

# CATCHING AND IGNORING SIGNAL 15 HELPS AVOID HANGS
trap "" 15

ulimit -c 0

for run in `jot 50 1`
do
  printf \\r$run
  timeout -s 9 60 ./heap_entropy >> $1
  sleep 2
done
