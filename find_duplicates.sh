#!/bin/bash

dir="/path/to/directory"  # Change this to the actual directory
declare -A file_map        # Create associative array (Bash 4+)

# Find all files in the directory recursively
find "$dir" -type f -print0 | while IFS= read -r -d '' file; do
  size=$(stat -c '%s' "$file")                  # Get file size in bytes
  base=$(basename "$file")                      # Get file name
  name="${base%.*}"                             # Remove extension
  name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')  # Convert name to lowercase

  key="${name_lower}|${size}"

  if [[ -n "${file_map[$key]}" ]]; then
    echo "Possible duplicate found: ${file_map[$key]} and $file"
  else
    file_map["$key"]="$file"
  fi
done
