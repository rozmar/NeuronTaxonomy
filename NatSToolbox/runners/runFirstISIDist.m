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
parameters.input.dir = 'E:\Data\FSMATDC\Comp';
% Output directory. The results (plot, data) will
% be saved here.
parameters.output.dir = 'E:\WholeFSDeltaAnalysisResult\PeriDeltaFirstISIDist\Comp';
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

parameters.channel.trigger.title = 'Delta end';
parameters.channel.event.title   = 'Spike';
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
%  Trigger neighborhood parameters
%% ==========================================
% Radius around the trigger to cut
parameters.analysis.collectRadius = [-0.025 0.025];
% Radius where to calculate/display the ISI
parameters.analysis.calcRadius = [0,0.025];
% Into how many cluster to divide
parameters.analysis.binNumber = 25;
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Plotting range (in seconds)
parameters.plot.range    = parameters.analysis.calcRadius;
% Stepsize for the x axis (time)
parameters.plot.xTickStep  = 0.005;
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
parameters.plot.paletteName = 'Comp';
% Show the plot time axis in second (0) or ms (1)
parameters.plot.inMiliseconds = 1;
% Type of the y axis
%  - 'cnt' event count
%  - 'prob' probabliity of event by bin (average event count normalized to
%  all event in recording)
parameters.plot.yScale = 'prob';
parameters.plot.title    = sprintf('First ISI distribution around %s', parameters.channel.trigger.title);
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
functionStructure.batchCalcFunction = @calculateFirstISIDistribution;
functionStructure.aggregateFunction = @aggregateFirstISIDistribution;
functionStructure.plotFunction      = @plotFirstISIDistribution;

batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters functionStructure;
%% ==========================================