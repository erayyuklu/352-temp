#!/bin/bash
# File: core/run_docker_tests.sh

# Set the output file name
OUTPUT_FILE="docker_test_results.txt"

echo "Running tests with explicit module paths..."
python manage.py test \
  core.tests.test_user_models \
  core.tests.test_task_models \
  core.tests.test_volunteer_models \
  core.tests.test_notification_models \
  core.tests.test_review_models \
  core.tests.test_bookmark_models \
  core.tests.test_tag_models \
  core.tests.test_photo_models \
  core.tests.test_comment_models \
  core.tests.test_feed_class \
  core.tests.test_search_class \
  core.tests.test_integration > "$OUTPUT_FILE" 2>&1

# Check if the tests completed successfully
if [ $? -eq 0 ]; then
  echo "Tests completed successfully. Results saved to $OUTPUT_FILE"
else
  echo "Tests failed. See $OUTPUT_FILE for details"
fi

# Print the file location
echo "Output file location: $(pwd)/$OUTPUT_FILE"