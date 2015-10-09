function [data] = mpassive(iv,cellname)
showprogress=0;
plotresults=0;
lasthypsectocount=.1;
x=iv.time;
sampleinterval=x(2)-x(1); %sampling rate
samplingrate=1/sampleinterval;
hudredmicsstep=floor(.0001/sampleinterval);

if hudredmicsstep==0
    hudredmicsstep=1;
end


if isfield(iv,'bridged')
    xx=abs(x-iv.segment(1)/1000);
    taustart=find(xx==min(xx))-hudredmicsstep; 
else
%%%%%%%% RS jump megkeresése start
xx=abs(x-iv.segment(1)/1000);
taustart=find(xx==min(xx))+1;
hossz=round(.003/sampleinterval);

h1 = fspecial('average', [1 hudredmicsstep]);
h2 = fspecial('average', [1 round(.005/sampleinterval)]);
h3 = fspecial('average', [1 taustart-1]);

if taustart-hossz>0
x=x(taustart-hossz:taustart+hossz); %csak aa szegmens elej�n kotor�sszon
else
    x=x(1:taustart+hossz);
end

% x=moving(x,hudredmicsstep,'mean');

x= imfilter(x,h1);
% figure;
% hold on;
for sweep=1:4
    y=iv.(['v',num2str(sweep)]);
    if taustart-hossz>0
        y=y(taustart-hossz:taustart+hossz); %csak a szegmens elej�n kotor�sszon
    else
         y=y(1:taustart+hossz);
    end
    
%     y=moving(y,hudredmicsstep,'mean');

    y= imfilter(y,h1);
%     plot(x,y);
    deriv=(diff(y)./diff(x));
    temp(sweep)=find(deriv==min(deriv),1,'first');
end
tauold=taustart;
[taustart,taustartdb]=mode(temp);
if taustartdb==1
    taustart=hossz;
end
if tauold-hossz>0
    taustart=taustart+tauold-hossz+1+floor(hudredmicsstep);
else
    taustart=taustart+1+floor(hudredmicsstep);
end
%%%%%%%% RS jump megkeresése end
end

x=iv.time;
if plotresults==1
    figure
end
for sweep=1:iv.sweepnum; %az osszes sweepen kikeresi a 10 ms elotti es utani 3 pontot, azt �tlagolja, rs-t sz�mol
    y=iv.(['v',num2str(sweep)]);
    v0=mean(y((taustart-5*hudredmicsstep):(taustart-3*hudredmicsstep)));
    vrs=mean(y(taustart));
    if iv.current(sweep)==0;
        fNorm = 1000 / (samplingrate/2);               %# normalized cutoff frequency
        [b,a] = butter(6, fNorm, 'low');  %# 10th order filter
        yfilt = filtfilt(b, a, y);
        temp=mean(y);
        data.noiselevel=mean(abs(y-temp))*1000;
        data.filterednoiselevel=mean(abs(yfilt-temp))*1000;
    end
    xx=abs(x-(iv.segment(1)+iv.segment(2))/1000);
    vhypend=find(xx==min(xx));
    vhypstart=find(x<x(vhypend)-lasthypsectocount,1,'last');
    vhyp=mean(y(vhypstart:vhypend));
    
    dvrs=v0-vrs;
    dvin=vrs-vhyp;
    
    if plotresults==1
        subplot(1,3,1) %figure;%kliplottolom az RS-t meghat�roz� pontokat
        hold on;
        plot(x, y,'.');
        plot(x((taustart-5*hudredmicsstep):(taustart-3*hudredmicsstep)), y((taustart-5*hudredmicsstep):(taustart-3*hudredmicsstep)), 'or');
        plot(x(taustart), y(taustart), 'og');
        xlim([iv.segment(1)/1000-.003,iv.segment(1)/1000+.003]);
        title([cellname(6:end),' segments:',num2str(iv.segment)]);
    end
    
    if iv.current(sweep)<0 %sag-et keres�nk j�l (500Hz sz�r�ssel)
        yy=y;
        fNorm = 500 / (samplingrate/2);               %# normalized cutoff frequency
        [b,a] = butter(6, fNorm, 'low');  %# 10th order filter
        y = filtfilt(b, a, y);
