% load AllLongSquares using load('<your_path>/autopatch_treedata.mat')
% load DATASUM using load('<your_path>/datasumMatrix.mat')
% clear all
close all
% load('autopatch_treedata.mat')
if ~strcmp(listPath(end),'/')
    load([listPath,'/datasumMatrix.mat'])
else
    load([listPath,'datasumMatrix.mat'])
end

addpath('plotSpread')
%% parameters
idxToUse = 'all'; % possible values: 'all', 'humanOnly', 'ratOnly'
maxAllowedRin = 700;
maxAllowedRS = 100;
dropNegativeRin = true;
dropNegativeRs = true;
minAllowedResting = -100;
maxAllowedResting = -50;
minAllowedHolding = -100;
maxApAmplitudeMedian = 150;
groupTimeInterval = 180; %1;%180; % 120; % seconds
dropBridged = true;
minAllowedApAmplMean = 40;

%% setup
datasum = DATASUM;
% humanSampleDates = createHumanDates();

%% manual exclusions
includeIdx = true(numel(datasum),1);
% includeIdx(1:10) = false; % avoid non autopatcher related ap named files, can be considered as startFromDate
% includeIdx([23,24,26]) = false; %leaky patch clamp 


% %% check for tolerable values
% idxToDrop = [datasum.rin]>maxAllowedRin;
% disp(['Number of elements dropped due to ''maxAllowedRin'': ', num2str(nnz(idxToDrop))]);
% includeIdx(idxToDrop) = false;
% 
% idxToDrop = [datasum.RS]>maxAllowedRS;
% disp(['Number of elements dropped due to ''maxAllowedRS'': ', num2str(nnz(idxToDrop))]);
% includeIdx(idxToDrop) = false;
% 
% if dropNegativeRin
%     idxToDrop = [datasum.rin]<0;
%     disp(['Number of elements dropped due to ''dropNegativeRin'': ', num2str(nnz(idxToDrop))]);
%     includeIdx(idxToDrop) = false;
% end
% 
% if dropNegativeRs
%     idxToDrop = [datasum.RS]<0;
%     disp(['Number of elements dropped due to ''dropNegativeRS'': ', num2str(nnz(idxToDrop))]);
%     includeIdx(idxToDrop) = false;
% end
% 
% idxToDrop = [datasum.resting]<minAllowedResting/1000;
% disp(['Number of elements dropped due to ''minAllowedResting'': ', num2str(nnz(idxToDrop))]);
% includeIdx(idxToDrop) = false;
% 
% idxToDrop = [datasum.resting]>maxAllowedResting/1000;
% disp(['Number of elements dropped due to ''maxAllowedResting'': ', num2str(nnz(idxToDrop))]);
% includeIdx(idxToDrop) = false;
% 
% holding = cellfun(@(x) x.holding, {datasum(:).iv});
% idxToDrop = holding<minAllowedHolding;
% disp(['Number of elements dropped due to ''minAllowedHolding'': ', num2str(nnz(idxToDrop))]);
% includeIdx(idxToDrop) = false;
% clear holding
% 
% if dropBridged
%     idxToDrop = [datasum.bridgedRS]~=0;
%     disp(['Number of elements dropped due to ''dropBridged'': ', num2str(nnz(idxToDrop))]);
%     includeIdx(idxToDrop) = false;
% end
% 
% idxToDrop = [datasum.apamplitudemean]<minAllowedApAmplMean;
% disp(['Number of elements dropped due to ''minAllowedApAmplMean'': ', num2str(nnz(idxToDrop))]);
% includeIdx(idxToDrop) = false;
% idxToDropApAmplMean = idxToDrop;
% 
% idxToDrop = [datasum.apamplitudemedian]>maxApAmplitudeMedian;
% disp(['Number of elements dropped due to ''maxApAmplitudeMedian'': ', num2str(nnz(idxToDrop))]);
% includeIdx(idxToDrop) = false;
% idxToDropMaxApAmplitudeMedian = idxToDrop;

% %% check if human sample
% isHuman = arrayfun(@(x) any(strcmp(x.fname(1:6),humanSampleDates)), datasum)';

