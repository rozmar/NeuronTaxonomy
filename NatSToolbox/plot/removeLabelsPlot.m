% removeLabelsPlot function removes all label 
% from the actual figure.
function removeLabelsPlot()
    %Delete labels
    ph = findall(gca,'type','text');    
    ps = get(ph, 'string');
    for i = 1 : length(ps)
        ps{i} = '';
    end
    set(ph,{'string'},ps);
end