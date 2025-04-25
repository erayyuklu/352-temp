#!/bin/bash

# Check for any root-level models.py or models directory
echo "Checking for conflicting modules..."
if [ -f "models.py" ] || [ -d "models" ]; then
    echo "Warning: Found models.py or models directory at root level which may cause conflicts"
    echo "Consider renaming or removing these"
fi

# Fix the test_runner.py file to use full module paths
echo "Updating test runner imports..."
sed -i 's/from tests\./from core.tests./g' core/tests/test_runner.py

# Run the tests using module paths instead of simple names
echo "Running tests with fixed module paths..."
python3 manage.py test core.tests