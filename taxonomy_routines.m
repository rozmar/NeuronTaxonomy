%  setting path,generating txt
close all
clear all

ivpercell=1;%'all the IVs'; % the first (ivpercell) IVs will be used for each cell if the (ivpercell) variable is numeric. All the IVs will be used if this variable is not numeric.
savetheIV=1; %the processed IV-s are saved (in separate directories) when ==1

locations=marcicucca_locations;
defPath=[locations.tgtardir,'MATLABdata/IV'];

projects(1).Name='quantal';
projects(1).listPath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/quantal'];
projects(1).listName='mg.txt';

projects(2).Name='humanNGF-old';
projects(2).listPath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/human_NGF'];
projects(2).listName='realngfcelldata.txt';

projects(3).Name='low-highNGF';
projects(3).listPath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/Low_high_glucose_NGF'];
projects(3).listName='lowhigh.txt';

projects(4).Name='Human_pyr_harvest';
projects(4).listPath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/Human_pyr_USA'];
projects(4).listName='harvestdata.txt';
projects(4).xlsname='harvestpyr.xls';

projects(5).Name='Rat_AAC_vs_BC';
projects(5).listPath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/AAC-BC'];
projects(5).listName='AACBCharvest.txt';
projects(5).xlsname='AACBCharvest.xls';

projects(6).Name='Magor-szabina';
projects(6).listPath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/Magor-Szabina'];
projects(6).listName='magor-szabina.txt';
projects(6).xlsname='magor-szabina.xls';

projects(7).Name='Human_rosehip';
projects(7).listPath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/human_rosehip'];
projects(7).listName='Human_stut.txt';
projects(7).xlsname='Human_stut.xls';

projects(8).Name='Human_AAC';
projects(8).listPath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/human_AAC'];
projects(8).listName='humanAAC.txt';
projects(8).xlsname='humanAAC.xls';

projects(9).Name='molnarg_Karrinak';
projects(9).listPath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/Molnarg/Karrinak'];
projects(9).listName='Spiketransmissiontohumaninterneurons.txt';
projects(9).xlsname='Spike transmission to human interneurons.xls';

[Selection,ok]=listdlg('ListString',{projects.Name},'ListSize',[300 600]);

listPath=projects(Selection).listPath;
listName=projects(Selection).listName;
xlsname=projects(Selection).xlsname;
taxonomy_generateTXTfromXLS(listPath,listName,xlsname,ivpercell)% the class can be only one character!

%% locating files
datasumDir=[listPath,'/datasums'];
featDir=[listPath,'/datafiles'];
ivdir=[listPath,'/IVs'];
projectName=[];
[cls, ~, ~, ~] = readInFileList(listPath,listName);% the class can be only one character!
cls=num2str(unique(cls));% the class can be only one character!
if size(cls,1)>size(cls,2)
    cls=cls';
end
cls(strfind(cls,' '))=[];% the class can be only one character!
clabels=cls;
[paths,alltheivdata]=gethekafilepaths(listPath,listName,defPath);
inputDir=paths;
%% extracting features
button = questdlg('Would you like to export raw IVs?','raw export','yes','no','yes');
if strcmp(button,'yes')
    %     if isempty(clabels)
    %         delete([featDir,'/*.mat']);
    %     else
    %         for i=1:length(clabels)
    %             delete([featDir,'/',clabels(i),'/*.mat']);
    %         end
    %     end
    processRawIvs(listPath,listName,inputDir,featDir,projectName, clabels);
end
%% collecting specified features
extractor = @basic_features;
button = questdlg('Would you like to collect features?','collect features','yes','no','yes');
if strcmp(button,'yes')
    if isempty(clabels)
        %         delete([datasumDir,'/*.mat']);
        i=1;
        collect_specified_features_from_dir(alltheivdata,featDir,datasumDir,savetheIV,clabels);
    else
        for i=1:length(clabels)
            %             delete([datasumDir,'/',clabels(i),'/*.mat']);
            collect_specified_features_from_dir(alltheivdata,featDir,datasumDir,savetheIV,clabels(i),extractor);
        end
    end
