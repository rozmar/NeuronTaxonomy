function [confmat theta missedIndex] = runLogReg(trainingSet, validationSet,printStat)
	X = trainingSet(:,1:end-1);
	y=trainingSet(:,end)';
	[m, n] = size(X);		%get sizes: m= number of samples, n=number of features
	X = [ones(m, 1) X];		%add one vector to the beginning (x_0)
	
	initial_theta = zeros(n + 1, 1);			%initial value of theta
	[cost, grad] = costFunction(initial_theta, X, y);		%initial cost, and gradient
	
	options = optimset('GradObj', 'on', 'MaxIter', 400);

	%  Run fminunc to obtain the optimal theta
	%  This function will return theta and the cost 
	[theta, cost] = ...
		fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);
		
	%printf("Optimal cost found: %f\n", cost);

	p = predict(theta, X);
	%printf("Accuracy on the train set: %.2f%%\n", mean(double(int8(p) == y')) * 100);
	
	V= validationSet(:,1:end-1);
	yv=validationSet(:,end)';
	V = [ones(size(V,1),1) V];
	
	pV = predict(theta, V);
	acc = mean(double(int8(pV) == yv'));
	tp = length(intersect(find(yv'==int8(pV)),find(yv'==1)));
	tn = length(intersect(find(yv'==int8(pV)),find(yv'==0)));
	fp = length(intersect(find(yv'~=int8(pV)),find(yv'==0)));
	fn = length(intersect(find(yv'~=int8(pV)),find(yv'==1)));
	
	confmat = [ tp fp fn tn ];
	
	missedIndex = find(yv'~=int8(pV));
	
	if printStat==2
		printf("%d/%d correct, %d/%d incorrect\n", length(find(yv'==int8(pV))), length(yv') , length(find(yv'~=int8(pV))), length(yv'));
		printf("%d/%d positive, %d/%d negative found\n",length(intersect(find(yv'==int8(pV)),find(yv'==1))), length(yv'(find(yv'(:)==1))) , length(intersect(find(yv'==int8(pV)),find(yv'==0))), length(yv'(find(yv'(:)==0))));
		%yv'(find(yv'~=int8(pV)))
		printf("Accuracy %f\n", mean(double(int8(pV) == yv')) * 100);
	end
	
end
