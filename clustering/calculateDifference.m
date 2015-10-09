


function avg = calculateDifference(idx1,idx2)

	cl1 = size(intersect(find(idx1==1), find(idx2==1)),2);
	cl2 = size(intersect(find(idx1==1), find(idx2==2)),2);

	if cl2>cl1
		idx2(idx2==2)=0;
		idx2(idx2==1)=2;
		idx2(idx2==0)=1;
    end
    
	avg = mean(idx1==idx2);

end