%         if round(.005/sampleinterval)<taustart
%             y=moving(y,round(.005/sampleinterval),'mean');
%             %y= imfilter(y,h2);
%         else
% %              y=moving(y,taustart-1,'mean');
%             y= imfilter(y,h3);
%         end
        
        kezdet=find(x>sum(iv.segment(1:2))/1000,1,'first');
        veg=length(x)-round(iv.segment(3)/10000*samplingrate);
        hely=kezdet+find(y(kezdet:veg)==max(y(kezdet:veg)),1,'first');
        if hely+round(.01*samplingrate)<length(x)
            [data.vrebound(sweep),temp]=max(yy(hely-round(.01*samplingrate):hely+round(.01*samplingrate)));
        else
            [data.vrebound(sweep),temp]=max(yy(hely-round(.01*samplingrate):end));
        end

        if temp(1)+hely-round(.01*samplingrate)>length(x)
            data.trebound(sweep)=x(end);
            data.dvrebound(sweep)=data.vrebound(sweep)-vhyp-dvrs;
        else 
            data.trebound(sweep)=x(temp(1)+hely-round(.01*samplingrate));
            data.dvrebound(sweep)=data.vrebound(sweep)-vhyp-dvrs;
        end

        [data.vsag(sweep),temp]=min(y(taustart:length(find(x<0.4+iv.segment(1)/1000))));
        dvsag=vrs-data.vsag(sweep);
        data.rsag(sweep)=-dvsag/(iv.current(sweep))*1000000;
	data.rsag(sweep);
        tauend=temp(1)+taustart;
        
        if plotresults==1
            subplot(1,3,3);
            % plot(sag(1,:), sag(2,:));
            hold on
            plot(x, y);
            plot(x(tauend),data.vsag(sweep),'ro');
        end
        
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IDŐÁLLANDÓ
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ez a script sz�molja a taut brute force-szalbegin
        %         %  for i=1:10;%%ilyen t�vols�gokkal fogja megpr�b�lni az id��lland�t kisz�molni
        %         %     tauend(i)=length(find(x<x(taustart)+.03*i));
        %         % end
        %         %         for i=1:10;
        %         %             xtau.(['a',num2str(i)])=x(taustart:tauend(i)); %az idoallando meresehez szolg�lo id?szakaszokat megcsin�lom
        %         %             ytau.(['a',num2str(i)])=y(taustart:tauend(i)); %az idoallando meresehez szolg�lo y �rt�keket megcsin�lom
        %         %         end
        %         %         for i=1:10
        %         %             % Define your exponential function
        %         %             fh = @(xx,pp) pp(1) + pp(2)*exp(-xx./pp(3));
        %         %             % define the error function. this is the function to
        %         %             % minimize: you can also use norm or whatever:
        %         %             errfh = @(pp,xx,yy) mean((yy(:)-fh(xx(:),pp)).^2);
        %         %             % an initial guess of the exponential parameters
        %         %             pp0 = [mean(ytau.(['a',num2str(i)])) (max(ytau.(['a',num2str(i)]))-min(ytau.(['a',num2str(i)]))) (max(xtau.(['a',num2str(i)])) - min(xtau.(['a',num2str(i)])))/2];
        %         %             % search for solution
        %         %             options = optimset('MaxFunEvals', 50000);
        %         %             [PP(i,:),fval(i,:)] = fminsearch(errfh,pp0,[],xtau.(['a',num2str(i)]),ytau.(['a',num2str(i)]));
        %         %         end
        %         %
        %         %         tautime=find(fval==min(fval));
        %         %
        %         %         PP=PP(tautime,:);
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ez a script sz�molja a taut brute force-szal end
        %
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Ez a script sz�molja a taut a sag-ig BEGIN
        %
        xtau=x(taustart:tauend); %az idoallando meresehez szolg�lo id?szakaszokat megcsin�lom
        ytau=y(taustart:tauend); %az idoallando meresehez szolg�lo y �rt�keket megcsin�lom
        %
        %         % Define your exponential function
        %         fh = @(xx,pp) pp(1) + pp(2)*exp(-xx./pp(3));
        %         % define the error function. this is the function to
        %         % minimize: you can also use norm or whatever:
        %         errfh = @(pp,xx,yy) mean((yy(:)-fh(xx(:),pp)).^2);
        %         % an initial guess of the exponential parameters
        %         pp0 = [mean(ytau) (max(ytau)-min(ytau)) (max(xtau) - min(xtau))/2];
        %         % search for solution
        %         options = optimset('MaxFunEvals', 50000);
        %         [PP,fval] = fminsearch(errfh,pp0,[],xtau,ytau);
        %
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Ez a script sz�molja a taut a sag-ig END
        %
        %         %         subplot(1,3,2)%figure %kiplottolom az exponencialis fittelest, meg hogy meddig fitteltem
        %         %         plot(x,y,'.',x,fh(x,PP),'r.',x(tauend),y(tauend),'g.');
        %         %         xlim([0,.25])
        %         %         ylim([min(iv.v1),mean(iv.v6)])
        %         %         hold on;
        %
        %
        %         fhh = @(xxx) abs(PP(1) + PP(2)*exp(-xxx./PP(3)) -(fh(x(taustart),PP)-0.632120559*(fh(x(taustart),PP)-fh(max(x),PP))));
        %         options = optimset('MaxFunEvals', 50000);
        %         XXX=fminsearch(fhh, .01);
        %         data.tau(sweep)=(XXX-xtau(1))*1000;
        %         data.tauend(sweep)=x(tauend);
        %         data.taufail(sweep)=fval;
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IDŐÁLLANDÓ
        %

        data.tauend(sweep)=x(tauend);
        [~,l]=min(abs(ytau-(ytau(1)-(1-1/exp(1))*(ytau(1)-ytau(end)))));
        data.taunew(sweep)=l(1)/samplingrate*1000;
        dtau=abs(ytau(1)-ytau(end));
        dtenpercent=ytau(1)-dtau*.1;
        dninetypercent=ytau(1)-dtau*.9;
        ttenpercent=find(ytau<dtenpercent,1,'first');
        tninetypercent=find(ytau<dninetypercent,1,'first');
        if size(ttenpercent,1)==0 || size(tninetypercent,1)==0
          data.tau1090risetime(sweep)=0;
        else
          data.tau1090risetime(sweep)=sampleinterval*(tninetypercent-ttenpercent);
        end

        disp(data.tau1090risetime(sweep));
        
        m=find(abs(ytau-(ytau(1)-(1-1/exp(1))*(ytau(1)-ytau(end))))<.0005);
        if isempty(m)
            m=find(abs(ytau-(ytau(1)-(1-1/exp(1))*(ytau(1)-ytau(end))))<.001);
            if isempty(m)
                m=find(abs(ytau-(ytau(1)-(1-1/exp(1))*(ytau(1)-ytau(end))))<.005);
            end
        end
        data.taunewfail(sweep)=(max(m)-min(m))/samplingrate*1000;
    end
    
    
    data.v0s(sweep)=v0;
    data.vrs(sweep)=vrs;
    data.vhyp(sweep)=vhyp;
    data.dvrs(sweep)=dvrs;
    data.dvin(sweep)=dvin;
    data.rs(sweep)=-dvrs/(iv.current(sweep))*1000000;
    data.rin(sweep)=-dvin/(iv.current(sweep))*1000000;
    
    
  if showprogress==1
      progressbar([],[],num2str(sweep/iv.sweepnum),0,0);
  end
    
end
if ~isfield('data','noiselevel')
    y=iv.v1;
    y=y(find(x>iv.segment(1)/1000+.1,1,'first'):find(x>sum(iv.segment(1:2)/1000),1,'first'));
    fNorm = 1000 / (samplingrate/2);               %# normalized cutoff frequency
    [b,a] = butter(6, fNorm, 'low');  %# 10th order filter
    yfilt = filtfilt(b, a, y);
    temp=mean(y);
    data.noiselevel=mean(abs(y-temp))*1000;
    data.filterednoiselevel=mean(abs(yfilt-temp))*1000;
end
        
        
data.samplingrate=samplingrate;
data.taustart=taustart;



data.v0=mean(data.v0s);
end
