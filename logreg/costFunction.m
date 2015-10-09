function [J grad] = costFunction(theta, X, y)
	m = length(y);	%number of examples
	J = 0;
	grad=(zeros(m));
	
	ht = sigmoid(X*theta);
	
	J = 1/m * sum(-y' .* log(ht) - (ones(m,1) - y' ) .* log(1-ht));
	
	grad = 1/m * X' * (ht - y');
end

