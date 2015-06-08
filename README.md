# Confidence-leak
Data and code for paper "Confidence leak in perceptual decision-making"

All analyses are written in Matlab. Codes are tested on MATLAB R2014b but should work for many previous generations of Matlab.
Here is a guideline to the files:

**FOLDERS: Expt1/Epxt2/Expt3/Expt4**

These folders contain the data and analysis code that reproduces all figures and statistical results reported in the paper.
  - Data: folder with all the behavioral data
  - Experiment code: the code used to collect the data (requires PsychToolbox)
Since Experiment 4 is a re-analysis of old data, only the relevant data from there are included.

**FOLDER: helperFunctions**

As the name suggests, it contains a number of helper functions called by the analyses files.

**FOLDER: metacog_analyses**

It contains the analysis file for the metacognition analyses, as well as the data for each experiment (generated in folders 
Expt1/Epxt2/Expt3) and the fitted data from our model (generated in folder modeling)

**FOLDER: modeling**

Includes the codes for model fitting for Experiments 1-3. Here is a guide to the critical files:
  - run_ModelFitting.m:     runs the model fitting
  - analyzeModelFit.m:      analyzes the results of the model fit
  - test_the_fit.m:         allows expection of the quality of fit; also used to generate the model fits in the figures
  - data_for_modeling.mat:  parameters that are computed based on the behavioral data (done in folders Expt1/Epxt2/Expt3)


The data and code are distributed under the most permissive license (MIT). Feel free to use them as you please. If your
work depends heavily on these codes, please cite the published paper (will include a reference here). Before the paper is
actually published, you can simply cite these data as:

Dobromir Rahnev. (2015). Confidence-leak: Confidence leak paper: data and code. Zenodo. 10.5281/zenodo.18396

(For instructions on other citation formats, go to: http://dx.doi.org/10.5281/zenodo.18396). 

If you have any questions, write to Doby Rahnev at drahnev@gmail.com.
