function taxonomy_generateTXTfromXLS(listPath,listName,xlsname,ivpercell)

locations=marcicucca_locations;
[~,alltheivdata]=gethekafilepaths([],[],[locations.tgtardir,'MATLABdata/IV']);

[num,txt,raw]=xlsread([listPath,'/',xlsname]);
a=dir([listPath,'/',listName]);
if ~isempty(a)
    delete([listPath,'/',listName]);
end
fileID = fopen([listPath,'/',listName],'w');
cleaner = onCleanup(@() fclose(fileID));
for i=1:size(raw,1);
    class=num2str(raw{i,1});
    id=num2str(raw{i,2});
    while length(id)<6
        id=['0',id];
    end
    fname=char(raw{i,3});
    g=num2str(raw{i,4});
    s=(raw{i,5});
    c=num2str(raw{i,6});

    fidx=find(strcmp([fname,'.mat'],alltheivdata.fnames),1,'first');
    
    if isempty(fidx)
       fprintf('%s missing\n', fname);
       continue; 
    else
       %fprintf('fidx = %d\n', fidx);
    end
    
    iv=load([alltheivdata.paths{fidx},'/',alltheivdata.fnames{fidx}]);
    iv=iv.iv;
    finames=fieldnames(iv);
    gs=[];
    ss=[];
    cs=[];
    for fieldnum=1:length(finames)
        finame=finames{fieldnum};
        hyps=strfind(finame,'_');
        gs(fieldnum)=str2num(finame(2:hyps(1)-1));
        ss(fieldnum)=str2num(finame(hyps(1)+2:hyps(2)-1));
        cs(fieldnum)=str2num(finame(hyps(2)+2:end));
    end

    if strcmp(g,'all')
        gidxes=ones(size(gs));
    elseif strcmp(g,'last')
        gidxes=zeros(size(gs));
        gidxes(end)=1;
    else
        gidxes=gs==str2num(g);
    end

    if ischar(s) && strcmp(s,'all')
        sidxes=ones(size(ss));
    elseif ischar(s) && strcmp(s,'last')
        sidxes=zeros(size(ss));
        sidxes(end)=1;
    elseif ischar(s) && any(strfind(s,','))
        vesszok=strfind(s,',');
        vesszok=[0,vesszok,length(s)+1];
        sidxes=zeros(size(ss));
        for ii=1:length(vesszok)-1
            snow=s(vesszok(ii)+1:vesszok(ii+1)-1);
            sidxes=sidxes|ss==str2num(snow);
        end

    else
        if ischar(s)
            s=str2num(s);
        end
        sidxes=ss==s;
    end

    idxestodo=gidxes &sidxes;

    if strcmp(c,'onlyone') && length(unique(cs(idxestodo)))==1
        cidxes=ones(size(cs));
    elseif length(c)==1
        cidxes=cs==str2num(c);
    else
        uniquechannels=(unique(cs(idxestodo)));
        Rs=[];
        for iii=1:length(uniquechannels)
            chidxsnow=find(cs==uniquechannels(iii));
            %
            for iiii=1:length(chidxsnow)
                finamenow=finames{chidxsnow(iiii)};
                xval=[];
                yval=[];
                for sweepnum=1:iv.(finamenow).sweepnum;
                    xval(sweepnum)=iv.(finamenow).current(sweepnum);
                    yval(sweepnum)=mean(iv.(finamenow).(['v',num2str(sweepnum)]));
                end
                p=polyfit(xval,yval,1);
                Rs(iiii,iii)=p(1);
            end
        end
        [~,idx]=max(mean(Rs));
        cidxes=cs==uniquechannels(idx);
    end
    idxestodo=idxestodo&cidxes;

    if isnumeric(ivpercell)
        eddig=min(ivpercell,length(find(idxestodo)));
    else
        eddig=length(find(idxestodo));
    end
    findexes=find(idxestodo);
    for iii=1:eddig
        gnow=num2str(gs(findexes(iii)));
        snow=num2str(ss(findexes(iii)));
        cnow=num2str(cs(findexes(iii)));
        fprintf(fileID,'\n%s %s %s %s %s %s',class,id,fname,gnow,snow,cnow);
    end

end

%fclose(fileID);

    
end