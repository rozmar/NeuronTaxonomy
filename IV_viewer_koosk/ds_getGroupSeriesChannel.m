function [group, series, channel] = ds_getGroupSeriesChannel(dsElement)
if isfield(dsElement, 'fname')
    % example: '1308311ap.mat_g1_s10_c3'
    gscExpr = '(.*).mat_g(?<group>\d+)_s(?<series>\d+)_c(?<channel>\d+)';
    gsc = regexp(dsElement.fname, gscExpr, 'names');
    group = str2double(gsc.group);
    series = str2double(gsc.series);
    channel = str2double(gsc.channel);
else
    error('Datasum element does not contain required field name ''fname''.');
end

end

