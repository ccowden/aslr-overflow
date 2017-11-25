#!/bin/sh

> $1

for run in `jot 800 1`
do
  printf \\r$run
  ./stack_entropy >> $1
done
