%file név beolvasása
%file=fopen("exps.txt","r");
%texps=textscan(file,"%s"){1,1};
%fclose(file);


startingdate=1301;	%kezdődátum
dothedatasum=1;	%kell datasum?
dotheanalyze=1;	%kell analízis?

sourcepath='../mdata'; 			%main directory
ivpath=[sourcepath,'/IV'];      		%iv directory
datapath=[sourcepath,'/data'];  		%data directory
metadatapath=[sourcepath,'/metadata'];  	%metadata directory
picturepath_iv=[sourcepath,'/pictures/IV'];	%képek

%commfile=[sourcepath,'/fileworkinon.stuff'];	%TODO: megcsinálni a lockolást

%kezdeti paraméterek
minsweepnum=6;
v0max=-.03;
holdingmin=-500;
holdingmax=5000;
stepneeded=20;
dontdothis=0;

temp=dir(metadatapath);               %list subfolders of metadata
metafiles=[];           	                 %contains metafiles

for tempi=1:length(temp)    %non folder files will be metadata
    if temp(tempi).isdir==0;
        metafiles{length(metafiles)+1}=temp(tempi).name;
    end
end

%loop through metafiles
for metafilenum=1:length(metafiles)
    %progressbar(['going throught   ',num2str(length(metafiles)),'  metafiles'],char(metafiles(metafilenum)),'passive membrane properties','active membrane properties','active membrane properties 2');
    %progressbar((metafilenum-1)/length(metafiles),[],[],[],[]);
    
    load([sourcepath,'/metadata/',char(metafiles(metafilenum))]);	%load goodIVs
   %GoodIVs=GoodIVs.GoodIVs;
    
    setupnames=fieldnames(GoodIVs); %list of good IV-s
    

    
    %loop through setupnames
    for setupnum=1:length(setupnames)
        setupname=char(setupnames(setupnum));
        i=0;
        
        %loop through all IV of the setup
        while i<size(GoodIVs.(setupname),2)
            i=i+1;
            %for i=1:size(GoodIVs.(setupname),2)
            
            %if given setup directory exists and not a copy
            if ~isempty(GoodIVs.(setupname)(1,i).dir) && ~any(strfind(GoodIVs.(setupname)(1,i).fname,'ásolat'))
                
                fpath=GoodIVs.(setupname)(1,i).dir;                                 %get directory name
                %pathvar=fpath(length(ivpath)+1:end);
                pathvar=fpath(length('/data/mount/TGTAR_1/MATLABdata/IV')+1:end);   %hard coded path should be removed
                pathvar
                fpath=[datapath,pathvar];
                fname=GoodIVs.(setupname)(1,i).fname;                               %get setup file name
                
                if ~strcmp(fname, '1303224rm.mat')      %only one file should be examined
                    continue;
                end
                    
                cellnames=GoodIVs.(setupname)(1,i).ivnames;
                                
                fnamenew=fname(1:findstr(fname,'.')-1);              
                fnamenew=['elfiz',fnamenew];
                fnamenew(fnamenew=='-')='_';
                %fnamenew(fnamenew=='ű')=[];
                
                temp=dir([datapath,pathvar,'/','data_iv_',fname]);	%get the data_iv file
                
                if isempty(temp) && dotheanalyze==1;		%if data_iv file is not exists, and we would like to do the analysis
                    
                    temp=load([fpath,'/',fname])			%temp is the data file
                    
                    return;
                    iv.(fnamenew)=temp.iv;
                    clear temp;
                    
                    %tempcom=textread(commfile,'%s');
                    %tempcom=char(tempcom);
                    
                    %if ~strcmp(GoodIVs.(setupname)(1,i).fname,tempcom)
                    if 1
                        %lock the current file
                        %outfile = fopen(commfile, 'wt' ); % ,'b','UTF-7');
                        %fprintf(outfile,'%s\r\n', fname);
                        %fclose(outfile);
                        for ii=1:length(cellnames)
                            
                            cellname=char(cellnames(ii));
                            if isnan(GoodIVs.(setupname)(1,i).holding(ii)) || isempty(GoodIVs.(setupname)(1,i).v0) || GoodIVs.(setupname)(1,i).v0(ii)>v0max || GoodIVs.(setupname)(1,i).holding(ii)<holdingmin || GoodIVs.(setupname)(1,i).holding(ii)>holdingmax || GoodIVs.(setupname)(1,i).sweepnum(ii)<minsweepnum || GoodIVs.(setupname)(1,i).firstcurrent(ii)>=0 || GoodIVs.(setupname)(1,i).lastcurrent(ii)<=0%GoodIVs.(setupname)(1,i).firstcurrent(ii)+GoodIVs.(setupname)(1,i).step(ii)*(GoodIVs.(setupname)(1,i).sweepnum(ii)-1)<=0
                                disp([cellname,' -- fail']);
                            else
                                temphossz=[];
                                for tempi=1:iv.(fnamenew).(cellname).sweepnum
                                    temphossz(tempi)=length(iv.(fnamenew).(cellname).(['v',num2str(iv.(fnamenew).(cellname).sweepnum)]));
                                end
                                if ~sum(temphossz==length(iv.(fnamenew).(cellname).time))
                                    disp([cellname,' -- fail not equal sweeps']);
                                elseif iv.(fnamenew).(cellname).time(end)<sum(iv.(fnamenew).(cellname).segment(1:2)/1000)
                                    disp([cellname,' -- fail not correct segments']);
                                else
                                    
                                    disp(cellname);
                                    
                                    data.(fnamenew).(cellname).pass=mpassive(iv.(fnamenew).(cellname),cellname);
                                    data.(fnamenew).(cellname).HH = mHH(iv.(fnamenew).(cellname),data.(fnamenew).(cellname).pass.dvrs);
                                    data.(fnamenew).(cellname)=offsetvoltage(data.(fnamenew).(cellname), iv.(fnamenew).(cellname));
                                    datasum.(fnamenew).(cellname)= calculateelfiz(iv.(fnamenew).(cellname),data.(fnamenew).(cellname));
                                    %                     fnamenew
                                    %                     progress=progress+1;
                                    %                     progress/length(fnames)
                                    %             %     pause(2);
                                    %             %     if mod(progress,10)==0
                                    %             %         close all;
                                    %             %     end
                                    plotiv(cellname, iv.(fnamenew), datasum.(fnamenew), data.(fnamenew), 1, 1000);
                                    saveas(gcf,[picturepath_iv,pathvar,'/',fnamenew,'_',cellname,'.jpg']);
                                    %close(gcf);
                                    %
                                end
                            end
                        end
                        if exist('data','var');
                            save([datapath,pathvar,'/','data_iv_',fname], 'data', 'iv');
                            clear data
                        end
                        clear iv
                        %             datasum=rmfield(datasum,fnamenew);
                    end
                else
                end
            end
            %%% datasum legyártása még1x
            if ~exist('datasum','var')
                datasum=struct;
            end
            
            %display([datapath,pathvar,'/','data_iv_',fname]);
            %display(~isfield(datasum,fnamenew));
            %display(sum(strcmpi(fname(1:9),texps))>0);
            if dothedatasum==1 && ~isempty(dir([datapath,pathvar,'/','data_iv_',fname])) && ~isfield(datasum,fnamenew) && sum(strcmpi(fname(1:9),texps))>0 %&& ~isempty(str2num(fname(1:length(num2str(startingdate))))) && str2num(fname(1:length(num2str(startingdate))))>startingdate
                clear temp
                temp=load([datapath,pathvar,'/','data_iv_',fname],'data');
                if  ~isfield(temp.data,fnamenew) %length(fieldnames(temp.data))>1 ||
                    delete([datapath,pathvar,'/','data_iv_',fname]);
                    i=i-1;
                else
                    cellnames=fieldnames(temp.data.(fnamenew));
                    for ii=1:length(cellnames)
                        cellname=char(cellnames(ii));
                        if sum(temp.data.(fnamenew).(cellname).HH.apnum)>0
                            tt=load([datapath,pathvar,'/','data_iv_',fname],'iv');
                            temp.iv=tt.iv;
                            datasum.(fnamenew).(cellname)= calculateelfiz(temp.iv.(fnamenew).(cellname),temp.data.(fnamenew).(cellname));
                            datasum.(fnamenew).(cellname).pathandfname={[datapath,pathvar],['/','data_iv_',fname]};
                            datasum.(fnamenew).(cellname).timesincemidnight=GoodIVs.(setupname)(1,i).timestart(ii);
                        end
                    end
                end
                clear temp;
            end
            dontdothis=0;
            %%% datasum legyártása még1x
            progressbar([],i/size(GoodIVs.(setupname),2));
        end
    end
    progressbar(metafilenum/length(metafiles));
end
if dothedatasum==1
    save([datapath,'/datasum'],'datasum');
end

%unlock every file
outfile = fopen(commfile, 'wt' );
fprintf(outfile,'%s\r\n', '');
fclose(outfile);