# Image Temperature Adjustment iOS App

## Overview
This iOS application allows users to adjust the color temperature of a JPEG image, simulating warmer or cooler tones. Built with SwiftUI for an intuitive user interface and OpenCV (via Swift bridging) for efficient image processing, the app provides a seamless way to modify image temperature while preserving quality.

## Features
- Load a JPEG image from a file path
- Adjust the color temperature by shifting tones towards warmer (reddish) or cooler (bluish) hues
- Save the processed image as a JPEG file
- Simple and intuitive UI built with SwiftUI
- Efficient image processing using OpenCV

## Technologies Used
- **SwiftUI**: For building the user interface
- **OpenCV**: For processing image color adjustments
- **Swift Bridging**: To integrate OpenCV with Swift

## Requirements
- Xcode (Latest Version)
- iOS 15+ deployment target
- Swift 5+

## Installation

### 1. Clone the Repository
```
git clone https://github.com/IrvanSaragi24/WarmCoolerImageApp.git
cd WarmCoolerImageApp
cd WarmCoolerDetectcd 
```

### 2. Install OpenCV

**Automatic Installation**  
Run the following script to download and install OpenCV:
```
chmod +x install_opencv.sh
./install_opencv.sh
```

**Manual Installation**
- Download OpenCV framework for iOS from the official OpenCV website
- Extract opencv-4.11.0.zip
- Drag the extracted opencv-4.11.0 folder into WarmCoolerDetect/Library
- Integrate OpenCV into Xcode by adding it to Frameworks, Libraries, and Embedded Content

### 3. Open the Project
```
cd ..
open WarmCoolerDetect.xcodeproj
```

### 4. Build and Run
- Select a compatible connected device
- Press Cmd + R to build and run the application

## Usage
1. Launch the app
2. Select a JPEG image to load
3. Adjust the temperature using the slider (positive values make it warmer, negative values make it cooler)
4. Save the adjusted image to a specified output path
