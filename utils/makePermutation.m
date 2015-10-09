function PM = makePermutation(elementNum, permLength)
	maxNum = [];
	PM = [];
	actperm = ones(1,permLength);
	firstMax = elementNum-(permLength-1);
	for i=firstMax:elementNum
		maxNum = [ maxNum i ];
	end
	
	for i=1:permLength
		actperm(i)=i;
	end
	
	while 1
		PM = [ PM ; actperm ];
		k=permLength;
		while 1
			actperm(k) = actperm(k)+1;
			
			if actperm(k)<=maxNum(k)
				break;
			end
			
			k = k-1;
			
			if k==0
				break;
			end
		end
		
		if k==0
			break;
		end
		
		if k<permLength
			for i=k+1:permLength
				actperm(i)=actperm(i-1)+1;
			end	
		end
	end
end