for k = 1 : 7
  F = [];
  for i = 1 : length(L)
   for j = 1 : size(L{i}(k).F,1)
       F(:,2:end)
       L{i}(k).F(j,:)
     if size(F(:,2:end),1)==0
         F = [ F ; 1 L{i}(k).F(j,:) ];
     else
         [im, id] = ismember(F(:,2:end),L{i}(k).F(j,:),'rows');
         if size(im,1)==0 || sum(im)==0
           F = [ F ; 1 L{i}(k).F(j,:) ];
         else
           F(find(id==1),1) = F(find(id==1),1)+1;
         end
     end
   end
  end
  if size(F,1)>0
     remidx = find(F(:,1)<10);
     F(remidx,:)=[];
     F = F(:,2:end);
  end
  Lee(k).F = F;
end