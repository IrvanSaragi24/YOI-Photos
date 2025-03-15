#!/bin/bash

OPENCV_URL="https://github.com/opencv/opencv/releases/download/4.11.0/opencv-4.11.0-ios-framework.zip"
LIBRARY_DIR="Library"

# Create Library directory if not exists
mkdir -p $LIBRARY_DIR

# Download OpenCV framework
curl -L $OPENCV_URL -o opencv-framework.zip

# Unzip the framework to Library folder
unzip opencv-framework.zip -d $LIBRARY_DIR

# Clean up
rm opencv-framework.zip

echo "OpenCV framework successfully installed in $LIBRARY_DIR."
