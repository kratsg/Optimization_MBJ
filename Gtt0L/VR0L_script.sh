#!/bin/bash

files=$(find ~/hf_tag02_v1/*.merged ! -name "*Gbb*" -type f)

baseDir="VR0L"
rm -rf $baseDir
mkdir -p $baseDir

for i in 1 3 4
do
  supercutsLocation="regions/VR0L-${i}.json"
  cutsLocation="${baseDir}/VR0L${i}Cuts"

  outputNMinus1="n-1/VR0L-${i}"
  python ../Optimization/do_n-1_cuts.py ${files[*]} --supercuts $supercutsLocation --output $outputNMinus1 --boundaries boundaries.json -f --tree nominal --eventWeight weight_mc

  python ../Optimization/optimize.py cut ${files[*]} --supercuts $supercutsLocation -o $cutsLocation --numpy -b --eventWeight weight_mc --weightsFile ../Optimization/weights.yml --tree nominal

  for lumi in 10
  do

    significancesLocation="${baseDir}/VR0L${i}Significances_${lumi}"

    python ../Optimization/optimize.py optimize --signal 37* --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory $cutsLocation -b --o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi $lumi

    summaryLocation="${baseDir}/summary_VR0L${i}_${lumi}.json"
    python ../Optimization/optimize.py summary --searchDirectory $significancesLocation --massWindows ../massWindows_Gtt.txt --output $summaryLocation

    outputHashLocation="${baseDir}/outputHash_VR0L${i}_${lumi}"
    python ../Optimization/optimize.py hash $summaryLocation --supercuts $supercutsLocation -o $outputHashLocation --use-summary

    outputFilePlots="VR0L${i}_${lumi}"
    python ../Optimization/graph-grid.py --lumi $lumi --outfile $outputFilePlots --sigdir $significancesLocation --cutdir $cutsLocation --massWindows ../massWindows_Gtt.txt --run1_csvfile ../run1_limit.csv --run1_1sigma_csvfile ../run1_limit_1sigma.csv --massWindows ../massWindows_Gtt.txt
    python ../Optimization/graph-cuts.py --lumi $lumi --outfile $outputFilePlots --sigdir $significancesLocation --supercuts $supercutsLocation --hashdir $outputHashLocation --massWindows ../massWindows_Gtt.txt
  done
done

# for lumi in 10
# do
#   python ../Optimization/find_optimal_control_region.py --lumi $lumi --basedir $baseDir
# done
