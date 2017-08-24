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
parameters.input.dir = 'E:\2016oktober\RS';
%parameters.input.dir = 'E:\Archive\Analysis 2016 06 Június\forFieldAnalysis\RAW\DES';
% Output directory. The results (plot, data) will
% be saved there.
% parameters.output.dir = 'E:\';
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
parameters.channel.sectionName      = 'rem';
parameters.channel.cycleMarkerName  = 'rem_0';
parameters.channel.eventName        = 'spike';
parameters.channel.sectionTitle     = 'REM';
parameters.channel.cycleMarkerTitle = 'REM Trough';
parameters.channel.eventTitle       = 'Spike';
%% ==========================================

%% ==========================================
%  Trigger conditions
%% ==========================================
% Print condition statistic
parameters.channel.printStat = 1;
%% ==========================================

%% ==========================================
%  Phase-Event coupling parameters
%% ==========================================
% How many bins have to be in the histogram?
parameters.analysis.binNumber = 90;
%% ==========================================

%% ==========================================
%  Single PEC analysis parameters
%% ==========================================
% Into how many part will we divide the unit circle
parameters.singlepec.category = 4;
% The maximal difference between the reference
% and examined vector at which we consider them
% to belong together.
parameters.singlepec.tolerance = 90;


parameters.singlepec.threshold = 0.5;
parameters.singlepec.referenceType = 'avg';
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Stepsize for the x axis, if linear plot will be shown (in degrees)
parameters.plot.xTickStep  = 45;
% Plot the grand-average histogram or not?
parameters.plot.globalAverage = 1;
% Type of plot
%  - 'lin'  - linear plot ("normal" histogram)
%  - 'circ' - circular plot
parameters.plot.type = 'circ';
% How to plot histogram? 
%  - 'avg' - barchart, only the mean without SD
%  - 'msd' - barchart, mean with SD
%  - 'bnd' - bounded line, mean with SD (shaded)
% For grand average:
parameters.plot.mode = 'bnd';
% Color palette of the plot (find in util/color/getAllPalette.m)
parameters.plot.paletteName = '100Hz';
% Hide numbers and labels on the plots?
parameters.plot.hideLabels = 0;
% Type of the shown value
%  - 'cnt'  event count per bin
%  - 'mean' average event count per bin (event count in each bin divided by the number of triggers)
%  - 'prob' relative event count per bin (event count in each bin divided by the sum of all events)
parameters.plot.yScale = 'prob';
% Plotting range for linear histogram (In circular case, it won't be
% considered)
parameters.plot.range = [-360,360];
% Title for the plot
parameters.plot.title = sprintf('%s phase-%s coupling', parameters.channel.sectionTitle, parameters.channel.eventTitle);
% Maximal value on grand average circular plot.
% If 0 or not given, script will calculate automatically
parameters.plot.circularLimit = 22;
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

% Convert tolerance angle to radian from degree
parameters.singlepec.tolerance = circ_ang2rad(parameters.singlepec.tolerance);
%% ==========================================
%  Start processing
%% ==========================================
functionStructure.batchCalcFunction = @calculatePECChange;

batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters;
%% ==========================================