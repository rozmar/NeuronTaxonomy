function plotUprisingTemplates(inputDir,outputDir)
  templateList = eval(['ls ',inputDir]);
  
  figure; clf;
  
  hold on;
  
  for i = 1 : size(templateList,1)
    load([inputDir,'/',strtrim(templateList(i,:))]);
    fprintf('Loading %s\n', strtrim(templateList(i,:)));
    plot(template);
  end
  
  if nargin==2
    print(gcf,'-dsvg','-r600',[outputDir,'/templates']);
  end
  
end
