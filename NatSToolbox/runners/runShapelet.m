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
parameters.input.dir = 'E:\Data\PYRMAT\l2';
% Output directory. The results (plot, data) will
% be saved here.
parameters.output.dir = 'E:\WholePyrDeltaAnalysisResult\TriggeredShapelet\L2';
%% ==========================================

%% ==========================================
%  Preprocessing parameters
%% ==========================================
% Do we want to cut the recording?
parameters.isCut = 0;
% Interval to retain from recording.
parameters.cutInterval = [0,1000];
% Do we want to downsample?
parameters.toDownSample = 0;
% Downsampling rate
parameters.downSampleRate  = 1;
% Do we want to remove spikes with Bayesian method?
parameters.toDespike = 0;
% Do we want to smooth the recording?
parameters.toSmooth  = 0;
% Size of smoothing window
parameters.smoothWindow = 41;
%% ==========================================

%% ==========================================
%  Channel parameters
%% ==========================================
parameters.channel.signal        = 'wideband';
parameters.channel.trigger.name  = 'delta_end';
parameters.channel.trigger.title = 'Delta end';
%% ==========================================

%% ==========================================
%  Section conditions
% ==========================================

% Condition which exclude those sections, before
% which any K-Complex appear in [-150,0]ms interval.
%conditions.section = createCondition('kcomplex', [-0.1,0], 1);
%% ==========================================

%% ==========================================
%  Categorization parameters
%% ==========================================
parameters.categorization.toCategorize = 0;
parameters.categorization.categorizationMode = 'no';
parameters.categorization.categorizationName = 'single category';
parameters.categorization.categorizationLimit = [1];
parameters.categorization.categoryColorLimit = [0,5];
parameters.categorization.outlierHandling     = 'elim';
%% ==========================================

%% ==========================================
%  Trigger conditions
% ==========================================
% Condition which exclude those triggers, around which
% in [-30,30]ms interval any spike appears.
%conditions.trigger = NoSpikeAround(-0.03, 0.03);
conditions.trigger = createCondition('spk',[-0.03,0.03],0);

% Condition which exclude those triggers, around which
% in [-30,30]ms interval any spike appears, except the 
% in [2.5,7.5]ms interval (right to the trigger)
 %conditions.trigger = NoSpikeAroundWithException(-0.03, 0.03, 0.0025, 0.0075);
% ==========================================

%% ==========================================
%  Filter parameters
%% ==========================================
% Flag which indicates filtering
parameters.toFilter = 1;
% Type of filter. Possible values
%  - 'butter' (Butterworth)
%  - 'fir' (FIR)
parameters.filter.filterType =  'butter';
% Order of filter
parameters.filter.filterOrder = 2;
% Passband frequencies
filterBands = [];
filterBands = [filterBands ; 80, 140 ];
filterBands = [filterBands ; 180, 250 ];
%% ==========================================

%% ==========================================
%  Shapelet parameters
%% ==========================================
parameters.shapelet.toCluster = 0;
% Radius around the trigger to cut
parameters.shapelet.radius = [-0.025 0.025];
% Into how many cluster to divide
parameters.shapelet.clusterNum = 4;
% How many replicates have to be performed
parameters.shapelet.replicates = 5;
% Z-score normalize troughlets before clustering
parameters.shapelet.zScore = 0;
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Stepsize for the x axis (time)
parameters.plot.xTickStep  = 0.005;
% Plot the average spectrogram per cell
parameters.plot.overallAverage = 1;
% Show clustered troughlets
parameters.plot.showClusters = 0;
% How to plot clusters? 
%  - 'avg' - mean without SD
%  - 'msd' - mean and SD with bounded line
%  - 'sup' - superimposed
parameters.plot.clusterPlotMode = 'sup';
% Troughlets plotted on each other?
parameters.superImposed = 1;
% Superimposed plot mode: 
%  'gray'      - gray
%  'grayscale' - grayscale
%  'color'     - use variable colors
parameters.superImposedMode = 'color';
% Show the plot time axis in second (0) or ms (1)
parameters.plot.inMiliseconds = 1;
%% ==========================================

parameters.channel.printStat = 1;
if exist('conditions', 'var')
  parameters.channel.conditions = conditions;
end
parameters.filter.filterBounds = filterBands;

%% ==========================================
%  Start processing
%% ==========================================
functionStructure.batchCalcFunction = @calculateShapelet;
functionStructure.aggregateFunction = @aggregateShapelet;
batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters;
%% ==========================================