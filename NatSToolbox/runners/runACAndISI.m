%% ==========================================
%  IMPORT NECESSARY DIRECTORIES
%% ==========================================
addpath(genpath('../'));
% multiWaitbar('Closeall');
%% ==========================================


%% ==========================================
%  Input-output parameters
%% ==========================================
% Input directory path. The files can be selected
% from a list later.
parameters.input.dir = 'E:\ACFISI\';
% Output directory. The results (plot, data) will
% be saved here.
parameters.output.dir = 'E:\ACout';
%% ==========================================

%% ==========================================
%  Required segment name parameters
%% ==========================================
% Channel names of the required segments. The 
% "all event" channel will be processed automatically,
% the peritrigger event will be given later;
parameters.segments.name   = {'spdl', 'rem'};
% Title of the segments. It will be the legend of the plot.
parameters.segments.title  = {'During spindle', 'During REM'}; 
% Colors of the segments.
parameters.segments.color = [63, 125, 0 ; 63, 63, 0];
%% ==========================================

%% ==========================================
%  Event parameters
%% ==========================================
% Name of the channel which will be used as event
parameters.event.name  = 'spike';
% Title of event channel for plot
parameters.event.title = 'spike';
%% ==========================================

%% ==========================================
%  All event parameters
%% ==========================================
% Color for all event plot. Nothing else have
% to be given.
parameters.all.color = [125, 63, 0];
%% ==========================================

%% ==========================================
%  Peritrigger parameters
%% ==========================================
% Do we need peritrigger plot? If yes, give
% in the following parameters.
parameters.isPeriTrigger = 1;
%% ==========================================
% Name of the channel which will be used as trigger
parameters.peritrigger.name  = 'spdl_0';
% Title of trigger channel for plot
parameters.peritrigger.title  = 'trough';
% Radius around the trigger (in sec)
parameters.peritrigger.radius = 0.0075;
% Color of the plot for peritrigger
parameters.peritrigger.color = [125, 192, 0];
%% ==========================================

%% ==========================================
%  ISI parameters
%% ==========================================
% Maximal ISI range
parameters.ISI.range = 0.1;
% Size of bins in ISI histogram
parameters.ISI.binSize = 0.002;
% Type of ISI values, possible values:
%  'count': event count
%  'norm': normalized event count
parameters.ISI.plotType = 'count';
% Type of ISI x-axis, possible values:
%  'log': event count
%  'lin': normalized event count
parameters.ISI.plotScale = 'log';
%% ==========================================

%% ==========================================
%  Autocorrelation parameters
%% ==========================================
% Max. range for Autocorrelation
parameters.AC.maxRange = 0.25;
% Bin size for autocorrelation
parameters.AC.binSize  = 0.01;
% Type of autocorrelation, possible values:
%  'rate': event rate
%  'count': event count
parameters.AC.plotType = 'rate';
%% ==========================================

%% ==========================================
%  Start processing
%% ==========================================
batchProcessor(parameters, @batchCalculateACAndISI, @aggregateACAndISI);
%% ==========================================
%  Clear
%% ==========================================
clear parameters;
%% ==========================================