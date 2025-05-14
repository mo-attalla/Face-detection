# High-Precision Face Detection using MATLAB

## Overview
This project presents a MATLAB-based desktop GUI application designed to detect human faces in digital images using a **custom algorithm** — without relying on high-level built-in functions.

The algorithm integrates:
- Skin tone segmentation (using YCbCr color space)
- Shape symmetry analysis
- Geometric filtering & ellipse fitting

## Features
- GUI for easy interaction (Load Image, Detect, Reset, Exit)
- High accuracy for frontal faces
- Low false positive rate through strict verification
- Manual implementation using basic image processing techniques

## How It Works
1. Image smoothing using Gaussian filter
2. Conversion from RGB to YCbCr
3. Skin region segmentation based on Cr and Cb thresholds
4. Morphological operations to clean the mask
5. Region properties extraction
6. Face verification based on:
   - Elliptical shape
   - Horizontal symmetry
   - Eccentricity constraints

## GUI Functions
- **Load Image**: Selects an image from the device  
- **Start Detection**: Applies the detection pipeline  
- **Reset**: Clears all current data  
- **Exit**: Closes the application

## Requirements
- MATLAB R2021a or higher
- Image Processing Toolbox

## Team Members
- Abdallah Ahmed Abdelwahid  
- Abdelrahman Mohamed Saad  
- Ahmed Gamal Mahmoud Salem  
- Ahmed Osama Soliman  
- Ezzat Mohamed Abdelmohsen Mohamed  
- Mohamed Abdo El-Sayed Attallah  
- Nada Mohamed Naguib  
- Shahd Ahmed Goda

## Screenshots
*Add screenshots here if needed*

## License
This project is for educational and academic use.
