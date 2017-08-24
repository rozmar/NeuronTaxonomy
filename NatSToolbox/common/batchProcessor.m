% batchProcessor is a general function which loads the input file(s) from
% the given directory, then run the given batchProcessor function, then
% aggregates the result with the given aggregator function.
%
% Parameters
%  parameters - parameter structure, its content depends on the batch
%  functions 
%  batchCalcFunction - function handle for the batch processor script
%  aggregateFunction - function handle for the aggregator script
function batchProcessor(parameters, functionStructure)

  %% -------------------------
  %  Check output directory
  %% -------------------------
  parameters = checkOutputParameters(parameters);
  %% -------------------------

  %% -------------------------
  %  Load the input files
  %% -------------------------
  [fileNameArray, inputDir] = selectFileList(parameters);
  nFile                     = length(fileNameArray);
  %% -------------------------
  
  %% -------------------------
  %  Process each file and save
  %  the result structure in array.
  %% -------------------------
  resultArray = cell(nFile, 1);
  for i = 1 : nFile
    fName   = fileNameArray{i};
    fPath   = sprintf('%s%s', inputDir, fName);
    I       = load(fPath);
    I.title = fName;
    
    % Open logfile
    if isSave(parameters)
      global logFile; %#ok<TLEV>
      logFile = fopen(strcat(parameters.output.dir,fName,'_stat.csv'),'w');
      fprintf(logFile,'%s\n',fName);
    end
    
    printStatus(sprintf('Process %s', fName),'=');
    
    try 
      [resultArray{i},parameters] = processMultiChannel(functionStructure.batchCalcFunction, I, parameters);
    
      if isfield(functionStructure, 'plotFunction')
        parameters.plot.fileName = strrep(fName,'_','');
        functionStructure.plotFunction(resultArray{i}, parameters);
      end
      
    catch MEx
      if strcmpi(MEx.identifier, 'CollectTrigger:EmptyTrigger')
        warning(MEx.message);
      elseif strcmpi(MEx.identifier, 'BatchProcess:EmptyResult')
        warning(MEx.message);
      else
        rethrow(MEx);
      end
      
    end
    
    % Close logfile
    if isSave(parameters)
      fclose(logFile); 
    end
  end
  %% -------------------------
  
  resultArray(cellfun(@isempty, resultArray)) = [];
  
  %% -------------------------
  %  Aggregate the results
  %% -------------------------
  if isfield(functionStructure, 'aggregateFunction')
    if isSave(parameters)
      logFile = fopen(strcat(parameters.output.dir,'average_stat.csv'),'w');
    end
    functionStructure.aggregateFunction(resultArray, parameters);
    if isSave(parameters)
      fclose(logFile); 
    end
  end
  %% -------------------------
  
end

%% =============================
%  List files in a dialog and 
%  allow to choose from them.
%% =============================
function [fileNameArray, inputDir] = selectFileList(parameters)

  inputDir                  = parameters.input.dir;
  [fileNameArray, inputDir] = listFilesInDir(inputDir);
  
  Selection = listdlg('ListString'    ,fileNameArray, ...
                        'Name'        ,'Select files', ...
                        'InitialValue',(1:length(fileNameArray)), ...
                        'ListSize'    ,[200,300], ...
                        'PromptString','Select files');
  
  fileNameArray = fileNameArray(Selection);
                  
  if isempty(fileNameArray)
    errordlg('You must select at least 1 file!');
    error('You must select at least 1 file!\n');
  end
end
%% =============================

%% =============================
%  Check if output directory was
%  given, and if yes, check for 
%  its existence.
%  Sets the isSave flag.
%% =============================
function parameters = checkOutputParameters(inparameters)

  parameters = inparameters;
  
  %% ---------------------------
  %  If output directory was given
  %% ---------------------------
  if isfield(parameters, 'output') && isfield(parameters.output, 'dir')
      
    outDir = parameters.output.dir;
    
    % Put / to the end of the 
    % directory's path if missing
    if isempty(regexp(outDir, '^.*[\/\\]$', 'once'))
      outDir = strcat(outDir, '/');
    end
    
    % If output directory doesn't
    % exists, warn the user.
    if ~exist(outDir, 'dir')
      throw(MException('TriggeredTroughlet:Outputcheck', ...
          sprintf('Output directory %s does not exist!',...
            strrep(outDir,'\','\\'))));
    else
      if ~exist(strcat(outDir,'\png'), 'dir')
        mkdir(strcat(outDir,'\png'));
      end
      
      if ~exist(strcat(outDir,'\fig'), 'dir')
        mkdir(strcat(outDir,'\fig'));
      end
    end
    
    isSaveVar    = true;
    parameters.output.dir = outDir;
  end
  %% ---------------------------

  %% ---------------------------
  % Set isSave flag
  %% ---------------------------
  parameters.isSave     = exist('isSaveVar', 'var')&&isSaveVar;
  %% ---------------------------
    
end
%% =============================
