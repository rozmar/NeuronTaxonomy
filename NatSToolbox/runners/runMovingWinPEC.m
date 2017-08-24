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
parameters.channel.segment.name = 'rm';
parameters.channel.cycle.name   = 'rmt_1';
parameters.channel.event.name   = 'spk';

parameters.channel.segment.title = 'REM';
parameters.channel.cycle.title   = 'REM trough';
parameters.channel.event.title   = 'Spike';
%% ==========================================

%% ==========================================
%  Analysis parameters
%% ==========================================
parameters.analysis.binNumber = 90;
% Size of moving window (in cycles)
parameters.analysis.windowSize = 11;
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Stepsize for the x axis, if linear plot will be shown (degree)
parameters.plot.xTickStep  = 45;
% Plot the grand average histogram
parameters.plot.globalAverage = 1;
% Type of plot
%  - 'lin' - linear plot ("normal" histogram)
%  - 'circ' - circular plot
parameters.plot.type = 'circ';
% How to plot histogram? 
%  - 'avg' - mean without SD (barchart)
%  - 'msd' - mean with SD (barchart)
%  - 'bnd' - mean with SD (bounded line)
% For grand average:
parameters.plot.mode = 'bnd';
% Color palette of the plot
parameters.plot.paletteName = '100Hz';
% Show numbers on the plots?
parameters.plot.hideLabels = 0;
% Type of the y axis
%  - 'cnt' event count
%  - 'mean' average event count (event count divided by the number of triggers)
%  - 'prob' relative event count (event count divided by sum of all events)
parameters.plot.yScale = 'prob';
% Plotting range
parameters.plot.range = [-360,360];
parameters.plot.title = sprintf('%s phase-%s coupling', parameters.channel.segment.title, parameters.channel.event.title);
% Maximal value on mean frequency plot.
% If 0, script will calculate its value.
%parameters.plot.circularLimit = 22;
% Maximal value on mean vector plot.
parameters.plot.meanVectorPlotMax = 1.0;
% Arrow thickness on mean vector plot
parameters.plot.arrowLineThickness = 2.5;
% Length of arrow head on mean vector plot.
parameters.plot.arrowHeadLength = 0.1;    
%% ==========================================

%% ==========================================
%  Start processing
%% ==========================================
functionStructure.batchCalcFunction = @calculateMovingWinPEC;
% functionStructure.aggregateFunction = @aggregatePEC;
% functionStructure.plotFunction      = @plotPEC;

batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters functionStructure;
%% ==========================================