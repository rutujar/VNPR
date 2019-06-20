# VNPR(Vehicle Number Plate Recognition)

# Project Objectives

* Developed a program to recognize automatic license plates based on limited dataset.

* Localized license plate by applying morphological operations and utilizing contour properties.

* Segmented character-like regions of the license plates by applying perspective transforms, performing a connected component analysis, and utilizing contour properties.

* Scissored the true characters from previous step by pruning extraneous license plate character candidates, and extracting each character from binary image to create a training set for building classifiers.

* Extracted BBPS features from the training set and Built two SVM classifiers for recognizing the letters and numbers of the license plate.

# Software/Packages Used



# Algorithms & Methods Used

* License plate localization
  * Apply morphological operations to reveal possible license plate region.
    * Blackhat operation
    * Sobel gradient
    * Otsu automatic thresholding
    * Erosion & dilation
  * Utilize contour properties to prune license plate candidates.
* Characters segmentation
  * Apply perspective transform to extract license plate region from car, obtaining a top-down, bird’s eye view more suitable for character segmentation.
    * 4-point transform
    * Adaptive thresholding
  * Perform a connected component analysis on the license plate region to find character-like sections of the image.
    * 8-connectivity component analysis
    * Convex hull
  * Utilize contour properties to segment the foreground license plate characters from the background of the license plate.
* Character Scissoring
  * Develop and implement a heuristic to prune extraneous license plate character candidates, leaving with only the real characters.
  * Define a method to extract each of the license plate characters from the binary image.
* Character Classification
  * Extract and label license character examples from license plate dataset.
  * Extract block-binary-pixel-sum (BBPS) features from real-world license plate character examples.
    * Block-binary-pixel-sum descriptor
  * Train two classifiers on the BBPS features: one classifier for letter recognition and a second classifier for digit recognition.
    * Support vector machine

## Support Me
If you liked this, leave a star and fork it! :star: 

If you liked this and also liked my other work, be sure to follow me for more! :slightly_smiling_face:
