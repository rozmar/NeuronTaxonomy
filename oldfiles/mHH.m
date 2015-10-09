function [data] = mHH(iv,dvrs)
showprogress=0;
searchslowevents=0;
movingaverageforsag=.01;
tresholdvalue=10;
x=iv.time;
sampleinterval=x(2)-x(1);
samplingrate=1/(x(2)-x(1)); %sampling rate
xx=abs(x-iv.segment(1)/1000);
taustart=find(xx==min(xx))+1;
xx=abs(x-sum(iv.segment(1:2))/1000);
pulseend=find(xx==min(xx))-1;
x=x(taustart:pulseend);
for sweep=1:iv.sweepnum;
    apmask=zeros(size(x));
    y=iv.(['v',num2str(sweep)]);
    y=y(taustart:pulseend);
    
    apmask=zeros(size(y));
    apmaskfirst=zeros(size(y));
    apmaskfirst=(y+dvrs(sweep)>0);
    [apmask, apnum] = bwlabel(apmaskfirst);
    if apnum>800
        apnum=0;
    elseif apnum>0
        
        dy=diff(y)./diff(x); %deriv�lom
        dy0=dy;%csak a sima deriv�lt
        dy=mean([0,dy';dy',0])'; %�tlagolom
        yav=mean([y(2:end)';y(1:end-1)'])'; %minden deriv�lthoz tartozik egy �tlagos fesz�lts�g�rt�k
        xav=mean([x(2:end)';x(1:end-1)'])'; %minden deriv�lthoz tartozik egy �tlagos id��g�rt�k
        interspike=[0];
        for i=1:apnum
            apmax=max(y(apmask==i));
            apmax=apmax(1);
            if find((y==apmax).*apmask==i,1,'first')>length(x)-50
                apnum=apnum-1;
            elseif find((y==apmax).*apmask==i,1,'first')<5 && apnum==1
                apnum=apnum-1;
            elseif find((y==apmax).*apmask==i,1,'first')<5
                
            else
                apmaxtime=x(find((y==apmax).*apmask==i));
                apmaxtime=apmaxtime(1);
                apmaxhely=find(x==apmaxtime);
                tresh=apmaxhely; %a treshold keres�se az AP cs�cs�n�l kezd?dik
                while y(tresh)>0.02 && tresh>4 %%treshold keresg�l�se - el�sz�r lemegy�nk 20mV-ig
                    tresh=tresh-1;
                end
                [temp,treshpre]=max(dy(tresh-3:apmaxhely-2));
                tresh=treshpre+tresh-3;
                while dy(tresh)>tresholdvalue && tresh>4  %%treshold keresg�l�se
                    tresh=tresh-1;
                end
                tresh=tresh+1;
                tresh;
                treshold=y(tresh);
                treshtime=x(tresh);
                data.(['sweep',num2str(sweep)]).treshcorrect(i)=1-abs((tresholdvalue-dy(tresh-1))/(dy(tresh)-dy(tresh-1)));
                if data.(['sweep',num2str(sweep)]).treshcorrect(i) > 1 || data.(['sweep',num2str(sweep)]).treshcorrect(i)<0
                    data.(['sweep',num2str(sweep)]).treshcorrect(i)=.5;
                end
                data.(['sweep',num2str(sweep)]).tresh(i)=treshold-abs(data.(['sweep',num2str(sweep)]).treshcorrect(i)*(y(tresh)-y(tresh-1)));
                data.(['sweep',num2str(sweep)]).treshtime(i)=treshtime-abs(data.(['sweep',num2str(sweep)]).treshcorrect(i)*(sampleinterval));

                apend=find(x==apmaxtime)+1; %az ap v�g�nek keres�se az ap cs�csn�l kezd�dik
                while y(apend)>0.01 && apend<length(x)-15  %%ap v�g�nek keres�se
                    apend=apend+1;
                end
                while dy(apend)<-tresholdvalue/2 && apend<length(x)-15  %%ap v�g�nek keres�se
                    apend=apend+1;
                end
                apendd=y(apend);
                apendtime=x(apend);
                data.(['sweep',num2str(sweep)]).apendcorrect(i)=abs((dy(apend)+tresholdvalue/2)/(dy(apend)-dy(apend-1)));
                if isinf(data.(['sweep',num2str(sweep)]).apendcorrect(i))
                    data.(['sweep',num2str(sweep)]).apendcorrect(i)=.5;
                end
                data.(['sweep',num2str(sweep)]).apend(i)=apendd+abs(data.(['sweep',num2str(sweep)]).apendcorrect(i)*(y(apend)-y(apend-1)));
                data.(['sweep',num2str(sweep)]).apendtime(i)=apendtime-abs(data.(['sweep',num2str(sweep)]).apendcorrect(i)*(sampleinterval));
                temp=tresh;
                while y(temp)<(apmax-treshold)/2+treshold && temp<length(y)
                    temp=temp+1;
                end
                data.(['sweep',num2str(sweep)]).aphwstart(i)=((apmax-treshold)/2+treshold-y(temp-1))/(y(temp)-y(temp-1))*(x(2)-x(1))+x(temp-1);
                data.(['sweep',num2str(sweep)]).aphwsv(i)=(apmax-treshold)/2+treshold;
                temp=find(x==apmaxtime);
                while y(temp)>(apmax-treshold)/2+treshold && temp<length(y)
                    temp=temp+1;
                end
                data.(['sweep',num2str(sweep)]).aphwstop(i)=((apmax-treshold)/2+treshold-y(temp-1))/(y(temp)-y(temp-1))*(x(2)-x(1))+x(temp-1);
                data.(['sweep',num2str(sweep)]).apmax(i)=apmax;
                data.(['sweep',num2str(sweep)]).apmaxtime(i)=apmaxtime;
                data.(['sweep',num2str(sweep)]).oldtresh(i)=treshold;
                data.(['sweep',num2str(sweep)]).oldtreshtime(i)=treshtime;

                data.(['sweep',num2str(sweep)]).oldapend(i)=apendd;
                data.(['sweep',num2str(sweep)]).oldapendtime(i)=apendtime;
                data.(['sweep',num2str(sweep)]).apamplitude(i)=(apmax-treshold)*1000;
                data.(['sweep',num2str(sweep)]).halfwidth(i)=(data.(['sweep',num2str(sweep)]).aphwstop(i)-data.(['sweep',num2str(sweep)]).aphwstart(i))*1000;
                dvmaxlength=find(dy0(tresh-3:apend+3)==max(dy0(tresh-3:apend+3)),1,'first');
                dvminlength=find(dy0(tresh-3:apend+3)==min(dy0(tresh-3:apend+3)),1,'first');
                data.(['sweep',num2str(sweep)]).dvmax(i)=dy0(tresh+dvmaxlength-4);
                data.(['sweep',num2str(sweep)]).dvmaxv(i)=yav(tresh+dvmaxlength-4);
                data.(['sweep',num2str(sweep)]).dvmaxt(i)=xav(tresh+dvmaxlength-4);
                data.(['sweep',num2str(sweep)]).dvmin(i)=dy0(tresh+dvminlength-4);
                data.(['sweep',num2str(sweep)]).dvminv(i)=yav(tresh+dvminlength-4);
                data.(['sweep',num2str(sweep)]).dvmint(i)=xav(tresh+dvminlength-4);
                data.(['sweep',num2str(sweep)]).compfail(i)=max(dy0((find(x==apmaxtime)+1):apend));

            end
            
        end
    end
    if apnum>0 && ~isfield(data, ['sweep',num2str(sweep)])
        apnum=0;
    end
    if apnum>0
       
        %%%%%%%%%%%%%%%% FOS SPIKEK KISZEDÉSE
        spikestokill=find(data.(['sweep',num2str(sweep)]).halfwidth<.05 | data.(['sweep',num2str(sweep)]).halfwidth>20 | isnan(data.(['sweep',num2str(sweep)]).halfwidth) | data.(['sweep',num2str(sweep)]).apamplitude<10);
        
        
        if length(spikestokill)>100
            spikestokill=1:apnum;
        end
        data.(['sweep',num2str(sweep)]).treshcorrect(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).tresh(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).treshtime(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).apendcorrect(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).apend(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).apendtime(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).aphwstart(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).aphwsv(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).aphwstop(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).apmax(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).apmaxtime(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).oldtresh(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).oldtreshtime(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).oldapend(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).oldapendtime(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).apamplitude(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).halfwidth(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).dvmax(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).dvmaxv(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).dvmaxt(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).dvmin(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).dvminv(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).dvmint(spikestokill)=[];
        data.(['sweep',num2str(sweep)]).compfail(spikestokill)=[];
        apnum=apnum-length(spikestokill);
        if apnum>400
            apnum=0;
            data.(['sweep',num2str(sweep)]).treshcorrect=[];
            data.(['sweep',num2str(sweep)]).tresh=[];
            data.(['sweep',num2str(sweep)]).treshtime=[];
            data.(['sweep',num2str(sweep)]).apendcorrect=[];
            data.(['sweep',num2str(sweep)]).apend=[];
            data.(['sweep',num2str(sweep)]).apendtime=[];
            data.(['sweep',num2str(sweep)]).aphwstart=[];
            data.(['sweep',num2str(sweep)]).aphwsv=[];
            data.(['sweep',num2str(sweep)]).aphwstop=[];
            data.(['sweep',num2str(sweep)]).apmax=[];
            data.(['sweep',num2str(sweep)]).apmaxtime=[];
            data.(['sweep',num2str(sweep)]).oldtresh=[];
            data.(['sweep',num2str(sweep)]).oldtreshtime=[];
            data.(['sweep',num2str(sweep)]).oldapend=[];
            data.(['sweep',num2str(sweep)]).oldapendtime=[];
            data.(['sweep',num2str(sweep)]).apamplitude=[];
            data.(['sweep',num2str(sweep)]).halfwidth=[];
            data.(['sweep',num2str(sweep)]).dvmax=[];
            data.(['sweep',num2str(sweep)]).dvmaxv=[];
            data.(['sweep',num2str(sweep)]).dvmaxt=[];
            data.(['sweep',num2str(sweep)]).dvmin=[];
            data.(['sweep',num2str(sweep)]).dvminv=[];
            data.(['sweep',num2str(sweep)]).dvmint=[];
            data.(['sweep',num2str(sweep)]).compfail=[];
            
        end
        
        if apnum==0
            data=rmfield(data,['sweep',num2str(sweep)]);
        end
        %%%%%%%%%%%%%%%% FOS SPIKEK KISZEDÉSE
        for i=1:apnum
            if i>1
                interspike(i-1)=(data.(['sweep',num2str(sweep)]).apmaxtime(i)-data.(['sweep',num2str(sweep)]).apmaxtime(i-1))*1000;
            end
        end
        
        %         if apnum>0
        if isempty(interspike)==0 %ha van interspike intervallum, akkor azt elmentem, �s �tlagspiket n�zek
            data.(['sweep',num2str(sweep)]).interspike=[mean(interspike),interspike];
        end
        stepsinoneway=round(.005/sampleinterval);%% ITT HAT�ROZOM MEG, HOGY A MEANSPIKE MILYEN ID�INTERVALLUMBAN LEGYEN!!!!!!!!!!!!!!!!
        meanspike.(['sweep',num2str(sweep)]).time=([0:sampleinterval:stepsinoneway*sampleinterval])*1000;
        for i=1:apnum
            meanspike.(['sweep',num2str(sweep)]).(['t',num2str(i)])=([((-round(stepsinoneway/2)+data.(['sweep',num2str(sweep)]).treshcorrect(i))*sampleinterval):sampleinterval:stepsinoneway*sampleinterval+data.(['sweep',num2str(sweep)]).treshcorrect(i)*sampleinterval])*1000;
            if find(x==data.(['sweep',num2str(sweep)]).oldtreshtime(i))+stepsinoneway>length(x)
                meanspike.(['sweep',num2str(sweep)]).(['v',num2str(i)])=iv.(['v',num2str(sweep)])(-round(stepsinoneway/2)+(find(x==data.(['sweep',num2str(sweep)]).oldtreshtime(i))+taustart):pulseend);
            else
                meanspike.(['sweep',num2str(sweep)]).(['v',num2str(i)])=iv.(['v',num2str(sweep)])(-round(stepsinoneway/2)+(find(x==data.(['sweep',num2str(sweep)]).oldtreshtime(i)))+taustart:(find(x==data.(['sweep',num2str(sweep)]).oldtreshtime(i))+stepsinoneway)+taustart);
            end
        end
 
    end		%apnum>0 end
    
    data.apnum(sweep)=apnum;
    if iv.current(sweep)>0 && apnum==0 %hump-et �s ramp-et keres�nk j�l (10ms-os mozg��tlagban)
        if ~exist('sag','var');

            
            fNorm = 500 / (samplingrate/2);               %# normalized cutoff frequency
            [b,a] = butter(6, fNorm, 'low');  %# 10th order filter
            sag(1,:) = filtfilt(b, a, x(1:length(find(x<0.4+iv.segment(1)/1000))));
        end

        
        fNorm = 500 / (samplingrate/2);               %# normalized cutoff frequency
            [b,a] = butter(6, fNorm, 'low');  %# 10th order filter
            sag(2,:) = filtfilt(b, a, y(1:length(find(x<0.4+iv.segment(1)/1000))));
            
        [data.vhump(sweep),temp]=max(sag(2,:));
        data.thump(sweep)=x(temp);
        rampstart=find(x<.1+iv.segment(1)/1000 ,1,'last');
        data.ramp(sweep,1:2) = polyfit(sag(1,rampstart:end),sag(2,rampstart:end),1);

