#!/bin/bash
./heap.sh "heapLog.txt"
./binaryToDec64.sh "heapLog.txt" > "heapDecimal.txt"

python plot64.addresses.py "heapDecimal.txt" "Heap Starting Address" "Memory Address Entropy for Heap - 64 bit Debian" 
python flatten64.addresses.py "heapDecimal.txt" "Heap Starting Address" "Flattened Memory Address Entropy for Heap - 64 bit Debian"


./mmap.sh "mmapLog.txt"
./binaryToDec64.sh "mmapLog.txt" > "mmapDecimal.txt"

python plot64.addresses.py "mmapDecimal.txt" "Mmap Starting Address" "Memory Address Entropy for Mmap - 64 bit Debian"
python flatten64.addresses.py "mmapDecimal.txt" "Mmap Starting Address" "Flattened Memory Address Entropy for Mmap - 64 bit Debian"


./text.sh "textLog.txt"
./binaryToDec64.sh "textLog.txt" > "textDecimal.txt"

python plot64.addresses.py "textDecimal.txt" "Text Starting Address" "Memory Address Entropy for Text - 64 bit Debian"
python flatten64.addresses.py "textDecimal.txt" "Text Starting Address" "Flattened Memory Address Entropy for text - 64 bit Debian" 


./vdso.sh "vdsoLog.txt"
./binaryToDec64.sh "vdsoLog.txt" > "vdsoDecimal.txt"

python plot64.addresses.py "vdsoDecimal.txt" "VDSO Starting Address" "Memory Address Entropy for VDSO - 64 bit Debian" 
python flatten64.addresses.py "vdsoDecimal.txt" "VDSO Starting Address" "Flattened Memory Address Entropy for VDSO - 64 bit Debian"


./libso.sh "libsoLog.txt"
./binaryToDec64.sh "libsoLog.txt" > "libsoDecimal.txt"

python plot64.addresses.py "libsoDecimal.txt" "Libso Starting Address" "Memory Address Entropy for Libso - 64 bit Debian" 
python flatten64.addresses.py "libsoDecimal.txt"  "Libso Starting Address" "Flattened Memory Address Entropy for Libso - 64 bit Debian"


./stack.sh "stackLog.txt"
./binaryToDec64.sh "stackLog.txt" > "stackDecimal.txt"

python plot64.addresses.py "stackDecimal.txt"  "Stack Starting Address" "Memory Address Entropy for Stack - 64 bit Debian"
python flatten64.addresses.py "stackDecimal.txt"  "Stack Starting Address" "Flattened Memory Address Entropy for Stack - 64 bit Debian"
