


function plotFeatureWithAP(ivpath,ivname,cellpath,cellfile,ttl,color,toplot)
	  
	feats = load("/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat").featS;
	iv = load(ivpath).iv.(ivname);
	Y = sweepToMatrix(iv);
	cell = load([cellpath,"/",cellfile]).cellStruct;
	apFeatures = cell.apFeatures;
	firingSweep = unique(apFeatures(:,1));
	
	for i=1:size(firingSweep,1)
		sap = apFeatures(find(apFeatures(:,1)==firingSweep(i)),:);
		if size(sap,1)>1
			apf = sap(1,:);
			break;
		end
	end
	
	if ~exist("apf","var")
		printf("Error, no sweep with more than one AP found.\n");
		return;
	end
	
	y=Y(apf(1),:);
	x=iv.time;
	
	
	samplingRate = 1 / (x(2)-x(1));
	
	start = apf(feats.thresholdPos)-10;
	endP = start + round(0.004*samplingRate);
	ap = y(start:endP);
	apx = x(start:endP);
		
	hold on;
	plotAP(apx,ap,'r-');
  
  if toplot==118
	  plotFeatureWithPoint(x(apf(feats.thresholdPos)),apf(feats.thresholdV));
	  plotFeatureWithPoint(x(apf(feats.ahpPos)), apf(feats.ahpV),'.');
	  drawVDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.thresholdV), apf(feats.ahpV));
	  drawTDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),x(apf(feats.ahpPos)), apf(feats.ahpV));
	  drawTDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),x(apf(feats.thresholdPos)),apf(feats.thresholdV));
	elseif toplot==126 
	  plotFeatureWithPoint(apf(feats.dvMaxT),apf(feats.dvMaxV),'^');
	  plotFeatureWithPoint(apf(feats.dvMinT), apf(feats.dvMinV),'v');
	  drawVDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.dvMaxV), apf(feats.dvMinV));	
	  drawTDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.dvMaxT),apf(feats.dvMaxV));
	  drawTDiff((x(apf(feats.thresholdPos)-round(0.001*samplingRate))),apf(feats.dvMinT), apf(feats.dvMinV));
  end
  
  title(ttl);
	hold off;
end