function [features,checkfeatures,ids] = selectdvMaxVApMaxVBySpike()
    dirs = ['A','B'];
    baseDir = '/media/borde/Data/mdata/IV/HumanOedema/';
    rawDir = '/media/borde/Data/mdata/HumanOedema/';
    load('/home/borde/Munka/NeuroScience/featureextractors/apFeatures.mat');
    checkfeatures = [];
    features = [];
    ids = {};
    
    for i = 1 : length(dirs)
       %list cell files
       files = dir([baseDir,dirs(i)]);
       for j = 1 : length(files)
          if files(j).isdir
             continue; 
          end
          
          curfeat = [];
          
          %load cell file
          load([baseDir,dirs(i),'/',files(j).name]);
          
          %load raw iv to get time
          fname_long = strsplit(files(j).name,'_');
          fname = fname_long{4};
          gsc = strcat(fname_long{5},'_',fname_long{6},'_',fname_long{7}(1:end-4));
          load([rawDir,fname]);
          iv = iv.(gsc);
          
          time = iv.time;
          
          %get the aps' features
          apFeatures = cellStruct.apFeatures;
          v0 = cellStruct.v0;
          
          %which sweeps had ap?
          sweepNumbers = unique(apFeatures(:,1));
          %examine all sweep
          for s = 1 : size(sweepNumbers,1)
            %aps in this sweep
            currentSweepAPs = apFeatures(apFeatures(:,1)==sweepNumbers(s),2:end);
            currentSweepAPs = [ (1:size(currentSweepAPs,1))' , currentSweepAPs ];
            
            %select features
            currentFeatures = currentSweepAPs(:,[1,featS.apMaxPos,featS.apMaxReal,featS.dvMaxVReal]);            
            currentFeatures = [ currentFeatures , ones(size(currentFeatures,1),1)*v0(sweepNumbers(s)) ];
            
            %calculate ap diffs
            apDiffs = time(currentFeatures(2:end,2))-time(currentFeatures(1:end-1,2));
            apDiffs = [ 0.8 ; apDiffs ];
            
            features = [ features ; currentFeatures(:,1) , apDiffs , currentFeatures(:,3)-currentFeatures(:,4) , currentFeatures(:,4)-currentFeatures(:,5) , ones(size(currentFeatures,1),1)*i ];
            curfeat = [ curfeat ; currentFeatures(:,3)-currentFeatures(:,4) , currentFeatures(:,4)-currentFeatures(:,5) ];
            
            for a = 1 : size(currentFeatures,1)
               ids{length(ids)+1} = files(j).name; 
            end
          end
          
          checkfeatures = [ checkfeatures ; nanmean(curfeat(:,1)) min(curfeat(:,2)) ];
          
       end
    end
    
end