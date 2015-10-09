function processUprising(inputDir,outputDir)
  uprisingList = dir(inputDir);
  
  for i = 1 : size(uprisingList,1)
    if uprisingList(i).isdir
        continue;
    end
    fname = strtrim(uprisingList(i).name);
    load(strcat(inputDir,'/',fname));
    if length(uprising)==0  
      fprintf('%s uprising not exists.\n', strtrim(uprisingList(i).name));
      continue;
    end
    fprintf('Loading %s\n', fname);
    template = createTemplate(uprising);
    newName = strrep(fname,'uprising','template')
    save([outputDir,'/',newName],'template');
  end
  
end