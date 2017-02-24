%
%
%
function processCellFromFile(fpath,fname,id,sourcepath,pathvar,cellname,dataDir)
	[locations]=marcicucca_locations;
	%kezdeti paraméterek
	minsweepnum=3;
	v0max=-.03;
	holdingmin=-500;
	holdingmax=5000;
	stepneeded=20;
	dontdothis=0;
	dothedatasum=0;
	
	
	%create new file name
	fnamenew=['elfiz',fname(1:findstr(fname,'.')-1)];
	fnamenew(fnamenew=='-')='_';
    %disp([fpath,'/',fname]);
	if exist([fpath,'/',fname])==0
		fprintf('File %s not exist.\n',fname);
		return
	end

	temp=load([fpath,'/',fname]);			%temp is the data file
	cellnames=fieldnames(temp.iv);			%collect cellnames
    datapath=[sourcepath];%,'/' ezt kivettem a sourcepath után, mert nekem nincsen projektkönyvtáram
					
	iv.(fnamenew)=temp.iv;			%save the loaded data to iv.(fnamenew)
	
	clear temp;
    
    onlyLast=0;             %only the specified sweep
    if regexp(cellname, 'g0_s0_c0')
       onlyLast=1;          %only the last sweep
       fprintf('Find the last IV, that is %s\n', cellnames{end});
       cellname = cellnames{end};
    elseif regexp(cellname, 'g\d_s0_c0') 
       onlyLast=2;          %all sweep in the same group
    end

	if dontdothis==0
		%loop through the cells
		for i=1:length(cellnames)
			
 			cellparts = strsplit(cellname,'_');
			if (onlyLast==2 & regexp(cellnames{i},['^',cellparts{1},'_']) ) | (onlyLast~=2 & regexp(cellnames{i},cellname))
            			
                cellname_current=cellnames{i};
                %fprintf('Current cellname: %s\n', cellname_current);

                if isfield(iv.(fnamenew),(strtrim(cellname_current)))==0
                    printf('%s cell doesnt exist.\n', strtrim(cellname_current));
                    continue
                end
                %fprintf('Processing %s\n',cellname_current);
                cell=iv.(fnamenew).(strtrim(cellname_current));	%get the current cell's sturct

                %if cell's holding is not a number OR
                %cell's first value greater than permitted maximal v0 OR
                %cell's holding isn't in the permitted interval OR
                %number of sweep less than min sweepnum OR
                %cell's first I not negative OR
                %cell's last I is negative, then FAIL

                if mode(diff(cell.current))>1000
                        disp(['current step ', num2str(mode(diff(cell.current))),' converted to ', num2str(mode(diff(cell.current))/1000000000)])
                        cell.current=cell.current/1000000000;
                        cell.realcurrent=cell.realcurrent/1000000000;
                        cell.holding=cell.holding/1000000000;
                end
                if isnan(cell.holding) %HOTFIX!!!!! cells with no holding potential are included...
                    cell.holding=0;
                end
                
                if isnan(cell.holding) 
                    disp([fname,'_',cellname_current,' -- fail - no holding potential']);
                elseif cell.v1(1)>v0max 
                    disp([fname,'_',cellname_current,' -- fail - v0 is greater than ',num2str(v0max)]);
                elseif cell.holding<holdingmin 
                    disp([fname,'_',cellname_current,' -- fail - holding current is smaller than ',num2str(holdingmin)]);
                elseif    cell.holding>holdingmax 
                    disp([fname,'_',cellname_current,' -- fail - holding current is greater than ',num2str(holdingmax)]);
                elseif cell.sweepnum<minsweepnum 
                    disp([fname,'_',cellname_current,' -- fail - sweepnum is less than ',num2str(minsweepnum)]);
                elseif ~(cell.current(1)<0) 
                    disp([fname,'_',cellname_current,' -- fail - first current is nonnegative -  ',num2str(cell.current(1))]);
                elseif cell.current(length(cell.current))<=0
                    disp([fname,'_',cellname_current,' -- fail - no injected current  recorded-  ',num2str(length(cell.current))]);
                else
                    temphossz=[];
                    
                    %loop through all sweep, store the length of the sweeps
                    for j=1:cell.sweepnum
                        temphossz(j)=length(cell.(['v',num2str(j)]));
                    end

                    if ~sum(temphossz==length(cell.time))	%not equal long sweeps
                        disp([fname,'_',cellname_current,' -- fail not equal sweeps']);
                    elseif cell.time(end)<sum(cell.segment(1:2)/1000)	%sweep too short
                        disp([fname,'_',cellname_current,' -- fail not correct segments']);
                    else
                        disp([fname,' ',cellname_current]);

                        cellStruct = featureExtract(cell,locations.taxonomy.fetureextractorlocation);
                        if isempty(cellStruct)
                          clear cellStruct;
                          disp([fname,'_',cellname_current,' -- no AP found']);
                        end
                    end
                end
                
                if exist('cellStruct','var');
                    %fprintf('Saving %s...\n',[datapath,pathvar,'/','data_iv_',id,'_',fname,'_',strtrim(cellname_current),'.mat']);
                    save([datapath,pathvar,'/','data_iv_',id,'_',fname,'_',strtrim(cellname_current),'.mat'], 'cellStruct');
                    clear cellStruct
                end                
            end
        end
		
		clear iv;
	
	    end
end
