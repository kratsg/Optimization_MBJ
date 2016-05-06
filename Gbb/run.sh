# produce cuts for all the samples
python ../optimize.py cut -b --numpy --ncores 7 \
    $(find ~/hf_tag02_v1/*.merged ! -name "*Gtt*" -type f) \
    --tree nominal --eventWeight weight_mc --weightsFile ../weights.yml
# calculate significances with lumi = 10 ifb
python ../Optimization/optimize.py optimize --signal 37* \
    --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') \
    -b --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=2 --lumi 10
# produce the sig plot
python ../Optimization/graph-grid.py --lumi 10 --outfile plots \
    --sigdir significances --cutdir cuts --massWindows ../massWindows_Gbb.txt \
    --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv
# produce the optimal cuts
python ../Optimization/graph-cuts.py --lumi 10 --outfile plots --sigdir significances \
    --supercuts supercuts.json --hashdir outputHash --massWindows ../massWindows_Gbb.txt
