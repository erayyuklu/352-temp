#!/bin/bash

# Set the output file name
OUTPUT_FILE="test_results.txt"

# Run the tests and pipe output to file
python3 manage.py test core > "$OUTPUT_FILE" 2>&1

# Check if the tests completed successfully
if [ $? -eq 0 ]; then
  echo "Tests completed successfully. Results saved to $OUTPUT_FILE"
else
  echo "Tests failed. See $OUTPUT_FILE for details"
fi

# Print the file location
echo "Output file location: $(pwd)/$OUTPUT_FILE"