end
%% generating DATASUM exporting IV files if needed
DATASUM=struct;
if isempty(clabels)
    hossz=1;
else
    hossz=length(clabels);
end
for i=1:hossz
    if isempty(clabels)
        datasumDirnow=[datasumDir,'/'];
    else
        datasumDirnow=[datasumDir,'/',clabels(i)];
    end
    fnames=dir(datasumDirnow);
    fnames([fnames.isdir])=[];
    disp(i)
    for fnum=1:length(fnames)
        load([datasumDirnow,'/',fnames(fnum).name]);
        datasum.fname=fnames(fnum).name;
        hyps=strfind(datasum.fname,'_');
        datasum.ID=datasum.fname(hyps(1)+1:hyps(2)-1);
        datasum.fname=datasum.fname(hyps(2)+1:end-4);
        
        if isempty(clabels)
            datasum.class=[];
        else
            datasum.class=str2num(clabels(i));
        end
        
        if isempty(fieldnames(DATASUM))
            NEXT=1;
            clear DATASUM
        else
            NEXT=length(DATASUM)+1;
        end
        DATASUM(NEXT)=datasum;
        if savetheIV==1
            iv=DATASUM(fnum).iv;
            if isempty(clabels)
                save([ivdir,'/',datasum.fname,'.mat'],'iv');
            else
                save([ivdir,'/',clabels(i),'/',datasum.fname,'.mat'],'iv');
            end
            
            %             figure(1)
            %             clf
            %             plot(iv.time,iv.v1)
            %             hold on
            %             plot(iv.time,iv.(['v',num2str(iv.sweepnum)]))
            %             title(datasum.fname)
            %             axis tight
            %                     pause
        end
    end
end

%% statistics and writing data to xls file
[locations]=marcicucca_locations;

