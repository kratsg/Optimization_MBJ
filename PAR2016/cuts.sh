#!/bin/bash

python ../Optimization/optimize.py cut ~/2.4.19-0-0/*.root --supercuts=supercuts_normal.json -o cuts_normal --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree
python ../Optimization/optimize.py cut ~/2.4.19-0-0/*.root --supercuts=supercuts_jigsaw.json -o cuts_jigsaw --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree
