%% ==================================
%  Starting the script
%% ==================================
addpath(genpath('.'));
clear parameters;
%% ==================================

%% ==================================
%  Input parameters
%% ==================================
parameters.datasumDir = 'E:\Data\RHTEST\datasum';
parameters.featureDir = 'E:\Data\RHTEST\feature';
%% ==================================

%% ==================================
%  Analysis parameters
%% ==================================
% Cut interval from the beginning and the end of the sweep
%parameters.cutFromEnd = 0.05;
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
%   - 1: Morlet wavelet
%   - 2: Fourier transformation
parameters.spectral.mode = 2;
%  ---------------------------
%  Fourier analysis parameters
parameters.fourier.numberOfPoints = 65536;
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
parameters.plot.frequencyBound = [15,80];
%  Flag to display spectrogram for each segment
parameters.plot.plotSpectrogram = 0;
%  Flag to display power spectrum for each sweep
parameters.plot.plotSinglePowerSpect = 1;
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
runSingleWavelet(parameters);
