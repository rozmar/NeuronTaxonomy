%% ==========================================
%  IMPORT NECESSARY DIRECTORIES
%% ==========================================
%addpath(genpath('../'));
multiWaitbar('Closeall');
clear parameters functionStructure;
%% ==========================================

%% ==========================================
%  Input-output parameters
%% ==========================================
% Input directory path. The files can be selected
% from a list later.
parameters.input.dir = 'E:\Data\';
% Output directory. The results (plot, data) will
% be saved here.
parameters.output.dir = 'E:\SingleSpindleWavelet\';
%% ==========================================

%% ==========================================
%  Preprocessing parameters
%% ==========================================
% Do we want to downsample?
parameters.toDownSample = 1;
% Downsampling rate
parameters.downSampleRate  = 8;
% Do we want to remove spikes with Bayesian method?
parameters.toDespike = 0;
%% ==========================================

%% ==========================================
%  Channel parameters
%% ==========================================
parameters.channel.signal = 'wideband';
%% ==========================================

%% ==========================================
%  Section conditions
%% ==========================================

% Condition which exclude those sections, before
% which any K-Complex appear in [-150,0]ms interval.
%conditions.section = createCondition('kcomplex', [-0.1,0], 0);
%% ==========================================

%% ==========================================
%  Filter parameters
%% ==========================================
% Flag which indicates filtering
parameters.toFilter = 0;
% Type of filter. Possible values
%  - 'butter' (Butterworth)
%  - 'fir' (FIR)
parameters.filter.filterType =  'butter';
% Order of filter
parameters.filter.filterOrder = 2;
% Passband frequencies
parameters.filter.filterBounds = [5,5000];
%% ==========================================

%% ==========================================
%  Wavelet parameters
%% ==========================================
% Minimal frequency
parameters.wavelet.min = 5; 
% Maximal frequency
parameters.wavelet.max = 50;
% Frequency stepsize
parameters.wavelet.step = 0.5;
% How many waves ("taper") should wavelet contain
parameters.wavelet.wavenumber = 9;
%% ==========================================

%% ==========================================
%  Normalization parameters
%% ==========================================
% Normalization type
%  'zscore'
%  'decibel'
parameters.wavelet.normalization.type = 'zscore';
% Normalization reference. Possible values
%  'trigger'  baseline will be calculated relative to section
%  'window'   baseline will be the displayed interval
parameters.wavelet.normalization.baseline = 'window';
% This parameter is only needed if the baseline is 'trigger'
% This time will be referred to the section.
parameters.wavelet.normalization.baselineTime = [-0.025, 0.025];
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Radius around the trigger to display
parameters.plot.timeBound = [1.0,2.0];
% Stepsize for the x axis (time)
parameters.plot.xTickStep  = 0.25;
% Boundaries where to plot frequency
parameters.plot.frequencyBound = [0,25];
% Stepsize for the y axis (frequency)
% Possible values
%   [] - ticks will be placed automatically
%   [x] - ticks will be placed in the plot range spaced by x
%   [x1,x2,...,xn] - ticks will be at given positions
parameters.plot.yTickStep  = [0,10,20,30,40,50];
% Plot the average spectrogram per cell
parameters.plot.overallAverage = 1;
% Plot the waveform over the spectrogram
parameters.plot.plotWaveform = 1;
% Color limits on spectrogram.
% If it is empty or not given,
% automatically calculated
parameters.plot.colorLimit = [-2.0, 2.0];
% Show the plot time axis in second (0) or ms (1)
parameters.plot.inMiliseconds = 0;
%% ==========================================

parameters.channel.printStat = 1;

global logFile;
logFile = -1;

if exist('conditions', 'var')
  if isfield(conditions, 'trigger') 
    parameters.channel.trigger.conditions = conditions.trigger;
  end
  
  if isfield(conditions, 'section') 
    parameters.channel.section.conditions = conditions.section;
  end
end

%% ==========================================
%  Start processing
%% ==========================================
functionStructure.batchCalcFunction = @calculateSectionWavelet;
%functionStructure.aggregateFunction = @aggregateWavelet;
batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters conditions;
%% ==========================================