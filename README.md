# Structure

### Code folder

* direct files in code folder are for curvature preserving PDEs code
    - mainScript is the main file
* files in nnsc folder are for non-negative sparse coding
    - spec_removal is the main file
    
### Data folder

* input images
* nnsc folder contains sub-folders which are self explainatory. Results of nnsc are in spec_removal sub-folder.

### Results folder
* Results of curvature preserving PDEs

### Nomenclature for results
* each experiment identified by a token
* cost/rms difference for each experiment
* x-> ground truth
* y-> input (synthetically generated)
* z-> output

Note: dictionary for NNSC not included due to size constraints. Create it using dictLearn first
