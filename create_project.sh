#!/bin/bash

# Determine the next available directory name (LX where X is a number)
i=1
while [ -d "L$i" ]; do
  i=$((i + 1))
done
NEW_DIR="L$i"

# Create the new directory
mkdir "$NEW_DIR"

# Create asm.asm
cat > "$NEW_DIR/asm.asm" <<EOF
; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

;Floating Point
; L/W ABI: xmm0, xmm1,...
section .text
    global _start

_start:

    ret
section .note.GNU-stack
EOF

# Create code.cpp
cat > "$NEW_DIR/code.cpp" <<EOF
#include <iostream>
#include <iomanip>
using namespace std;
extern "C" ; // Example external function

int main() {
    return 0;
}
EOF


echo "Project created at: $NEW_DIR"
