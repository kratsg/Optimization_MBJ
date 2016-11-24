#!/bin/bash

files=$(find /Users/kratsg/2.4.19-0-0_1L/*.root  -not -iname "*Gbb*" -not -iname "*data*")

python ../Optimization/optimize.py cut ${files} --supercuts=supercuts/normal_${version}.json -o cuts/normal_${version} --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree --ncores=7
#python ../Optimization/optimize.py cut ${files} --supercuts=supercuts/jigsaw_${version}.json -o cuts/jigsaw_${version} --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree
