#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but it's not installed. Aborting."
    exit 1
fi

# Check if the file is provided as argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <json_file>"
    exit 1
fi

# Check if the provided file exists
if [ ! -f "$1" ]; then
    echo "File '$1' not found. Aborting."
    exit 1
fi

# Calculate averages for different "Parallel layers"
averages=$(jq 'group_by(.["Parallel layers"]) | map({
  "Parallel layers": .[0]["Parallel layers"],
  "Pull Time": (map(.["Pull Time"]) | add / length),
  "Speed": (map(.Speed) | add / length),
  "Memory": (map(.Memory) | add / length)
})' "$1")

echo "$averages" | jq -s '.'
