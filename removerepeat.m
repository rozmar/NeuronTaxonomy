
SNX = NX;
sy = y;
removeIndexes = [];

for i = 1 : length(cells)
  removeIndexes = [ removeIndexes ; cells{i}.values(2:end) ];
end

SNX(removeIndexes,:)=[]; 
sy(removeIndexes,:)=[];