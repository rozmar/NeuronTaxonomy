function [datasum] = calculateelfiz(iv,data)
neededsteadyapnum=8;
RS=0;
RScount=0;
datasum.burstspikes=zeros(1,iv.sweepnum);
for i=1:iv.sweepnum
    if -40< iv.current(i) && iv.current(i)<40 %RS ki�tlagol�sa
    else
        RS=RS+data.pass.rs(i);
        RScount=RScount+1;
    end
    if  data.HH.apnum(i)>1 && isfield(data.HH.(['sweep',num2str(i)]),'interspike') && data.HH.(['sweep',num2str(i)]).interspike~=0 && data.HH.(['sweep',num2str(i)]).apmaxtime(1)<.15
        if data.HH.(['sweep',num2str(i)]).interspike(2)<70
            datasum.burstspikes(i)=2;
            while datasum.burstspikes(i)+1<=data.HH.apnum(i) && or(data.HH.(['sweep',num2str(i)]).interspike(datasum.burstspikes(i)+1)<data.HH.(['sweep',num2str(i)]).interspike(datasum.burstspikes(i))*2, data.HH.(['sweep',num2str(i)]).interspike(datasum.burstspikes(i)+1)<20)
                datasum.burstspikes(i)=datasum.burstspikes(i)+1;
            end
            restisimin=100;
            if data.HH.apnum(i)>datasum.burstspikes(i)+1
                restisimin=min(data.HH.(['sweep',num2str(i)]).interspike(datasum.burstspikes(i)+2:end));
            end
            if datasum.burstspikes(i)>8 || data.HH.(['sweep',num2str(i)]).apmaxtime(datasum.burstspikes(i))-data.HH.(['sweep',num2str(i)]).apmaxtime(1)>.08 || restisimin<max(data.HH.(['sweep',num2str(i)]).interspike(2:datasum.burstspikes(i)));
                datasum.burstspikes(i)=0;
            end
        end
    end
    
end
datasum.noiselevel=data.pass.noiselevel;
datasum.filterednoiselevel=data.pass.filterednoiselevel;
datasum.sampleinterval=1/data.pass.samplingrate*1000000;
datasum.RS=RS/RScount;
datasum.sags=data.pass.rsag./data.pass.rin(1:length(data.pass.rsag));
datasum.SAG=mean(datasum.sags(1:1));
for i=2:4
    if length(datasum.sags)>=i && std(datasum.sags(1:i))<.1
        datasum.SAG=mean(datasum.sags(1:i));
    end
end
datasum.rebounds=data.pass.dvrebound./data.pass.dvin(1:size(data.pass.dvrebound,2));
datasum.rebound=datasum.rebounds(1);
if isfield(data.HH,'rhump') %%mert ilyen is el�fordul, ha nincs pozit�v �raml�pcs�, �s r�gt�n t�zel
    datasum.humps=data.HH.rhump./data.pass.rin(1:length(data.HH.rhump));
    datasum.HUMP=(datasum.humps(end));
else
    datasum.humps=0;
    datasum.HUMP=0;
end
datasum.Rins=data.pass.rin(1:5);
datasum.Rin=mean(datasum.Rins(1:3));
datasum.Rinstd=std(datasum.Rins(1:3));
if datasum.Rinstd>datasum.Rin/10 %%%%%%%%%%%%%%%%%%ha nagyon sz�rnak a bemen�k, akkor csak az els�t sz�molom..
    datasum.Rin=mean(datasum.Rins(1:1));
    datasum.Rinstd=0;
end
datasum.vresting=data.pass.v0*1000;
datasum.v0=mean(data.pass.v0s);
datasum.v0std=std(data.pass.v0s);
datasum.apnum=data.HH.apnum;
datasum.maxapnum=max(datasum.apnum);
datasum.reobasesweep=data.HH.reobasesweep;
if datasum.reobasesweep>0
    datasum.reobase=iv.realcurrent(datasum.reobasesweep);%datasum.reobasesweep*20-120;
else
    datasum.reobase=NaN;
