function eventVector = getEvents(inputStructure, parameters)

  if ~isfield(parameters, 'eventName')
    errordlg('Name of event channel hasn''t been given!'); 
    error('Name of event channel hasn''t been given!');
  end
  
  if ~isfield(inputStructure, parameters.eventName)
    errordlg(sprintf('Field %s in input file is missing!', parameters.eventName));
    error('Field %s in input file is missing!', parameters.eventName);
  end
  
  eventVector = inputStructure.(parameters.eventName).times;
end