function condition = createCondition(markerName, interval, type)
  condition = struct('type',type,'interval', interval, 'marker', markerName);
end