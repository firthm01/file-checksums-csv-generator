#!/bin/bash

# Get the directory from the first argument
directory="$1"

# Get the output file path from the second argument
output_file="$2"

# Check if directory and output_file are provided
if [[ -z "$directory" || -z "$output_file" ]]; then
    echo "Usage: ./checksum.sh <directory> <output_file>"
    exit 1
fi

# Function to generate checksum for a file
generate_checksum() {
    file="$1"
	echo "$file ..."
	checksum=$(md5 -q "$file")
	echo "$checksum"
	filename=$(basename "$file")
    echo "\"$file\",\"$filename\",$checksum" >> "$output_file"
}

# Function to traverse the directory and generate checksums
traverse_directory() {
    local current_dir="$1"

    # Loop through files and directories
    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            # Generate checksum for the file
            generate_checksum "$file"
        elif [[ -d "$file" ]]; then
            # Recursively traverse the subdirectory
            traverse_directory "$file"
        fi
    done < <(find "$current_dir" -mindepth 1 -maxdepth 1 -print0)
}

# Start traversing the directory and generating checksums
traverse_directory "$directory"
