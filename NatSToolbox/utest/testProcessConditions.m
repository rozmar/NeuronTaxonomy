%load file
fileName = 'E:\2016 szeptember\PYR\MATOriginal\Layer3\Rat72d5t2c3.mat';
S = load(fileName);

%% Test 1: Test delta without K-complex (before deltaend)
fprintf('Test 1: Test delta without K-complex (before deltaend)\n');
S.delta_st = S.deltast;
S.delta_end = S.deltaend;
S.Kcomplex = S.Kcomplex;
condition = struct('type',0,'interval',[-0.15,0],'marker','Kcomplex');
parameters = struct('triggerType', 'marker', 'triggerName', 'delta_end', 'conditions', condition);
selectedTriggers = processConditions(S, parameters);
assert(length(selectedTriggers)==length(S.delta_end.times), 'Not the same number of triggers remained');
assert(length(selectedTriggers)==length(S.delta_st.times), 'Not the same number of starts remained');
assert(sum(sort(selectedTriggers)~=sort(S.delta_end.times))==0, 'Not the same triggers retained.');

%% Test 2: Test delta without K-complex (in segment)
fprintf('Test 2: Test delta without K-complex (in segment)\n');
S.delta_st = S.deltast;
S.delta_end = S.deltaend;
S.Kcomplex = S.Kcomplex;
condition = struct('type',0,'interval',[],'marker','Kcomplex');
parameters = struct('triggerType', 'sectionend', 'triggerName', 'delta', 'conditions', condition);
selectedTriggers = processConditions(S, parameters);
assert(length(selectedTriggers)==length(S.delta_end.times), 'Not the same number of triggers remained (segmentwise)');
assert(length(selectedTriggers)==length(S.delta_st.times), 'Not the same number of starts remained (segmentwise)');
assert(sum(sort(selectedTriggers)~=sort(S.delta_end.times))==0, 'Not the same triggers retained. (segmentwise)');

%% Test 3: Test delta with K-complex (before deltaend)
fprintf('Test 3: Test delta with K-complex (before deltaend)\n');
S.delta_st = S.kdeltast;
S.delta_end = S.kdeltaend;
S.Kcomplex = S.Kcomplex;
condition = struct('type',1,'interval',[-0.15,0],'marker','Kcomplex');
parameters = struct('triggerType', 'marker', 'triggerName', 'delta_end', 'conditions', condition);
selectedTriggers = processConditions(S, parameters);
assert(length(selectedTriggers)==length(S.delta_end.times), 'Not the same number of triggers remained');
assert(length(selectedTriggers)==length(S.delta_st.times), 'Not the same number of starts remained');
assert(sum(sort(selectedTriggers)~=sort(S.delta_end.times))==0, 'Not the same triggers retained.');

%% Test 4: Test delta with K-complex (in segment)
fprintf('Test 4: Test delta with K-complex (in segment)\n');
S.delta_st = S.kdeltast;
S.delta_end = S.kdeltaend;
S.Kcomplex = S.Kcomplex;
condition = struct('type',1,'interval',[],'marker','Kcomplex');
parameters = struct('triggerType', 'sectionend', 'triggerName', 'delta', 'conditions', condition);
selectedTriggers = processConditions(S, parameters);
assert(length(selectedTriggers)==length(S.delta_end.times), 'Not the same number of triggers remained (segmentwise)');
assert(length(selectedTriggers)==length(S.delta_st.times), 'Not the same number of starts remained (segmentwise)');
assert(sum(sort(selectedTriggers)~=sort(S.delta_end.times))==0, 'Not the same triggers retained. (segmentwise)');

%% Test 5: Test delta with K-complex followed by spindle
fprintf('Test 5: Test delta with K-complex followed by spindle\n');
S.delta_st = S.kdeltast;
S.delta_end = S.kdeltaend;
S.Kcomplex = S.Kcomplex;
condition(1) = struct('type',1,'interval',[],'marker','Kcomplex');
condition(2) = struct('type',1,'interval',[0,0.15],'marker','spdl_0');
parameters = struct('triggerType', 'sectionend', 'triggerName', 'delta', 'conditions', condition);
assert(isfield(S, 'spdl_0'), 'No spdl channel found.');
assert(isfield(S, 'skdeltend'), 'No sdeltaend channel found.');
selectedTriggers = processConditions(S, parameters);

figure;
hold on;
scatter(S.delta_end.times, ones(size(S.delta_end.times)), 'r');
scatter(S.skdeltend.times, ones(size(S.skdeltend.times))*0.9, 'g');
plot(selectedTriggers, ones(size(selectedTriggers))*0.9, 'b.');
scatter(S.spdl_0.times, ones(size(S.spdl_0.times))*0.8, 'b');

assert(length(selectedTriggers)==length(S.skdeltend.times), 'Not the same number of triggers remained (segmentwise)');
assert(sum(abs(sort(selectedTriggers)-sort(S.skdeltend.times))<0.001)==0, 'Not the same triggers retained. (segmentwise)');

%% Test 6: Test delta with K-complex which isn't followed by spindle
fprintf('Test 6: Test delta with K-complex which isn''t followed by spindle\n');
S.delta_st = S.kdeltast;
S.delta_end = S.kdeltaend;
S.Kcomplex = S.Kcomplex;
condition(1) = struct('type',1,'interval',[],'marker','Kcomplex');
condition(2) = struct('type',0,'interval',[0,0.15],'marker','spdl_0');
parameters = struct('triggerType', 'sectionend', 'triggerName', 'delta', 'conditions', condition);
assert(isfield(S, 'spdl_0'), 'No spdl channel found.');
assert(isfield(S, 'nkdeltend'), 'No sdeltaend channel found.');
selectedTriggers = processConditions(S, parameters);

assert(length(selectedTriggers)==length(S.nkdeltend.times), 'Not the same number of triggers remained (segmentwise)');
assert(sum(sort(selectedTriggers)~=sort(S.nkdeltend.times))==0, 'Not the same triggers retained. (segmentwise)');
