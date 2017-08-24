%% ==========================================
%  IMPORT NECESSARY DIRECTORIES
%% ==========================================
%addpath(genpath('../'));
multiWaitbar('Closeall');
clear parameters conditions;
%% ==========================================

%% ==========================================
%  Input-output parameters
%% ==========================================
% Input directory path. The files can be selected
% from a list later.
parameters.input.dir = 'E:\Data\RSTEST\';
% Output directory. The results (plot, data) will
% be saved here.
%parameters.output.dir = 'E:\tmp';
%% ==========================================

%% ==========================================
%  Preprocessing parameters
%% ==========================================
% Do we want to cut the recording?
parameters.isCut = 0;
% Interval to retain from recording.
parameters.cutInterval = [0,800];
%% ==========================================

%% ==========================================
%  Channel parameters
%% ==========================================
%  Segment start-end markers
%parameters.channel.segment.name = 'rm_';
parameters.channel.segment.name = 'rm';
%  Segment trough markers 
parameters.channel.cycle.name   = 'rmt_1';
%parameters.channel.cycle.name   = 'rem_0';
%  Event markers
parameters.channel.event.name   = 'spk';
%parameters.channel.event.name   = 'spike';
%  Signal channel
parameters.channel.signal.name   = 'wb_1';
%parameters.channel.signal.name   = 'wideband';

parameters.channel.segment.title = 'REM';
parameters.channel.cycle.title   = 'REM trough';
parameters.channel.event.title   = 'Spike';
parameters.channel.signal.title  = 'Wideband';
%% ==========================================

%% ==========================================
%  Analysis parameters
%% ==========================================
% Do we analyze multichannel?
parameters.analysis.multiChannel = 0;
% Number of channels
parameters.analysis.numOfChannel = 2;
%  Number of bins in cycle
parameters.analysis.binNumber = 90;
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
%  Do we want to plot spike distribution?
parameters.plot.plotEventDist = 1;
%  Do we want to plot the Mean Vector Direction?
parameters.plot.meanVectorDir = 1;
% Do we want to smooth the event distribution plot?
% (Mean vector plot can't be smoothed)
parameters.plot.smooth.plot    = 1;
% Smooth window size
parameters.plot.smooth.winSize = 51;
% Smoothing Gaussian's SD
parameters.plot.smooth.smSD    = 10;
%% ==========================================

%% ==========================================
%  Start processing
%% ==========================================
functionStructure.batchCalcFunction = @calculatePECChange;
% functionStructure.aggregateFunction = @aggregatePEC;
functionStructure.plotFunction      = @plotMVDByArrow;
%functionStructure.plotFunction      = @plotPECChange;

batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters functionStructure;
%% ==========================================