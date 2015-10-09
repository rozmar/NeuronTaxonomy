%
%
%
function [ AHP ADP concavitymin concavitymax concavity concavitystd ahp05 ahp090 ] = findAhpAdp(x,Y,taustart,pulseend,apNums,current,sampleInterval,threshold,apend)

	AHP = [];
	ADP = [];
	ahp05 = [];
	ahp090 = [];
	concavitymin = [];
	concavitymax = [];
	concavity = [];
	concavitystd = [];
	searchslowevents=0;
		
	x = x(taustart:pulseend);
	firedY = Y(find(apNums>0),taustart:pulseend);
	firedApNum = apNums(apNums>0);
	sweeps=unique(threshold(:,1));
    
	for i=1:size(sweeps,1)
		y = firedY(i,:);
		h = fspecial('average', [1 round(.001/sampleInterval)]);
		yahp= imfilter(y,h);
		
		h = fspecial('average', [1 round(.005/sampleInterval)]);
		yahpslow= imfilter(y,h);
		%stepSize = round(0.002 / sampleInterval);
        stepSize = 1;
				
		sweepAPThreshold = threshold(find(threshold(:,1)==sweeps(i)),2);			
		sweepAPApend = apend(find(apend(:,1)==sweeps(i)),2);    
            
		for j=1:firedApNum(i)
			if j==firedApNum(i)
				endPos = length(y)-(stepSize*2);
            else
				endPos = sweepAPThreshold(j+1)-taustart-(2*stepSize);
				while endPos<5
					endPos=endPos+stepSize;
				end
			end
			stepSize = 1;			
			ahpStart = sweepAPApend(j)-taustart;
			             
			if ahpStart>endPos
				ahpStart=endPos;
            end
			
			ahp = ahpStart;
            
