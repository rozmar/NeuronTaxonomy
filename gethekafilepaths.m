function [pathsout,alldata]=gethekafilepaths(listPath,listName,defPath)
%gethekafilepaths searches for paths of specified files in the defPath directory

% defPath='/home/rozmar/Mount/TGTAR_1/HEKAdata';
% listPath='/home/rozmar/Downloads';
% listName='mg.txt';
disp(['indexing datafiles']);
dirstocheck={defPath};
fnames=cell(0);
paths=cell(0);
while ~isempty(dirstocheck)
    dirnow=char(dirstocheck(1));
    fnamestemp=dir(dirnow);
    fnamestemp(strcmp({fnamestemp.name},'.')|strcmp({fnamestemp.name},'..'))=[];
    diridxes=find([fnamestemp.isdir]);
    fileidxes=find(~[fnamestemp.isdir]);
    for i=1:length(diridxes)
        dirstocheck=[dirstocheck,{[dirnow,'/',fnamestemp(diridxes(i)).name]}];
    end
    for i=1:length(fileidxes)
        fnames=[fnames,{[fnamestemp(fileidxes(i)).name]}];
        paths=[paths,{[dirnow]}];
    end
    dirstocheck(1)=[];
end
if ~isempty(listPath)
    [cls, id, name, ivname] = readInFileList(listPath,listName);
    for fnum=1:length(name)
        fnameidx(fnum)=find(strcmp(fnames,[char(name(fnum)),'.mat']),1,'first');
    end
    pathsout=paths(fnameidx);
    disp(['indexing finished']);
else
    pathsout=[];
end
    alldata.fnames=fnames;
    alldata.paths=paths;
end