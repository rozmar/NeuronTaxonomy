


function datasum = calculateElfiz(cell,current,x)
	
	%load the names of the AP features
	load('/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat','featS');

	datasum = {};

	datasum = aggActiveAPV(cell,current,datasum);
	datasum = aggActiveAPVDiffQuotient(datasum);

	datasum = aggActiveAPTimes(cell,x,datasum);
	datasum = aggActiveAPTimesDiffQuotient(datasum);
	
	datasum = aggPassiveVoltages(cell,current,datasum);
	datasum = aggPassTime(cell,x,datasum);
	datasum = divideStdWithMean(datasum);
	
	%%%%%%%%%%%%%%%%%%%%%%%%
	%%%             Passive features         %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%

	%Rin
	rin = -cell.dvin ./ current * 1000000;

	datasum.rinavg = mean(rin(1:3));
	datasum.rinstd = std(rin(1:3));

	%SAG
	sags = cell.rsag ./ rin(1:length(cell.rsag));

	datasum.sagavg = mean(sags(1:min(length(sags),3)));
	datasum.sagstd = std(sags(1:min(length(sags),3)));
	
	%rebound
	rbd = cell.dvrebound ./ cell.dvin(1:size(cell.dvrebound,1));
	datasum.reboundavg = mean(rbd(1:min(length(rbd),3)));
	datasum.reboundstd = std(rbd(1:min(length(rbd),3)));
	
	%v0
	datasum.v0avg = mean(cell.v0);
	datasum.v0std = std(cell.v0);
	
	%v0 steepness
	diffv0 = cell.v0(2:end)-cell.v0(1:end-1);
	datasum.dv0avg = mean(diffv0);
	datasum.dv0steep = (cell.v0(end)-cell.v0(1))/length(cell.v0);
	
	%taurisetime
	datasum.taurisetimeavg = mean(cell.tau0_90risetime(1:min(length(cell.tau0_90risetime),3)));
	datasum.taurisetimestd = std(cell.tau0_90risetime(1:min(length(cell.tau0_90risetime),3)));
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%             Passive features  end        %%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%             Active features          %%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if size(cell.apFeatures,1)>0

		apFeaturesMean = nanmean(cell.apFeatures(:,2:end));
		apFeaturesStd = nanstd(cell.apFeatures(:,2:end));
		
		apFeatures = cell.apFeatures;
		
		sweeps = unique(apFeatures(:,1));
		dT = [];
		ahp10sI = [];
		ahp90sI = [];
		for i=1:length(sweeps)
			sweepSpikes = apFeatures(find(apFeatures(:,1)==sweeps(i)),:);	%spikes belong to this sweep
			firstAp = sweepSpikes(find(sweepSpikes(:,3)==min(sweepSpikes(:,3))),:);	%first spike in this sweep
			dT = [ dT ;  firstAp(3) ];
			sISI = (sweepSpikes(2:end,featS.thresholdPos) - sweepSpikes(1:end-1,featS.ahpPos))./cell.samplingRate;
      if size(cell.ahp05,2)==0
        ahp10 = NaN;
      else
			  ahp10 = cell.ahp05(cell.ahp05(:,1)==sweeps(i),2);
      end
			if size(cell.ahp090,2)==0  
        ahp90 = NaN;
      else
        ahp90 = cell.ahp090(cell.ahp090(:,1)==sweeps(i),2);
      end
			ahp10sI = [ ahp10sI ; ahp10./sISI ];
			ahp90sI = [ ahp90sI ; ahp90./sISI ];
		end
		
		datasum.firstSpikeFromTaustartavg = nanmean(dT) / cell.samplingRate;
		datasum.firstSpikeFromTaustartavg = nanstd(dT) / cell.samplingRate;
			
		mISI = [];
		for i=1:length(sweeps)
			mISI = apFeatures(find(apFeatures(:,featS.ISI)>0),featS.ISI);
		end
		
		datasum.ISIavg = nanmean(mISI);
		datasum.ISIstd = nanstd(mISI);
		datasum.ISImin = min(mISI);
		datasum.ISImax = max(mISI);
		
		datasum.ahp10PerISI = nanmean(ahp10sI);
		datasum.ahp90PerISI = nanmean(ahp90sI);
		datasum.ahp10PerISIMin = min(ahp10sI);
		datasum.ahp90PerISIMin = min(ahp90sI);
		datasum.ahp10PerISIMax = max(ahp10sI);
		datasum.ahp90PerISIMax = max(ahp90sI);		
		
	else
		datasum.firstSpikeFromTaustartavg = 0;
		datasum.firstSpikeFromTaustartavg = 0;
		datasum.ISIavg = 0;
		datasum.ISIstd = 0;
		datasum.ISImin = 0;
		datasum.ISImax  = 0;
	end
				
	%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%        Active features end      %%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%datasum.ramp = mean(cell.ramp);
    if size(cell.ramp(current>0,:),1)>1
        datasum.ramp = mean(cell.ramp(current>0,:));
    else
        datasum.ramp = cell.ramp;
    end
    
	
	datasum.rheobaseToSweep = cell.rheobase / size(current,1);
	datasum.steadyToSweep = cell.steady / size(current,1);
	
	datasum.rheobaseToSteady = datasum.steadyToSweep - datasum.rheobaseToSweep;
	
	datasum.concavity=mean(cell.concavity);
	datasum.concavityMin = min(cell.concavitymin);
	datasum.concavityMax = max(cell.concavitymax);
	datasum.concavityStd = mean(cell.concavitystd);
end