%             figure; clf;
%             hold on;
%             plot(x,yahp,'b-');
%             while ahp<endPos && (ahp+stepSize)<endPos && yahp(ahp+stepSize)<yahp(ahp)
%                 plot(x(ahp),yahp(ahp),'go','linewidth',1,'markerfacecolor','g');
%                 ahp=ahp+stepSize;
%             end
%             
%             ahp=ahp+stepSize;
%             plot(x(ahp),yahp(ahp),'go','linewidth',1,'markerfacecolor','g');      
      
			%ahp = ahpStart + find(y(ahpStart:ahp)==min(y(ahpStart:ahp)),1,'first');
			
            %plot(x(ahp),yahp(ahp),'ro','linewidth',1,'markerfacecolor','r');
                  
            ahp = find(y(ahpStart:endPos)==min(y(ahpStart:endPos)),1,'first');
            
            ahp = ahp + ahpStart;
            
            
			adp = ahp + 1;
            
			%stepSize = round(0.002/sampleInterval);
            
            %nextStep = (adp<endPos-stepSize) && (yahp(adp+stepSize)>yahp(adp));
			%secStep = (adp<endPos-stepSize) && (adp<endPos-2*stepSize) && (yahp(adp+2*stepSize)>yahp(adp));
			%thirdStep = (adp<endPos-stepSize) && (adp<endPos-3*stepSize) && (yahp(adp+3*stepSize)>yahp(adp));
			
            
            if (adp<endPos-stepSize)
                nextStep = (yahp(adp+stepSize)>yahp(adp));
                secStep = (adp<endPos-2*stepSize) && (yahp(adp+2*stepSize)>yahp(adp));
                thirdStep = (adp<endPos-3*stepSize) && (yahp(adp+3*stepSize)>yahp(adp));
                while (adp<endPos-stepSize) & (nextStep || secStep || thirdStep)
                    adp=adp+stepSize;
                    nextStep = (yahp(adp+stepSize)>yahp(adp));
                    secStep = (adp<endPos-2*stepSize) && (yahp(adp+2*stepSize)>yahp(adp));
                    thirdStep = (adp<endPos-3*stepSize) && (yahp(adp+3*stepSize)>yahp(adp));
                end
            end
				
			%adp=adp+stepSize;
			adp=ahp + find(y(ahp:adp)==max(y(ahp:adp)) ,1,'first')-1;
				
			if adp<endPos && searchslowevents==1 %searching for slow events
				[lol,ahpslow]=min(yahp(adp:endPos));	%search minimal event after adp
				clear lol;
				ahpslow=ahpslow+adp;			%this will be the slow ahp position
				
				if not(i==apnum)	%if it's not the last ap, refine the adp
					[lol,adp]=max(y(ahp:ahpslow));
					clear lol;
					adp=ahp+adp;
				end
				
				%go forward from ahpslow by 5 stepSize to the maximal value
				adpslow=ahpslow+2;
				while adpslow+stepSize*10<endPos && yahpslow(adpslow+stepSize*5)>yahpslow(adpslow)
					adpslow=adpslow+stepSize*5;
				end
				
				adpslow=ahpslow + find(y(ahpslow:adpslow)==max(y(ahpslow:adpslow)) ,1,'first');	%maximal value will be the adpslow
				
				ahp = min([ahp,endPos]);
				adp = min([adp,endPos]);
				
				ahpslow=min([ahpslow,endPos]);
				adpslow=min([adpslow,endPos]);
			end
			AHP = [ AHP ; ahp y(ahp) x(ahp) ];
			ADP = [ ADP ; adp y(adp) x(adp) ];
								
			%examine all ap except the last - this step was discarded with
			%a '='
			if j<=firedApNum(i)

				dv = y(endPos)-y(ahp);		%difference in voltage between ahp and next threshold
				                
				dv090 = 0.9*dv;		%use only the 90% of the difference
				dv05 = 0.1*dv;		%use only the 90% of the difference
				                
				if 0
                    figure;
                    clf;
                    hold on;
                    %plot(x(sweepAPThreshold(j)-taustart:sweepAPThreshold(j+1)-taustart),y(sweepAPThreshold(j)-taustart:sweepAPThreshold(j+1)-taustart),'b-');
                    plot(x,y,'b-');
                    %plot(x(sweepAPApend(j)-taustart),y(sweepAPApend(j)-taustart),'ko','markersize',10);
                    plot(x(ahp),y(ahp),'ro','markersize',10);
                    plot(x(endPos),y(endPos),'go','markersize',10);
                    %plot(x(sweepAPThreshold(j+1)-taustart),y(sweepAPThreshold(j+1)-taustart),'ko','markersize',10);
                    hold off;				
				end

				pos90 = find(y(ahp:endPos)>=y(ahp)+dv090,1,'first');	%find that position
				pos5 = find(y(ahp:endPos)>=y(ahp)+dv05,1,'first');	%find that position
				                
				if size(pos90,2)==0
					pos90=NaN;
				end
				if size(pos5,2)==0
					pos5=NaN;
				end
						
				if isnan(pos5)		
					ahp05= [ ahp05 ; sweeps(i) NaN ];
				else 
					ahp05= [ ahp05 ; sweeps(i) x(ahp+pos5)-x(ahp) ];
				end
				
				if isnan(pos90)
					concavitymin = [ concavitymin ; NaN ];
					concavitymax = [ concavitymax ; NaN ];
					concavity = [ concavity ; NaN ];
					concavitystd = [ concavitystd ; NaN ];
					
					ahp090 = [ ahp090 ; sweeps(i) NaN ];
				else
					ahp090= [ ahp090 ; sweeps(i) x(ahp+pos90)-x(ahp) ];

					dv090 = yahp(ahp+pos90)-yahp(ahp);	%the real 90% value
				
					dt = pos90;		%difference in time
					line = [ yahp(ahp):(dv090/dt):yahp(ahp+pos90)  ];	%line between the two point
							
					differ = yahp(ahp:ahp+pos90)-line;	%calculate the difference between the line and the iv
						
					concavitymin = [ concavitymin ; min(differ) ];
					concavitymax = [ concavitymax ; max(differ) ];
					concavity = [ concavity ; mean(differ) ];
					concavitystd = [ concavitystd ; std(differ) ];
				end
			end
			
		end
		
		

	end
	AHP(:,1)=AHP(:,1)+taustart;
	ADP(:,1)=ADP(:,1)+taustart;
end

