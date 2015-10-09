function featuresandisi = calculateFeaturePerBeforeIsi()

%     ahp10perISI
%     concavity
%     apEnd5threshold5DiffMax
%     thresholdVRealdvMinVRealDiffMax
%     halfWidthStartdvMaxDiff


    dirs = ['A','B'];
    rawDir = '/media/borde/Data/mdata/HumanAACBC/';
    baseDir = '/media/borde/Data/mdata/IV/HumanAACBC/';
    
    load('/home/borde/Munka/Adatok/apFeatures.mat');

    featuresandisi = {};
    
    %loop through classes
    for i = 1 : length(dirs)
        %list cell files
        label = dirs(i);
        files = dir([baseDir,label]);
        
        %loop through files
        for j = 1 : length(files)
            
          cellfeatures = [];
            
          if files(j).isdir
             continue; 
          end
          
          fname = files(j).name;
          fname_splitted = strsplit(fname, '_');
          
          rawname = fname_splitted{4};
          gsc = strcat(fname_splitted{5},'_',fname_splitted{6},'_',fname_splitted{7}(1:end-4));
          
          
          %load feature file
          load([baseDir,label,'/',fname]);
          load([rawDir,rawname]);
          time = iv.(gsc).time;
          
          fprintf('%s loaded\n', fname);
          
          sinterval = 1/cellStruct.samplingRate;
          apFeatures = cellStruct.apFeatures;
          
%     ahp10perISI
%     concavity
%     apEnd5threshold5DiffMax
%     thresholdVRealdvMinVRealDiffMax
%     halfWidthStartdvMaxDiff          
          
          ISI = apFeatures(:,featS.ISI);
          firstap = (ISI==0);
          notfirstap = logical(ones(size(firstap))-firstap);
          lastap = [ firstap(2:end) ; 1 ];
          notlastap = logical(ones(size(lastap))-lastap);
          
          if sum(notfirstap)==0
              continue;
          end
          
          ahp05 = cellStruct.ahp05(:,2);
          concavity = cellStruct.concavity;
          
          apend = time(apFeatures(:,featS.apEndPos));
          threshold = time(apFeatures(:,featS.thresholdPos));
          
          halfwidthStart = apFeatures(:,featS.halfWidthStart);
          dvMax = apFeatures(:,featS.dvMaxT);
          
          thresholdV = apFeatures(:,featS.thresholdVReal);
          dvMinV = apFeatures(:,featS.dvMinVReal);
          
          
          
          
          apend_threshold_diff = apend - threshold;
          thresholdV_dvMinV_diff = thresholdV - dvMinV;
          
          halfwidthstart_dvmax_diff = halfwidthStart - dvMax;
          
          cellfeatures = [ ISI(notfirstap) , ahp05 , concavity , apend_threshold_diff(notlastap) , thresholdV_dvMinV_diff(notlastap) , halfwidthstart_dvmax_diff(notlastap) ];
          
          idx = length(featuresandisi)+1;
          
          featuresandisi{idx}.ID = fname;
          featuresandisi{idx}.label = i;
          featuresandisi{idx}.features = cellfeatures;
          
        end
    end

end