function printTopFeatures(best,featureList)
  for i = 3:length(best)
    f = fopen(['bestFeatures',num2str(i),'s.txt'],'w');
    R = best(i).R;
    for k=1:size(R,1)
      for j = 1 : i  
        fprintf(f,"%s\t",featureList{R(k,j)}); 
      end; 
      fprintf(f,"%f\t%d\n",R(k,end-1),R(k,end)); 
      end
      fclose(f);
    end
end