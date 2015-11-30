% Extract features from IV describes APs
%
% Gets the time, raw IVs, ap masks and the num of APs by sweep.
% Returns the ap features in a matrix, where a row belongs to 
% an AP, the first column the number of sweep, and the following columns are:
%  - number of sweep
%  - maximal voltage in AP
%  - position of the maximal voltage point (time isn't returned, can be derived from x array)

%  - threshold position
%  - Voltage at threshold
%  - threshCorrector corrigating quotient for the threshold values
%  - threshVCorrected  corrigated threshold voltage

%  - position of the end of the AP
%  - Voltage at apEnd
%  - apendCorrector corrigating quotient for the apend values
%  - apendVCorrected  corrigated apend voltage

%  - halfWidth start time
%  - halfWidth Voltage
%  - halfWidth end time
%  - halfWidthLength

%  - apAmplitude amplitude of the AP

%  - dvMaxPos position of maximal differential in the AP
%  - dvMax dvMaxV dvMaxT attributes at the maximal derivative 
%  - dvMinPos 
%  - dvMin dvMinV dvMinT
function [apFeatures apNums] = describeAP(x,Y,apMasks,apNums,taustart,pulseend)
	xold = x;
	sampleInterval = x(2)-x(1);
	apFeatures = [];
	thresholdFeatures5 = [];
	apEndFeatures5 = [];
	x = x(taustart:pulseend)';
	apNums(apNums>800)=0;
	sweepIDs = (1:1:size(Y,1))';
    sweepID = sweepIDs(find(apNums>0));
	hasAPY =  Y(find(apNums>0),taustart:pulseend);
	hasAPMasks = apMasks(find(apNums>0),:);
	hasAPNums = apNums(find(apNums>0));
	for i=1:size(hasAPY,1)
		y = hasAPY(i,:);		%current IV
		diffy = diff(y)./diff(x);		%differentials
        ddiffy = diff(diffy)./diff(x(1:end-1));		%differentials
		%dy = calcDerivativeInPoint(y,(1/((x(2)-x(1)))));	%derivatives in points
		dy = mean([ 0 diffy ; diffy 0 ]);
		yav = mean([y(2:end);y(1:end-1)]);	%average values at differentials
		xav=mean([x(2:end);x(1:end-1)]);	%average values at differentials
        apstodel=zeros(hasAPNums(i),1);
		for j=1:hasAPNums(i)		
			ap = y(hasAPMasks(i,:)==j);
			apx = x(hasAPMasks(i,:)==j);
			apMax = max(ap);
			apRow = [];
			currentAPmaskMaxPos = find(((y==apMax).*hasAPMasks(i,:)==j),1,'first');	%find the current examined APs maximal point position
			%currentAPmaskMaxPos--;
										
			%if this position is too late or too early, remove this 
			if currentAPmaskMaxPos>length(x)-50 || (currentAPmaskMaxPos<5 && hasAPNums(i)==1)
                apstodel(j)=1;
% 				hasAPNums(i)=hasAPNums(i)-1;
			elseif currentAPmaskMaxPos>=5
				apRow = [ sweepID(i) apMax currentAPmaskMaxPos ];
					
				thresholdFeatures = findThreshold(currentAPmaskMaxPos,y,dy);	%find the threshold features
				thresholdFeatures5 = [ thresholdFeatures5 ; findThreshold(currentAPmaskMaxPos,y,dy,50) ];	%find the threshold features

				apEndFeatures = findApEnd(currentAPmaskMaxPos,y,dy);
				apEndFeatures5 = [ apEndFeatures5 ; findApEnd(currentAPmaskMaxPos,y,dy,20) ];
				
				halfwidthFeatures = findHalfWidth(x,y,thresholdFeatures(1),currentAPmaskMaxPos,apEndFeatures(1));
																
				apAmplitude = (apMax-thresholdFeatures(2))*1000;
												
				apRow = [ apRow thresholdFeatures apEndFeatures halfwidthFeatures apAmplitude ];
												
				apDiff = diffy(thresholdFeatures(1)-3:apEndFeatures(1)+3);
                apDDiff = ddiffy(thresholdFeatures(1)-3:apEndFeatures(1)+3);
				
				dvMaxLength = find(apDiff==max(apDiff),1,'first');
				dvMinLength = find(apDiff==min(apDiff),1,'first');
																
				dvMaxPos = thresholdFeatures(1)-3+dvMaxLength;
				dvMinPos = thresholdFeatures(1)-3+dvMinLength;
				
				dvMax = diffy(dvMaxPos);
				dvMin = diffy(dvMinPos);
				
				dvMaxV = yav(dvMaxPos);
				dvMinV = yav(dvMinPos);
				
				dvMaxT = xav(dvMaxPos);
				dvMinT = xav(dvMinPos);

				apRow = [ apRow dvMaxPos dvMax dvMaxV dvMaxT dvMinPos dvMin dvMinV dvMinT ];				
     
			end
			apFeatures = [ apFeatures ; apRow ];
        end
        apNums((sweepID(i)))=apNums((sweepID(i)))-sum(apstodel);
	end
	if size(apFeatures,2)==0
	  return;
	end
	apFeatures(:,[3 4 8]) = apFeatures(:,[3 4 8])+taustart-1;
	thresholdFeatures5(:,1) = thresholdFeatures5(:,1)+(taustart-1);
	apEndFeatures5(:,1) = apEndFeatures5(:,1)+(taustart-1);	
	
	apFeatures = [ apFeatures thresholdFeatures5 apEndFeatures5 ];
	
	plotAP=0;
	if plotAP==1
		%Plot AP features by AP
		%for i=1:size(apFeatures,1)
			i=3;
			figure(i);
			clf;
			hold on;
			plot(xold,Y(apFeatures(i,1),:),'b-','linewidth',5);
			plot(xold(apFeatures(i,4)),apFeatures(i,7),'ro','markerfacecolor','r');
			%plot(xold(thresholdFeatures5(i,1)),thresholdFeatures5(i,4),'g@');
			plot(xold(apFeatures(i,3)),apFeatures(i,2),'go','markerfacecolor','g');
			plot(xold(apFeatures(i,8)),apFeatures(i,9),'ko','markerfacecolor','k');
			%plot(xold(apEndFeatures5(i,1)),apEndFeatures5(i,4),'r@');
			%plot(apFeatures(i,12),apFeatures(i,13),'ro');
			%plot(apFeatures(i,14),apFeatures(i,13),'ro');
			plot(apFeatures(i,20),apFeatures(i,19),'k^','markerfacecolor','k');
			plot(apFeatures(i,24),apFeatures(i,23),'kv','markerfacecolor','k');
			xlim([xold(apFeatures(i,4)-5) xold(apFeatures(i,8)+5)]);
			hold off;		
		%end
    end
    
%     apFeatures =[apFeatures thresholdFeatures5 apEndFeatures5];
    
    return
end