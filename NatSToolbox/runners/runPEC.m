%% ==========================================
%  IMPORT NECESSARY DIRECTORIES
%% ==========================================
%addpath(genpath('../'));
multiWaitbar('Closeall');
%% ==========================================

%% ==========================================
%  Input-output parameters
%% ==========================================
% Input directory path. The files can be selected
% from a list later.
parameters.input.dir = 'E:\';
% Output directory. The results (plot, data) will
% be saved here.
%parameters.output.dir = 'E:\';
%% ==========================================

%% ==========================================
%  Preprocessing parameters
%% ==========================================
% Do we want to cut the recording?
parameters.isCut = 0;
% Interval to retain from recording.
parameters.cutInterval = [0,1000];
%% ==========================================

%% ==========================================
%  Channel parameters
%% ==========================================
parameters.channel.segmentName      = 'spdl';
parameters.channel.cycleMarkerName  = 'spdl_0';
parameters.channel.eventName        = 'spk';
parameters.channel.segmentTitle     = 'Spindle';
parameters.channel.cycleMarkerTitle = 'Trough';
parameters.channel.eventTitle       = 'Spike';
%% ==========================================

%% ==========================================
%  Trigger conditions
%% ==========================================
% Print condition statistic
parameters.channel.printStat = 1;

% ==========================================

%% ==========================================
%  Phase-Event coupling parameters
%% ==========================================
% Into how many cluster to divide
parameters.analysis.binNumber = 90;
% Want to categorize triggers?
parameters.analysis.toCategorize = 1;
% How to categorize triggers. 
%  - 'no' - no categorization
%  - 'rand' - random categorization
parameters.analysis.categorizationMode = 'no';
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
parameters.plot.title = sprintf('%s phase-%s coupling', parameters.channel.segmentTitle, parameters.channel.eventTitle);
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

if exist('conditions', 'var')
  parameters.channel.conditions = conditions;
end

%% ==========================================
%  Start processing
%% ==========================================
functionStructure.batchCalcFunction = @calculatePEC;
functionStructure.aggregateFunction = @aggregatePEC;
functionStructure.plotFunction      = @plotPEC;

batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters;
%% ==========================================