%% ==========================================
%  IMPORT NECESSARY DIRECTORIES
%% ==========================================
multiWaitbar('Closeall');
clear parameters;
%% ==========================================

%% ==========================================
%  Input-output parameters
%% ==========================================
% Input directory path. The files
% can be selected from a list later.
parameters.input.dir = 'E:\Data\forSpiking\10Hz';
% Output directory. The results (plot, data) will
% be saved here.
%parameters.output.dir = 'E:\SpindleWiKComplex';
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
% Radius in which the density function will be estimated
parameters.peakfind.radius = [-0.025,0.025];
% Minimal distance between peaks (in seconds)
parameters.peakfind.minDistance = 0.0025;
% The p value for KS-test which controls the fineness of estimation
parameters.peakfind.smoothingPValue = 1-1e-5;
% Ration for prominence calculation
parameters.peakfind.prominenceRatio = 0.1;
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
parameters.plot.paletteName = 'DESC';
%% ==========================================

functionStructure.batchCalcFunction = @calculatePeritriggerDistribution;
%functionStructure.plotFunction      = @plotWaveformStatistics;
functionStructure.aggregateFunction = @accumulatePeritriggerDistribution;
 
batchProcessor(parameters, functionStructure);

clear parameters;
