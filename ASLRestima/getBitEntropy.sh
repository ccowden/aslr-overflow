#!/bin/bash

#make sure the Ent code is built
cd Ent
make
cd ..

#put randomized bits (excludes first 16, last 12 bits) into a temp file
#also remove new lines by writing to a temp file
while read line
do
    printf ${line:16:36}
done < $1 > temp.txt

#run the Ent code
"Ent/ent" temp.txt -c > $2

#clean up
rm temp.txt
