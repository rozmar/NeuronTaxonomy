% calculateACAndISI performs the ISI and AC calculation for a vector of
% events passed as parameter. It returns both result in a structure for a
% given event vector.
% 
% Parameters
%  eventVector - nx1 vector containing the events
%  parameters  - parameter structure with fields needed for AC and ISI
% Retrun values
%  resultStruct - structure containing the calculated results
%    ISI - bins and ticks for x and y values
%    AC  - bins and ticks for x and y values
function resultStruct = calculateACAndISI(eventVector, parameters)

  %% ----------------------
  %  Calculate values
  %% ----------------------
  [ISIbins, ISIBounds] = calculateEventISI(eventVector, parameters.ISI);  
  [AC, lags]           = calculateEventAC(eventVector, parameters.AC);
  %% ----------------------
  
  %% ----------------------
  %  Save to structure
  %% ----------------------
  resultStruct.ISI.bins  = ISIbins';
  resultStruct.ISI.xtick = ISIBounds';
  resultStruct.ISI.scale = parameters.ISI.plotScale;
  resultStruct.AC.bins   = AC';
  resultStruct.AC.xtick  = lags';
  %% ----------------------
  
end