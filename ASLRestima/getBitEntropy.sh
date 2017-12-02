#!/bin/bash

echo "Usage: ./getBitEntropy.sh rawLogFile outputFile"

#make sure the Ent code is built
echo "Building ENT"
cd Ent
make > /dev/null
cd ..

#put randomized bits (excludes first 16, last 12 bits) into a temp file
#also remove new lines by writing to a temp file
echo "Reformatting input file"
while read line
do
    printf ${line:16:36}
done < $1 > temp.txt

echo "Executing ent code"
"Ent/ent" temp.txt -c > $2

echo "Results saved in $2"

#clean up
rm temp.txt
