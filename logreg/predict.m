function p = predict(theta,X)
	m = size(X,1);
	p= sigmoid(X*theta);
end