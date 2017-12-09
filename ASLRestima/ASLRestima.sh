#!/bin/bash

######################## Source the config file ########################
. ./ASLRestima.config

######################## Build memory segments ########################
echo "Building all memory segments..."
make all -f Makefile

echo "Building ENT..."
cd Ent
make > /dev/null
cd ..

echo "*************************************"

######################## Function to Call a Memory Segment Finder #####################
function loop_mem_segment() {
    ulimit -c 0
    
    ## $1 is the memory segment the function is applied to.
    ## Empty file before starting to write to it.
    > "${logFiles[$1]}"

    # Gather $ITERATIONS samples of starting addresses
    for run in `jot $ITERATIONS 1`
    do
        printf \\r$run > /dev/null
        timeout -s 9 60 "./${findAddress[$1]}" >> "${logFiles[$1]}"
    done
}

######################## Loop through Memory Segments ########################
for i in "${types[@]}"
do
    ########## Define Variables ##########
    YAXIS="${capitalTypes[$i]}"" Starting Address"
    TITLE="Memory Address Entropy for ""${capitalTypes[$i]}"" - 64 bit ""${OPSYSTEM}"
    FLATTITLE="Flattened ""$TITLE"
    DISTRIBTITLE="Distribution of ""$TITLE"
    LOGFILE=${logFiles[$i]}
    DECIMALFILE="$i""Decimal.txt"
    DECFULLFILE="$i""DecFull.txt"
    BITLENGTH=${lengths[$i]}
    FIRSTBIT=${startPos[$i]}
    ENTFILE="$i""Entropy.txt"

    ########## Build Log/Decimal/Full files ##########
    if [ ! -f "$LOGFILE" ]; then
        echo "$i: $LOGFILE not found. Creating it for you."
        loop_mem_segment $i
    fi

    if [ ! -f "$DECIMALFILE" ]; then
        echo "$i: $DECIMALFILE not found. Running binaryToDec64.sh to create it."
        ./binaryToDec64.sh "$LOGFILE" > "$DECIMALFILE"
    fi

    if [ ! -f "$DECFULLFILE" ]; then
        echo "$i: $DECFULLFILE not found. Running binaryToDecFull.sh to create it."
        ./binaryToDecFull.sh $LOGFILE > $DECFULLFILE
    fi

    ########## Execute Python scripts for plotting ##########
    if [ ! -d "graphs" ]; then
        mkdir "graphs"
    fi

    python plot64.addresses.py "$DECIMALFILE" "$SUPPRESSPLOTS" "$YAXIS" "$TITLE"
    python flatten64.addresses.py "$DECIMALFILE" "$SUPPRESSPLOTS" "$YAXIS" "$FLATTITLE"
    python distrib64.addresses.py "$DECFULLFILE" "$SUPPRESSPLOTS" "$NUMBEROFBINS" "COUNT" "$DISTRIBTITLE"
    echo "$i: Finished creating plots."

    ########## Run the ENT Statistics ##########
    echo "$i: Finished evaluating entropy for $BITLENGTH bits starting at bit $FIRSTBIT."
    while read line 
    do
        printf ${line:$FIRSTBIT:$BITLENGTH}
    done < $LOGFILE > temp.txt

    "Ent/ent" temp.txt -ct > $ENTFILE

    echo "$i: Finished measuring entropy statistics."

    ########## Clean up ##########
    rm temp.txt

    echo "$i: Finished running script."
done
