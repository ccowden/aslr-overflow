#!/bin/sh

> $1

for run in `jot 800 1`
do
  printf \\r$run
  ./text_entropy >> $1
done
