function plotWaveformStatistics(resultStructure, parameters) 
  
  if parameters.categorize.toCategorize
    titles = parameters.categorize.categoryLabel;
    classLabels = sort(unique(resultStructure.class));
  else
    classLabels = 1;
  end
    
  for i = 1 : length(classLabels)

    thisFlag = (resultStructure.class==classLabels(i));
      
    %% -------------------------------
    %  Plot property distribution
    %% -------------------------------
    figure;
    subplot(2,2,1);
    hist(resultStructure.upSlope(thisFlag));
    title('Slope of first part');
    subplot(2,2,2);
    hist(resultStructure.downSlope(thisFlag));
    title('Slope of second part');
    subplot(2,2,3);
    hist(resultStructure.waveLength(thisFlag));
    title('Wavelength distribution');
    subplot(2,2,4);
    hist(resultStructure.waveAmplitude(thisFlag));
    title('Wave amplitude distribution');
    
    if parameters.categorize.toCategorize
      suptitle(strjoin({strrep(resultStructure.fileName,'_','\_'),titles{i}}));
    else
      suptitle(strrep(resultStructure.fileName,'_','\_'));  
    end
    %% -------------------------------
    
    %% -------------------------------
    %  Plot delta length vs. spindle distance corr.
    %% -------------------------------
    thisWavelength = resultStructure.waveLength(thisFlag);
    
    if isfield(parameters, 'following')
      figure;
    
      thisDifference = resultStructure.difference(thisFlag);
      
      scatter(thisDifference, thisWavelength, 'filled');
  
      correlation = corr(thisDifference(~isnan(thisDifference)), thisWavelength(~isnan(thisDifference)));
  
      xlabel('Difference of delta end and spindle 2. trough');
      ylabel('Delta wavelength');
      title(strjoin({strrep(resultStructure.fileName,'_','\_'),num2str(correlation),titles{i}}));
    end
    %% -------------------------------
    
    %% -------------------------------
    %  Plot slope vs. delta length
    %% -------------------------------
    figure;
    thisLeftSlope = resultStructure.upSlope(thisFlag);
    thisRightSlope = resultStructure.downSlope(thisFlag);
    
    firstLine = polyfit(thisLeftSlope, thisWavelength, 1);
    secondLine = polyfit(thisRightSlope, thisWavelength, 1);
    
    subplot(1,2,1);
    hold on;
    scatter(thisLeftSlope, thisWavelength, 'filled');
    plot(thisLeftSlope, firstLine(1)*thisLeftSlope + firstLine(2), 'r-');
    hold off;
    xlabel('Left slope (\muV/s)');
    ylabel('Delta width');
    title(strjoin({'First slope vs. length of delta','corr=',num2str(corr(thisLeftSlope, thisWavelength))}));
    
    subplot(1,2,2);
    hold on;
    scatter(thisRightSlope, thisWavelength, 'filled');
    plot(thisRightSlope, secondLine(1)*thisRightSlope + secondLine(2), 'r-');
    hold off;
    xlabel('Right slope (\muV/s)');
    ylabel('Delta width');
    title(strjoin({'Second slope vs. length of delta','corr=',num2str(corr(thisRightSlope, thisWavelength))}));
    
    if parameters.categorize.toCategorize
      suptitle(strjoin({strrep(resultStructure.fileName,'_','\_'),titles{i}}));
    else
      suptitle(strrep(resultStructure.fileName,'_','\_'));  
    end
    %% -------------------------------
    
    %% -------------------------------
    %  Plot delta waves in descending order
    %% -------------------------------
    if isfield(parameters, 'following')
      figure;
      hold on;
      thisWaves = resultStructure.waveForms(thisFlag);
      thisWaves = thisWaves(~isnan(thisDifference));
      thisLength = resultStructure.waveFormLength(thisFlag);
      thisLength = thisLength(~isnan(thisDifference));
    
      if isfield(resultStructure,'waveFormSpike')
        thisSpikes = resultStructure.waveFormSpike(thisFlag);
        thisSpikes = thisSpikes(~isnan(thisDifference));
      end
    
      nonNanWaveLength = thisWavelength(~isnan(thisDifference));
      [~,orderByLength] = sort(nonNanWaveLength);
      for w = 1 : length(thisWaves)
        
        currentIndex = orderByLength(w);
        waveEndPosition = nonNanWaveLength(currentIndex);
        
        currentWave = thisWaves{currentIndex};
        currentTime = linspace(0, thisLength(currentIndex), length(currentWave));
        currentTime = currentTime - waveEndPosition;
      
        plot(currentTime, currentWave+w);
      
        if isfield(resultStructure,'waveFormSpike')
          currentSpikeVector = thisSpikes{currentIndex} - waveEndPosition;
      
          for sp = 1 : length(currentSpikeVector)
            [~,spikePosition] = min(abs(currentTime-currentSpikeVector(sp)));
            plot(currentSpikeVector(sp), currentWave(spikePosition)+w, 'r.', 'markersize', 10, 'markerfacecolor', 'r');    
          end
        end
      
      end
    
      if parameters.categorize.toCategorize
        title(strjoin({'Delta waves',titles{i},'in descending order'}));
      else
        title('Delta waves',titles{i},'in descending order');  
      end
      hold off;
    end
    %% -------------------------------
    
  end

end