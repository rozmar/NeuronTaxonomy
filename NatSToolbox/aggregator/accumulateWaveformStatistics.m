function accumulateWaveformStatistics(resultStructureArray, parameters)

  %% -----------------------------
  %  Initial check: we don't have
  %  to aggregate single cell.
  %% -----------------------------
  if length(resultStructureArray)==1
    return; 
  end
  
  % Convert to structure array
  resultStructureArray = [resultStructureArray{:}];
  %% -----------------------------
  
  %% -----------------------------
  %  Collect overall results
  %% -----------------------------
  accumulatedResultStructure = createResultStructure(resultStructureArray);
  %% -----------------------------
  
  plotWaveformStatistics(accumulatedResultStructure, parameters);
  
end

function appendedMatrix = appendToMatrix(previousMatrix, newResult)
  newMatrix = [newResult.upSlope, newResult.downSlope, newResult.waveLength, newResult.waveAmplitude, newResult.difference, newResult.class];
  appendedMatrix = [previousMatrix;newMatrix];
end

function accumulatedResultStructure = createResultStructure(resultStructureArray)

  overallResultMatrix = [];
  overallWaveformLength = [];
  overallWaveformArray = {};
  overallWaveformSpike = {};
  for i = 1 : length(resultStructureArray)
    overallResultMatrix = ...
        appendToMatrix(overallResultMatrix, resultStructureArray(i));
    
    overallWaveformArray = [overallWaveformArray;resultStructureArray(i).waveForms]; %#ok<AGROW>
    if isfield(resultStructureArray, 'waveFormLength')
      overallWaveformLength = [overallWaveformLength;resultStructureArray(i).waveFormLength]; %#ok<AGROW>
      overallWaveformSpike  = [overallWaveformSpike;resultStructureArray(i).waveSpikes]; %#ok<AGROW>
    end
  end

  accumulatedResultStructure = struct(...
      'fileName', 'Accumulated result', ...
      'upSlope', overallResultMatrix(:,1), ...
      'downSlope', overallResultMatrix(:,2), ...
      'waveLength', overallResultMatrix(:,3), ...
      'waveAmplitude', overallResultMatrix(:,4), ...
      'difference', overallResultMatrix(:,5), ...
      'class', overallResultMatrix(:,6));
  
  accumulatedResultStructure.waveForms = overallWaveformArray;
  
  if isfield(resultStructureArray, 'waveFormLength')
    accumulatedResultStructure.waveFormLength = overallWaveformLength;
    accumulatedResultStructure.waveFormSpike  = overallWaveformSpike;
  end
  
end