function M = growMatrix(mat, m, n)
	M = mat;
	M = [M, repmat(0, size(M,1), n-size(M,2))];
end