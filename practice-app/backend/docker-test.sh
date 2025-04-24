#!/bin/bash
# Script for running tests in Docker environment

# Display help information
show_help() {
    echo "Neighborhood Assistance Board Docker Test Runner"
    echo "Usage: ./docker-test.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  all         Run all tests (default)"
    echo "  models      Run only model tests"
    echo "  utility     Run only utility class tests"
    echo "  integration Run only integration tests"
    echo "  coverage    Run all tests with coverage report"
    echo "  help        Display this help message"
    echo ""
}

# Parse arguments
TEST_TYPE="all"
if [ $# -gt 0 ]; then
    case $1 in
        all|models|utility|integration|coverage)
            TEST_TYPE=$1
            ;;
        help|-h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
fi

# Make sure Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running or not accessible."
    exit 1
fi

# Make sure we're in the right directory
if [ ! -f "manage.py" ]; then
    echo "Error: Script must be run from the Django project root directory."
    exit 1
fi

# Build and start Docker containers if not already running
if ! docker-compose ps | grep -q "web.*Up"; then
    echo "Starting Docker containers..."
    docker-compose up -d
    echo "Waiting for services to initialize..."
    sleep 5
fi

# Run migrations to ensure DB schema is up to date
echo "Applying migrations..."
docker-compose exec web python manage.py migrate

# Run tests based on the selected option
case $TEST_TYPE in
    all)
        echo "Running all tests..."
        docker-compose exec web python manage.py test core
        ;;
    models)
        echo "Running model tests..."
        docker-compose exec web python manage.py test core.tests.test_user_models core.tests.test_task_models core.tests.test_volunteer_models core.tests.test_notification_models core.tests.test_review_models core.tests.test_bookmark_models core.tests.test_tag_models core.tests.test_photo_models core.tests.test_comment_models
        ;;
    utility)
        echo "Running utility class tests..."
        docker-compose exec web python manage.py test core.tests.test_feed_class core.tests.test_search_class
        ;;
    integration)
        echo "Running integration tests..."
        docker-compose exec web python manage.py test core.tests.test_integration
        ;;
    coverage)
        echo "Running tests with coverage..."
        # Make sure coverage is installed
        docker-compose exec web pip install coverage
        # Run tests with coverage
        docker-compose exec web coverage run --source=core manage.py test core
        # Generate report
        docker-compose exec web coverage report
        # Generate HTML report
        docker-compose exec web coverage html
        echo "HTML coverage report generated in htmlcov/ directory inside the container"
        echo "To access it, run: docker-compose exec web ls -la htmlcov/"
        ;;
esac

# Display test completion message
echo "Testing completed!"