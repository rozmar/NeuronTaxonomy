#! /bin/bash

for i in {1..11} 
do 
  nohup nice -n 19 octave --silent --eval "runGetClustering('/home/sborde/mdata/datasum','/home/sborde/ClusteringPosRamp',$i)" &  
done
