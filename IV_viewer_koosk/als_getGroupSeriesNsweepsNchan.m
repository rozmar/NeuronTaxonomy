function [group, series, numSweeps, numChannel] = als_getGroupSeriesNsweepsNchan(alsElement)

if isfield(alsElement, 'seriesnums')
    % example: [1;10;27;1]
    group = alsElement.seriesnums(1);
    series = alsElement.seriesnums(2);
    numSweeps = alsElement.seriesnums(3);
    numChannel = alsElement.seriesnums(4);
else
    error('AllLongSquares element does not contain required field name ''seriesnums''.');
end


end

