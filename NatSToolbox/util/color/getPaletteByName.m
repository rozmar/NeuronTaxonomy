% Return a color object by its name.
% If this name doesn't exists, error will be shown.
function palette = getPaletteByName(name)

  % Get all palette
  allPalette = getAllPalette();
  
  % Find the current
  thisColorIndex = strcmpi({allPalette(:).name}, name);
  
  % Bad naming
  if sum(thisColorIndex)==0
    warndlg(sprintf('Color named %s doesn''t exist. Default color has been chosen.', name));
    warning('Color named %s doesn''t exist. Default color has been chosen.', name);
    thisColorIndex = strcmp({allPalette(:).name}, 'DEFAULT');
  end
  
  % Create result 
  palette  = convertTo0_1(allPalette(thisColorIndex));
end

function newPalette = convertTo0_1(oldPalette)
  newPalette = oldPalette;
  
  newPalette.fc = newPalette.fc./255;
  newPalette.bc = newPalette.bc./255;
  
end