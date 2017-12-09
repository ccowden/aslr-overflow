#!/bin/bash

######################## Function to Call a Memory Segment Finder #####################
function loop_mem_segment() {
    trap "" 15
    ulimit -c 0
    
    ## $1 is the memory segment the function is applied to.
    ## Empty file before starting to write to it.
    > "${binaryFiles[$1]}"

    # Gather $ITERATIONS samples of starting addresses
    for run in `jot $ITERATIONS 1`
    do
        printf \\r$run > /dev/null
        timeout -s 9 60 "./${findAddress[$1]}" >> "${binaryFiles[$1]}"
    done
}

######################## Function to Convert Binary Addresses to Decimal #####################
function binaryToDec64() {
    line1=""
    line2=""
    line3=""
    line4=""
    line5=""
    line6=""
    line7=""
    line8=""
    while read line
    do
        read -ra ADDR1 <<< "$((2#${line:0:8}))"
        read -ra ADDR2 <<< "$((2#${line:8:8}))"
        read -ra ADDR3 <<< "$((2#${line:16:8}))"
        read -ra ADDR4 <<< "$((2#${line:24:8}))"
        read -ra ADDR5 <<< "$((2#${line:32:8}))"
        read -ra ADDR6 <<< "$((2#${line:40:8}))"
        read -ra ADDR7 <<< "$((2#${line:48:8}))"
        read -ra ADDR8 <<< "$((2#${line:56:8}))"
        line1="$line1, ${ADDR1}"
        line2="$line2, ${ADDR2}"
        line3="$line3, ${ADDR3}"
        line4="$line4, ${ADDR4}"
        line5="$line5, ${ADDR5}"
        line6="$line6, ${ADDR6}"
        line7="$line7, ${ADDR7}"
        line8="$line8, ${ADDR8}"
    done < $1
    echo "${1:8}"
    echo "${line1:2}"
    echo "${line2:2}"
    echo "${line3:2}"
    echo "${line4:2}"
    echo "${line5:2}"
    echo "${line6:2}"
    echo "${line7:2}"
    echo "${line8:2}"
}


function binaryToDecFull() {
    local line1=""
    while read line
    do
        read -ra ADDR1 <<< "$((2#${line:1:64}))"
        line1="$line1, ${ADDR1}"
    done < $1
    echo "${1:8}"
    echo "${line1:1}"
}