end
% datasum.maxcurrentfromreobase=length(datasum.apnum)*20-120-datasum.reobase;
%datasum.taus=data.pass.tau(1:5);
% datasum.tau1=data.pass.tau(1);
% datasum.tau2=data.pass.tau(2);
% datasum.tau3=data.pass.tau(3);
% datasum.tau4=data.pass.tau(4);
% datasum.tau5=data.pass.tau(5);
% datasum.taubest=data.pass.tau(find(data.pass.taufail(1:5)==min(data.pass.taufail(1:5)),1,'first'));
% datasum.taubestcurr=iv.current(find(data.pass.taufail(1:5)==min(data.pass.taufail(1:5)),1,'first'));
% datasum.taulongest=data.pass.tau(find(data.pass.tauend(1:5)==max(data.pass.tauend(1:5)),1,'first'));
% datasum.taulongestcurr=iv.current(find(data.pass.tauend(1:5)==max(data.pass.tauend(1:5)),1,'first'));
%datasum.taumin=min(datasum.taus);
% datasum.taumincurr=iv.current(find(datasum.taus==min(datasum.taus),1,'first'));

if length(data.pass.taunew)>=5
datasum.taunews=data.pass.taunew(1:5);
else
    datasum.taunews=data.pass.taunew;
end
datasum.taunew1=data.pass.taunew(1);
datasum.taunewfail1=data.pass.taunewfail(1);
% datasum.taunewbest=data.pass.taunew(find(data.pass.taunewfail==min(data.pass.taunewfail),1,'first'));


if data.HH.apnum(end)>0
    
    datasum.apnumfromreobase=datasum.apnum(datasum.reobasesweep:end);
    datasum.steadysweep=data.HH.steadysweep;
    datasum.steadyAPnum=datasum.apnum(datasum.steadysweep);
    datasum.goodsteadyAPnum=datasum.steadyAPnum-datasum.burstspikes(datasum.steadysweep)-1;
    
    
    %%%%%%%%%%%%%%%%%%AP UT�NI ESEM�NYEK!!!!!!!!!!!!!!
    %%%%%%%%%%%%%%%%%%AP UT�NI ESEM�NYEK!!!!!!!!!!!!!!
    mindiff=0.0005; %ami alatt nem vesz�nk m�r k�l�nbs�get az AP ut�ni esem�nyekre
    minVdiff=.2/1000; %amilyen fesz�lts�gk�l�nbs�g alatt m�r nem vesz�nk k�l�nbs�get..
    if ~isempty(datasum.reobasesweep)
        datasum.treshold=data.HH.(['sweep',num2str(datasum.reobasesweep)]).tresh_corrected(1)*1000;
        datasum.apampl=data.HH.(['sweep',num2str(datasum.reobasesweep)]).apamplitude(1);
        datasum.aprisetime=data.HH.(['sweep',num2str(datasum.reobasesweep)]).apmaxtime(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).treshtime(1);
        datasum.aphw=data.HH.(['sweep',num2str(datasum.reobasesweep)]).halfwidth(1);
        
        datasum.apwidth=(data.HH.(['sweep',num2str(datasum.reobasesweep)]).apendtime(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).treshtime(1))*1000;
        datasum.apstartenddiff=(data.HH.(['sweep',num2str(datasum.reobasesweep)]).tresh(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).apend(1))*1000;
        datasum.dvmax=data.HH.(['sweep',num2str(datasum.reobasesweep)]).dvmax(1);
        datasum.dvmaxv=data.HH.(['sweep',num2str(datasum.reobasesweep)]).dvmaxv_corrected(1)*1000;
        datasum.dvmin=data.HH.(['sweep',num2str(datasum.reobasesweep)]).dvmin(1);
        datasum.dvminv=data.HH.(['sweep',num2str(datasum.reobasesweep)]).dvminv_corrected(1)*1000;
        
        if (data.HH.(['sweep',num2str(datasum.reobasesweep)]).maxtime(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahptime(1))>mindiff %% Csak akkor foglalkozunk AHP-ADP-vel, ha nem �rte el a k�vetkez� tresholdot
            datasum.ahpampl=(data.HH.(['sweep',num2str(datasum.reobasesweep)]).apend(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahpv(1))*1000;
            datasum.ahpwidth=(data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahptime(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).apendtime(1))*1000;
            if (data.HH.(['sweep',num2str(datasum.reobasesweep)]).maxtime(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).adptime(1))>mindiff
                datasum.adpampl=(data.HH.(['sweep',num2str(datasum.reobasesweep)]).adpv(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahpv(1))*1000;
                datasum.adpwidth=(data.HH.(['sweep',num2str(datasum.reobasesweep)]).adptime(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahptime(1))*1000;
                if (data.HH.(['sweep',num2str(datasum.reobasesweep)]).maxtime(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahptimeslow(1))>mindiff
                    datasum.ahpslowampl=(data.HH.(['sweep',num2str(datasum.reobasesweep)]).adpv(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahpvslow(1))*1000;
                    datasum.ahpslowwidth=(data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahptimeslow(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).adptime(1))*1000;
                else
                    datasum.ahpslowampl=0;
                    datasum.ahpslowwidth=0;
                end
            else
                datasum.adpampl=0;
                datasum.adpwidth=0;
                datasum.ahpslowampl=0;
                datasum.ahpslowwidth=0;
            end
        else
            datasum.ahpampl=0;
            datasum.ahpwidth=0;
            datasum.adpampl=0;
            datasum.adpwidth=0;
            datasum.ahpslowampl=0;
            datasum.ahpslowwidth=0;
        end
        if (data.HH.(['sweep',num2str(datasum.reobasesweep)]).adptime(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahptime(1))<mindiff
            datasum.adpampl=0;
            datasum.adpwidth=0;
        end
        if (data.HH.(['sweep',num2str(datasum.reobasesweep)]).ahptimeslow(1)-data.HH.(['sweep',num2str(datasum.reobasesweep)]).adptime(1))<mindiff
            datasum.ahpslowampl=0;
            datasum.ahpslowwidth=0;
        end
        if datasum.adpwidth>20 %%%%%%%%%% az irre�lisan t�voli ADP eset�n kinull�zok mindent ut�na
            datasum.adpampl=0;
            datasum.adpwidth=0;
            datasum.ahpslowampl=0;
            datasum.ahpslowwidth=0;
        end
        datasum.firstapmaxtime=data.HH.(['sweep',num2str(datasum.reobasesweep)]).apmaxtime(1)*1000-iv.segment(1);
        datasum.burstinterval=-100;
        if datasum.burstspikes(datasum.steadysweep)>0
            datasum.burstinterval=mean(data.HH.(['sweep',num2str(datasum.steadysweep)]).interspike(2:datasum.burstspikes(datasum.steadysweep)));
        end
        datasum.steadyinterval=100;
        if datasum.apnum(datasum.steadysweep)>datasum.burstspikes(datasum.steadysweep)+1
            datasum.steadyinterval=mean(data.HH.(['sweep',num2str(datasum.steadysweep)]).interspike(datasum.burstspikes(datasum.steadysweep)+2:end));
        end
        datasum.compfail=mean(data.HH.(['sweep',num2str(datasum.steadysweep)]).compfail);
        if datasum.compfail>0
            datasum.compfail=1;
        end
    end
    
    
    
    
    if ~isempty(datasum.steadysweep) %%%%%%%%%%%%%%%%%%%%%%steady state AP-k
        for i=1:datasum.steadyAPnum
            
            datasum.steadyaphws(i)=data.HH.(['sweep',num2str(datasum.steadysweep)]).halfwidth(i);
            datasum.steadyapampls(i)=data.HH.(['sweep',num2str(datasum.steadysweep)]).apamplitude(i);
            datasum.steadytresholds(i)=data.HH.(['sweep',num2str(datasum.steadysweep)]).tresh_corrected(i)*1000;
            datasum.steadyapwidths(i)=(data.HH.(['sweep',num2str(datasum.steadysweep)]).apendtime(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).treshtime(i))*1000;
            datasum.steadyapstartenddiffs(i)=(data.HH.(['sweep',num2str(datasum.steadysweep)]).tresh(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).apend(i))*1000;
            
            if (data.HH.(['sweep',num2str(datasum.steadysweep)]).maxtime(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).ahptime(i))>mindiff %% Csak akkor foglalkozunk AHP-ADP-vel, ha nem �rte el a k�vetkez� tresholdot
                datasum.steadyahpampls(i)=(data.HH.(['sweep',num2str(datasum.steadysweep)]).apend(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).ahpv(i))*1000;
                datasum.steadyahpwidths(i)=(data.HH.(['sweep',num2str(datasum.steadysweep)]).ahptime(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).apendtime(i))*1000;
                if (data.HH.(['sweep',num2str(datasum.steadysweep)]).maxtime(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).adptime(i))>mindiff
                    datasum.steadyadpampls(i)=(data.HH.(['sweep',num2str(datasum.steadysweep)]).adpv(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).ahpv(i))*1000;
                    datasum.steadyadpwidths(i)=(data.HH.(['sweep',num2str(datasum.steadysweep)]).adptime(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).ahptime(i))*1000;
                    if (data.HH.(['sweep',num2str(datasum.steadysweep)]).maxtime(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).ahptimeslow(i))>mindiff
                        datasum.steadyahpslowampls(i)=(data.HH.(['sweep',num2str(datasum.steadysweep)]).adpv(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).ahpvslow(i))*1000;
                        datasum.steadyahpslowwidths(i)=(data.HH.(['sweep',num2str(datasum.steadysweep)]).ahptimeslow(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).adptime(i))*1000;
                    else
                        datasum.steadyahpslowampls(i)=0;
                        datasum.steadyahpslowwidths(i)=0;
                    end
                else
                    datasum.steadyadpampls(i)=0;
                    datasum.steadyadpwidths(i)=0;
                    datasum.steadyahpslowampls(i)=0;
                    datasum.steadyahpslowwidths(i)=0;
                end
            else
                datasum.steadyahpampls(i)=0;
                datasum.steadyahpwidths(i)=0;
                datasum.steadyadpampls(i)=0;
                datasum.steadyadpwidths(i)=0;
                datasum.steadyahpslowampls(i)=0;
                datasum.steadyahpslowwidths(i)=0;
            end
            
            if abs(data.HH.(['sweep',num2str(datasum.steadysweep)]).adptime(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).ahptime(i))<mindiff
                datasum.steadyadpampls(i)=0;
                datasum.steadyadpwidths(i)=0;
            end
            if abs(data.HH.(['sweep',num2str(datasum.steadysweep)]).ahptimeslow(i)-data.HH.(['sweep',num2str(datasum.steadysweep)]).adptime(i))<mindiff
                datasum.steadyahpslowampls(i)=0;
                datasum.steadyahpslowwidths(i)=0;
            end
            if datasum.steadyadpwidths(i)>20 %%%%%%%%%% az irre�lisan t�voli ADP eset�n kinull�zok mindent ut�na
                datasum.steadyadpampls(i)=0;
                datasum.steadyadpwidths(i)=0;
                datasum.steadyahpslowampls(i)=0;
                datasum.steadyahpslowwidths(i)=0;
            end
        end
        
        if datasum.burstspikes(datasum.steadysweep)+2<datasum.apnum(datasum.steadysweep)
            datasum.steadyaphw = mean(deleteoutliers(datasum.steadyaphws(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadyapampl = mean(deleteoutliers(datasum.steadyapampls(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadytreshold = mean(deleteoutliers(datasum.steadytresholds(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadytresholddiff = mean(deleteoutliers(datasum.steadytresholds(datasum.burstspikes(datasum.steadysweep)+1:end-1)-data.pass.v0s(datasum.steadysweep)*1000));
            datasum.steadyapwidth = mean(deleteoutliers(datasum.steadyapwidths(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadyapstartenddiff = mean(deleteoutliers(datasum.steadyapstartenddiffs(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadyahpampl = mean(deleteoutliers(datasum.steadyahpampls(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadyahpwidth = mean(deleteoutliers(datasum.steadyahpwidths(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadyadpampl = mean(deleteoutliers(datasum.steadyadpampls(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadyadpwidth = mean(deleteoutliers(datasum.steadyadpwidths(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadyahpslowampl = mean(deleteoutliers(datasum.steadyahpslowampls(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
            datasum.steadyahpslowwidth = mean(deleteoutliers(datasum.steadyahpslowwidths(datasum.burstspikes(datasum.steadysweep)+1:end-1)));
        elseif datasum.burstspikes(datasum.steadysweep)==datasum.apnum(datasum.steadysweep)
            datasum.steadyaphw = datasum.steadyaphws(end);
            datasum.steadyapampl = datasum.steadyapampls(end);
            datasum.steadytreshold = datasum.steadytresholds(end);
            datasum.steadytresholddiff = datasum.steadytresholds(end)-data.pass.v0s(datasum.steadysweep)*1000;
            datasum.steadyapwidth = datasum.steadyapwidths(end);
            datasum.steadyapstartenddiff = datasum.steadyapstartenddiffs(end);
            datasum.steadyahpampl = datasum.steadyahpampls(end);
            datasum.steadyahpwidth = datasum.steadyahpwidths(end);
            datasum.steadyadpampl = datasum.steadyadpampls(end);
            datasum.steadyadpwidth = datasum.steadyadpwidths(end);
            datasum.steadyahpslowampl = datasum.steadyahpslowampls(end);
            datasum.steadyahpslowwidth = datasum.steadyahpslowwidths(end);
        else
            datasum.steadyaphw = datasum.steadyaphws(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadyapampl = datasum.steadyapampls(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadytreshold = datasum.steadytresholds(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadytresholddiff= datasum.steadytresholds(datasum.burstspikes(datasum.steadysweep)+1)-data.pass.v0s(datasum.steadysweep)*1000;
            datasum.steadyapwidth = datasum.steadyapwidths(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadyapstartenddiff = datasum.steadyapstartenddiffs(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadyahpampl = datasum.steadyahpampls(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadyahpwidth = datasum.steadyahpwidths(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadyadpampl = datasum.steadyadpampls(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadyadpwidth = datasum.steadyadpwidths(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadyahpslowampl = datasum.steadyahpslowampls(datasum.burstspikes(datasum.steadysweep)+1);
            datasum.steadyahpslowwidth = datasum.steadyahpslowwidths(datasum.burstspikes(datasum.steadysweep)+1);
        end
        datasum.ahpwidthnew=datasum.apwidth+datasum.ahpwidth;
        datasum.ahpamplnew=datasum.apstartenddiff+datasum.ahpampl;
        %%%%%%%%%%%%%%%%%%%%%%%FIRING PATTERN!!!!!!!!!!!!!
        interspike=data.HH.(['sweep',num2str(datasum.steadysweep)]).interspike;
        datasum.accomodation=0;
        datasum.ISIchange=0;
        datasum.ISIchangevsapnum=0;
        %     datasum.ISIchangeerror=0;
        if datasum.apnum(datasum.steadysweep)-datasum.burstspikes(datasum.steadysweep)>3
            datasum.accomodation=interspike(end)/interspike(datasum.burstspikes(datasum.steadysweep)+2); % az els� nem burst spike ut�ni ISI �s az ut�ls� ISI ar�nya
            [p] = polyfit(data.HH.(['sweep',num2str(datasum.steadysweep)]).apmaxtime(datasum.burstspikes(datasum.steadysweep)+2:end),data.HH.(['sweep',num2str(datasum.steadysweep)]).interspike(datasum.burstspikes(datasum.steadysweep)+2:end),1);
            %         datasum.ISIchangeerror=mean(abs(data.HH.(['sweep',num2str(datasum.steadysweep)]).apmaxtime(2:end).*p(1)+p(2)-data.HH.(['sweep',num2str(datasum.steadysweep)]).interspike(2:end)));
            datasum.ISIchange=p(1);
            [p] = polyfit(1:length(data.HH.(['sweep',num2str(datasum.steadysweep)]).interspike(datasum.burstspikes(datasum.steadysweep)+2:end)),data.HH.(['sweep',num2str(datasum.steadysweep)]).interspike(datasum.burstspikes(datasum.steadysweep)+2:end),1);
            datasum.ISIchangevsapnum=p(1);
            %         figure
            %         plot(data.HH.(['sweep',num2str(datasum.steadysweep)]).apmaxtime(datasum.burstspikes(datasum.steadysweep)+2:end), data.HH.(['sweep',num2str(datasum.steadysweep)]).interspike(datasum.burstspikes(datasum.steadysweep)+2:end),'.')
            %         hold on
            %         plot(data.HH.(['sweep',num2str(datasum.steadysweep)]).apmaxtime(datasum.burstspikes(datasum.steadysweep)+2:end), data.HH.(['sweep',num2str(datasum.steadysweep)]).apmaxtime(datasum.burstspikes(datasum.steadysweep)+2:end).*p(1)+p(2));
            %         plot(data.HH.(['sweep',num2str(datasum.steadysweep)]).apmaxtime(datasum.burstspikes(datasum.steadysweep)+2:end),datasum.perror,'ro');
            %         pause(2)
            %         close all
        end
        if datasum.burstspikes(datasum.steadysweep)>0
            datasum.bursting=datasum.burstspikes(datasum.steadysweep);
        else
            datasum.bursting=0;
        end
        datasum.aphwchange=0;
        datasum.aphwchangevsapnum=0;
        datasum.apamplchange=0;
        datasum.apamplchangevsapnum=0;
        
        if datasum.apnum(datasum.steadysweep)-datasum.burstspikes(datasum.steadysweep)>2
            [p] = polyfit(data.HH.(['sweep',num2str(datasum.steadysweep)]).apmaxtime(datasum.burstspikes(datasum.steadysweep)+1:end),data.HH.(['sweep',num2str(datasum.steadysweep)]).halfwidth(datasum.burstspikes(datasum.steadysweep)+1:end),1);
            datasum.aphwchange=p(1);
            [p] = polyfit(1:length(data.HH.(['sweep',num2str(datasum.steadysweep)]).halfwidth(datasum.burstspikes(datasum.steadysweep)+1:end)),data.HH.(['sweep',num2str(datasum.steadysweep)]).halfwidth(datasum.burstspikes(datasum.steadysweep)+1:end),1);
            datasum.aphwchangevsapnum=p(1);
            [p] = polyfit(data.HH.(['sweep',num2str(datasum.steadysweep)]).apmaxtime(datasum.burstspikes(datasum.steadysweep)+1:end),data.HH.(['sweep',num2str(datasum.steadysweep)]).apamplitude(datasum.burstspikes(datasum.steadysweep)+1:end),1);
            datasum.apamplchange=p(1);
            [p] = polyfit(1:length(data.HH.(['sweep',num2str(datasum.steadysweep)]).apamplitude(datasum.burstspikes(datasum.steadysweep)+1:end)),data.HH.(['sweep',num2str(datasum.steadysweep)]).apamplitude(datasum.burstspikes(datasum.steadysweep)+1:end),1);
            datasum.apamplchangevsapnum=p(1);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%FIRING PATTERN!!!!!!!!!!!!
        %%%%%%%%%%%%%%%%%%%%%%%%Ingerelhet�s�g%%%%%%%%%%%%%
        %     datasum.ingerelhetoseg1=datasum.apnum(datasum.reobasesweep)/20;
        %     datasum.ingerelhetoseg2=0;
        %     datasum.ingerelhetoseg3=0;
        [p] = polyfix([0:20:(datasum.steadysweep-datasum.reobasesweep+1)*20],[0,datasum.apnumfromreobase(1:(datasum.steadysweep-datasum.reobasesweep+1))],0,0,1);
        datasum.ingerelhetoseg=p(1);
        %     if datasum.reobasesweep<length(datasum.apnum)
        %         [p] = polyfit([0:20:40],[0,datasum.apnumfromreobase(1:2)],1);
        %         datasum.ingerelhetoseg2=p(1);
        %         if datasum.reobasesweep+1<length(datasum.apnum)
        %             [p] = polyfit([0:20:60],[0,datasum.apnumfromreobase(1:3)],1);
        %             datasum.ingerelhetoseg3=p(1);
        %         end
        %     end
        
        %%%%%%%%%%%%%%%%%%%%%%%%Ingerelhet�s�g%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%RAMP%%%%%%%%%%%%%%%%%%%%
        datasum.ramp=0;
        datasum.rheobaseramp=0;
        if isfield(data.HH, 'ramp') && size(data.HH.ramp,1)>datasum.reobasesweep-2
            datasum.ramp=data.HH.ramp(datasum.reobasesweep-1,1);
        end
        if isfield(data.HH, 'ramp') && size(data.HH.ramp,1)>datasum.reobasesweep-1 && data.HH.(['sweep',num2str(datasum.reobasesweep)]).apmaxtime(1)>.3
            datasum.rheobaseramp=data.HH.ramp(datasum.reobasesweep,1);
        end
        datasum.rampnew=data.HH.rampnew(datasum.reobasesweep-1,1);
        datasum.rheobaserampnew=data.HH.rampnew(datasum.reobasesweep,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%RAMP%%%%%%%%%%%%%%%%%%%%%
        
        
    end
else
    datasum.aphw=0;
    datasum.apampl=0;
    datasum.treshold=0;
    datasum.apwidth=0;
    datasum.apstartenddiff=0;
    datasum.dvmax=0;
    datasum.dvmaxv=0;
    datasum.dvmin=0;
    datasum.dvminv=0;
    datasum.steadyaphws(i)=0;
    datasum.steadyapampls(i)=0;
    datasum.steadytresholds(i)=0;
    datasum.steadyapwidths(i)=0;
    datasum.steadyapstartenddiffs(i)=0;
    datasum.steadyahpampls(i)=0;
    datasum.steadyahpwidths(i)=0;
    datasum.steadyadpampls(i)=0;
    datasum.steadyadpwidths(i)=0;
    datasum.steadyahpslowampls(i)=0;
    datasum.steadyahpslowwidths(i)=0;
    datasum.aphwchange=0;
    datasum.aphwchangevsapnum=0;
    datasum.apamplchange=0;
    datasum.apamplchangevsapnum=0;
    datasum.ingerelhetoseg=0;
    
    datasum.steadysweep=length(datasum.apnum);
    datasum.reobasesweep=datasum.steadysweep;
    
end
end
