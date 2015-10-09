function out=test_pred(in)
	theta = reshape(in(1:2),2,1);
	X = reshape(in(3:8),2,3)';
	out = predict(theta, X)';
end