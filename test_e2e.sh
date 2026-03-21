#!/bin/bash
set -e

if [ ! -f ".env" ]; then
    echo "ERROR: Missing API configuration file."
    echo "Please create a .env file from .env.example and populate it with your valid API keys."
    echo "For example:"
    echo "  cp .env.example .env"
    echo "  # Edit .env and insert the API keys"
    return 1 2>/dev/null || true
fi

# Need to export variables for docker
set -a
source .env
set +a

if [ -z "$API_KEY_THEMOVIEDB" ] || [[ "$API_KEY_THEMOVIEDB" == *"your_tmdb_api_key_here"* ]]; then
    echo "ERROR: API_KEY_THEMOVIEDB is not set correctly in your .env file."
    return 1 2>/dev/null || true
fi

echo "Building Docker container..."
DOCKER_BUILDKIT=0 docker build -t filebot .

echo "Setting up dummy media files..."
rm -rf /tmp/filebot_e2e_test
mkdir -p /tmp/filebot_e2e_test/input
mkdir -p /tmp/filebot_e2e_test/output
touch /tmp/filebot_e2e_test/input/The.Matrix.1999.mp4

echo "Running FileBot on dummy files..."
# Run the filebot container in test/dry-run mode
docker run --rm \
    -e API_KEY_THEMOVIEDB="$API_KEY_THEMOVIEDB" \
    -e API_KEY_THETVDB="$API_KEY_THETVDB" \
    -e API_KEY_FANART_TV="$API_KEY_FANART_TV" \
    -e API_KEY_OMDB="$API_KEY_OMDB" \
    -v /tmp/filebot_e2e_test:/media \
    filebot -rename /media/input --output /media/output --format "{n} - {y}" --db TheMovieDB -non-strict --action test > /tmp/filebot_e2e_test/test_output.log 2>&1 || true

echo "Checking output..."
if grep -q "The Matrix - 1999.mp4" /tmp/filebot_e2e_test/test_output.log; then
    echo "SUCCESS: File successfully recognized and dry-run rename succeeded."
else
    echo "FAIL: Expected output file not found in output log."
    cat /tmp/filebot_e2e_test/test_output.log
    return 1 2>/dev/null || true
fi
