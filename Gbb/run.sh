# produce cuts for all the samples
python ../optimize.py cut -b --numpy --ncores 7 \
    $(find ~/hf_tag2.4.11-1-0/*.root ! -name "*Gtt*" ! -name "*data*" -type f) \
    --tree nominal --eventWeight weight_mc --weightsFile ../weights.yml
# calculate significances with lumi = 10 ifb
python ../Optimization/optimize.py optimize --signal 37* \
    --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') \
    -b --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=2 --lumi 10
# produce the sig plot
python ../Optimization/slim_significances.py
python ../Optimization/graph-grid.py --lumi 10 --outfile plots \
    --sigdir significances_slim --cutdir cuts --massWindows ../massWindows_Gbb.txt \
    --run1_csvfile ../run1_limit.csv --run1_1sigma_csvfile ../run1_limit_1sigma.csv
# produce the optimal cuts
python ../Optimization/optimize.py summary \
  --searchDirectory significances --massWindows ../massWindows_Gbb.txt \
  --output summary.json
python ../Optimization/optimize.py hash summary.json \
  --supercuts supercuts.json -o outputHash --use-summary
python ../Optimization/graph-cuts.py --lumi 10 --outfile plots --sigdir significances \
    --supercuts supercuts.json --hashdir outputHash --massWindows ../massWindows_Gbb.txt
