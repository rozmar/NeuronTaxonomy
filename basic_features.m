function datasum = basic_features(cell,current,time)
    %load the names of the AP features
    [locations]=marcicucca_locations;
	load([locations.taxonomy.fetureextractorlocation,'/apFeatures.mat'],'featS');
    dvrs = cell.dvrs;
    RS=-cell.dvrs./current;
    RS(abs(current)<20)=[];
    if isempty(RS) | isnan(RS)
        pause
    end
    datasum.RS=mean(RS*10^6);
    datasum.si=mode(diff(time));
%     datasum.rsmedian=median(RS*10^6);
    datasum.resting = mean(cell.v0);
    datasum.rheobase = current(cell.rheobase);
    rinall = -cell.dvin ./ current * 1000000;
    datasum.tau0_90risetime = mean(cell.tau0_90risetime);
    
    rsagnum=min([sum(current<0),2]);
    rsagnum=1;
    datasum.sag = cell.rsag(1:rsagnum) ./ rinall(1:rsagnum);
    datasum.sag = nanmean(datasum.sag(1:rsagnum));
    datasum.rin = nanmean(rinall(1:rsagnum));
    datasum.rsag=nanmean(cell.rsag(1:rsagnum));
    datasum.rebound=cell.dvrebound(1:rsagnum)./cell.dvin(1:rsagnum);
    datasum.rebound = nanmean(datasum.rebound(1:rsagnum));
    datasum.rrebound =abs(nanmean(cell.dvrebound(1:rsagnum)./current(1:rsagnum)))* 1000000;
    datasum.reboundsagratio=datasum.rebound/datasum.sag;
    if ~isempty(cell.rhump)
        datasum.rhump=cell.rhump(end);
        datasum.hump=cell.rhump(end)/rinall(length(cell.rhump));
    else
        datasum.rhump=NaN;
        datasum.hump=NaN;
    end
%     datasum.apnumALL=sum(cell.apNums);
    rawdata=struct;
    rawdata.apnum=cell.apNums(cell.apNums>0);
    rawdata.threshold=cell.apFeatures(:,featS.thresholdVReal);
    rawdata.apamplitude=cell.apFeatures(:,featS.apAmplitude);
    rawdata.aprisetime=(cell.apFeatures(:,featS.apMaxPos)-cell.apFeatures(:,featS.thresholdPos))*datasum.si;
    rawdata.aphalfwidth=cell.apFeatures(:,featS.halfWidthLength);
    ahpV=cell.apFeatures(:,featS.ahpV)+dvrs(cell.apFeatures(:,1));
    apEndV=(cell.apFeatures(:,featS.apEndV)+dvrs(cell.apFeatures(:,1)));
    rawdata.ahpAmplitude = abs(ahpV-apEndV);
    rawdata.ahpLength = cell.ahp090(:,2);
    rawdata.dVperdtMaxD=cell.apFeatures(:,featS.dvMaxD);
    rawdata.dVperdtMaxV=cell.apFeatures(:,featS.dvMaxVReal);
    rawdata.dVperdtMinD=cell.apFeatures(:,featS.dvMinD);
    rawdata.dVperdtMinV=cell.apFeatures(:,featS.dvMinVReal);
    rawdata.apMaxV=cell.apFeatures(:,featS.apMaxReal);
    
    
    rawdata.ISI = cell.apFeatures(find(cell.apFeatures(:,featS.ISI)>0),featS.ISI);
    if isempty(rawdata.ISI)
        rawdata.ISI=NaN;
    end
    
    sweeps = find(cell.apNums>2);
    rawdata.accomodation=nan(max(size(sweeps),1));
    rawdata.apaccomodation=nan(max(size(sweeps),1));
    rawdata.hwaccomodation=nan(max(size(sweeps),1));
    rawdata.thresholdaccomodation=nan(max(size(sweeps),1));
    rawdata.sweepISI=nan(max(size(sweeps),1));
    
    for i=1:length(sweeps)
        sweepnum=sweeps(i);
        potidxes=find(cell.apFeatures(:,featS.ISI)>0 & cell.apFeatures(:,1)==sweepnum);
        
        isi1 = cell.apFeatures(potidxes(1),featS.ISI);
        isi2 = cell.apFeatures(potidxes(end),featS.ISI);
        rawdata.accomodation(i)=isi2/isi1;
        
        potidxes=find(cell.apFeatures(:,1)==sweepnum); %cell.apFeatures(:,featS.apMax)>0 & 
         
        apampl1 = cell.apFeatures(potidxes(1),featS.apAmplitude);
        apampl2 = cell.apFeatures(potidxes(end),featS.apAmplitude);
        rawdata.apaccomodation(i)=apampl2/apampl1;
        
        hw1 = cell.apFeatures(potidxes(1),featS.halfWidthLength);
        hw2 = cell.apFeatures(potidxes(end),featS.halfWidthLength);
        rawdata.hwaccomodation(i)=hw2/hw1;
        
        thresh1 = cell.apFeatures(potidxes(1),featS.thresholdV);
        thresh2 = cell.apFeatures(potidxes(end),featS.thresholdV);
        rawdata.thresholdaccomodation(i)=thresh2-thresh1;
        
        rawdata.sweepISI(i)=nanmean(cell.apFeatures(potidxes,featS.ISI)); 
    end
    
    fieldstodo=fieldnames(rawdata);
    for fieldi=1:length(fieldstodo)
        fieldn=fieldstodo{fieldi};
        datasum.([fieldn,'mean']) = nanmean(rawdata.(fieldn));
        datasum.([fieldn,'std']) = nanstd(rawdata.(fieldn));
        datasum.([fieldn,'min']) = nanmin(rawdata.(fieldn));
        datasum.([fieldn,'max']) = nanmax(rawdata.(fieldn));
        datasum.([fieldn,'median']) = nanmedian(rawdata.(fieldn));
        datasum.([fieldn,'1']) = rawdata.(fieldn)(1);
        if length(rawdata.(fieldn))>1
            datasum.([fieldn,'2']) = rawdata.(fieldn)(2);
            if length(rawdata.(fieldn))>2
                datasum.([fieldn,'3']) = rawdata.(fieldn)(3);
            else
                datasum.([fieldn,'3']) = NaN;
            end
        else
            datasum.([fieldn,'2']) = NaN;
            datasum.([fieldn,'3']) = NaN;
        end
    end

    datasum.concavitymean=mean(cell.concavity);
    datasum.concavitymedian=median(cell.concavity);
    datasum.concavitymin=mean(cell.concavitymin);
    datasum.concavitymax=mean(cell.concavitymax);
    
end