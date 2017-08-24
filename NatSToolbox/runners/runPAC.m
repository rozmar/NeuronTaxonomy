%% ==========================================
%  IMPORT NECESSARY DIRECTORIES
%% ==========================================
%addpath(genpath('../'));
% multiWaitbar('Closeall');
%% ==========================================

%% ==========================================
%  Input-output parameters
%% ==========================================
% Input directory path. The files can be selected
% from a list later.
parameters.input.dir = 'E:\Archive\Analysis 2016 06 Június\forWaveletTesting';
% Output directory. The results (plot, data) will
% be saved here.
parameters.output.dir = 'E:\';
%% ==========================================

%% ==========================================
%  Cut recording parameters
%% ==========================================
parameters.isCut = 0;

parameters.cutInterval = [0,1000];
%% ==========================================


%% ==========================================
%  Channel parameters
%% ==========================================
parameters.channel.signal         = 'wideband';
parameters.channel.trigger        = 'spdl_0';
parameters.channel.triggerSection = 'spdl';
parameters.channel.excludeevent   = 'spike';
%% ==========================================

%% ==========================================
%  PAC parameters
%% ==========================================
% Size of bins in degree
parameters.binSize = 4;

parameters.filter.phase = [6,25];

parameters.filter.amplitude = [80,140;180,250];
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
parameters.plotType = {'exp_circ','exp_lin'};
%% ==========================================

%% ==========================================
%  Start processing
%% ==========================================
batchProcessor(parameters, @batchCalculatePAC, @aggregatePAC);
%% ==========================================
%  Clear
%% ==========================================
clear parameters;
%% ==========================================