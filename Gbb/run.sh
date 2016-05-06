# produce cuts for all the samples
python ../optimize.py cut -b --numpy --ncores 7 \
    $(find ~/hf_tag02_v1/*.merged ! -name "*Gtt*" -type f) \
    --tree nominal --eventWeight weight_mc --weightsFile ../weights.yml
# calculate significances with lumi = 10 ifb
python ../Optimization/optimize.py optimize --signal 37* \
    --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') \
    -b --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=2 --lumi 10
