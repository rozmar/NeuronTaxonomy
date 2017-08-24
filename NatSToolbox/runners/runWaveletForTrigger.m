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
parameters.input.dir = 'E:\Data\FSMATDC\Desc';
% Output directory. The results (plot, data) will
% be saved here.
parameters.output.dir = 'E:\WholeFSDeltaAnalysisResult\TriggeredWaveletWithSpike\Desc';
%% ==========================================

%% ==========================================
%  Preprocessing parameters
%% ==========================================
% Do we want to cut the recording?
parameters.isCut = 0;
% Interval to retain from recording.
parameters.cutInterval = [0,1000];
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
parameters.channel.signal        = 'wideband';
parameters.channel.trigger.name  = 'delta_end';
parameters.channel.trigger.title = 'Delta end';
% parameters.channel.section.name  = 'spdl';
% parameters.channel.section.title = 'Spindle';
%% ==========================================


%% ==========================================
%  Section conditions
% ==========================================

% Condition which exclude those sections, before
% which any K-Complex appear in [-150,0]ms interval.
%conditions.section = createCondition('kcomplex', [-0.1,0], 0);
%% ==========================================

%% ==========================================
%  Trigger conditions
% ==========================================

% Condition which exclude those triggers, around which
% in [-30,30]ms interval any spike appears.
%conditions.trigger = NoSpikeAround(-0.03, 0.03);
%conditions.trigger = createCondition('spk',[-0.03,0.03],0);

% Condition which exclude those triggers, around which
% in [-30,30]ms interval any spike appears, except the 
% in [2.5,7.5]ms interval (right to the trigger)
conditions.trigger = NoSpikeAroundWithException(-0.03, 0.03, 0.0025, 0.0075);

% ==========================================

%% ==========================================
%% Neighbor parameters
%% ==========================================
% This parameter is only needed if we want to normalize
% spectrogram by the containing cycle, or if we want to 
% categorize by containing cycle length.
% Here you have to give the name of neighboring marker's name,
% which indicates the edges of the containing cycle.
parameters.neighbor.name = 'speak_0';
% The maximal value where a neighbor can appear around the trigger.
parameters.neighbor.radius = 0.1;
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
%  Categorization parameters
%% ==========================================
parameters.categorization.toCategorize = 0;
parameters.categorization.categorizationMode  = 'weightedrand';
parameters.categorization.categorizationName  = 'weighted random discard';
parameters.categorization.retainRatio         = 0.25;
parameters.categorization.categorizationLimit = 1;
parameters.categorization.categoryColorLimit  = [0,5];
parameters.categorization.outlierHandling     = 'elim';
%% ==========================================


%% ==========================================
%  Wavelet parameters
%% ==========================================
% Minimal frequency
parameters.wavelet.min = 30; 
% Maximal frequency
parameters.wavelet.max = 300;
% Frequency stepsize
parameters.wavelet.step = 5;
% How many waves ("taper") should wavelet contain
parameters.wavelet.wavenumber = 7;
% Radius around the trigger to cut
parameters.wavelet.triggerRadius = 0.130;
%% ==========================================

%% ==========================================
%  Normalization parameters
%% ==========================================
% Normalization type
%  'zscore'
%  'decibel'
parameters.wavelet.normalization.type = 'decibel';
% Normalization reference. Possible values
%  'interval' baseline will be the containing interval
%  'trigger'  baseline will be calculated relative to trigger
%  'window'   baseline will be the displayed interval
parameters.wavelet.normalization.baseline = 'trigger';
% This parameter is only needed if the baseline is 'trigger'
% This time will be referred to the trigger.
parameters.wavelet.normalization.baselineTime = [-0.025, 0.025];
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Radius around the trigger to display
parameters.plot.timeBound = [-0.025,0.025];
% Stepsize for the x axis (time)
parameters.plot.xTickStep  = 0.005;
% Boundaries where to plot frequency
parameters.plot.frequencyBound = [30,300];
% Stepsize for the y axis (frequency)
% Possible values
%   [] - ticks will be placed automatically
%   [x] - ticks will be placed in the plot range spaced by x
%   [x1,x2,...,xn] - ticks will be at given positions
parameters.plot.yTickStep  = [30,50,100,150,200,250,300];
% Plot the average spectrogram per cell
parameters.plot.overallAverage = 1;
% Plot individual spectrogram. This number
% means each nth spectrogram will be plotted.
parameters.plot.singlePlot = 0;
% Plot the waveform over the spectrogram
parameters.plot.plotWaveform = 1;
% Color limits on spectrogram.
% If it is empty or not given,
% automatically calculated
parameters.plot.colorLimit = [0.0, 5.0];
% Show the plot time axis in second (0) or ms (1)
parameters.plot.inMiliseconds = 1;
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
functionStructure.batchCalcFunction = @calculateWavelet;
functionStructure.aggregateFunction = @aggregateWavelet;
batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters conditions functionStructure logFile;
%% ==========================================