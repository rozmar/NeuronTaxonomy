%% ==================================
%  Starting the script
%% ==================================
addpath(genpath('.'));
clear parameters;
%% ==================================

%% ==================================
%  Input parameters
%% ==================================
parameters.datasumDir = 'E:\DATA\RHTEST\datasums';
parameters.featureDir = 'E:\DATA\RHTEST\datafiles';
%% ==================================

%% ==================================
%  Analysis parameters
%% ==================================
% Minimal interval after the AP peak
parameters.gapAfterSpike = 0.06;
% Minimal length of a slice.
% If we concatenate slices, 
% it won't be taken
% into account. 
parameters.minSliceLength = 0.0;
% Handle different slice 
% separately or concatenated
parameters.concatSlices   = 1;
%% ==================================

%% ==================================
%  Spectral analysis parameters
%% ==================================
%  Analysis mode
%   - 'wvl': Morlet wavelet
%   - 'fft': Fourier transformation
parameters.spectral.mode = 'fft';
%  ---------------------------
%  Fourier analysis parameters
parameters.fourier.numberOfPoints = 2^16;
%  ---------------------------
%  Wavelet analysis parameters
parameters.wavelet.min = 10;
parameters.wavelet.max = 80;
parameters.wavelet.step = 1;
parameters.wavelet.wavenumber = 9;
%% ==================================

%% ==================================
%  Plotting parameters
%% ==================================
%  Minimal and maximal frequency to use
parameters.plot.frequencyBound = [0,80];
%  Flag to display spectrogram for each segment
parameters.plot.plotSpectrogram = 0;
%  Flag to display power spectrum for each sweep
parameters.plot.plotSinglePowerSpect = 0;

parameters.plot.categoryRange = [-0.05,-0.025];
parameters.plot.categoryNumber = 2;
%% ==================================


%% ==================================
%  Don't change script after this
%% ==================================
% Import xlwrite dependencies
utilBase = '../utils/xlwrite/';
javaaddpath([utilBase,'poi_library/poi-3.8-20120326.jar']);
javaaddpath([utilBase,'poi_library/poi-ooxml-3.8-20120326.jar']);
javaaddpath([utilBase,'poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
javaaddpath([utilBase,'poi_library/xmlbeans-2.3.0.jar']);
javaaddpath([utilBase,'poi_library/dom4j-1.6.1.jar']);

% Run script
calculateISWSpectrum(parameters);
