function [featureperAfterIsi,ids] = calculateFeaturePerAfterIsi()

    dirs = ['A','B'];
    rawDir = '/media/borde/Data/mdata/HumanAACBC/';
    baseDir = '/media/borde/Data/mdata/IV/HumanAACBC/';
    
    load('/home/borde/Munka/Adatok/apFeatures.mat');

    featureperAfterIsi = [];
    ids = {};
    
    %loop through classes
    for i = 1 : length(dirs)
        %list cell files
        label = dirs(i);
        files = dir([baseDir,label]);
        
        %loop through files
        for j = 1 : length(files)
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
          
          apmax = time(apFeatures(:,featS.apMaxPos));
          threshold = time(apFeatures(:,featS.thresholdPos));
          apend = time(apFeatures(:,featS.apEndPos));
          ahp = apFeatures(:,featS.ahpT);
          halfwidth = apFeatures(:,featS.halfWidthLength);
          dvMax = apFeatures(:,featS.dvMaxT);
          dvMin = apFeatures(:,featS.dvMinT);
          ISI = apFeatures(:,featS.ISI);

          threshold_apmax_diff = (apmax-threshold);
          apmax_apend_diff = (apend-apmax);
          apend_ahp_diff = (ahp-apend);
          threshold_dvmax_diff = (dvMax-threshold);
          dvmax_apmax_diff = (apmax-dvMax);
          apmax_dvmin_diff = (dvMin - apmax);
          dvmin_apend_diff = (apend-dvMin);
          
          firstap = find(ISI==0);
          lastap = find(ISI==0)-1;
          lastap = [ lastap(2:end) ; size(ISI,1) ];
          
          threshold_apmax_diff(lastap) = [];
          apmax_apend_diff(lastap) = [];
          apend_ahp_diff(lastap) = [];
          threshold_dvmax_diff(lastap) = [];
          dvmax_apmax_diff(lastap) = [];
          apmax_dvmin_diff(lastap) = [];
          dvmin_apend_diff(lastap) = [];
          ISI(firstap) = [];

          threshold_apmax_diff = threshold_apmax_diff./ISI;
          apmax_apend_diff = apmax_apend_diff./ISI;
          apend_ahp_diff = apend_ahp_diff./ISI;
          threshold_dvmax_diff = threshold_dvmax_diff./ISI;
          dvmax_apmax_diff = dvmax_apmax_diff./ISI;
          apmax_dvmin_diff = apmax_dvmin_diff./ISI;
          dvmin_apend_diff = dvmin_apend_diff./ISI;
          apend_ahp_diff = dvmin_apend_diff./ISI;
          
          featureperAfterI = [ threshold_apmax_diff apmax_apend_diff apend_ahp_diff threshold_dvmax_diff dvmax_apmax_diff apmax_dvmin_diff dvmin_apend_diff apend_ahp_diff repmat(i,size(ISI,1),1) ];
              if size(featureperAfterI,1)~=0
                %featureperAfterIsi = [ featureperAfterIsi ;  mean(featureperAfterI(1:min(10,size(featureperAfterI,1)),:)) ];
                featureperAfterIsi = [ featureperAfterIsi ;  featureperAfterI ];
              end
        end
    end

end