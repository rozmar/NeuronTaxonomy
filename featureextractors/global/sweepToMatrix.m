% Converts more sweeps to one matrix.
%
% One row of the matrix represents an IV of a sweep.
function Y = sweepToMatrix(ivs) 
	Y = [];
	for i=1:ivs.sweepnum
		Y = [Y ; ivs.(['v',num2str(i)])'];
    end;
end