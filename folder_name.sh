#!/bin/bash

# Find all directories starting with 'Week_' or 'week_'
for d in Topic* topic*; do
  if [ -d "$d" ]; then
    # Lowercase version of the folder name
    lower=$(echo "$d" | tr '[:upper:]' '[:lower:]')
    
    # If already lowercase, skip
    if [ "$d" == "$lower" ]; then
      continue
    fi
    
    # Temporary rename to avoid case-only issue
    temp="${d}_temp"

    echo "Renaming $d to $temp"
    mv "$d" "$temp"

    echo "Renaming $temp to $lower"
    mv "$temp" "$lower"

    # Stage the rename
    git add -A
  fi
done
