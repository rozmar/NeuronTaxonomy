samenum = 0; 
for i = 1 : length(fn) 
  id = fn{i}; 
  for j = i+1 ; length(fn) ; 
    if strcmp(fn{j},id)==1 && strcmp(g{i},g{j})==1
      if samenum==0
        thesame(1).id = id;
        thesame(1).g =  g{j};  
        thesame(1).s = s{i};
      end
      samenum++;
      thesame(samenum).s = [ thesame(samenum).s ; s{j} ];
    end;
  end
end