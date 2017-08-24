% printStatus displays a message bordered with * character to visually
% separate from the other parts of the output.
%
% printStatus(message, delimiter)
%   - message text to display
%   - delimiter type of character for border, (default *)
function printStatus(message, delimiter)

  if nargin<2
    delimiter = '*';
  end
  
  startChar = '*';
  if delimiter~='*'
    startChar = '|';
  end
  
  border = ones(1,30)*delimiter;
  
  
  fprintf('%s\n', border);
  fprintf('%c %s\n', startChar, message);
  fprintf('%s\n', border);
end