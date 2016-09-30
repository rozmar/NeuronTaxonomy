function datasums = collect_specified_features_from_dir(ivinputDir,featinputDir,outputDir,savetheIV,clabel,extractor)
    if nargin<6
        extractor = @basic_features;
    end

	if nargin > 4
		clabel = ['/',clabel];
	else
		clabel = '/A';
	end			

	files=dir([featinputDir,clabel]);
	
    dsmatrix = [];
    datasums = struct;
    
    outputDir = [outputDir,clabel];
    
    if exist(outputDir)==0
       mkdir(outputDir); 
    end
    
    datasumnum = 0;
    for i = 1 : length(files)
        if strcmp(files(i).name,'.') || strcmp(files(i).name,'..')
            continue;
        end      
        datasumnum = datasumnum + 1;
        fname = files(i).name;
        parts = strsplit(fname,'_');
        if length(parts)==7
            id = parts{3};
            ivname = parts{4};
            cellname = [parts{5},'_',parts{6},'_',parts{7}(1:strfind(parts{7},'.')-1)];
        else
            id = strcat(parts{3},'_',parts{4});
            ivname = parts{5};
            cellname = [parts{6},'_',parts{7},'_',parts{8}(1:strfind(parts{8},'.')-1)];
        end
        
        %Load extracted features
        cell=load([featinputDir,clabel,'/',fname]);
        cell = cell.cellStruct;	
        if sum(cell.apNums)>0
            %Load Raw IV
            if strcmp(class(ivinputDir),'char')
                iv=load([ivinputDir,'/',ivname]);
            else
                fnameidx=find(strcmp(ivinputDir.fnames,ivname),1,'first');
                iv=load([ivinputDir.paths{fnameidx},'/',ivname]);
            end
            iv = iv.iv.(strtrim(cellname));
            if mode(diff(iv.current))>1000
                        disp(['current step ', num2str(mode(diff(iv.current))),' converted to ', num2str(mode(diff(iv.current))/1000000000)])
                        iv.current=iv.current/1000000000;
                        iv.realcurrent=iv.realcurrent/1000000000;
                        iv.holding=iv.holding/1000000000;
            end
                
            %Calculate specified features
            datasum = extractor(cell,iv.current,iv.time);
            if savetheIV==1
                datasum.iv=iv;
            end
            if length(fieldnames(datasums))==0
                datasums = datasum;
            else
                features = fieldnames(datasum);
                for f = 1 : length(features)
                    datasums(datasumnum).(features{f}) = datasum.(features{f});
                end
            end
            
            save([outputDir,'/datasum_',id,'_',ivname,'_',strtrim(cellname),'.mat'],'datasum');
            disp(['Processed ',fname]);
        else
            disp(['failed due to abscence of APs ',fname]);
        end
    end
    datasum = datasums;
    save([outputDir,'/../datasumMatrix.mat'],'datasum','-v7.3');
end
