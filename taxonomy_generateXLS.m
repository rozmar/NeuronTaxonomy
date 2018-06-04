% function taxonomy_generateXLS
locations=marcicucca_locations;
defPath=[locations.tgtardir,'MATLABdata/TreeData'];
[pathsout,alldata]=gethekafilepaths([],[],defPath);
%%
clear AllLongSquares
neededfiles = find(~cellfun(@isempty,regexp(alldata.fnames,'ap')));
for filei=1:length(neededfiles)
    filename=alldata.fnames{neededfiles(filei)};
    dirname=alldata.paths{neededfiles(filei)};    
    load([dirname,'/',filename]);

    peridx=strfind(dirname,'/');
    setupname=dirname(peridx(end)+1:end);
    neededseries=find(~cellfun(@isempty,regexp({seriesdata.seriesname},'iv')) | ~cellfun(@isempty,regexp({seriesdata.seriesname},'IV')) | ~cellfun(@isempty,regexp({seriesdata.seriesname},'Long')) | ~cellfun(@isempty,regexp({seriesdata.seriesname},'long'))|~cellfun(@isempty,regexp({seriesdata.seriesname},'Long Square')));
    
    for seriesi=1:length(neededseries)
        if ~exist('AllLongSquares','var')
            NEXT=1;
        else
            NEXT=length(AllLongSquares)+1;
        end
        datatoadd=seriesdata(neededseries(seriesi));
        datatoadd.seriesnums=seriesnums(neededseries(seriesi),:)';
        datatoadd.filename=filename(1:end-4);
        datatoadd.pathtoTreeData=dirname;
        datatoadd.setup=setupname;
        
        if length(datatoadd.tracename)>1
            if any(strfind(datatoadd.seriesname,'-IV'))
                neededtrace=find(strcmp(datatoadd.tracename,'Vmon-4'));
            elseif any(strfind(datatoadd.seriesname,'-III'))
                neededtrace=find(strcmp(datatoadd.tracename,'Vmon-3'));
            elseif any(strfind(datatoadd.seriesname,'-II'))
                neededtrace=find(strcmp(datatoadd.tracename,'Vmon-2'));
            elseif any(strfind(datatoadd.seriesname,'-I'))
                neededtrace=find(strcmp(datatoadd.tracename,'Vmon-1'));
            end
            if isempty(neededtrace)
                disp('error - multiple traces, dunno what to use')
            end
              datatoadd.tracename=datatoadd.tracename(neededtrace);
              datatoadd.tracenum=datatoadd.tracenum(neededtrace);
              datatoadd.seriesnums(end)=1; 
        end
        if any(strfind(datatoadd.tracename{1},'Vmon'))
            AllLongSquares(NEXT)=datatoadd;
        end
    end
end
%%
clear toxls
xlspath=[locations.tgtardir,'ANALYSISdata/marci/_Taxonomy/Autopatcher/'];
for i=1:length(AllLongSquares)
    toxls(i,:)={1,i,AllLongSquares(i).filename,AllLongSquares(i).seriesnums(1),AllLongSquares(i).seriesnums(2),AllLongSquares(i).tracenum};%str2num(AllLongSquares(i).tracename{1}(end))
end

    path=[locations.matlabstuffdir,'20130227_xlwrite/'];
    javaaddpath([path 'poi_library/poi-3.8-20120326.jar']);
    javaaddpath([path 'poi_library/poi-ooxml-3.8-20120326.jar']);
    javaaddpath([path 'poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
    javaaddpath([path 'poi_library/xmlbeans-2.3.0.jar']);
    javaaddpath([path 'poi_library/dom4j-1.6.1.jar']);
    
delete([xlspath,'/autopatch.xls']);
xlwrite([xlspath,'/autopatch.xls'],toxls'','Sheet 1',['A1']);

save([xlspath,'autopatch_treedata'],'AllLongSquares');