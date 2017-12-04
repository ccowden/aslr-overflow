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
    if [ ! -f "$i"Log.txt ]; then
        echo "$i""Log.txt not found. Running $i.sh to create it."
        ./$i.sh "$i""Log.txt"
    fi
    if [ ! -f "$i"Decimal.txt ]; then
        echo "$i""Decimal.txt not found. Running binaryToDec64.sh to create it."
        ./binaryToDec64.sh "$i""Log.txt" > "$i""Decimal.txt"
    fi

    YAXIS="${capitalTypes[$i]}"" Starting Address"
    TITLE="Memory Address Entropy for ""${capitalTypes[$i]}"" - 64 bit ""${OPSYSTEM}"
    FLATTITLE="Flattened ""$TITLE"
    DECIMALFILE="$i""Decimal.txt"
    python plot64.addresses.py "$DECIMALFILE" "$YAXIS" "$TITLE"
    python flatten64.addresses.py "$DECIMALFILE" "$YAXIS" "$FLATTITLE"
done
