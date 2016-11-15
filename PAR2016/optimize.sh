#!/bin/bash

python ../Optimization/optimize.py cut ~/2.4.19-0-0/*.root --supercuts=supercuts.json -o cuts --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree
python optimize.py optimize --signal 37* --bkgd 4* --searchDirectory=cuts -b --o=significances --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=2
python graph-grid.py --lumi 5 --outfile "output.pdf" --sigdir "significances"