%    elseif  iv.current(sweep)>0 && apnum>0 && sum(sum([data.(['sweep',num2str(sweep)]).apmaxtime<x(taustart)+.1; data.%(['sweep',num2str(sweep)]).apmaxtime>x(taustart)+.2]))==apnum
%        if sum(data.(['sweep',num2str(sweep)]).apmaxtime>.2)>0 && sum(data.(['sweep',num2str(sweep)]).treshtime>.2)>0 && sum((data.%(['sweep',num2str(sweep)]).apmaxtime<.2).*(data.(['sweep',num2str(sweep)]).apmaxtime>.1))==0
%            rampstart=round(.1/sampleinterval);
%            rampend=find(data.(['sweep',num2str(sweep)]).treshtime(find(data.(['sweep',num2str(sweep)]).treshtime>.1,1,'first'))<x,1,'first')-round(.01/sampleinterval);
%        else
%            rampstart=round(.1/sampleinterval);
%            rampend=length(x);
%        end
%        data.ramp(sweep,1:2)=polyfit( x(rampstart:rampend),y(rampstart:rampend),1);
    end	%end ramp & hump if 0 ap
    rampstart=round(.2/sampleinterval)
    data.rampnew(sweep,1:2)=polyfit( x(rampstart:end),y(rampstart:end),1);
    if showprogress==1
        progressbar([],[],[],sweep/iv.sweepnum,[]);
    end
end
if exist('meanspike','var')
    data.meanspike=meanspike;
end

if ~isfield(data, 'ramp')
    data.ramp=[0,0];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%AHP �S ADP KERS�S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%begin, de nem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%mindenhol
if data.apnum(end)>0 && iv.current(end)>=0
    reobasesweep=find(data.apnum==0,1, 'last')+1;
    if isempty(reobasesweep)
        reobasesweep=2;
    end
    steadysweep=find(abs(data.apnum-8)==min(abs(data.apnum-8)),1,'first');
    if data.apnum(reobasesweep)>8
        steadysweep=reobasesweep;
    end
    while data.apnum(steadysweep)<8 && length(data.apnum)>steadysweep %& datasum.apnum(datasum.steadysweep)<16
        steadysweep=steadysweep+1;
    end
else
    reobasesweep=0;
    steadysweep=0;
end
data.reobasesweep=reobasesweep;
data.steadysweep=steadysweep;

for sweep=1:iv.sweepnum;
    if data.apnum(sweep)>0 
        y=iv.(['v',num2str(sweep)]);
        y=y(taustart:pulseend);
        apnum=data.apnum(sweep);
%         yahp=moving(y,round(.001/sampleinterval),'mean');   %majd az AHP keres�shez kell az 1ms mozg��tlag
        h = fspecial('average', [1 round(.001/sampleinterval)]);
        yahp= imfilter(y,h);
        if searchslowevents==1;
%             yahpslow=moving(y,round(.005/sampleinterval),'mean');     %majd az AHP keres�shez kell az x ms mozg��tlag
            h = fspecial('average', [1 round(.005/sampleinterval)]);
            yahpslow= imfilter(y,h);
        end
        
        stepsize=round(.002/sampleinterval); % ennyit kell l�pkedi, hogy 2 ms-onk�nt l�pkedj�nk
        data.(['sweep',num2str(sweep)]).concavity=NaN(apnum,1);
        data.(['sweep',num2str(sweep)]).concavitystd=NaN(apnum,1);
        data.(['sweep',num2str(sweep)]).concavitymin=NaN(apnum,1);
        data.(['sweep',num2str(sweep)]).concavitymax=NaN(apnum,1);
        data.(['sweep',num2str(sweep)]).concavitylengthins=NaN(1,apnum);
        
        for stufi=1:3
                    data.(['sweep',num2str(sweep)]).(['concavity',num2str(stufi)])=NaN(apnum,1);
                    data.(['sweep',num2str(sweep)]).(['concavitystd',num2str(stufi)])=NaN(apnum,1);
        end
        temp=struct;
        for i=1:apnum %ebben a m�sodik k�rben az AP-k k�z�tti esem�nyeket n�zz�k (AHP&ADP)
            if i==apnum
                maxhossz=length(x)-stepsize*10;
            else
                maxhossz=find(abs(x-data.(['sweep',num2str(sweep)]).treshtime(i+1))==min(abs(x-data.(['sweep',num2str(sweep)]).treshtime(i+1))),1,'first')-stepsize*2;
                while maxhossz<5
                    maxhossz=maxhossz+stepsize;
                end
            end

            ahp=find(abs(x-data.(['sweep',num2str(sweep)]).apendtime(i))==min(abs(x-data.(['sweep',num2str(sweep)]).apendtime(i))),1,'first');
            
            disp(["sweep ",num2str(sweep)," apnum ",num2str(i)," apendtime ",num2str(data.(['sweep',num2str(sweep)]).apendtime(i))]);
            
            if ahp>maxhossz
                ahp=maxhossz;
            end
            ahpp=ahp;
            while yahp(ahp+stepsize)<yahp(ahp) && ahp<maxhossz
                ahp=ahp+stepsize;
            end
            ahp=ahp+stepsize;
            ahp=ahpp + find(y(ahpp:ahp)==min(y(ahpp:ahp)) ,1,'first');
            adp=ahp+2; %az ADP keres�se az AHPn�l kezd?dik
            while (yahp(adp+stepsize)>yahp(adp) || yahp(adp+2*stepsize)>yahp(adp) || yahp(adp+3*stepsize)>yahp(adp)) && adp<maxhossz-stepsize  %x(adp)< data.(['sweep',num2str(sweep)]).treshtime(i+1)
                adp=adp+stepsize;
            end
            adp=adp+stepsize;
            adp=ahp + find(y(ahp:adp)==max(y(ahp:adp)) ,1,'first');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
            if adp<maxhossz && searchslowevents==1; %csak ha van �rtelme, akkor keres�nk las� komponenseket
                [lol,ahpslow]=min(yahp(adp:maxhossz));
                clear lol;
                ahpslow=ahpslow+adp;
                
                if not(i==apnum)
                    [lol,adp]=max(y(ahp:ahpslow));
                    clear lol;
                    adp=ahp+adp;
                end
                
                adpslow=ahpslow+2;
                while adpslow+stepsize*10<maxhossz && yahpslow(adpslow+stepsize*5)>yahpslow(adpslow)
                    adpslow=adpslow+stepsize*5;
                end
                
                adpslow=ahpslow + find(y(ahpslow:adpslow)==max(y(ahpslow:adpslow)) ,1,'first');
                
                if ahp>maxhossz
                    ahp=maxhossz;
                end
                if adp>maxhossz
                    adp=maxhossz;
                end
                if ahpslow>maxhossz
                    ahpslow=maxhossz;
                end
                if adpslow>maxhossz
                    adpslow=maxhossz;
                end
                data.(['sweep',num2str(sweep)]).ahptimeslow(i)=x(ahpslow);
                data.(['sweep',num2str(sweep)]).ahpvslow(i)=y(ahpslow);
                data.(['sweep',num2str(sweep)]).adptimeslow(i)=x(adpslow);
                data.(['sweep',num2str(sweep)]).adpvslow(i)=y(adpslow);
            else
                data.(['sweep',num2str(sweep)]).ahptimeslow(i)=x(adp);
                data.(['sweep',num2str(sweep)]).ahpvslow(i)=y(adp);
                data.(['sweep',num2str(sweep)]).adptimeslow(i)=x(adp);
                data.(['sweep',num2str(sweep)]).adpvslow(i)=y(adp);
            end
            data.(['sweep',num2str(sweep)]).ahptime(i)=x(ahp);
            data.(['sweep',num2str(sweep)]).ahpv(i)=y(ahp);
            data.(['sweep',num2str(sweep)]).adptime(i)=x(adp);
            data.(['sweep',num2str(sweep)]).adpv(i)=y(adp);
            data.(['sweep',num2str(sweep)]).maxtime(i)=x(maxhossz);
            
            
            
            if i<apnum && maxhossz>ahp
                if yahp(ahp)==yahp(maxhossz)
                    stuff=ones(maxhossz-ahp+1,1)*yahp(ahp);
                else
                    stuff=[yahp(ahp):(yahp(maxhossz)-yahp(ahp))/(maxhossz-ahp):yahp(maxhossz)]';
                end
                stufn=floor((maxhossz-ahp)/3);
                data.(['sweep',num2str(sweep)]).concavitymin(i)=min(yahp(ahp:maxhossz)-stuff);
                data.(['sweep',num2str(sweep)]).concavitymax(i)=max(yahp(ahp:maxhossz)-stuff);
                data.(['sweep',num2str(sweep)]).concavity(i)=mean(yahp(ahp:maxhossz)-stuff);
                data.(['sweep',num2str(sweep)]).concavitystd(i)=std(yahp(ahp:maxhossz)-stuff);
                data.(['sweep',num2str(sweep)]).concavitylengthins(i)=(maxhossz-ahp)*sampleinterval;
                for stufi=1:3
                    data.(['sweep',num2str(sweep)]).(['concavity',num2str(stufi)])(i)=mean(yahp(ahp+(stufi-1)*stufn:ahp+(stufi)*stufn)-stuff(1+(stufi-1)*stufn:1+(stufi)*stufn));
                    data.(['sweep',num2str(sweep)]).(['concavitystd',num2str(stufi)])(i)=std(yahp(ahp+(stufi-1)*stufn:ahp+(stufi)*stufn)-stuff(1+(stufi-1)*stufn:1+(stufi)*stufn));
                end
                

            end
        end
    end
    
    if showprogress==1
        progressbar([],[],[],[],sweep/iv.sweepnum);
    end
    
end

end