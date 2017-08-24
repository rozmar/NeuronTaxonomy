%
%
%
function [ AHP ADP concavitymin concavitymax concavity concavitystd ahp05 ahp090 ] = findAhpAdp(time,Y,taustart,pulseend,apNums,current,sampleInterval,threshold,apend)

	AHP = [];
	ADP = [];
	ahp05 = [];
	ahp090 = [];
	concavitymin = [];
	concavitymax = [];
	concavity = [];
	concavitystd = [];
	searchslowevents=0;
		
    % Time of stimulation
	time = time(taustart:pulseend);
    % IV during stimulation
	firedY = Y((apNums>0),taustart:pulseend);
    % Number of AP where has been any
	firedApNum = apNums(apNums>0);
    % Sweep number
	sweeps=unique(threshold(:,1));
    
    nFiringSweep = length(sweeps);
    
    % Loop through each sweep
	for i= 1 : nFiringSweep
        
        % current sweep
		y = firedY(i,:);
        
        % Filter signal for AHP search
		h = fspecial('average', [1 round(.002/sampleInterval)]);
		yahp= imfilter(y,h);
        
        if sweeps(i)==20
%           figure;
%           plot(time, [diff(yahp),0]);
          %figure;
          %plot(time, yahp); 
          %plot(yahp); 
        end
		
        % Filter signal for slow AHP search
		h = fspecial('average', [1 round(.005/sampleInterval)]);
		yahpslow= imfilter(y,h);
        
		stepSize = round(0.001 / sampleInterval);
%         stepSize = 1;
				
        % Get current thresholds and AP ends
		sweepAPThreshold = threshold((threshold(:,1)==sweeps(i)),2);			
		sweepAPApend = apend((apend(:,1)==sweeps(i)),2);    
            
        dy = mean([0 diff(yahp); diff(yahp) 0 ], 1);
        
        % Loop through each AP
		for j = 1 : firedApNum(i)
            
            % Start search from AP end
			ahpStart = sweepAPApend(j) - taustart;            
            
            % Search end will be the the next threshold, 
            % or the end of the recording
            if j == firedApNum(i)
				endPos = length(y);
            else
				endPos = sweepAPThreshold(j+1) - taustart;
            end
            endPos = max(endPos -(stepSize*2),5);
                        
% 			stepSize = 1;	
            			             
            if ahpStart>endPos
				ahpStart=endPos;
            end
			
% 			ahp = ahpStart;
            
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
                 
            % AHP will be the first local minimum after the AP end
            %ahp = find(y(ahpStart:endPos)==min(y(ahpStart:endPos)),1,'first') + ahpStart;
            [~, ahp] = min(yahp(ahpStart:endPos));
            ahp = ahpStart + ahp;
            
			adp = ahp + 1;
            
			%stepSize = round(0.002/sampleInterval);
            
            %nextStep = (adp<endPos-stepSize) && (yahp(adp+stepSize)>yahp(adp));
			%secStep = (adp<endPos-stepSize) && (adp<endPos-2*stepSize) && (yahp(adp+2*stepSize)>yahp(adp));
			%thirdStep = (adp<endPos-stepSize) && (adp<endPos-3*stepSize) && (yahp(adp+3*stepSize)>yahp(adp));
			
            % Differential in each point
            
            % Go while the next 3 consecutive point is 
            
%             nextStep = (yahp(adp+stepSize)>yahp(adp)) && (adp < (endPos-stepSize));
%             secStep = (adp<endPos-2*stepSize) && (yahp(adp+2*stepSize)>yahp(adp));
%             thirdStep = (adp<endPos-3*stepSize) && (yahp(adp+3*stepSize)>yahp(adp));
%             while (adp<endPos-stepSize) & (nextStep || secStep || thirdStep)
%                 adp=adp+stepSize;
%                 nextStep = (yahp(adp+stepSize)>yahp(adp));
%                 secStep = (adp<endPos-2*stepSize) && (yahp(adp+2*stepSize)>yahp(adp));
%                 thirdStep = (adp<endPos-3*stepSize) && (yahp(adp+3*stepSize)>yahp(adp));
%             end

           
            
            sectionY = yahp(adp:endPos);
            sectionDy = dy(adp:endPos);
            sind = 1;
            
            upwardMove = sum(sectionDy(sind:min(length(sectionDy),sind+1*stepSize)));
            while (sind<length(sectionDy))
                
                if sweeps(i)==20
                  scatter(sind+ahp+1, sectionY(sind), 'r');
                end
                
                upwardMove = sum(sectionDy(sind:min(length(sectionDy),sind+1*stepSize)));
                sind = sind + stepSize;
                
                if (upwardMove<=0)
                    break;
                end
                
                
            end
            
			adp = sind + ahp + 1;	
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
			AHP = [ AHP ; ahp y(ahp) time(ahp) ];
			ADP = [ ADP ; adp y(adp) time(adp) ];
								
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
				                
				if size(pos90,2)<=1
					pos90=NaN;
				end
				if size(pos5,2)<=1
					pos5=NaN;
				end
						
				if isnan(pos5)		
					ahp05= [ ahp05 ; sweeps(i) NaN ];
				else 
					ahp05= [ ahp05 ; sweeps(i) time(ahp+pos5)-time(ahp) ];
				end
				
				if isnan(pos90)
					concavitymin = [ concavitymin ; NaN ];
					concavitymax = [ concavitymax ; NaN ];
					concavity = [ concavity ; NaN ];
					concavitystd = [ concavitystd ; NaN ];
					
					ahp090 = [ ahp090 ; sweeps(i) NaN ];
				else
					ahp090= [ ahp090 ; sweeps(i) time(ahp+pos90)-time(ahp) ];

					dv090 = yahp(ahp+pos90)-yahp(ahp);	%the real 90% value
				
					dt = pos90;		%difference in time
					line = [ yahp(ahp):(dv090/(dt)):yahp(ahp+pos90)  ];	%line between the two point
					if length(line)<length(yahp(ahp:ahp+pos90)) % kókányolás.. valamiért néha rövidebb a line változó.. bocsi az igénytelenségért
                        line=[line,line(end)];
                    end
                    
					differ = yahp(ahp:ahp+pos90)-line;	%calculate the difference between the line and the iv
						
					concavitymin = [ concavitymin ; min(differ) ];
					concavitymax = [ concavitymax ; max(differ) ];
					concavity = [ concavity ; mean(differ) ];
					concavitystd = [ concavitystd ; std(differ) ];
				end
            end
            
            if sweeps(i)==20
%                 hold on;
%                 
%                 scatter(time(AHP(end,1)), y(AHP(end,1)), 'r');
                scatter((ADP(end,1)), y(ADP(end,1)), 'g');
%                 hold off;
            
            end
			
        end
		
    end
    
	AHP(:,1)=AHP(:,1)+taustart;
	ADP(:,1)=ADP(:,1)+taustart;
    
end

