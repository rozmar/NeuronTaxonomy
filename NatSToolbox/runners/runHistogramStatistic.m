%% ==========================================
%  IMPORT NECESSARY DIRECTORIES
%% ==========================================
multiWaitbar('Closeall');
clear parameters functionStructure;
%% ==========================================

%% ==========================================
%  Input-output parameters
%% ==========================================
% Input directory path. The files
% can be selected from a list later.
parameters.input.dir = 'E:\Data\FSMATDC\Desc';
% Output directory. The results (plot, data) will
% be saved here.
%parameters.output.dir = 'E:\PeriDeltaSpikeHistWithK\Desc';
%% ==========================================

%% ==========================================
%  Analysis parameters
%% ==========================================
% Name of the historgram to describe
parameters.source.histogramType  = 'meanFHistogram';
% Range of the histogram relative to the trigger
parameters.source.range = [-0.025,0.125];

% Range of the histogram relative to the trigger
parameters.analysis.range = [-0.025,0.025];
%% ==========================================

%% ==========================================
%  Channel parameters
%% ==========================================
parameters.channel.trigger.name = 'delta_end';
parameters.channel.event.name   = 'spk';

parameters.channel.trigger.title = 'Delta end';
parameters.channel.event.title   = 'Spike';
%% ==========================================
%% ==========================================
%  Analysis parameters
%% ==========================================
parameters.categorization.toCategorize = 0;
parameters.categorization.categorizationMode = 'no';
%% ==========================================
%% ==========================================
%  Analysis parameters
%% ==========================================
parameters.analysis.radius = [-0.025,0.025];

parameters.analysis.binNumber = 50;

parameters.analysis.minDistance = 0.0025;
%parameters.peakfind.minDistance = 2.5;

parameters.analysis.smoothingPValue = 1-1e-5;

parameters.analysis.prominenceRatio = 0.1;
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Plot each segment with the found slope or not?
parameters.plot.debug = 0;
%% ==========================================

functionStructure.batchCalcFunction = @collectPeritriggerDistributions;
%functionStructure.plotFunction      = @plotWaveformStatistics;
functionStructure.aggregateFunction = @accumulatePeritriggerDistribution;

batchProcessor(parameters, functionStructure);

clear parameters S