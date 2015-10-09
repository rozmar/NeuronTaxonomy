
function [XKnown,yKnown] = makeKnownSet(X,y,ratio)

    knownSize = int64(sum(y==1)*ratio);

    onesIndex = find(y==1);
    zerosIndex = find(y==0);

    onesIndex = onesIndex(randperm(size(onesIndex,1)));
    zerosIndex = zerosIndex(randperm(size(zerosIndex,1)));

    yKnownIndices = [ onesIndex(1:knownSize) ; zerosIndex(1:knownSize) ];

    yKnown = y(yKnownIndices);
    XKnown = X(yKnownIndices,:);
end