% plotClusteredSlices plots slices in the same size groped by the given
% vector. Each group can be shown by its mean&SD (bounded line) or
% superimposed. 
% 
% Parameters
%  - timeVector - tx1 vector, the time values
%  - sliceMatrix - nxt matrix, contains the slices to plot
%  - groupVector - nx1 vector, the grouping variables
%  - parameters  - structure to customize the plot
%     - clusterPlotMode - 'msd' (Mean&SEM) or 'sup' (superimposed)
%     - xTick - where to put the x axis ticks
%     - xTickLabel - what to write to ticks
function plotClusteredSlices(timeVector, sliceMatrix, groupVector, parameters)

  %% -------------------------
  %  Parameter setting
  %% -------------------------
  
  % Mode for display
  mode = parameters.clusterPlotMode;  
  % Group labels
  labelGroup = unique(groupVector);
  % Number of groups
  nGroup     = length(labelGroup);
  % Get no. of elements per group
  nGroups    = histc(groupVector, labelGroup);
  % Number of rows and columns
  [r,c]      = getSubplotDimension(nGroup);
  %% -------------------------
  
  figure;
  set(gcf, 'visible', 'off');
    
  %% -------------------------
  %  Take each group
  %% -------------------------
  for i = 1 : nGroup
    subplot(r,c,i);
    
    % Select slices in this group
    thisGroupIndex = (groupVector==i);
    thisSlices     = sliceMatrix(thisGroupIndex,:);
    
    % Plot this group
    if strcmpi(mode, 'msd')
      boundedline(timeVector, mean(thisSlices), std(thisSlices));
    elseif strcmpi(mode, 'avg')
      plot(timeVector, mean(thisSlices), 'LineWidth', 3);  
    elseif strcmpi(mode, 'sup')
      plotSuperimposedMean(timeVector, thisSlices);
    end
    
    % Set title
    titleStr = 'Group: %d, # %d';
    titleStr = sprintf(titleStr, i, nGroups(i));
    title(titleStr, 'FontSize', 14);
    
    % Customize
    xlim(timeVector([1,end]));    
    set(gca, 'FontSize', 14)
    set(gca, 'XTick', parameters.xTick);
    set(gca, 'XTickLabel', parameters.xTickLabel);
  end
  %% -------------------------
  
  set(gcf, 'visible', 'on');
  
end

% This function plots values superimposed and the mean
function plotSuperimposedMean(xValues, yMatrix)
  hold on;
  plot(xValues, yMatrix);
  plot(xValues, mean(yMatrix), 'w-', 'LineWidth', 3);
  hold off;
end