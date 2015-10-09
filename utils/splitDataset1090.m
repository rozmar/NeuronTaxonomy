%Splits the given dataset 90/10 proportion.
%
%Divide the whole dataset into 10 equal (semi-equal) long set
%and select the which10 as test, the remaining train.
function [ninety ten] = splitDataset1090(dataset,which10)
	tenth = round(rows(dataset)/10);			%number of the 10% set
	stepsize = ((size(dataset,1)-tenth+2)-(1+tenth))/8;	%the first and last tenth number element must be in mask, so divide the remaining distance
	mask = ones(size(dataset,1),1);			%mask for selecting: 1 in the 90%, 0 in the 10%
	
	tenthStartIndex=floor(1+(which10-1)*stepsize);	%interval of the 10%
	tenthEndIndex = tenthStartIndex+tenth-1;
	if tenthEndIndex>size(dataset,1)
		tenthEndIndex=size(dataset,1);
	end
	
	mask(tenthStartIndex:tenthEndIndex,:)=0;		%modify the mask

	%split the data
	ninety = dataset(find(mask==1),:);
	ten = dataset(find(mask==0),:);
end