path=[locations.matlabstuffdir,'NotMine/20130227_xlwrite/'];
javaaddpath([path 'poi_library/poi-3.8-20120326.jar']);
javaaddpath([path 'poi_library/poi-ooxml-3.8-20120326.jar']);
javaaddpath([path 'poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
javaaddpath([path 'poi_library/xmlbeans-2.3.0.jar']);
javaaddpath([path 'poi_library/dom4j-1.6.1.jar']);
path=[locations.matlabstuffdir,'20130227_xlwrite/'];
javaaddpath([path 'poi_library/poi-3.8-20120326.jar']);
javaaddpath([path 'poi_library/poi-ooxml-3.8-20120326.jar']);
javaaddpath([path 'poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
javaaddpath([path 'poi_library/xmlbeans-2.3.0.jar']);
javaaddpath([path 'poi_library/dom4j-1.6.1.jar']);
fieldek=fieldnames(DATASUM);
fieldek(find(strcmp(fieldek,'fname')))=[];
fieldek(find(strcmp(fieldek,'iv')))=[];
fieldek(find(strcmp(fieldek,'ID')))=[];

% fieldek(find(strcmp(fieldek,'class')))=[];

fnames=[{'Filename'},{DATASUM.fname}];
IDs=[{'ID'},{DATASUM.ID}];

datamatrix=NaN(length(fieldek),length(DATASUM));
clear statmatrix
for fieldnum=1:length(fieldek)
    datamatrix(fieldnum,:)=[DATASUM.(fieldek{fieldnum})];
    %hm
    if any(strcmp(fieldek,'class'))
        %         adatok=clear;
        classfieldnum=find(strcmp(fieldek,'class'));
        classes=[DATASUM.class];
        uniqueclasses=unique(classes);
        classnum=length(uniqueclasses);
        if classnum>1
            datforstat=struct;
            for classi=1:classnum
                %                 classidx=strfind(classes,uniqueclasses(classi)); %?????
                classidx=classes==uniqueclasses(classi);
                datforstat(classi).data=datamatrix(fieldnum,classidx);
                datforstat(classi).data(isnan(datforstat(classi).data))=[];
                datforstat(classi).classname=uniqueclasses(classi);
            end
            averagevalues=[];
            lillieps=[];
            ttestps=[];
            wilcoxonps=[];
            statrow=[];
            statheader={};
            for firstclassi=1:classnum-1
                if length(datforstat(firstclassi).data)>=4
                    [~,lillieps(1)] =lillietest(datforstat(firstclassi).data);
                else
                    lillieps(1)=NaN;
                end
                averagevalues(1)=nanmean(datforstat(firstclassi).data);
                for secondclassi=firstclassi+1:classnum
                    averagevalues(2)=nanmean(datforstat(secondclassi).data);
                    constantstring=[num2str(uniqueclasses(firstclassi)),' vs ',num2str(uniqueclasses(secondclassi))];
                    if length(datforstat(secondclassi).data)>=4
                        [~,lillieps(2)]=lillietest(datforstat(secondclassi).data);
                        
                    else
                        lillieps(2)=NaN;
                        
                    end
                    if length(datforstat(secondclassi).data)>=4 && length(datforstat(firstclassi).data)>=4
                        [~,ttestps]=ttest2(datforstat(firstclassi).data,datforstat(secondclassi).data);
                        wilcoxonps = ranksum(datforstat(firstclassi).data,datforstat(secondclassi).data);
                    else
                        ttestps=NaN;
                        wilcoxonps = NaN;
                    end
                    statrow=[statrow,averagevalues,lillieps,ttestps,wilcoxonps];
                    statheader=[statheader,{['average value for ',num2str(uniqueclasses(firstclassi))],['average value for ',num2str(uniqueclasses(secondclassi))],['lilliefors p for ',num2str(uniqueclasses(firstclassi))],['lilliefors p for ',num2str(uniqueclasses(secondclassi))],['t test ',constantstring],['wilcoxon test ',constantstring]}];
                end
            end
            statmatrix(fieldnum,:)=statrow;
        end
    end
end
if classnum>1
    %     fieldek=[fieldek;statheader'];
    fnames=[fnames,statheader];
    datamatrix=[datamatrix,statmatrix];
end
% % % oszlopszam=length(DATASUM);
% % % Abetszam=str2num('A');
% % % Zbetuszam=str2num('Z');
% % % endbetu
% % % while oszlopszam/Abetszam>1
% % %
% % % elsobetu=char(floor(oszlopszam/Abetszam)+'A');
% % % masodikbetu=char(oszlopszam-floor(oszlopszam/Abetszam)+'A');

xlwrite([listPath,'/sumdata.xls'],fieldek','Sheet 1',['C1']);
xlwrite([listPath,'/sumdata.xls'],fnames','Sheet 1',['A1']);
xlwrite([listPath,'/sumdata.xls'],IDs','Sheet 1',['B1']);
xlwrite([listPath,'/sumdata.xls'],datamatrix','Sheet 1',['C2']);%,char(length(DATASUM)+'A'),num2str(length(fieldek)+1)
return
%% csoport hisztogramok
fieldek=fieldnames(DATASUM);
fieldek(find(strcmp(fieldek,'fname')))=[];
fieldek(find(strcmp(fieldek,'iv')))=[];
csoporok=unique([DATASUM.class]);
princompmatrix=[];
princompps=[];
princompnames=[];
for fieldnum=1:length(fieldek)
    figure(1)
    clf
    clear datanow
    for i=1:length(csoporok)
        alldata=[DATASUM.(fieldek{fieldnum})];
        range=[min(alldata):(max(alldata)-min(alldata))/20:max(alldata)];
        subplot(length(csoporok)+1,1,1)
        hist(alldata,range)
        title(fieldek{fieldnum})
        
        neededcells=[DATASUM.class]==csoporok(i);
        toplot=[DATASUM(neededcells).(fieldek{fieldnum})];
        subplot(length(csoporok)+1,1,i+1)
        hist(toplot,range)
        title(csoporok(i))
        datanow(i).data=toplot;
    end
    figure(2)
    clf
    plot([DATASUM.class],alldata,'ko')
    xlim([0 5])
    [p,h]=ranksum(datanow(1).data,datanow(2).data,.001);
    if h==1
        disp(p)
        if ~any(isnan([DATASUM.(fieldek{fieldnum})]))
            princompmatrix(:,size(princompmatrix,2)+1)=[DATASUM.(fieldek{fieldnum})]';
            princompps(length(princompps)+1)=p;
            princompnames{length(princompnames)+1}=fieldek{fieldnum}
        end
        %         pause
    end
end

%% principal component analysis
mergecorrelatingvals=1;
corrpval=.01;
count=6;

[princomppsnew,IX]=sort(princompps);
princompmatrixnew=princompmatrix(:,IX);
princompnamesnew=princompnames(IX);



if mergecorrelatingvals==1
    i=1;
    princompmatrixnewnew=[];
    princompnamesnewnew=[];
    while length(princompnamesnew)>1 %for i=1:size(princompmatrixnew,2)
        tomerge=zeros(1,size(princompmatrixnew,2));
        for j=1:size(princompmatrixnew,2)
            [R,p]=corrcoef(princompmatrixnew(:,i),princompmatrixnew(:,j));
            if p(2)<corrpval %abs(R(2))>maxcorrval
                tomerge(j)=1;
            end
        end
        mergeidx=find(tomerge);
        newname=[];
        for namei=1:length(mergeidx)
            newname=[newname,'-',princompnamesnew{mergeidx(namei)}];
        end
        princompnamesnewnew=[princompnamesnewnew,{newname}];
        princompnamesnew(mergeidx)=[];
        princompmatrixnewnew=[princompmatrixnewnew,princompmatrixnew(:,mergeidx(1))];
        princompmatrixnew(:,mergeidx)=[];
    end
    if length(princompnamesnew)==1
        mergeidx=1;
        princompnamesnewnew=[princompnamesnewnew,{[princompnamesnew{mergeidx}]}];
        princompnamesnew(mergeidx)=[];
        princompmatrixnewnew=[princompmatrixnewnew,princompmatrixnew(:,mergeidx(1))];
        princompmatrixnew(:,mergeidx)=[];
    end
    
    princompmatrixnew=princompmatrixnewnew;
    princompnamesnew=princompnamesnewnew;
end



princomppsnew=princomppsnew(1:min(count,length(princompnamesnew)));
princompmatrixnew=princompmatrixnew(:,1:min(count,length(princompnamesnew)));
princompnamesnew=princompnamesnew(1:min(count,length(princompnamesnew)));



% close all
figure(1)
clf
subplot(2,2,3);
hold on
[COEFF,SCORE,latent,tsquare] = princomp(zscore(princompmatrixnew));
medians=[median(SCORE([DATASUM.class]==1,1)),median(SCORE([DATASUM.class]==1,2)),median(SCORE([DATASUM.class]==1,3));median(SCORE([DATASUM.class]==2,1)),median(SCORE([DATASUM.class]==2,2)),median(SCORE([DATASUM.class]==2,3))];

plot3(SCORE([DATASUM.class]==1,1),SCORE([DATASUM.class]==1,2),SCORE([DATASUM.class]==1,3),'ro','MarkerFaceColor',[1 0 0]);
plot3(SCORE([DATASUM.class]==2,1),SCORE([DATASUM.class]==2,2),SCORE([DATASUM.class]==2,3),'bo','MarkerFaceColor',[0 0 1]);
plot3(SCORE([DATASUM.class]>2,1),SCORE([DATASUM.class]>2,2),SCORE([DATASUM.class]>2,3),'ko','MarkerFaceColor',[1 1 1]);

xlabel('1st principal component')
ylabel('2nd principal component')
zlabel('3rd principal component')
plot3(medians(1,1),medians(1,2),medians(1,3),'rx','MarkerSize',16,'LineWidth',3)
plot3(medians(2,1),medians(2,2),medians(2,3),'bx','MarkerSize',16,'LineWidth',3)
plot3(medians(:,1),medians(:,2),medians(:,3),'ko-','MarkerSize',16,'LineWidth',3)
xlim([-3 3])
ylim([-3 3])
subplot(2,2,1)
hold on
[nall,xout]=hist(SCORE([DATASUM.class]==3,1),[-3:.5:3]);
[n11,~]=hist(SCORE([DATASUM.class]==1,1),xout);
[n21,~]=hist(SCORE([DATASUM.class]==2,1),xout);
bar1=bar(xout,[nall;n21;n11]','grouped');%,'k','b','r','FaceColor',[1 1 1]
set(bar1(1),'FaceColor',[1 1 1]) ;
set(bar1(2),'FaceColor',[0 0 1]) ;
set(bar1(3),'FaceColor',[1 0 0]) ;
set(bar1,'barwidth',1) ;
% bar(xout,n21,'b','FaceColor',[0 0 1])
% bar(xout,n11,'r','FaceColor',[1 0 0])
xlim([-3 3])

subplot(2,2,4)
hold on
[nall,xout]=hist(SCORE([DATASUM.class]==3,1),[-3:.5:3]);
[n11,~]=hist(SCORE([DATASUM.class]==1,2),xout);
[n21,~]=hist(SCORE([DATASUM.class]==2,2),xout);
bar1=barh(xout,[nall;n21;n11]','grouped');%,'k','FaceColor',[1 1 1])
set(bar1(1),'FaceColor',[1 1 1]) ;
set(bar1(2),'FaceColor',[0 0 1]) ;
set(bar1(3),'FaceColor',[1 0 0]) ;
set(bar1,'barwidth',1) ;
% barh(xout,n21,'b','FaceColor',[0 0 1])
% barh(xout,n11,'r','FaceColor',[1 0 0])
ylim([-3 3])


figure(2)
clf
hold on
plot3(princompmatrixnew([DATASUM.class]>2,1),princompmatrixnew([DATASUM.class]>2,2),princompmatrixnew([DATASUM.class]>2,3),'ko','MarkerFaceColor',[1 1 1]);
plot3(princompmatrixnew([DATASUM.class]==1,1),princompmatrixnew([DATASUM.class]==1,2),princompmatrixnew([DATASUM.class]==1,3),'ro','MarkerFaceColor',[1 0 0]);
plot3(princompmatrixnew([DATASUM.class]==2,1),princompmatrixnew([DATASUM.class]==2,2),princompmatrixnew([DATASUM.class]==2,3),'bo','MarkerFaceColor',[0 0 1]);
xlabel(princompnamesnew{1})
ylabel(princompnamesnew{2})
zlabel(princompnamesnew{3})
%% correlating values

%% balázs reobase+curr accomodation
dataneeded=struct;
isidataneeded=struct;
fieldek=fieldnames(DATASUM);
fieldek(find(strcmp(fieldek,'fname')))=[];
fieldek(find(strcmp(fieldek,'iv')))=[];
csoporok=unique([DATASUM.class]);
fieldnamestarts={'accomodation','apaccomodation','hwaccomodation'};

for k=1:length(fieldnamestarts)
    fieldnamestart=fieldnamestarts{k};
    for i=1:length(csoporok)
        alldata=[DATASUM.(fieldek{fieldnum})];
        neededcells=[DATASUM.class]==csoporok(i);
        for j=1:4
            fieldnev=[fieldnamestart,num2str(j)];
            isifieldnev=[fieldnamestart,num2str(j),'isi'];
            toplot=[DATASUM(neededcells).(fieldnev)];
            isitoplot=[DATASUM(neededcells).(isifieldnev)];
            dataneeded(i).(fieldnamestart)(j).DATA=toplot';
            isidataneeded(i).(fieldnamestart)(j).DATA=isitoplot';
        end
    end
end
finames=fieldnames(dataneeded);
figure(1)
clf
for i=1:length(finames)
    finame=finames{i};
    for ii=1:2
        data=[dataneeded(ii).(finame).DATA];
        isidata=[isidataneeded(ii).(finame).DATA];
        meandata=nanmean(data);
        stddata=nanstd(data);
        ndata=sum(~isnan(data));
        sedata=stddata./sqrt(ndata);
        subplot(length(finames),3,i*3-2);
        hold all;
        errorbar([1:4],meandata,sedata,'LineWidth',2);
        ylabel(finame)
        subplot(length(finames),3,i*3-1);
        hold all
        plot([1:4],ndata,'o','LineWidth',2)
        ylabel('n')
        datanow=[];
        isidatanow=[];
        for iii=1:4
            isidatanow=[isidatanow;isidata(:,iii)];
            datanow=[datanow;data(:,iii)];
        end
        subplot(length(finames),3,i*3);
        hold all
        plot(isidatanow,datanow,'o')
        xlabel('ISI (s)')
        ylabel(finame)
    end
end
%% MG Human AAC SAG/REBOUND cucc
close all
% DATASUM(find([DATASUM.sag]-[DATASUM.rebound]<-1))=[];
[ids,ic,ci]=unique({DATASUM.ID});
DATASUM=DATASUM(ic);
figure
subplot(2,1,1)
hist([DATASUM.sag],[1:.05:2])
ylabel('sag')
xlim([1,2])
ylim([0 10])
ylim()
subplot(2,1,2)
hist([DATASUM.rebound],[1:.05:2])
ylabel('rebound')
xlim([1,2])
ylim([0 10])

butt=1
while butt==1
    figure(2)
    plot([DATASUM.sag],[DATASUM.rebound],'ko')
    hold on
    xlim([.9,2])
    ylim([.9,2])
    plot([0,2],[0,2],'k-','LineWidth',2)
    [x,y,butt]=ginput(1);
    clf
    plot([DATASUM.sag],[DATASUM.rebound],'ko')
    hold on
    xlim([.9,2])
    ylim([.9,2])
    plot([0,2],[0,2],'k-','LineWidth',2)
    difs=abs([DATASUM.sag]-x)+abs([DATASUM.rebound]-y);
    [~,ezkell]=min(difs);
    plot([DATASUM(ezkell).sag],[DATASUM(ezkell).rebound],'ro','MarkerFaceColor',[1 0 0])
    figure(22)
    clf
    plot(DATASUM(ezkell).iv.time,DATASUM(ezkell).iv.v1,'k-')
    % hold on
    % plot(DATASUM(ezkell).iv.time,DATASUM(ezkell).iv.v2,'k-')
    title(num2str(ezkell))
    title(num2str(DATASUM(ezkell).ID))
end
%% cutting out APs, plotting variables
load([locations.taxonomy.fetureextractorlocation,'/apFeatures.mat'],'featS');
zeropos='apMaxPos';
zeropos='threshold5Pos';
dvperdtmovingaverage=8;
sineeded=5;
timebefore=.0005;
timeafter=.001;
appercell=[5];
vonalvastagsag=3;
APwaves=struct;
figure(1)
clf
hold all
for celli=1:length(DATASUM)
    load([listPath,'/datafiles/',num2str(DATASUM(celli).class),'/data_iv_',DATASUM(celli).ID,'_',DATASUM(celli).fname,'.mat']);
    zeroh=cellStruct.apFeatures(:,featS.(zeropos));
    sweepnum=cellStruct.apFeatures(:,featS.sweepNum);
    si=DATASUM(celli).si;
    stepback=round(timebefore/si);
    stepforward=round(timeafter/si);
    for i=1:length(appercell)
        api=appercell(i);
        if api<=length(sweepnum)
            APwaves(celli).V(:,i)=DATASUM(celli).iv.(['v',num2str(sweepnum(api))])(zeroh(api)-stepback:zeroh(api)+stepforward)+cellStruct.dvrs(sweepnum(api));
            APwaves(celli).t(:,i)=[-stepback*si:si:stepforward*si];
            APwaves(celli).dVperdt=diff(moving(APwaves(celli).V(:,i),dvperdtmovingaverage))/si;
            APwaves(celli).dVperdtT=mean([APwaves(celli).t(1:end-1,i),APwaves(celli).t(2:end,i)],2);
            APwaves(celli).dVperdtV=mean([APwaves(celli).V(1:end-1,i),APwaves(celli).V(2:end,i)],2);
            
            APwaves(celli).ddVperdt=diff(APwaves(celli).dVperdt(:,i))/si;
            APwaves(celli).ddVperdtT=mean([APwaves(celli).dVperdtT(1:end-1,i),APwaves(celli).dVperdtT(2:end,i)],2);
            APwaves(celli).ddVperdtV=mean([APwaves(celli).dVperdtV(1:end-1,i),APwaves(celli).dVperdtV(2:end,i)],2);
            
            
            if DATASUM(celli).class<3
                subplot(2,2, (DATASUM(celli).class-1)*2+1)
                hold all
                plot([APwaves(celli).t],[APwaves(celli).V])
                subplot(2,2,DATASUM(celli).class*2)
                hold all
                plot([APwaves(celli).dVperdtT],[APwaves(celli).dVperdt])
            end
        end
    end
end
%
AACezeket=find([DATASUM.class]==1 & round([DATASUM.si]*10^6)==sineeded);
aaccolor=[.7,.7,.7];
BCezeket=find([DATASUM.class]==2 & round([DATASUM.si]*10^6)==sineeded);
bccolor=[.7,.7,.7];
figure(2)
clf
h1=subplot(2,4,1);
hold on
plot([APwaves(AACezeket).t],[APwaves(AACezeket).V],'color',aaccolor)
hold on
plot(mean([APwaves(AACezeket).t],2),mean([APwaves(AACezeket).V],2),'r-','LineWidth',vonalvastagsag)
axis tight
xlabel('time (s)')
ylabel('Vm (V)')
h2=subplot(2,4,2);
hold on
plot([APwaves(AACezeket).dVperdtT],[APwaves(AACezeket).dVperdt],'color',aaccolor)
hold on
plot(mean([APwaves(AACezeket).dVperdtT],2),mean([APwaves(AACezeket).dVperdt],2),'r-','LineWidth',vonalvastagsag)
axis tight
xlabel('time (s)')
ylabel('dV/dt (V/s)')
h3=subplot(2,4,3);
hold on
plot([APwaves(AACezeket).dVperdtV],[APwaves(AACezeket).dVperdt],'color',aaccolor)
hold on
plot(mean([APwaves(AACezeket).dVperdtV],2),mean([APwaves(AACezeket).dVperdt],2),'r-','LineWidth',vonalvastagsag)
axis tight
xlabel('Vm (V)')
ylabel('dV/dt (V/s)')
h4=subplot(2,4,4);
hold on
plot([APwaves(AACezeket).ddVperdtT],[APwaves(AACezeket).ddVperdt],'color',aaccolor)
hold on
plot(mean([APwaves(AACezeket).ddVperdtT],2),mean([APwaves(AACezeket).ddVperdt],2),'r-','LineWidth',vonalvastagsag)
axis tight
xlabel('time (s)')
ylabel('d^2V/dt^2 (V/s^2)')

h5=subplot(2,4,5);
hold on
plot([APwaves(BCezeket).t],[APwaves(BCezeket).V],'color',bccolor)
hold on
plot(mean([APwaves(BCezeket).t],2),mean([APwaves(BCezeket).V],2),'k-','LineWidth',vonalvastagsag)
axis tight
xlabel('time (s)')
ylabel('Vm (V)')
h6=subplot(2,4,6);
hold on
plot([APwaves(BCezeket).dVperdtT],[APwaves(BCezeket).dVperdt],'color',bccolor)
hold on
plot(mean([APwaves(BCezeket).dVperdtT],2),mean([APwaves(BCezeket).dVperdt],2),'k-','LineWidth',vonalvastagsag)
axis tight
xlabel('time (s)')
ylabel('dV/dt (V/s)')
h7=subplot(2,4,7);
hold on
plot([APwaves(BCezeket).dVperdtV],[APwaves(BCezeket).dVperdt],'color',bccolor)
hold on
plot(mean([APwaves(BCezeket).dVperdtV],2),mean([APwaves(BCezeket).dVperdt],2),'k-','LineWidth',vonalvastagsag)
axis tight
xlabel('Vm (V)')
ylabel('dV/dt (V/s)')
h8=subplot(2,4,8);
hold on
plot([APwaves(BCezeket).ddVperdtT],[APwaves(BCezeket).ddVperdt],'color',bccolor)
hold on
plot(mean([APwaves(BCezeket).ddVperdtT],2),mean([APwaves(BCezeket).ddVperdt],2),'k-','LineWidth',vonalvastagsag)
axis tight
xlabel('time (s)')
ylabel('d^2V/dt^2 (V/s^2)')

linkaxes([h1,h5],'xy');
linkaxes([h2,h6],'xy');
linkaxes([h4,h8],'xy');
% linkaxes([h1,h2,h4,h5,h6,h8],'x');
linkaxes([h3,h7],'xy');

% vonalvastagsag=1;
figure(3)
clf
subplot(2,2,1);
hold on
plot(mean([APwaves(BCezeket).t],2),mean([APwaves(BCezeket).V],2),'k-','LineWidth',vonalvastagsag)
plot(mean([APwaves(AACezeket).t],2),mean([APwaves(AACezeket).V],2),'r-','LineWidth',vonalvastagsag)
axis tight
xlabel('time (s)')
ylabel('Vm (V)')
subplot(2,2,2);
hold on
plot(mean([APwaves(BCezeket).dVperdtT],2),mean([APwaves(BCezeket).dVperdt],2),'k-','LineWidth',vonalvastagsag)
plot(mean([APwaves(AACezeket).dVperdtT],2),mean([APwaves(AACezeket).dVperdt],2),'r-','LineWidth',vonalvastagsag)
axis tight
xlabel('time (s)')
ylabel('dV/dt (V/s)')
subplot(2,2,3);
hold on
plot(mean([APwaves(BCezeket).dVperdtV],2),mean([APwaves(BCezeket).dVperdt],2),'k-','LineWidth',vonalvastagsag)
plot(mean([APwaves(AACezeket).dVperdtV],2),mean([APwaves(AACezeket).dVperdt],2),'r-','LineWidth',vonalvastagsag)
axis tight
xlabel('Vm (V)')
ylabel('dV/dt (V/s)')
subplot(2,2,4);
hold on
plot(mean([APwaves(BCezeket).ddVperdtT],2),mean([APwaves(BCezeket).ddVperdt],2),'k-','LineWidth',vonalvastagsag)
plot(mean([APwaves(AACezeket).ddVperdtT],2),mean([APwaves(AACezeket).ddVperdt],2),'r-','LineWidth',vonalvastagsag)
axis tight
xlabel('time (s)')
ylabel('d^2V/dt^2 (V/s^2)')