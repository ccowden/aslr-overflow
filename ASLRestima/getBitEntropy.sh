#!/bin/bash

#make sure the Ent code is built
echo "Building ENT"
cd Ent
make > /dev/null
cd ..

########## CREATING LOG.TXT FILES ####################
declare -a types=("heap" "text" "stack" "mmap" "vdso" "libso")
declare -A startPos=( ["heap"]=16 ["text"]=16 ["stack"]=24 ["mmap"]=17 ["vdso"]=24 ["libso"]=17 )
declare -A lengths=( ["heap"]=30 ["text"]=30 ["stack"]=30 ["mmap"]=29 ["vdso"]=22 ["libso"]=29 ) 


########## RUNNING ENT SCRIPT ########################
for i in "${types[@]}"
do
    if [ ! -f "$i"Log.txt ]; then
        echo "$i""Log.txt not found. Running $i.sh to create it."
        ./$i.sh "$i"Log.txt
        echo ""
    fi

    #put randomized bits into a temp file
    #also remove new lines by writing to a temp file
    echo "Evaluating randomness from bits ${startPos[$i]}:${lengths[$i]} for $i"
    while read line 
    do
        printf ${line:${startPos[$i]}:${lengths[$i]}}
    done < "$i""Log.txt" > temp.txt

    "Ent/ent" temp.txt -c | tee "$i""Entropy.txt"

    echo "Results saved in "$i"Entropy.txt"

    #clean up
    rm temp.txt
done