% %% exclude by time if too close to each other, check if already excluded, use last valid if in the same group
% lastTime = [];
% lastFname = '';
% lastIdx = [];
% droppedByGrouping = 0;
% timeDifferenceList = [];
% fileCellStats = containers.Map('KeyType','char','ValueType','double');
% for i = 1:numel(datasum)
%     if ~includeIdx(i)
%         continue
%     end
%     id = str2double(datasum(i).ID);
%     als = AllLongSquares(id);
%     [group, series, nSweeps, nChannel] = als_getGroupSeriesNsweepsNchan(als);
%     [group2, series2, ~] = ds_getGroupSeriesChannel(datasum(i));
%     if group~=group2 || series~=series2
%         disp(['Group and series mismatch, idx=', num2str(i)]);
%     end
%     sTime = als.realtime;
%     fname = als.filename;
%     if ~isempty(lastFname) && strcmp(fname, lastFname)
%         timeDifference = sTime - lastTime;
%         timeDifferenceList = [timeDifferenceList; timeDifference]; %#ok<AGROW>
%         if timeDifference < groupTimeInterval
%             includeIdx(lastIdx) = false;
%             droppedByGrouping = droppedByGrouping + 1;
%         else
%             fileCellStats(fname) = fileCellStats(fname) + 1;
%         end
%     else
%         fileCellStats(fname) = 1;
%     end
%     lastTime = sTime;
%     lastFname = fname;
%     lastIdx = i;
% end
% disp(['Number of elements dropped due to grouping: ', num2str(droppedByGrouping)]);

chosenIdx = includeIdx;
humanOnlyIdx = includeIdx;
ratOnlyIdx = includeIdx;
% %% collect
% humanOnlyIdx = isHuman & includeIdx;
% ratOnlyIdx = ~isHuman & includeIdx;
% switch idxToUse
%     case 'all'
%         chosenIdx = includeIdx;
%     case 'humanOnly'
%         chosenIdx = humanOnlyIdx;
%     case 'ratOnly'
%         chosenIdx = ratOnlyIdx;
%     otherwise
%         error(['Not supported ''idxToUse'' value: ', idxToUse]);
% end
% disp(['Showing values for: ', idxToUse]);

% fcsIncludeIdx = false(numel(fileCellStats.keys),1);
% i = 0;
% for key = fileCellStats.keys
%     i = i + 1;
%     if any(arrayfun(@(x) strcmp(key, ds_getFname(x)), datasum(chosenIdx)))
%         fcsIncludeIdx(i) = true;
%     end
% end
% includedFilenames = fileCellStats.keys';
% includedFilenames(:,2) = fileCellStats.values';
% includedFilenames = includedFilenames(fcsIncludeIdx, :);
% clear i
% disp('Finished counting included measurements for different samples.')

% disp('Showing values for bad ones');
% chosenIdx = ~chosenIdx;

rin = [datasum(chosenIdx).rin];
rs = [datasum(chosenIdx).RS];
resting = [datasum(chosenIdx).resting]*1000;
rinHuman = [datasum(humanOnlyIdx).rin];
rsHuman = [datasum(humanOnlyIdx).RS];
restingHuman = [datasum(humanOnlyIdx).resting]*1000;
rinRat = [datasum(ratOnlyIdx).rin];
rsRat = [datasum(ratOnlyIdx).RS];
restingRat = [datasum(ratOnlyIdx).resting]*1000;

rheobase = [datasum(chosenIdx).rheobase];
rheobaseRat = [datasum(ratOnlyIdx).rheobase];
rheobaseHuman = [datasum(humanOnlyIdx).rheobase];
thresholdmedian = [datasum(chosenIdx).thresholdmedian]*1000;
% threshold1 = [datasum(chosenIdx).threshold1]*1000;
% threshold2 = [datasum(chosenIdx).threshold2]*1000;
% threshold3 = [datasum(chosenIdx).threshold3]*1000;
apamplitudemean = [datasum(chosenIdx).apamplitudemean];
apamplitudemedian = [datasum(chosenIdx).apamplitudemedian];
apamplitude1 = [datasum(chosenIdx).apamplitude1];
aphalfwidthmedian = [datasum(chosenIdx).aphalfwidthmedian];
aphalfwidthmedianRat = [datasum(ratOnlyIdx).aphalfwidthmedian];
aphalfwidthmedianHuman = [datasum(humanOnlyIdx).aphalfwidthmedian];
aphalfwidth1 = [datasum(chosenIdx).aphalfwidth1];
apMaxVmedian = [datasum(chosenIdx).apMaxVmedian]*1000;
apMaxV1 = [datasum(chosenIdx).apMaxV1]*1000;
holding = cellfun(@(x) x.holding, {datasum(chosenIdx).iv});

