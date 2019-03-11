function [h, m, s] = als_realtime2hms( realtime )

t = seconds(realtime);
[h, m, s] = hms(t);

end

