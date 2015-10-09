

function drawap(ivpath,ivname,cellpath,cellfile,ttl,color,apnum)
	  
	feats = load("/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat").featS;
	iv = load(ivpath).iv.(ivname);
	Y = sweepToMatrix(iv);
	cell = load([cellpath,"/",cellfile]).cellStruct;
	apFeatures = cell.apFeatures;
	
  x=iv.time;
  i = apnum;
	  apf = apFeatures(i,:);
			
	  y=Y(apf(1),:);
	  samplingRate = 1 / (x(2)-x(1));
	
	  start = apf(feats.thresholdPos)-10;
	  endP = start + round(0.006*samplingRate);
	  ap = y(start:endP);
	  apx = x(start:endP);
		
	  %figure(randi(100));
	  hold on;
	  plotAP(apx,ap,color);
	  
    plotFeatureWithPoint(x(apf(feats.ahpPos)), apf(feats.ahpV),'.');
	  %plotFeatureWithPoint(apf(feats.dvMaxT),apf(feats.dvMaxV),'^');
	  %plotFeatureWithPoint(apf(feats.dvMinT), apf(feats.dvMinV),'v');
	  %drawVDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.dvMaxV), apf(feats.dvMinV));	
	  %drawTDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.dvMaxT),apf(feats.dvMaxV));
	  %drawTDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.dvMinT), apf(feats.dvMinV));
    
    %drawTDiff(apf(feats.dvMaxT),apf(feats.dvMinT),-0.055);	
	  %drawVDiff(apf(feats.dvMaxT),apf(feats.dvMaxV),-0.055);
	  %drawVDiff(apf(feats.dvMinT),apf(feats.dvMinV),-0.055);
    title(ttl);
	  hold off;
  
end