%% make diagrams
numIncluded = nnz(chosenIdx);
disp(['Number of included elements: ', num2str(numIncluded)]);
disp(['Number of included elements which are from a human sample: ', num2str(nnz(humanOnlyIdx))]);
disp(['Number of included elements which are from a rat sample: ', num2str(nnz(ratOnlyIdx))]);
color1 = [14, 77, 159]./255; % [55, 110, 180]./255; % [47, 129, 197]./255;  %
color2 = [42, 174, 156]./255; %[229, 235, 8]./255; % [193, 210, 20]./255;
% color3 = [235, 241, 243]./255;
color3 = 'w';
boxWidth = 107;
shMarkerSize = 4;
% figure('Name', 'Rin (MOhm)')
% h = scatter(1:numIncluded,rin); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, chosenIdx, datasum);
f = figure('Name', 'Rin');
sh = plotSpread(rin', 'categoryIdx', ones(numel(rin),1), 'distributionColors', {color1}, 'xValues', 0.9, 'spreadWidth', 0.15); hold on;
boxplot(rin, 'Symbol', '', 'OutlierSize', 5, 'Colors', color1, 'Widths', 0.05); title('R_{in}');
ax = gca; 
set(sh{1}, 'MarkerSize', shMarkerSize);
ax.XLim = [0.81, 1.05];
ax.YLabel.String = 'M{\Omega}';
ax.FontSize = 8; ax.TitleFontWeight = 'normal';
f.PaperType = 'A4'; 
f.OuterPosition(1:2) = [325, 571];
f.OuterPosition(3:4) = [boxWidth,245]; 
f.PaperUnits = 'centimeters'; 
ax.XTick = []; 
ax.Box = 'Off'; 
% ax.Color = color3; 
ax.LabelFontSizeMultiplier = 1;
drawnow;

f = figure('Name', 'Rin');
sh = plotSpread({rin'; rinRat'; rinHuman'}, 'distributionColors', {color1; color1*1.15; color1*1.3}, 'xValues', [0.9, 1.15, 1.4], 'spreadWidth', 0.15, ...
    'xNames', {'all', 'rodent', 'human'}); hold on;
boxplot([rin, rinRat, rinHuman], [ones(numel(rin),1); ones(numel(rinRat),1)*2; ones(numel(rinHuman),1)*3], 'Symbol', '', ...
    'OutlierSize', 5, 'Colors', [color1; color1*1.15; color1*1.3], 'Widths', 0.05, 'Positions', [1, 1.25, 1.5]);
title('R_{in}');
ax = gca; 
set(sh{1}, 'MarkerSize', shMarkerSize);
ax.XLim = [0.81, 1.55];
ax.YLabel.String = 'M{\Omega}';
ax.FontSize = 8; ax.TitleFontWeight = 'normal';
f.PaperType = 'A4'; 
f.OuterPosition(1:2) = [335, 581];
f.OuterPosition(3:4) = [236,245]; 
f.PaperUnits = 'centimeters';
ax.Box = 'Off'; 
ax.LabelFontSizeMultiplier = 1;
drawnow;
ax.XTick = [0.95, 1.2, 1.45];
ax.XTickLabel = {'all', 'rodent', 'human'};


f = figure('Name', 'RS (MOhm)'); sh = plotSpread(rs', 'categoryIdx', ones(numel(rs),1), 'distributionColors', {color1}, 'xValues',  0.9, 'spreadWidth', 0.15); 
hold on; boxplot(rs, 'Symbol', '', 'OutlierSize', 5, 'Colors', color1, 'Widths', 0.05); title('RS');
ax = gca;
set(sh{1}, 'MarkerSize', shMarkerSize);
ax.FontSize = 8; ax.TitleFontWeight = 'normal';
ax.LabelFontSizeMultiplier = 1;
ax.YLabel.String = 'M{\Omega}';
f.OuterPosition(1:2) = [500, 571];
ax.XLim = [0.81, 1.05]; f.PaperType = 'A4'; f.OuterPosition(3:4) = [boxWidth,245]; f.PaperUnits = 'centimeters'; ax.XTick = []; ax.Box = 'Off'; ax.Color = color3; 

f = figure('Name', 'RS (MOhm)'); sh = plotSpread({rs'; rsRat'; rsHuman'},'distributionColors',  {color1; color1*1.15; color1*1.3}, ...
    'xValues',  [0.9, 1.15, 1.4], 'xNames', {'all', 'rodent', 'human'}, 'spreadWidth', 0.15); 
hold on; boxplot([rs, rsRat, rsHuman], [ones(numel(rs),1); ones(numel(rsRat),1)*2; ones(numel(rsHuman),1)*3], ...
    'Symbol', '', 'OutlierSize', 5, 'Colors', [color1; color1*1.15; color1*1.3], 'Widths', 0.05, 'Positions', [1, 1.25, 1.5]);
title('RS');
ax = gca;
set(sh{1}, 'MarkerSize', shMarkerSize);
ax.FontSize = 8; ax.TitleFontWeight = 'normal';
ax.LabelFontSizeMultiplier = 1;
ax.YLabel.String = 'M{\Omega}';
f.OuterPosition(1:2) = [520, 591];
ax.XLim = [0.81, 1.55]; 
f.PaperType = 'A4'; 
f.OuterPosition(3:4) = [236,245]; 
f.PaperUnits = 'centimeters'; 
ax.XTick = [0.95, 1.2, 1.45];
ax.XTickLabel = {'all', 'rodent', 'human'};
ax.Box = 'Off'; ax.Color = color3; 

% figure('Name', 'RS (MOhm)')
% h = scatter(1:numIncluded,rs); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, chosenIdx, datasum);
%%
figure('Name', 'Resting potential (mV)')
h = scatter(1:numIncluded,resting); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, chosenIdx, datasum);
%%
f = figure('Name', 'Resting potential (mV)');
sh = plotSpread(resting', 'categoryIdx', ones(numel(resting),1), 'distributionColors', {color1}, 'xValues', 0.9, 'spreadWidth', 0.15); hold on;
boxplot(resting, 'Symbol', '', 'OutlierSize', 5, 'Colors', color1, 'Widths', 0.05); 
t = title('Resting potential');
ax = gca;
ax.XLim = [0.8, 1.05]; f.PaperType = 'A4'; f.PaperUnits = 'centimeters'; ax.XTick = []; ax.Box = 'Off'; ax.Color = color3; 
ax.YLabel.String = 'mV';
set(sh{1}, 'MarkerSize', shMarkerSize);
ax.LabelFontSizeMultiplier = 1;
ax.FontSize = 8; ax.TitleFontWeight = 'normal';
drawnow
% ax.PlotBoxAspectRatioMode = 'manual';
f.OuterPosition(1:2) = [700, 571];
f.OuterPosition(3:4) = [boxWidth,245];
drawnow;
pause(0.5);
ax.PlotBoxAspectRatioMode = 'manual';
drawnow;
f.OuterPosition(3:4) = [131, 259];

f = figure('Name', 'Resting potential (mV)');
sh = plotSpread({resting', restingRat', restingHuman'}, 'distributionColors', {color1; color1*1.15; color1*1.3}, ...
    'xValues',  [0.9, 1.15, 1.4], 'xNames', {'all', 'rodent', 'human'}, 'spreadWidth', 0.15); hold on;
boxplot([resting, restingRat, restingHuman], [ones(numel(resting),1); ones(numel(restingRat),1)*2; ones(numel(restingHuman),1)*3], ...
    'Symbol', '', 'OutlierSize', 5, 'Colors', [color1; color1*1.15; color1*1.3], 'Widths', 0.05, 'Positions', [1, 1.25, 1.5]); 
t = title('Resting potential');
ax = gca;
ax.XLim = [0.8, 1.55]; f.PaperType = 'A4'; f.PaperUnits = 'centimeters'; 
ax.XTick = [0.95, 1.2, 1.45];
ax.XTickLabel = {'all', 'rodent', 'human'};
ax.Box = 'Off'; 
ax.Color = color3; 
ax.YLabel.String = 'mV';
set(sh{1}, 'MarkerSize', shMarkerSize);
ax.LabelFontSizeMultiplier = 1;
ax.FontSize = 8; ax.TitleFontWeight = 'normal';
drawnow
% ax.PlotBoxAspectRatioMode = 'manual';
f.OuterPosition(1:2) = [700, 571];
f.OuterPosition(3:4) = [236,245]; 
%%

% f = figure('Name', 'AP amplitude median(mV)');
% sh = plotSpread(apamplitudemedian', 'categoryIdx', ones(numel(apamplitudemedian),1), 'distributionColors', {color1}, 'xValues', 0.87, 'spreadWidth', 0.15); hold on;
% boxplot(apamplitudemedian, 'Symbol', '', 'OutlierSize', 5, 'Colors', color1, 'Widths', 0.065); title({'AP amplitude';'median'});
% ax = gca; ax.XLim = [0.77, 1.05]; f.PaperType = 'A4'; f.Position(3:4) = [boxWidth,393]; f.PaperUnits = 'centimeters'; ax.XTick = []; ax.Box = 'Off'; ax.Color = color3; 
% ax.FontSize = 8; ax.TitleFontWeight = 'normal';
% set(sh{1}, 'MarkerSize', shMarkerSize);
% ax.YLabel.String = 'mV';
% ax.LabelFontSizeMultiplier = 1;
% drawnow
% f.OuterPosition(1:2) = [852, 567];
% f.OuterPosition(3:4) = [boxWidth, 259];
% drawnow;
% pause(0.5);
% ax.PlotBoxAspectRatioMode = 'manual';
% drawnow;
% f.OuterPosition(3:4) = [130, 259];
% 
% figure('Name', 'Rheobase (pA)')
% h = scatter(1:numIncluded,rheobase); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, chosenIdx, datasum);
% figure('Name', 'rheobase (pA)')
% boxplot(rheobase); title('Rheobase (pA)');
% figure('Name', 'rheobase (pA)')
% histogram(rheobase); title('Rheobase (pA)');
% 
% f = figure('Name', 'Rheobase');
% h1 = histogram(rheobaseRat, 0:50:600, 'FaceColor', color1, 'LineStyle', 'none'); title('Rheobase (pA)');
% hold on
% h2 = histogram(rheobaseHuman, (0:50:600)-5, 'FaceColor', color2, 'LineStyle', 'none');
% lgd = legend('rat', 'human', 'Location', 'northeast');
% lgd.Box = 'off';
% lgd.Position = [0.6, 0.7108464119725801, 0.2925, 0.1344];
% xlabel('Current amplitude (pA)');
% ylabel('Count');
% ax = gca; f.PaperType = 'A4'; ax.XTick = 0:200:500; 
% f.OuterPosition(1:2) = [1000, 571];
% f.OuterPosition(3:4)= [201,245]; 
% ax.FontSize = 8; ax.TitleFontWeight = 'normal';
% ax.LabelFontSizeMultiplier = 1;
% f.PaperUnits = 'centimeters'; ax.Box = 'Off'; ax.Color = color3; ax.XLim = [-20, 560];
% drawnow
% 
% % % figure('Name', 'threshold median (mV)');
% % % boxplot(thresholdmedian)
% % % figure('Name', 'threshold1 (mV)');
% % % boxplot(threshold1)
% % % figure('Name', 'threshold2 (mV)');
% % % boxplot(threshold2)
% % % figure('Name', 'threshold3 (mV)');
% % % boxplot(threshold3)
% 
% % % figure('Name', 'aphalfwidthmedian (ms)');
% % % boxplot(aphalfwidthmedian); title('AP half width median (ms)');
% % f = figure('Name', 'aphalfwidthmedian (ms)');
% % h = histogram(aphalfwidthmedian, 20); title('AP half width median (ms)');
% % drawnow
% f = figure('Name', 'AP half width median histogram');
% % h1 = histogram(aphalfwidthmedianRat, 20, 'BinLimits', [0.05, 1.7], 'FaceColor', color1, 'LineStyle', 'none'); title('AP half width median histogram');
% % hold on;
% % h2 = histogram(aphalfwidthmedianHuman, 20, 'BinLimits', [0.05, 1.7], 'FaceColor', color2, 'LineStyle', 'none', 'BinEdges', h1.BinEdges-0.01); % 
% h1 = histogram(aphalfwidthmedianRat, 0.05:0.1:1.75, 'FaceColor', color1, 'LineStyle', 'none'); title('AP half width median');
% hold on;
% h2 = histogram(aphalfwidthmedianHuman, 'FaceColor', color2, 'LineStyle', 'none', 'BinEdges', h1.BinEdges-0.01); % 
% lgd = legend('rat', 'human', 'Location', 'northeast');
% lgd.Box = 'off';
% lgd.Position = [0.5207, 0.6746, 0.4175, 0.1605];
% xlabel('Duration (ms)');
% yl = ylabel('Count');
% ax = gca; ax.XLim = [0, 1.75]; ax.YLim = [0, 28]; f.PaperType = 'A4'; f.PaperUnits = 'centimeters'; ax.FontSize = 8; ax.TitleFontWeight = 'normal';
% % f.OuterPosition(3:4) = [294, 282]; 
% f.OuterPosition(1:2) = [1225, 571];
% f.OuterPosition(3:4) = [206, 245]; 
% ax.Box = 'Off'; ax.Color = color3; 
% ax.LabelFontSizeMultiplier = 1;
% drawnow
% 
% % figure, bar((h1.BinEdges(1:end-1)+h1.BinEdges(2:end))./2, [h2.BinCounts; h1.BinCounts]', 'Stacked')
% 
% % % figure('Name', 'apamplitude1 (mV)');
% % % boxplot(apamplitude1)
% % % figure('Name', 'apMaxVmedian (mV)');
% % % boxplot(apMaxVmedian)
% % % figure('Name', 'apamplitude1 (mV)');
% % % boxplot(apamplitude1)
% % % figure('Name', 'aphalfwidth1 (ms)');
% % % boxplot(aphalfwidth1)
% % % figure('Name', 'apMaxV1 (mV)');
% % % boxplot(apMaxV1)
% % figure('Name', 'holding (pA)'); 
% % boxplot(holding); title('Holding (pA)');
% % % figure('Name', 'holding (pA)');
% % % h = scatter(1:numIncluded,holding); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, chosenIdx, datasum);
% % % 
% % % figure('Name', 'apamplitudemean (mV)');
% % % h = scatter(1:numIncluded,apamplitudemean); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, chosenIdx, datasum);
% % % 
% % % figure('Name', 'threshold median (mV)');
% % % h = scatter(1:numIncluded,thresholdmedian); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, chosenIdx, datasum);
% % % 
% % % figure('Name', 'aphalfwidthmedian (ms)');
% % % h = scatter(1:numIncluded,aphalfwidthmedian); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, chosenIdx, datasum);
% % % 
% % % figure('Name', 'apMaxV1 (mV)');
% % % h = scatter(1:numIncluded,apMaxV1); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, chosenIdx, datasum);
% % 
% % figure,
% % histogram(timeDifferenceList,[0:10:600])
% % 
% % % apamplitudemeandropped = [datasum(idxToDropApAmplMean).apamplitudemean];
% % % figure('Name', 'dropped apamplitudemean (mV)');
% % % h = scatter(1:nnz(idxToDropApAmplMean),apamplitudemeandropped); h.ButtonDownFcn = @(o,e) scatter_btndownfcn(o, e, idxToDropApAmplMean, datasum);
% % 
% % 
% 
% 
if exist('vfig', 'var') && isvalid(vfig)
    delete(vfig);
end
vfig = IVViewer()

