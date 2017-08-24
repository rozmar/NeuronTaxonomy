function invertedSegmentStructure = invertSegmentStructure(segmentStructure, containingSegmentEdges)
  invertedSegmentStructure.start = [containingSegmentEdges(1);segmentStructure.end];
  invertedSegmentStructure.end   = [segmentStructure.start;containingSegmentEdges(2)];
end