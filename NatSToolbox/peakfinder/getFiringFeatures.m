function [featureMatrix, featureNames] = getFiringFeatures(cellByGroup, parameters)

  %-------------------------------
  % Get parameters
  %-------------------------------
  radius       = parameters.triggerRadius * 1000;
  nBin         = parameters.nBin;
  edges        = linspace(-radius, radius, nBin+1);
  x            = linspace(-radius, radius, 1000);
  xSI          = diff(x([1,2]));
  nCell        = length(cellByGroup);
  %-------------------------------
  
  %-------------------------------
  % Initialize
  %-------------------------------  
  featureMatrix = zeros(nCell,8);
  currentCell   = 1;
  featureNames  = {'MEAN', ...
                   'SKEW', ...
                   'KURT', ...
                   'PKNUM', ...
                   'MPKDIFF', ...
                   'SDPKDIFF', ...
                   'PKINTR',...
                   'PKABMEAN'};
  %-------------------------------  
  

  %-------------------------------
  % Get groups
  %-------------------------------
  groupVector  = [cellByGroup.groupID];
  groupNumbers = unique(groupVector);
  nGroup       = length(groupNumbers);
  %-------------------------------
  
  %-------------------------------
  % Process groups
  %-------------------------------
  outputDir   = parameters.outputDir;
  peakOutFile = fopen([outputDir,'/peakTimes.txt'],'w');
  for g = 1 : nGroup
    thisGroupIdx  = (groupVector==groupNumbers(g));
    thisGroupCell = cellByGroup(thisGroupIdx);
    nFile         = sum(thisGroupIdx);
    %-------------------------------
    % Process files in group
    %-------------------------------
%     figure;
%     [r,c] = getSubplotDimension(nFile);
    for f = 1 : nFile
      %-------------------------------
      % Get current cell spikes
      %-------------------------------
      name               = thisGroupCell(f).name;
      thisSpikeV         = thisGroupCell(f).spikeVector * 1000;
      loweredSpikeV      = removeBaselineFromFiring(thisSpikeV, edges);
      %-------------------------------
      
      %-------------------------------
      % Create Kernel smoothed curve
      %-------------------------------
      smoothedData       = estimateWithKernel(thisSpikeV, x, 0.9);
      [~, peakLocations] = findpeaks(smoothedData, 'MINPEAKDISTANCE', round(2.5/xSI));
%       peakLocations      = smoothPeaks(smoothedData, peakLocations, round(2/xSI));
      prominenceVector   = calculatePeakProminence(x, smoothedData, peakLocations);
      peakLocations      = dropPeaksByProminence(x, smoothedData, peakLocations, prominenceVector, 0.10);
      %-------------------------------
      
      %-------------------------------
      % Fit normal dist. to data
      %-------------------------------
      normDist         = fitdist(loweredSpikeV, 'normal');
      gammDist         = fitdist(loweredSpikeV+radius, 'gamma');
      npdf             = pdf(normDist, x');
      gpdf             = pdf(gammDist, x'+radius);
      
      [h_norm,p_norm]  = kstest(loweredSpikeV, [x', cdf(normDist, x')]);
      [h_gam,p_gam]    = kstest(loweredSpikeV, [x', cdf(gammDist, x'+radius)]);
      fitted           = [1-h_norm,1-h_gam];
      
      % Check distribution fit
      if sum(fitted)==0
        % No distribution fit
        meanFiring = mean(loweredSpikeV);
        fprintf('Cell %s. no distribution fit.\n', name);
      else
        % Either or both of the dist. fit
        if p_norm>p_gam
          % Norm. dist. fit better
          [~,pos]    = max(npdf);
          fitted(2) = fitted(2)*0.5;
          fprintf('Cell %s. normal distribution fit better.\n', name);
        else
          % Gamma dist. fit better
          [~,pos]    = max(gpdf); 
          fitted(1)  = fitted(1)*0.5;
          fprintf('Cell %s. gamma distribution fit better.\n', name);
        end
        meanFiring = x(pos);
      end       
      %-------------------------------
      
      %-------------------------------
      % Calculate features from data
      %-------------------------------
      featureMatrix(currentCell,1) = meanFiring;
      featureMatrix(currentCell,2) = skewness(thisSpikeV);
      featureMatrix(currentCell,3) = kurtosis(thisSpikeV);
      %-------------------------------
      
      %-------------------------------
      % Calculate features from KS curve
      %-------------------------------
      peakValues                   = smoothedData(peakLocations);
      baseProbability              = mean(smoothedData);
      smallPeaks                   = (peakValues<baseProbability);
      peakLocations(smallPeaks)    = [];
      peakValues(smallPeaks)       = [];
      peakTimes                    = x(peakLocations);
      
      
      peakAboveMean                = peakValues(baseProbability<=peakValues);
      peakOfInterest               = peakTimes(-6.25<=peakTimes&peakTimes<=6.25);
      peakForVar                   = peakTimes(-12.5<=peakTimes&peakTimes<=12.5);
      peakAroundTrough             = peakTimes(-2<=peakTimes&peakTimes<=2);
      
