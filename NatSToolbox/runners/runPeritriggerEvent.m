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
parameters.input.dir = 'E:\Data\FSMATDC\100Hz';
% Output directory. The results (plot, data) will
% be saved here.
parameters.output.dir = 'E:\tmp';
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
%  Channel parameters. Name are exact channel name
%  Title are for plot and status messgages.
%% ==========================================
parameters.channel.trigger.name  = 'delta_end';
parameters.channel.event.name    = 'spk';
% parameters.channel.section.name  = 'spdl';

parameters.channel.trigger.title = 'Delta end';
parameters.channel.event.title   = 'Spike';
% parameters.channel.section.title = 'Spindle';
%% ==========================================

%% ==========================================
%  Section conditions
%% ==========================================
% Condition which exclude those sections, before
% which any K-Complex appear in [-100,0]ms interval.
%conditions.section = createCondition('kcomplex', [-0.1,0], 0);
%% ==========================================

%% ==========================================
%  Trigger conditions
%% ==========================================
% Condition which exclude those triggers,
% around which the given trigger appears
%conditions.trigger = createCondition('kcomplex',[-0.1,0],1);
% ==========================================

%% ==========================================
%  Categorization parameters
%% ==========================================
parameters.categorization.toCategorize = 0;
parameters.categorization.categorizationMode  = 'sec_pos';
parameters.categorization.categorizationName  = 'by position in spindle';
parameters.categorization.categorizationLimit = [1;2;3;4;5];
parameters.categorization.outlierHandling     = 'elim';
%% ==========================================

%% ==========================================
%  Modification parameters
%% ==========================================
parameters.modification.toModify = 1;
parameters.modification.modificationType = 'align_nearest';

parameters.modification.eventName = 'spk';
parameters.modification.emptyMode = 'discard';
parameters.modification.searchRadius = 0.0025;
parameters.modification.channel = parameters.channel;
%% ==========================================
% parameters.modification.analysis.radius = [-0.025,0.025];
% parameters.modification.analysis.minDistance = 0.0025;
% parameters.modification.analysis.smoothingPValue = 1-1e-5;
% parameters.modification.analysis.prominenceRatio = 0.1;
%% ==========================================

%% ==========================================
%  Trigger neighborhood parameters
%% ==========================================
% Radius around the trigger to cut
parameters.analysis.radius = [-0.025 0.025];
% Into how many cluster to divide
parameters.analysis.binNumber = 50;
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Stepsize for the x axis (time)
parameters.plot.xTickStep  = 0.025;
% Plot the grand average histogram
parameters.plot.globalAverage = 1;
% Averaging mode. Possible values:
%  - 'weighted' - weighted average of cells
%  - 'normal' - non weighted average of cells
parameters.plot.averagingMode = 'weighted';
% How to plot histogram? 
%  - 'avg' - mean without SD (barchart)
%  - 'msd' - mean with SD (barchart)
%  - 'bnd' - mean with SD (bounded line)
% For grand average:
parameters.plot.mode = 'msd';
% Color of the plot
parameters.plot.paletteName = '100Hz';
% Show the plot time axis in second (0) or ms (1)
parameters.plot.inMiliseconds = 1;
% Type of the y axis
%  - 'cnt' event count
%  - 'mean' average event count (event count divided by trigger)
%  - 'freq' average event count divided by bin size
%  - 'prob' probabliity of event by bin (average event count normalized to
%  all event in recording)
parameters.plot.yScale = 'freq';
% Do we have to plot the raster?
parameters.plot.raster = 1;
% How big is a raster tick?
parameters.plot.rasterSize = 1;
% How much is the offset between rasters?
parameters.plot.rasterOffset = 0.05;
% Plotting range
parameters.plot.range    = parameters.analysis.radius;
parameters.plot.title    = sprintf('Peri-%s %s histogram', parameters.channel.trigger.title, parameters.channel.event.title);
%% ==========================================

parameters.channel.printStat = 1;

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
functionStructure.batchCalcFunction = @calculatePeritriggerEvent;
functionStructure.aggregateFunction = @aggregatePeritriggerEvent;
functionStructure.plotFunction      = @plotPeritriggerEvent;

batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters functionStructure;
%% ==========================================