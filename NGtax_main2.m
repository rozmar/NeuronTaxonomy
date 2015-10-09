function  NGtax_main2(fpath,fname,sourcepath,pathvar)	
				
	%kezdeti paraméterek
	minsweepnum=6;
	v0max=-.03;
	holdingmin=-500;
	holdingmax=5000;
	stepneeded=20;
	dontdothis=0;
	dothedatasum=1;
	
	
	%create new file name
	fnamenew=['elfiz',fname(1:findstr(fname,'.')-1)];
	fnamenew(fnamenew=='-')='_';

	temp=load([fpath,'/',fname]);			%temp is the data file
	cellnames=fieldnames(temp.iv);			%collect cellnames
      	datapath=[sourcepath,'/IV/'];
	ivpath=[sourcepath,'/IV'];
	picturepath_iv=[sourcepath,'/pictures/IV/'];

	iv.(fnamenew)=temp.iv;			%save the loaded data to iv.(fnamenew)
	
	clear temp;

      if dontdothis==0
	%loop through the cells
	for i=1:length(cellnames)

		cell=iv.(fnamenew).(cellnames{i});	%get the current cell's sturct
		cellname=cellnames{i};

		%if cell's holding is not a number OR
		%cell's first value greater than permitted maximal v0 OR
		%cell's holding isn't in the permitted interval OR
		%number of sweep less than min sweepnum OR
		%cell's first I not negative OR
		%cell's last I is negative, then FAIL
		if isnan(cell.holding) || cell.v1(1)>v0max || cell.holding<holdingmin || cell.holding>holdingmax || cell.sweepnum<minsweepnum || cell.current(1)>=0 || cell.current(length(cell.current))<=0
			disp([cellname,' -- fail']);
		else
			temphossz=[];
			
			%loop through all sweep, store the length of the sweeps
			for j=1:cell.sweepnum
				temphossz(j)=length(cell.(['v',num2str(j)]));
			end
						
			if ~sum(temphossz==length(cell.time))	%not equal long sweeps
				disp([cellname,' -- fail not equal sweeps']);
			elseif cell.time(end)<sum(cell.segment(1:2)/1000)	%sweep too short
				disp([cellname,' -- fail not correct segments']);
			else
				disp(cellname);
				
				data.(fnamenew).(cellname).pass=mpassive(cell,cellname);
				data.(fnamenew).(cellname).HH = mHH(cell,data.(fnamenew).(cellname).pass.dvrs);
				data.(fnamenew).(cellname)=offsetvoltage(data.(fnamenew).(cellname), cell);
				datasum.(fnamenew).(cellname)= calculateelfiz(cell,data.(fnamenew).(cellname));
				plotiv(cellname, iv.(fnamenew), datasum.(fnamenew), data.(fnamenew), 1, 1000);
				saveas(gcf,[picturepath_iv,pathvar,'/',fnamenew,'_',cellname,'.jpg']);
			end
		end
	end
	
	if exist('data','var');
		save([datapath,pathvar,'/','data_iv_',fname], 'data', 'iv');
		clear data
	end
	
	clear iv;

      end
	%datasum legyártása még1x
	if ~exist('datasum','var')
		datasum=struct;
	end

	if dothedatasum==1 && ~isempty(dir([datapath,pathvar,'/','data_iv_',fname])) && ~isfield(datasum,fnamenew)
		clear temp
		temp=load([datapath,pathvar,'/','data_iv_',fname],'data');
		cellnames=fieldnames(temp.data.(fnamenew));
		for ii=1:length(cellnames)
			cellname=char(cellnames(ii));
			if sum(temp.data.(fnamenew).(cellname).HH.apnum)>0
				tt=load([datapath,pathvar,'/','data_iv_',fname],'iv');
				temp.iv=tt.iv;
				datasum.(fnamenew).(cellname)= calculateelfiz(temp.iv.(fnamenew).(cellname),temp.data.(fnamenew).(cellname));
				datasum.(fnamenew).(cellname).pathandfname={[datapath,pathvar],['/','data_iv_',fname]};
			#	datasum.(fnamenew).(cellname).timesincemidnight=GoodIVs.(setupname)(1,i).timestart(ii);
			end
		end
		clear temp;
	end
	dontdothis=0;
	%datasum legyártása még1x vége
	
	%progressbar([],i/size(GoodIVs.(setupname),2));

	if dothedatasum==1
		save([datapath,'/datasum_',fname],'datasum');
	end;
