#!/bin/bash

######################## SET UP ########################
declare -a types=("heap" "text" "stack" "mmap" "vdso" "libso")
declare -A capitalTypes=( ["heap"]="Heap" ["text"]="Text" ["stack"]="Stack" ["mmap"]="Mmap" ["vdso"]="Vdso" ["libso"]="Libso" )
declare -A startPos=( ["heap"]=16 ["text"]=16 ["stack"]=24 ["mmap"]=17 ["vdso"]=24 ["libso"]=17 )
declare -A lengths=( ["heap"]=30 ["text"]=30 ["stack"]=30 ["mmap"]=29 ["vdso"]=22 ["libso"]=29 ) 

echo "Usage: ./plotEverything.sh [OperatingSystem]"

######################## ACCEPT ARGUMENTS ########################
if [ $# -eq 1 ]; then
    OPSYSTEM=$1
else
    OPSYSTEM="Debian"
fi

######################## BUILD WHAT IS REQUIRED ########################
echo "Building all memory segments..."
make -f Makefile

echo "Building ENT..."
cd Ent
make > /dev/null
cd ..

######################## ITERATE THROUGH MEM SEGMENTS ########################
for i in "${types[@]}"
do
    ########## DEFINE VARIABLES ##########
    YAXIS="${capitalTypes[$i]}"" Starting Address"
    TITLE="Memory Address Entropy for ""${capitalTypes[$i]}"" - 64 bit ""${OPSYSTEM}"
    FLATTITLE="Flattened ""$TITLE"
    DISTRIBTITLE="Distribution of ""$TITLE"
    LOGFILE="$i""Log.txt"
    BASHSCRIPT="$i.sh"
    DECIMALFILE="$i""Decimal.txt"
    DECFULLFILE="$i""DecFull.txt"
    BITLENGTH=${lengths[$i]}
    FIRSTBIT=${startPos[$i]}
    ENTFILE="$i""Entropy.txt"

    ########## BUILD LOG/DECIMAL/FULL FILES ##########
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

    ########## EXECUTE PYTHON SCRIPTS FOR PLOTTING ##########
    python plot64.addresses.py "$DECIMALFILE" "$YAXIS" "$TITLE"
    python flatten64.addresses.py "$DECIMALFILE" "$YAXIS" "$FLATTITLE"
    python distrib64.addresses.py "$DECFULLFILE" "COUNT" "$DISTRIBTITLE"

    ########## RUN THE ENT STATISTICS ##########
    echo "Evaluating $BITLENGTH randomized bits starting at bit $FIRSTBIT for $i"
    while read line 
    do
        printf ${line:$FIRSTBIT:$BITLENGTH}
    done < $LOGFILE > temp.txt

    "Ent/ent" temp.txt -c | tee $ENTFILE

    echo "Results saved in $ENTFILE"

    ########## CLEAN UP ##########
    rm temp.txt
done
