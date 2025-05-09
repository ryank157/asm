#!/bin/bash
# Check if a directory argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi
# Set the directory variable
DIR="$1"

# Assemble the assembly file
# Add -i "$DIR/" to tell NASM to look for includes in the project directory
nasm -f elf64 -i "$DIR/" "$DIR/asm.asm" -o "$DIR/asm.o"
if [ $? -ne 0 ]; then
  echo "Assembly failed!"
  exit 1
fi

# Compile the C++ code
g++ -c "$DIR/code.cpp" -o "$DIR/code.o" -std=c++17 -Wall -fPIE -O2
if [ $? -ne 0 ]; then
  echo "Compilation failed!"
  exit 1
fi

# Link the object files
g++ "$DIR/code.o" "$DIR/asm.o" -o "$DIR/main" -pie
if [ $? -ne 0 ]; then
  echo "Linking failed!"
  exit 1
fi

# objdump -d -M intel "$DIR/code.o" > "$DIR/code.dump"
# objdump -d -M intel "$DIR/asm.o" > "$DIR/asm.dump"
objdump -d -M intel "$DIR/main" > "$DIR/main.dump"

echo "Build successful!"

# Optionally, run the executable
"./$DIR/main"
