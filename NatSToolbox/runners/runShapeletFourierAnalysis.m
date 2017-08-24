%% ==========================================
%  Channel parameters
%% ==========================================
parameters.channel.signal         = 'wideband';
parameters.channel.triggerName    = 'spdl_0';
%% ==========================================

%% ==========================================
%  Filter parameters
%% ==========================================
% Flag which indicates filtering
parameters.toFilter = 0;
% Type of filter. Possible values
%  - 'butter' (Butterworth)
%  - 'fir' (FIR)
parameters.filter.filterType =  'butter';
% Order of filter
parameters.filter.filterOrder = 2;
% Passband frequencies
parameters.filter.filterBounds = [180,250];
%% ==========================================

%% ==========================================
%  Analysis parameters
%% ==========================================
parameters.analysis.triggerRadius = 0.025;
parameters.analysis.paddingSize = 0.01;
parameters.analysis.nfft = 2^13;
%% ==========================================

%% ==========================================
%  Plot parameters
%% ==========================================
parameters.plot.xLimit = [0,300];
%% ==========================================

S = load('E:\2016 szeptember\FS\Rat169d1t1c1FS.mat');

analyzeShapeletFourier(S, parameters);

clear S parameters;