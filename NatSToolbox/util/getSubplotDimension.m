% getSubplotDimension calculates the optimal row and column number for
% subplots for a given number of plots.
%
% Parameters
%  - nAxes number of plots on the subplot
% Return values
%  - r rows of subplot
%  - c cols of subplot
function [r,c] = getSubplotDimension(nAxes, mode)

  %% -------------------------
  %  If we want balanced layout,
  %  it will be "squared" else
  %  rectangular.
  %% -------------------------
  if nargin<2 || strcmpi(mode, 'balanced')
    r = round(sqrt(nAxes));
    c = ceil(nAxes/r);
  else
    c = min(5, nAxes);
    r = ceil(nAxes/c);
  end
end