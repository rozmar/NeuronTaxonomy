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
parameters.input.dir = 'E:\Data\FSMATDC\200Hz';
% Output directory. The results (plot, data) will
% be saved here.
parameters.output.dir = 'E:\';
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
% The sample interval between 
parameters.analysis.resolution    = 1e-5;
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Plotting range (in seconds)
parameters.plot.range    = parameters.analysis.collectRadius;
% Stepsize for the x axis (time)
parameters.plot.xTickStep  = 0.005;
% Plot the grand average histogram
parameters.plot.globalAverage = 1;
% Color of the plot
parameters.plot.paletteName = '200Hz';
% Show the plot time axis in second (0) or ms (1)
parameters.plot.inMiliseconds = 1;

parameters.plot.title    = sprintf('Instantaneous frequency around %s', parameters.channel.trigger.title);
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
functionStructure.batchCalcFunction = @calculatePeritriggerInstFreq;
%functionStructure.aggregateFunction = @aggregatePeritriggerInstFreq;
functionStructure.plotFunction      = @plotPeritriggerInstFreq;

batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters functionStructure;
%% ==========================================