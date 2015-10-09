function template = createTemplate(timeSeries,silentMode)
  meanLength = 0;
  
  if nargin<2
    silentMode = 0;
  end
  
  for i = 1 : length(timeSeries)
    if isempty(timeSeries{i})==1
        continue;
    end
    if isfield(timeSeries{i},'iv')
        meanLength = meanLength + length(timeSeries{i}.iv);
        sweepMean = mean(timeSeries{i}.iv);
        timeSeries{i}.iv = timeSeries{i}.iv-sweepMean;
    else
        meanLength = meanLength + length(timeSeries{i});
        sweepMean = mean(timeSeries{i});
        timeSeries{i} = timeSeries{i}-sweepMean;        
    end
  end
    
  meanLength = meanLength / length(timeSeries);
 
  for i = 1 : length(timeSeries)
    if isempty(timeSeries{i})==1
        continue;
    end
    if isfield(timeSeries{i},'iv')
        if length(timeSeries{i}.iv)==0
          continue;
        end
        template = resampleSweep(timeSeries{i}.iv, meanLength);
    else
        if length(timeSeries{i})==0
          continue;
        end
        template = resampleSweep(timeSeries{i}, meanLength);
    end
    break;
  end

  r = ones(size(template));
  if silentMode==0
    fprintf('Matching timeseries to template...\n');
  end
  %fflush(stdout);
  drawnow('update');

  for i = 2 : length(timeSeries)
    if silentMode==0
      fprintf('Matching %d/%d...\n', i, length(timeSeries));
      %fflush(stdout);
      drawnow('update');
    end
    if isempty(timeSeries{i})==1
        continue;
    end
    if isfield(timeSeries{i},'iv')
        if length(timeSeries{i}.iv)==0
          continue;
        end
        anotherSegment = resampleSweep(timeSeries{i}.iv, meanLength);
    else
        if length(timeSeries{i})==0
          continue;
        end
        anotherSegment = resampleSweep(timeSeries{i}, meanLength);
    end
        [D,d,t] = fillDTWMatrix(anotherSegment, template, 1);
        [template,r] = updateTemplateSweep(anotherSegment, template, t, r);
  end
  if silentMode==0
    fprintf('Template ready.\n');
    %fflush(stdout);
    drawnow('update');
  end
  
end
