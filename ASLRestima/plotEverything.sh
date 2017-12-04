#!/bin/bash

declare -a types=("heap" "text" "stack" "mmap" "vdso" "libso")
declare -A capitalTypes=( ["heap"]="Heap" ["text"]="Text" ["stack"]="Stack" ["mmap"]="Mmap" ["vdso"]="Vdso" ["libso"]="Libso" )

echo "Usage: ./plotEverything.sh [OperatingSystem]"

#If OS is passed in as first argument, use it.
if [ $# -eq 1 ]; then
    OPSYSTEM=$1
else
    OPSYSTEM="Debian"
fi

make -f Makefile

#Iterate through all segments of memory. Create logs and decimal files if needed. Generate plots.
for i in "${types[@]}"
do
    YAXIS="${capitalTypes[$i]}"" Starting Address"
    TITLE="Memory Address Entropy for ""${capitalTypes[$i]}"" - 64 bit ""${OPSYSTEM}"
    FLATTITLE="Flattened ""$TITLE"
    DISTRIBTITLE="Distribution of ""$TITLE"
    LOGFILE="$i""Log.txt"
    BASHSCRIPT="$i.sh"
    DECIMALFILE="$i""Decimal.txt"
    DECFULLFILE="$i""DecFull.txt"

    if [ ! -f "$LOGFILE" ]; then
        echo "$LOGFILE not found. Running $BASHSCRIPT to create it."
        ./$BASHSCRIPT $LOGFILE
    fi
    if [ ! -f "$DECIMALFILE" ]; then
        echo "$DECIMALFILE not found. Running binaryToDec64.sh to create it."
        ./binaryToDec64.sh "$LOGFILE" > "$DECIMALFILE"
    fi

    if [ ! -f "$DECFULLFILE" ]; then
        echo "$DECFULLFILE not found. Running binaryToDecFull.sh to create it."
        ./binaryToDecFull.sh $LOGFILE > $DECFULLFILE
    fi

    python plot64.addresses.py "$DECIMALFILE" "$YAXIS" "$TITLE"
    python flatten64.addresses.py "$DECIMALFILE" "$YAXIS" "$FLATTITLE"
    python distrib64.addresses.py "$DECFULLFILE" "COUNT" "$DISTRIBTITLE"
done
