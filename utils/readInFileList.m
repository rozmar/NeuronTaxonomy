function [cls id name iv] = readInFileList(fpath,fileName)
%Reads in the specified file from the given path.
%
%The file contains the list of IV's
%File format:
%class filename g s c
	file = [fpath,'/',fileName];			%absolute file name
	f=fopen(file,'r');				%open file
	[cls id name g s c] = textread(file,'%d %s %s %2d %3d %2d');	%read data
    %% HOTFIX - sometimes empty lines are read...
    todel=find(strcmp(name,''));
    if ~isempty(todel)
        cls(todel)=[];
        id(todel)=[];
        name(todel)=[];
        g(todel)=[];
        s(todel)=[];
        c(todel)=[];
    end
    %%
	%name=cell2mat(name);				%convert name to matrix
	iv = {};
	for i=1:size(cls,1)
        %iv_row = ['g',num2str(g(i)),'_s',num2str(s(i)),'_c',num2str(c(i))]
        iv_row = sprintf('g%d_s%d_c%d', g(i), s(i), c(i));
		iv{i} = iv_row; %generate iv names
	end
	fclose(f);					
	return;
end