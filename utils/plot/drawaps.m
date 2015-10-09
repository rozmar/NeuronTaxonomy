

function drawaps(ivpath,ivname,cellpath,cellfile,ttl,color)
	  
	feats = load("/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat").featS;
	iv = load(ivpath{1}).iv.(ivname{1});
	Y = sweepToMatrix(iv);
	cell = load([cellpath,"/",cellfile{1}]).cellStruct;
	apFeatures = cell.apFeatures;
	
  x=iv.time;
  for i = 1 : size(apFeatures,1)
	  apf = apFeatures(i,:);
			
	  y=Y(apf(1),:);
	  samplingRate = 1 / (x(2)-x(1));
	
	  start = apf(feats.thresholdPos)-10;
	  endP = start + round(0.004*samplingRate);
	  ap = y(start:endP);
	  apx = x(start:endP);
		
	  figure(randi(100));
	  hold on;
	  plotAP(apx,ap,color);
	  
	  plotFeatureWithPoint(apf(feats.dvMaxT),apf(feats.dvMaxV),'^');
	  plotFeatureWithPoint(apf(feats.dvMinT), apf(feats.dvMinV),'v');
	  drawVDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.dvMaxV), apf(feats.dvMinV));	
	  drawTDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.dvMaxT),apf(feats.dvMaxV));
	  drawTDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.dvMinT), apf(feats.dvMinV));
    title(strcat(num2str(apf(1)),' sweep, ',num2str(i),' ap'));
	  hold off;
  
end