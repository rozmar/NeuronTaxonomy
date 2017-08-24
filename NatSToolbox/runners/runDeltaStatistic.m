%% ==========================================
%  IMPORT NECESSARY DIRECTORIES
%% ==========================================
%addpath(genpath('../'));
multiWaitbar('Closeall');
clear parameters;
%% ==========================================

%% ==========================================
%  Input-output parameters
%% ==========================================
% Input directory path. The files can be selected
% from a list later.
parameters.input.dir = 'E:\Data\FSMAT\100Hz';
% Output directory. The results (plot, data) will
% be saved here.
%parameters.output.dir = 'E:\SpindleWiKComplex';
%% ==========================================

%% ==========================================
%  CHANNEL NAMES
%% ==========================================
% Name of the channel to cut delta
parameters.channel.signal  = 'wideband';
% Name of the delta channel
parameters.segment.name = 'delta';
% Name of the delta channel
parameters.segment.title = 'Delta';
%% ==========================================

%% ==========================================
%  Following section parameters
%% ==========================================
% parameters.following.trigger.name  = 'spdl_0';
% parameters.following.trigger.title = 'Trough';
% parameters.following.section.name  = 'spdl';
% parameters.following.section.title = 'Spindle';
% 
% parameters.following.section.conditions = createCondition('delta_end',[-0.1,0],1);
% 
% parameters.contained.trigger.name = 'kcomplex';
%% ==========================================

%% ==========================================
%  Categorization parameters
%% ==========================================
parameters.categorize.toCategorize = 1;
parameters.categorize.title      = 'Delta';
parameters.categorize.conditions = createCondition('spdl_st', [0.0,0.3], 1);
parameters.categorize.categoryLabel = {'With spindle after', 'Without spindle after'};
%% ==========================================

%% ==========================================
%  FILTERING
%% ==========================================
% Filter type, can be 
% 'butter' (Butterworth)
% 'fir' (FIR)
parameters.filter.filterType =  'butter';
% Filter order
parameters.filter.filterOrder = 2;
% Bandpass frequencies
parameters.filter.filterBounds = [0.4 30];
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
% Plot each segment with the found slope or not?
parameters.plot.debug = 0;
%% ==========================================

functionStructure.batchCalcFunction = @describeWaveform;
functionStructure.plotFunction      = @plotWaveformStatistics;
functionStructure.aggregateFunction = @accumulateWaveformStatistics;

batchProcessor(parameters, functionStructure);

clear parameters S