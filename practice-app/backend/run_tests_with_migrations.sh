#!/bin/bash

# Set the output file name
OUTPUT_FILE="test_results.txt"

# Try to determine the correct Python command
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "Error: Could not find Python executable. Please make sure Python is installed and in your PATH."
    exit 1
fi

echo "Using Python command: $PYTHON_CMD"

# Make migrations for the core app
echo "Creating migrations for core app..."
$PYTHON_CMD manage.py makemigrations core

# Run the migrations to create database tables
echo "Running migrations to set up database..."
$PYTHON_CMD manage.py migrate

# Run the tests and pipe output to file
echo "Running tests..."
$PYTHON_CMD manage.py test core > "$OUTPUT_FILE" 2>&1

# Check if the tests completed successfully
if [ $? -eq 0 ]; then
    echo "Tests completed successfully. Results saved to $OUTPUT_FILE"
else
    echo "Tests failed. See $OUTPUT_FILE for details"
fi

# Print the file location
echo "Output file location: $(pwd)/$OUTPUT_FILE"