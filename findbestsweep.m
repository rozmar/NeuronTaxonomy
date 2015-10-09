
SW = [];

debug = 1;

for k = 1 : 2
  diffInd = 0;
  diffMin = 100; 
  comparing = mean(eval(['cell',num2str(k)]).vsag.-eval(['cell',num2str(k)]).vrebound);
  if debug
      disp(comparing);
  end
  for j = 1 : size(eval(['cell',num2str(k)]).vsag,1)
    current = eval(['cell',num2str(k)]).vsag(j).-eval(['cell',num2str(k)]).vrebound(j);
    diff = abs( comparing - current );
    if diff < diffMin
      diffMin = diff;
      diffInd = j;
    end
  end
  SW(k) = diffInd;
end