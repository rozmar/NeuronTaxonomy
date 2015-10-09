
function collectUprisingFromDir(ivinputdir,cellinputdir,outputdir)
  files=dir(cellinputdir);
  load('/home/borde/Munka/Adatok/apFeatures.mat');
  
  for i = 1 : length(files)
    if files(i).isdir
      continue;
    end
    tmp = strsplit(files(i).name,'_');
    fprintf('%s\n', files(i).name);
    if length(tmp)==8
      cellname = strcat('data_iv_',tmp(3),'_',tmp(4),'_',tmp(5),'_',tmp(6),'_',tmp(7),'_',tmp(8));
      outname = strcat('uprising_',tmp(3),'_',tmp(4),'_',tmp(5),'_',tmp(6),'_',tmp(7),'_',tmp(8));
      rawfname = tmp{5};
      chan = strsplit(tmp{8},'.');
      gsc = strcat(tmp(6),'_',tmp(7),'_',chan(1));
    else 
      cellname = strcat('data_iv_',tmp(3),'_',tmp(4),'_',tmp(5),'_',tmp(6),'_',tmp(7));
      outname = strcat('uprising_',tmp(3),'_',tmp(4),'_',tmp(5),'_',tmp(6),'_',tmp(7));
      rawfname = tmp{4};
      chan = strsplit(tmp{7},'.');
      gsc = strcat(tmp(5),'_',tmp(6),'_',chan(1));
    end
   
    cellfull = strcat(cellinputdir,'/',cellname);
    ivfull = strcat(ivinputdir,'/',rawfname);
    cell = load(cellfull{1});
    cell = cell.cellStruct;
    iv = load(ivfull);
    iv = iv.iv.(gsc{1});
    
    apf = cell.apFeatures;
    
    sweepNumbers = unique(apf(:,1));
    adps = [];
    
    for j = 1 : size(sweepNumbers,1)
      apfsub = apf(apf(:,1)==sweepNumbers(j),:);
      if size(apfsub,1)<2
        continue;
      end  
      
      ahp090sub = cell.ahp090(cell.ahp090(:,1)==sweepNumbers(j),2);

      adps = [ adps ; apfsub(1:end-1,1) , apfsub(1:end-1,featS.ahpPos) , round((apfsub(1:end-1,featS.ahpT)+ahp090sub)*cell.samplingRate)+2 apfsub(1:end-1,featS.ISI) ];
    end
        
    uprising = {};
    
    Y = sweepToMatrix(iv);
       
    for j = 1 : size(adps,1)
      if isnan(adps(j,3))
         continue;
      end
      uprising{j}.iv = Y(adps(j,1), (adps(j,2):adps(j,3)));
      uprising{j}.time = iv.time((adps(j,2):adps(j,3)));
      uprising{j}.ISI = adps(j,4);
    end
    
    save([outputdir,'/',outname{1}],'uprising');
        
  end
end
