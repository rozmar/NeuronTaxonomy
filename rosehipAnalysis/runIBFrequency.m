%% ==================================
%  Starting the script
%% ==================================
addpath(genpath('.'));
clear parameters;
%% ==================================

%% ==================================
%  Input parameters
%% ==================================
% parameters.datasumDir = 'E:\RHDATA\ANALYSISdata\marci\_Taxonomy\human_rosehip\datasums';
% parameters.featureDir = 'E:\RHDATA\ANALYSISdata\marci\_Taxonomy\human_rosehip\datafiles';

parameters.datasumDir = 'E:\Data\RHTESTNICE\datasums';
parameters.featureDir = 'E:\Data\RHTESTNICE\datafiles';
%% ==================================

%% ==================================
%  Analysis parameters
%% ==================================
parameters.maxIntraBurstValue = 0.1;
parameters.intraBurstFactor = 2;
parameters.maxSingleBurstLength = 0.4;
%% ==================================

%% ==================================
%  Plot parameters
%% ==================================
parameters.plot.individual = 1;
%% ==================================

%% ==================================
%  Don't change script after this
%% ==================================
% Import xlwrite dependencies
utilBase = '../utils/xlwrite/';
javaaddpath([utilBase,'poi_library/poi-3.8-20120326.jar']);
javaaddpath([utilBase,'poi_library/poi-ooxml-3.8-20120326.jar']);
javaaddpath([utilBase,'poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
javaaddpath([utilBase,'poi_library/xmlbeans-2.3.0.jar']);
javaaddpath([utilBase,'poi_library/dom4j-1.6.1.jar']);

% Run script
calculateInterburstFrequency(parameters);
