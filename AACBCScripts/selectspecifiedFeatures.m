function [ahpperIsi,ids] = selectspecifiedFeatures()

    dirs = ['A','B'];
    baseDir = '/media/borde/Data/mdata/Uprising/AACBC/';

    ahpperIsi = [];
    ids = {};
    
    
    for i = 1 : length(dirs)
       %list cell files
       files = dir([baseDir,dirs(i)]);
       label = dirs(i);
       
       for j = 1 : length(files)
          if files(j).isdir
             continue; 
          end
          
          fname = files(j).name;
          
          %load uprising file
          load([baseDir,label,'/',fname]);
          
          fprintf('%s loaded\n', fname);
            
          ahpperI = [];
          for u = 1 : length(uprising)-1
              
              if isempty(uprising{u}) | isempty(uprising{u+1})
                 continue; 
              end
              
%               if uprising{u}.ISI~=0
%                   continue;
%               end
              
              if uprising{u+1}.ISI==0
                  continue;
              end
             
              time = uprising{u}.time;
              iv = uprising{u}.iv;
              ISI = uprising{u+1}.ISI;
                               
              ahpadpD = iv(end)-iv(1);
                            
              ahpperISI = [];
              for n = 1 : 100
                  ahpNF = (find(iv>=iv(1)+(n/100)*ahpadpD,1,'first'));
                  ahpNL = (find(iv<iv(1)+(n/100)*ahpadpD,1,'last'));
                  if ahpNF==ahpNL
                      ahpNtime = time(ahpNF);
                  else
                      lambda = (iv(1)+(n/100)*ahpadpD-iv(ahpNL))/(iv(ahpNF)-iv(ahpNL));
                      ahpNtime = (time(ahpNF)*lambda+time(ahpNL)*(1-lambda)); 
                  end
                  if isempty(ahpNtime)
                      ahpNtime = 0;
                  end
                  ahpperISI = [ ahpperISI , (ahpNtime-time(1)) ];
              end
              
              ahpperISI = ahpperISI ./ (ones(1,size(ahpperISI,2))*ISI);
              ahpperI = [ ahpperI ; ahpperISI ];
                            
              
                          
%               if size(ahpperI,1)==10
%                  break; 
%               end
              
          end          

          if size(ahpperI,1)==1
            ahpperIsi = [ ahpperIsi ; ahpperI , i ];
          elseif size(ahpperI,1)==0
              continue;
          else
            mahhperI = [];
            for n = 1 : 100 
               mahhperI(n) = min(deleteoutliers(ahpperI(:,n))); 
            end
            ahpperIsi = [ ahpperIsi ; mahhperI , i ];
          end
          ids{length(ids)+1} = fname;
          clear uprising;
       end
       
    end
end