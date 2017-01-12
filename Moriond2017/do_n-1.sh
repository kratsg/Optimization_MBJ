#!/bin/bash

files=$(find /Users/kratsg/2.4.19-0-0/${version}/*.root  -not -iname "*Gbb*" -not -iname "*data*")

for i in 1 2 3
do
  supercutsLocation="regions_${version}/SR-${i}.json"

  outputNMinus1="n-1/SR-${i}"
  python ../Optimization/do_n-1_cuts.py ${files[*]} --supercuts $supercutsLocation --output $outputNMinus1 --boundaries boundaries.json -f --tree oTree --eventWeight event_weight

done

python ~/TakeOverTheWorld/totw.py --weights ../Optimization/weights.json --config TOTW/n-1_SR_${version}.yml --lumi 35 -i n-1 -b
