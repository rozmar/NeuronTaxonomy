% Function, which extract electrophysiological features from the given cell.
%
% In parameter expects the cell, returns the struct, which contains the 
% extracted features. The struct's fields contains the features. If a feature
% is global for the whole cell, it's a single scalar. If the value different for the
% sweeps, it's a vector. If a feature differs by sweep and has more value, it
% will be contained in a matrix.	
function cellStruct = featureExtract(iv,dataDir)

	if nargin < 2
		dataDir = '.';
	end

	load([dataDir,'/apFeatures.mat'],'featS');

	plotPassive	= 0;
	plotActive	= 1;	

	x = iv.time;
	lastHypSecToCount = 0.1;
	movingaverageforsag=.01;
	tresholdvalue=10;
	minapamplitude=20; % amplitude of minimal AP amplitude to be recognized
	sampleInterval = x(2) - x(1); 				%difference between two sample point in time (in secundum)
	samplingRate = 1 / sampleInterval; 			%samplingrate, number of sample points in one second
	cellStruct.samplingRate  = samplingRate;
	hundredMicsStep = max(floor(.0001 / sampleInterval ),1);	%number of sample points in 100 microseconds, can't be less than 1
		
	Y = sweepToMatrix(iv);					%create matrix from IV-s (if the new format of IV files are used, it's unnecessary)		
		
	[cellStruct.taustart cellStruct.vrs] = findRSJump(x,Y,iv.current,sampleInterval,hundredMicsStep,iv.segment);		%find RS jump and the RS value
	
	[cellStruct.v0, cellStruct.dvrs] = calculateV0BySweep(x,Y,cellStruct.taustart,hundredMicsStep,cellStruct.vrs,iv.current);	%calculate v0 and dvrs

    [~,noisesweep]=min(abs(iv.current));
	[cellStruct.noiselevel cellStruct.filterednoiselevel] = calculateNoiseLevel(Y(noisesweep,:),samplingRate);	%calculate noise level from the 0 current
	
	[cellStruct.vhyp cellStruct.dvin] = findHyperPolarization(x,Y,iv.segment,lastHypSecToCount,cellStruct.vrs);

	[cellStruct.vsag cellStruct.dvsag cellStruct.rsag cellStruct.tauend] = findSag(x,Y(find(iv.current<0),:),cellStruct.taustart,cellStruct.vrs(find(iv.current<0)),samplingRate,iv.segment,iv.current(find(iv.current<0)));

    [cellStruct.vrebound cellStruct.trebound cellStruct.dvrebound cellStruct.reb0_90risetime ] = findRebound(x,Y(find(iv.current<0),:),samplingRate,iv.segment,cellStruct.vhyp(find(iv.current<0),:),cellStruct.dvrs(find(iv.current<0),:));
		
	cellStruct.tau0_90risetime = getTauRiseTime(x,Y(find(iv.current<0),:),cellStruct.taustart,cellStruct.tauend,sampleInterval,samplingRate);
	
	pnum = length(find(iv.current<0));
	
	if plotPassive==1
		for i=1:pnum
			figure;
			subplot(1,1,1);
			hold on
			plot(x,Y(i,:),'-b');
			plot(x(cellStruct.taustart),Y(i,cellStruct.taustart),'r@');
			plot([0 iv.segment(1)/1000],[cellStruct.v0(i) cellStruct.v0(i)],'r-');
			plot([sum(iv.segment(1:2)/1000)-0.1 sum(iv.segment(1:2)/1000)],[cellStruct.vhyp(i) cellStruct.vhyp(i)],'r-');
			plot(cellStruct.trebound(i),cellStruct.vrebound(i),'r@');
			plot([x(cellStruct.tauend(i))-0.01 x(cellStruct.tauend(i))+0.01],[cellStruct.vsag(i) cellStruct.vsag(i)],'r-');
			hold off;
		end
	end
	
	cellStruct.pulseEnd = getPulseEnd(x,iv.segment);

	[apMasks cellStruct.apNums] = labelAP(x,Y,cellStruct.taustart,cellStruct.pulseEnd,cellStruct.dvrs,hundredMicsStep,minapamplitude,iv.current);

	[cellStruct.apFeatures cellStruct.apNums] = describeAP(x,Y,apMasks,cellStruct.apNums,cellStruct.taustart,cellStruct.pulseEnd);
	
	if size(cellStruct.apFeatures,2)==0
	  cellStruct={};
	  return;	
	end

	[ cellStruct.apFeatures cellStruct.apNums ] = removeBadSpikes(cellStruct.apFeatures, cellStruct.apNums);

	[ cellStruct.hump cellStruct.ramp cellStruct.rhump ] = findHumpRamp(x,Y,iv.current,cellStruct.apNums,samplingRate,iv.segment,cellStruct.vrs);

	[ cellStruct.rheobase cellStruct.steady ] = getRheobaseSteady(x,Y,cellStruct.taustart,cellStruct.pulseEnd,cellStruct.apNums,iv.current,sampleInterval);
		
	if size(cellStruct.apFeatures,1)>0

		[cellStruct.apFeatures ] = offsetVoltage(cellStruct.apFeatures,cellStruct.apNums,cellStruct.hump,iv.current,cellStruct.dvrs);
								
		[ cellStruct.ahp cellStruct.adp cellStruct.concavitymin cellStruct.concavitymax cellStruct.concavity cellStruct.concavitystd cellStruct.ahp05 cellStruct.ahp090] = findAhpAdp(x,Y,cellStruct.taustart,cellStruct.pulseEnd,cellStruct.apNums,iv.current,sampleInterval,cellStruct.apFeatures(:,[1 4]),cellStruct.apFeatures(:,[1 8]));

		cellStruct.apFeatures = [ cellStruct.apFeatures cellStruct.ahp cellStruct.adp  ];
        
		[ cellStruct.apFeatures cellStruct.meanISI ] = getInterSpike(x,cellStruct.apFeatures);
		
		plotActive=0;
		if plotActive==1
			for i=1:size(cellStruct.apFeatures,1)
				apv = cellStruct.apFeatures(i,:);
				endPos = apv(featS.ahpPos)+100;
				figure(i);
				clf;
				hold on;
				plot(x,Y(apv(featS.sweepNum),:),'b-');
				plot(x(apv(featS.thresholdPos)),apv(featS.thresholdV),'go');
				plot(x(apv(featS.apMaxPos)),apv(featS.apMax),'bo');
				plot(x(apv(featS.apEndPos)),apv(featS.apEndV),'ro');
				plot(apv(featS.halfWidthStart),apv(featS.halfWidthV),'go');
				plot(apv(featS.halfWidthEnd),apv(featS.halfWidthV),'go');
				plot([apv(featS.halfWidthStart) apv(featS.halfWidthEnd)],[apv(featS.halfWidthV) apv(featS.halfWidthV)],'g-');
				plot(apv(featS.dvMinT),apv(featS.dvMinV),'vk');
				plot(apv(featS.dvMaxT),apv(featS.dvMaxV),'^k');
				plot(apv(featS.ahpT),apv(featS.ahpV),'co');
				if apv(featS.ISI)>0
					plot([x(cellStruct.apFeatures(i-1,featS.apMaxPos)) x(apv(featS.apMaxPos))],[apv(featS.apMax) apv(featS.apMax)],'g-');
				end
				title(['Sweep',num2str(apv(1))]);
				hold off;
			end
        end
	
		firedSweep = unique(cellStruct.apFeatures(:,1));
		for i=1:size(firedSweep,1)
			sweepISI = cellStruct.apFeatures(cellStruct.apFeatures(:,1)==firedSweep(i),featS.ISI);
			if size(sweepISI,1)==1
				continue;
			end
			goodISI = sweepISI(2:end);
			ahp5 = cellStruct.ahp05(cellStruct.ahp05(:,1)==firedSweep(i),2);
			ahp90 = cellStruct.ahp090(cellStruct.ahp090(:,1)==firedSweep(i),2);
            if length(ahp5)==length(goodISI)
                a5gS=ahp5./goodISI;
                a90gS=ahp90./goodISI;
            else
                a5gS=ahp5(1:end-1)./goodISI;
                a90gS=ahp90(1:end-1)./goodISI;
            end
			cellStruct.ahp5PerISI = mean(a5gS(~isnan(a5gS)));
			cellStruct.ahp90PerISI = mean(a90gS(~isnan(a90gS)));	
			cellStruct.ahp5PerISIMin = min(a5gS(~isnan(a5gS)));
			cellStruct.ahp90PerISIMin = min(a90gS(~isnan(a90gS)));	
			cellStruct.ahp5PerISIMax = max(a5gS(~isnan(a5gS)));
			cellStruct.ahp90PerISIMax = max(a90gS(~isnan(a90gS)));							
		end
		
		plotAP=0;
		if plotAP==1
			for i=1:size(firedSweep,1)
				firingSweep = cellStruct.apFeatures(cellStruct.apFeatures(:,1)==firedSweep(i),:);
				ahp5 = cellStruct.ahp05(cellStruct.ahp05(:,1)==firedSweep(i),:);
				ahp90 = cellStruct.ahp090(cellStruct.ahp090(:,1)==firedSweep(i),:);
				for j=1:size(firingSweep,1)-1
					apf = firingSweep(j,:);
					startPos = apf(featS.thresholdPos)-100;
					endPos = firingSweep(j+1,featS.thresholdPos);
					figure(i*j);
					clf;
					hold on;
					plot(x(startPos:endPos),Y(firedSweep(i),startPos:endPos),'b-');
					plot(apf(featS.ahpT),apf(featS.ahpV),'ro');
					plot(x(firingSweep(j+1,featS.thresholdPos)),firingSweep(j+1,featS.thresholdV),'go');
					plot([apf(featS.ahpT) ahp5(j,2)],[apf(featS.ahpV) apf(featS.ahpV)],'r-');
					plot([apf(featS.ahpT) ahp90(j,2)],[apf(featS.ahpV)+.001 apf(featS.ahpV)+.001],'r-');
					hold off;
				end	
			end
		end
	end
	
end
