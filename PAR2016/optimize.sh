#!/bin/bash

python ../Optimization/optimize.py optimize --signal 37* --bkgd 4* --searchDirectory=cuts/normal -b --o=significances/normal --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=2
python ../Optimization/optimize.py optimize --signal 37* --bkgd 4* --searchDirectory=cuts/jigsaw -b --o=significances/jigsaw --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=2
