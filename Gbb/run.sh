# produce cuts for all the samples
python ../optimize.py cut -b --numpy --ncores 7 \
    $(find ~/hf_tag02_v1/*.merged ! -name "*Gtt*" -type f) \
    --tree nominal --eventWeight weight_mc --weightsFile ../weights.yml
# calculate significances with lumi = 10 ifb
python ../Optimization/optimize.py optimize --signal 37* \
    --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') \
    -b --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=2 --lumi 10
# produce the sig plot
python ../Optimization/slim_significances.py
python ../Optimization/graph-grid.py --lumi 10 --outfile plots \
    --sigdir significances_slim --cutdir cuts --massWindows ../massWindows_Gbb.txt \
    --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv
# produce the optimal cuts
python ../Optimization/write_all_optimal_cuts.py \
    --supercuts supercuts.json --significances significances \
    --mass_windows ../massWindows_Gbb.txt -o outputHash
python ../Optimization/graph-cuts.py --lumi 10 --outfile plots --sigdir significances \
    --supercuts supercuts.json --hashdir outputHash --massWindows ../massWindows_Gbb.txt
