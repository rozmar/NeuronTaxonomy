%% Test 1: test empty event vector
segmentStructure = struct('start',[1,3,5],'end',[1.5,3.2,5.4]);
eventVector = [];
mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector, mode);
assert(sum(containingIndex)==0, 'Test case with empty event vector, mode=within failed');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector, mode);
assert(sum(containingIndex)==3, 'Test case with empty event vector, mode=without failed');

%% Test 2: test one segment
segmentStructure = struct('start',[5],'end',[5.4]);
eventVector1 = [4];
eventVector2 = [5.2];
eventVector3 = [5.4];
eventVector4 = [5.5];

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector1, mode);
assert(sum(containingIndex)==0, 'Test case with 1 event, mode=within failed');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector1, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=without failed');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector2, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=within failed');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector2, mode);
assert(sum(containingIndex)==0, 'Test case with 1 event, mode=without failed');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector3, mode);
assert(sum(containingIndex)==0, 'Test case with 1 event, mode=within failed');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector3, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=without failed');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector4, mode);
assert(sum(containingIndex)==0, 'Test case with 1 event, mode=within failed');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector4, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=without failed');

%% Test 3: test 2 disjunct segments
segmentStructure = struct('start',[5,6],'end',[5.4,6.2]);
eventVector1 = [4,5.6,7];
eventVector2 = 5.2;
eventVector3 = 6.1;
eventVector4 = [5.3,6.11];

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector1, mode);
assert(sum(containingIndex)==0, 'Test case with 1 event, mode=within failed');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector1, mode);
assert(sum(containingIndex)==2, 'Test case with 1 event, mode=without failed');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector2, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=within failed');
assert(sum(containingIndex==[1;0])==2, 'Test case with 1 include event (mode=within) failed: bad flag');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector2, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=without failed');
assert(sum(containingIndex==[0;1])==2, 'Test case with 1 include event (mode=without) failed: bad flag');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector3, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=within failed');
assert(sum(containingIndex==[0;1])==2, 'Test case with 1 include event (mode=within) failed: bad flag');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector3, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=without failed');
assert(sum(containingIndex==[1;0])==2, 'Test case with 1 include event (mode=without) failed: bad flag');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector4, mode);
assert(sum(containingIndex)==2, 'Test case with 1 event, mode=within failed');
assert(sum(containingIndex==[1;1])==2, 'Test case with 1 include event (mode=within) failed: bad flag');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector4, mode);
assert(sum(containingIndex)==0, 'Test case with 1 event, mode=without failed');
assert(sum(containingIndex==[0;0])==2, 'Test case with 1 include event (mode=without) failed: bad flag');

%% Test 4: test 2 overlapping segments
segmentStructure = struct('start',[5,5.5],'end',[5.7,6.0]);
eventVector1 = [4,7];
eventVector2 = 5.2;
eventVector3 = 5.9;
eventVector4 = 5.6;
eventVector5 = [5.3,5.8];

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector1, mode);
assert(sum(containingIndex)==0, 'Test case with 1 event, mode=within failed');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector1, mode);
assert(sum(containingIndex)==2, 'Test case with 1 event, mode=without failed');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector2, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=within failed');
assert(sum(containingIndex==[1;0])==2, 'Test case with 1 include event (mode=within) failed: bad flag');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector2, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=without failed');
assert(sum(containingIndex==[0;1])==2, 'Test case with 1 include event (mode=without) failed: bad flag');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector3, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=within failed');
assert(sum(containingIndex==[0;1])==2, 'Test case with 1 include event (mode=within) failed: bad flag');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector3, mode);
assert(sum(containingIndex)==1, 'Test case with 1 event, mode=without failed');
assert(sum(containingIndex==[1;0])==2, 'Test case with 1 include event (mode=without) failed: bad flag');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector4, mode);
assert(sum(containingIndex)==2, 'Test case with 1 event, mode=within failed');
assert(sum(containingIndex==[1;1])==2, 'Test case with 1 include event (mode=within) failed: bad flag');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector4, mode);
assert(sum(containingIndex)==0, 'Test case with 1 event, mode=without failed');
assert(sum(containingIndex==[0;0])==2, 'Test case with 1 include event (mode=without) failed: bad flag');

mode = 'within';
containingIndex = findEventContainingSegment(segmentStructure, eventVector5, mode);
assert(sum(containingIndex)==2, 'Test case with 1 event, mode=within failed');
assert(sum(containingIndex==[1;1])==2, 'Test case with 1 include event (mode=within) failed: bad flag');
mode = 'without';
containingIndex = findEventContainingSegment(segmentStructure, eventVector5, mode);
assert(sum(containingIndex)==0, 'Test case with 1 event, mode=without failed');
assert(sum(containingIndex==[0;0])==2, 'Test case with 1 include event (mode=without) failed: bad flag');