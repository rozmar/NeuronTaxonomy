
AP = [];

debug = 1;

for k = 1 : 2
  diffInd = 0;
  diffMin = 100;
  %dvMaxVRealdvMinVRealDiff
  %comparing = mean(eval(['cell',num2str(k)]).apFeatures(:,featS.dvMaxV).-eval(['cell',num2str(k)]).apFeatures(:,featS.dvMinV) );
  %dvMaxdvMinDiffMin
  %comparing = min(eval(['cell',num2str(k)]).apFeatures(:,featS.dvMaxPos).-eval(['cell',num2str(k)]).apFeatures(:,featS.dvMinPos) );
  comparing = mean(eval(['cell',num2str(k)]).apFeatures(:,featS.dvMinV));
  if debug
      disp(comparing);
  end
  for j = 1 : size(eval(['cell',num2str(k)]).apFeatures,1)
    current = eval(['cell',num2str(k)]).apFeatures(j,featS.dvMinV);
    diff = abs( comparing - current );
    if diff < diffMin
      diffMin = diff;
      diffInd = j;
    end
  end
  AP(k) = diffInd;
end