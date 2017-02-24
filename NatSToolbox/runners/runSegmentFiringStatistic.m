%% ==========================================
%  IMPORT NECESSARY DIRECTORIES
%% ==========================================
%addpath(genpath('../'));
multiWaitbar('Closeall');
clear parameters conditions functionStructure;
%% ==========================================

%% ==========================================
%  Input-output parameters
%% ==========================================
% Input directory path. The files can be selected
% from a list later.
parameters.input.dir = 'E:\Data\FSMATDC\200Hz';
% Output directory. The results (plot, data) will
% be saved here.
% parameters.output.dir = 'E:\WholePyrDeltaAnalysisResult\PeriNearestSpikeHistogram\L3';
%% ==========================================

%% ==========================================
%  Statistic parameter
%% ==========================================
parameters.statistic.segments.name = {'spdl';'delta'};
parameters.statistic.event         = 'spk';
%% ==========================================

%% ==========================================
%  Start processing
%% ==========================================
functionStructure.batchCalcFunction = @calculateSegmentFiringStatistic;
%functionStructure.aggregateFunction = @aggregatePeritriggerEvent;

batchProcessor(parameters, functionStructure);
%% ==========================================
%  Clear
%% ==========================================
clear parameters;
%% ==========================================