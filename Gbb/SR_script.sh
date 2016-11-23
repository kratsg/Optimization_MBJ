#!/bin/bash

files=$(find ~/hf_tag2.4.11-1-0/*.root ! -name "*Gtt*" ! -name "*data*" -type f)

baseDir="SR"
rm -rf $baseDir
mkdir -p $baseDir

for i in 1 3
do
  supercutsLocation="regions/SR${i}.json"
  cutsLocation="${baseDir}/SR${i}Cuts"

  outputNMinus1="n-1/SR-${i}"
  python ../Optimization/do_n-1_cuts.py ${files[*]} --supercuts $supercutsLocation --output $outputNMinus1 --boundaries boundaries.json -f --tree nominal --eventWeight "weight_mc*weight_btag*weight_elec*weight_muon*weight_pu"

  python ../Optimization/optimize.py cut ${files[*]} --supercuts $supercutsLocation -o $cutsLocation --numpy -b --eventWeight "weight_mc*weight_btag*weight_elec*weight_muon*weight_pu" --weightsFile ../Optimization/weights.yml --tree nominal

  for lumi in 10
  do
    significancesLocation="${baseDir}/SR${i}Significances_${lumi}"

    python ../Optimization/optimize.py optimize --signal 37* --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory $cutsLocation -b --o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.75 --lumi $lumi

    summaryLocation="${baseDir}/summary_SR${i}_${lumi}.json"
    python ../Optimization/optimize.py summary --searchDirectory $significancesLocation --massWindows ../massWindows_Gbb.txt --output $summaryLocation

    outputHashLocation="${baseDir}/outputHash_SR${i}_${lumi}"
    python ../Optimization/optimize.py hash $summaryLocation --supercuts $supercutsLocation -o $outputHashLocation --use-summary

    outputFilePlots="SR${i}_${lumi}"
    python ../Optimization/graph-grid.py --lumi $lumi --outfile $outputFilePlots --sigdir $significancesLocation --cutdir $cutsLocation --massWindows ../massWindows_Gbb.txt --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv --massWindows ../massWindows_Gbb.txt
    python ../Optimization/graph-cuts.py --lumi $lumi --outfile $outputFilePlots --sigdir $significancesLocation --supercuts $supercutsLocation --hashdir $outputHashLocation --massWindows ../massWindows_Gbb.txt
  done
done

for lumi in 10
do
  python ../Optimization/find_optimal_signal_region.py --lumi $lumi --basedir $baseDir --massWindows ../massWindows_Gbb.txt --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv --numSRs 3
done
