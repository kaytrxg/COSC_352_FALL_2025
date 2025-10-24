#!/bin/bash

# Baltimore Homicide Analysis Runner
# This script builds and runs the Scala analysis in Docker

IMAGE_NAME="bmore-analysis"
CONTAINER_NAME="bmore-analysis-run"

echo "=================================="
echo "Baltimore Homicide Analysis"
echo "=================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo "ERROR: Docker daemon is not running. Please start Docker."
    exit 1
fi

# Check if image exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Docker image not found. Building image..."
    echo ""
    
    # Build the Docker image
    docker build -t $IMAGE_NAME .
    
    if [ $? -ne 0 ]; then
        echo ""
        echo "ERROR: Failed to build Docker image"
        exit 1
    fi
    
    echo ""
    echo "Image built successfully!"
    echo ""
else
    echo "Docker image found. Using existing image."
    echo ""
fi

# Remove any existing container with the same name
docker rm -f $CONTAINER_NAME &> /dev/null

# Run the container
echo "Running analysis..."
echo ""
docker run --name $CONTAINER_NAME --rm $IMAGE_NAME

# Check if run was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "=================================="
    echo "Analysis completed successfully!"
    echo "=================================="
else
    echo ""
    echo "ERROR: Analysis failed"
    exit 1
fi
