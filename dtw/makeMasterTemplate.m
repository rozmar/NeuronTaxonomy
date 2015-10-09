function makeMasterTemplate(inputDir,outputDir,classLabel)
  templateList = dir([inputDir,'/',classLabel]);
  
  templates = {};
  figure('visible','off');
  clf;
  hold on;
  for i = 1 : size(templateList,1)
    if templateList(i).isdir==1
        continue;
    end
    load([inputDir,'/',classLabel,'/',strtrim(templateList(i).name)]);
    fprintf('Loading %s\n', strtrim(templateList(i).name));
    templates{i} = template;
    plot(templates{i});
  end
  hold off;
  set(gcf, 'visible','on');
  
  template = createTemplate(templates);
  save([outputDir,'/master_template',classLabel,'.mat'],'template');
  
end
