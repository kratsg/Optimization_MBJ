#!/bin/bash

python ../Optimization/optimize.py cut ~/2.4.19-0-0/*.root --supercuts=supercuts/normal.json -o cuts/normal --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree
python ../Optimization/optimize.py cut ~/2.4.19-0-0/*.root --supercuts=supercuts/jigsaw.json -o cuts/jigsaw --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree
