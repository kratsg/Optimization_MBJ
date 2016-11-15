#!/bin/bash

python ../Optimization/optimize.py optimize --signal 37* --bkgd 4* --searchDirectory=cuts_normal -b --o=significances_normal --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=2
python ../Optimization/optimize.py optimize --signal 37* --bkgd 4* --searchDirectory=cuts_jigsaw -b --o=significances_jigsaw --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=2
