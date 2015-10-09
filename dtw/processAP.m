function processAP(inputDir,outputDir)
  APList = eval(['ls ',inputDir]);
  
  for i = 1 : size(APList,1)
    load([inputDir,'/',strtrim(APList(i,:))]);
    if length(ap)==0
      fprintf('%s uprising not exists.\n', strtrim(APList(i,:)));
      continue;
    end
    fprintf('Loading %s\n', strtrim(APList(i,:)));
    template = createTemplate(ap);
    newName = strrep(strtrim(APList(i,:)),'uprising','template')
    save([outputDir,'/',newName],'template');
  end
  
end