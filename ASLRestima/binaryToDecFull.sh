#!/bin/bash
line1=""
while read line
do
  read -ra ADDR1 <<< "$((2#${line:1:64}))"
  line1="$line1, ${ADDR1}"
done < $1
echo "${1:8}"
echo "${line1:1}"
