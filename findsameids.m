
cells = {};
for i = 1 : length(fileName)
  exist = 0;
  id = substr(fileName{i},1,find(fileName{i}=='_')(4));
  disp(i)
  length(cells)
  cells
  for j = 1 : length(cells) 
    if strcmp(cells{j}.key,id)==1
      cells{j}.values = [ cells{j}.values ; i ];
      exist = 1;
      break;
    end
  end
  if exist==1
    continue
  end
  cells{length(cells)+1}.key = id;
  cells{length(cells)}.values = [i];
end