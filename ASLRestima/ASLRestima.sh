#!/bin/bash

echo ""
echo "Welcome to ASLRestima. Beginning computations..."

######################## Source the config file ########################
. ./ASLRestima.config
. ./ASLRestimaFunctions.sh
LOG=$LOGFILENAME
REPORT=$REPORTFILENAME
echo "Initiating ASLRestima" > $LOG
echo "" >> $LOG
echo "================= ASLRestima Report =================" > $REPORT
echo "Performing calculations on $ITERATIONS iterations for all memory segments." >> $REPORT
echo "" >> $REPORT

######################## Clean up, if requested ########################
if [ "$CLEANUP" = true ]; then
    echo "Beginning clean up!" >> $LOG
    make superclean >> $LOG
    echo "" >> $LOG
fi

######################## Build memory segments ########################
make all -f Makefile >> $LOG

echo "Building ENT framework" >> $LOG
cd Ent
make >> $LOG
cd ..
echo "Successfully built required files" >> $LOG
echo "" >> $LOG

######################## Loop through Memory Segments ########################
for i in "${types[@]}"
do
    echo "Examining the $i"
    echo "$i:" >> $REPORT

    ########## Define Variables ##########
    YAXIS="${capitalTypes[$i]}"" Starting Address"
    TITLE="Memory Address Entropy for ""${capitalTypes[$i]}"" - 64 bit ""${OPSYSTEM}"
    FLATTITLE="Flattened ""$TITLE"
    DISTRIBTITLE="Distribution of ""$TITLE"
    BINARYFILE=${binaryFiles[$i]}
    DECIMALFILE="$i""Decimal.txt"
    DECFULLFILE="$i""DecFull.txt"
    BITLENGTH=${lengths[$i]}
    FIRSTBIT=${startPos[$i]}
    ENTFILE="$i""Entropy.txt"

    ########## Build Binary/Decimal/Full files ##########
    if [ ! -f "$BINARYFILE" ]; then
        echo "$i: Creating $BINARYFILE" >> $LOG
        loop_mem_segment $i
    fi

    if [ ! -f "$DECIMALFILE" ]; then
        echo "$i: Creating $DECIMALFILE" >> $LOG
        binaryToDec64 "$BINARYFILE" > "$DECIMALFILE"
    fi

    if [ ! -f "$DECFULLFILE" ]; then
        echo "$i: Creating $DECFULLFILE" >> $LOG
        binaryToDecFull $BINARYFILE > $DECFULLFILE
    fi

    echo "$i: Successfully gathered $ITERATIONS starting addresses." >> $LOG

    ########## Execute Python scripts for plotting ##########
    if [ ! -d "graphs" ]; then
        echo "" >> $LOG
        echo "Creating graphs directoring for plots" >> $LOG
        echo "" >> $LOG
        mkdir "graphs"
    fi

    echo "$i: Creating plot of all $ITERATIONS addresses" >> $LOG
    python plot64.addresses.py "$DECIMALFILE" "$SUPPRESSPLOTS" "$YAXIS" "$TITLE"

    echo "$i: Creating flattened plot of all $ITERATIONS addresses" >> $LOG
    python flatten64.addresses.py "$DECIMALFILE" "$SUPPRESSPLOTS" "$YAXIS" "$FLATTITLE"

    echo "$i: Creating histogram to illustrate distribution of addresses" >> $LOG
    python distrib64.addresses.py "$DECFULLFILE" "$SUPPRESSPLOTS" "$NUMBEROFBINS" "COUNT" "$DISTRIBTITLE"

    echo "$i: Successfully created all 3 plots" >> $LOG

    ########## Calculating number of bits of entropy ########
    echo "$i: Calculating number of bits of entropy" >> $LOG
    ./entropy64 $BINARYFILE >> $REPORT


    ########## Run the ENT Statistics ##########
    echo "$i: Finished evaluating entropy for $BITLENGTH bits starting at bit $FIRSTBIT." >> $LOG
    while read line 
    do
        printf ${line:$FIRSTBIT:$BITLENGTH}
    done < $BINARYFILE > temp.txt

    "Ent/ent" temp.txt -ct > $ENTFILE

    echo "$i: Finished measuring entropy statistics." >> $LOG

    ########## Clean up ##########
    rm temp.txt

    echo "$i: Successfully completed all operations" >> $LOG
    echo "" >> $LOG
    echo "" >> $REPORT
done

######################## Clean up, if requested ########################
if [ "$CLEANUP" = true ]; then
    echo "Beginning clean up!" >> $LOG
    make superclean >> $LOG
    echo "" >> $LOG
fi


echo "All done! Please check the graphs directory for your plots, $REPORT for a summary of the results, and $LOG for debugging information."
