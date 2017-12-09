#!/bin/sh

for run in `jot 800 1`
do
  printf \\r$run
  ./co_entropy 
done
  export LOG="./texttextbin.log"
  printf "\nTEXT to TEXT   -> "
  ./entropy64  $LOG
  export LOG="./textlibsobin.log"
  printf "TEXT to LIBSO  -> "
  ./entropy64  $LOG
  export LOG="./textvdsobin.log"
  printf "TEXT to VDSO   -> "
  ./entropy64  $LOG
  export LOG="./heaplibsobin.log"
  printf "HEAP to LIBSO  -> "
  ./entropy64  $LOG
  export LOG="./libsovdsobin.log"
  printf "LIBSO  to VDSO -> "
  ./entropy64  $LOG
  export LOG="./heapstackbin.log"
  printf "HEAP  to STACK -> "
  ./entropy64  $LOG
  export LOG="./stackvdsobin.log"
  printf "STACK to VDSO -> "
  ./entropy64  $LOG
  export LOG="./textheapbin.log"
  printf "TEXT to HEAP -> "
  ./entropy64  $LOG
