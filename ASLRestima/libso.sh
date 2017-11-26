#!/bin/sh

> $1

for run in `jot 800 1`
do
  printf \\r$run
  ./libso_entropy >> $1
done