%       meanFiring                   = mean(peakTimes);
      peakDifferences              = diff(peakForVar);
%       featureMatrix(currentCell,1) = meanFiring;
      featureMatrix(currentCell,4) = length(peakOfInterest);
      featureMatrix(currentCell,5) = mean(peakDifferences);
      %featureMatrix(currentCell,6) = var(peakDifferences);
      featureMatrix(currentCell,6) = std(peakDifferences);
      featureMatrix(currentCell,7) = logical(length(peakAroundTrough));
      featureMatrix(currentCell,8) = length(peakAboveMean);
      
      featureMatrix(isnan(featureMatrix)) = 0;
      %-------------------------------
      
      hold on;
      plot(peakTimes, peakValues, 'go', 'markerfacecolor', 'g');
      %plot([-radius,radius], [1,1]*baseProbability, 'g--');
      
      %plot([1,1]*meanFiring, get(gca,'YLim'), 'r--');
      
      %newCurve = removeBaselineFromSmoothedCurve(smoothedData);
      %plot(x, newCurve, '-', 'Color', [1,0,1]);
%       if sum(fitted)~=0
%         normMarker = '-';
%         gamMarker  = '-';
%         if fitted(1)==0.5
%           normMarker = '--';
%         elseif fitted(2)==0.5
%           gamMarker  = '--';
%         end
%         
%         if fitted(1)>0
%           plot(x, npdf, normMarker, 'Color', [1,0,0]);
%         end
%         if fitted(2)>0
%           plot(x, gpdf, gamMarker, 'Color', [0,1,0]);
%         end
%       end
      
%       boundaries = [-12.5,-6.25,6.25,12.5];
%       bcol = [0, 0.5, 0;0.5,0,0.5;0.5,0,0.5;0, 0.5, 0];
%       for b = 1 : 4
%         plot([1,1]*boundaries(b), get(gca, 'YLim'), '-.', 'Color', bcol(b,:), 'linewidth', 2);
%       end
      hold off;
      
      for p = 1 : length(peakTimes)-1
        fprintf(peakOutFile, '%f ', peakTimes(p));
      end
      fprintf(peakOutFile, '%f\n', peakTimes(end));
      
      saveas(gcf, [outputDir,'/',name,'.fig']);

      title(strrep(name,'_','\_'));
      currentCell = currentCell + 1;
    end
%     suptitle(thisGroupCell(1).groupName);
  end
  fclose(peakOutFile);
  %-------------------------------
end

function smoothedData = estimateWithKernel(dataVector, timeVector, alpha)
    h = findBestBandwidth(dataVector, timeVector', struct('alpha',alpha,'printMode',1));
    smoothedData = ksdensity(dataVector, timeVector, 'Bandwidth', h);
end

function stretched = stretchCurveToAmplitude(curve, amplitude)
  ratio = amplitude/max(curve);
  stretched = curve .* ratio;
end

function newCurve = removeBaselineFromSmoothedCurve(smoothedCurve)
  newCurve = smoothedCurve - mean(smoothedCurve);
  newCurve = max(newCurve,0);
end

function loweredSpikeVector = removeBaselineFromFiring(spikeVector, edges)
  loweredSpikeVector = spikeVector;
  toRemove           = false(size(spikeVector)); 
  nBin = length(edges)-1;
  [nInBin,iInBin] = histc(spikeVector, edges);
  meanIntensity = round(length(spikeVector)/nBin);
  for i = 1 : nBin
    indexInBin = find(iInBin==i);
    toRemove(indexInBin(1:min(meanIntensity, nInBin(i)))) = true;
  end
  loweredSpikeVector(toRemove) = [];
end
