#!/bin/bash

files=$(find /Users/kratsg/2.4.19-0-0/${version}/*.root  -not -iname "*Gbb*" -not -iname "*data*")

baseDir="SR/${version}"
rm -rf $baseDir
mkdir -p $baseDir

for i in 1 2 3
do
  supercutsLocation="regions_${version}/SR-${i}.json"
  cutsLocation="${baseDir}/SR${i}Cuts"

  python ../Optimization/optimize.py cut ${files[*]} --supercuts=$supercutsLocation -o $cutsLocation --numpy -b --eventWeight "event_weight" --weightsFile ../Optimization/weights.json --tree oTree --ncores=7

  for lumi in 35
  do
    significancesLocation="${baseDir}/SR${i}Significances_${lumi}"

    python ../Optimization/optimize.py optimize --signal $(awk '{print $1"*"}' ../massWindows_Gtt.txt | tr '\n' ' ') --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory=$cutsLocation -b -o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi $lumi

    summaryLocation="${baseDir}/summary_SR${i}_${lumi}.json"
    python ../Optimization/optimize.py summary --searchDirectory $significancesLocation --massWindows ../massWindows_Gtt.txt --output $summaryLocation

    outputHashLocation="${baseDir}/outputHash_SR${i}_${lumi}"
    python ../Optimization/optimize.py hash $summaryLocation --supercuts $supercutsLocation -o $outputHashLocation --use-summary

    outputFilePlots="SR${i}_${lumi}_${version}"
    python ../Optimization/graph-grid.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots --do-run2 --run2-excl ../run2_limit.csv --run2-1sigma ../run2_limit_1sigma.csv -b
    python ../Optimization/graph-cuts.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots -b --outputHash $outputHashLocation --supercuts $supercutsLocation

  done
done

for lumi in 35
do
  python ../Optimization/find_optimal_signal_region.py --lumi $lumi --basedir $baseDir --massWindows ../massWindows_Gtt.txt --do-run2 --run2-excl ../run2_limit.csv --run2-1sigma ../run2_limit_1sigma.csv --numSRs 3 --output ${version}

  python ../Optimization/write_optimal_signal_region_summary.py ${baseDir}/summary_SR*.json -o summary_Gtt${version}_optimalSR_${lumi}.json

  python ../Optimization/summary-comparison.py --base-summary summary_baseline_${version}.json --comp-summary summary_Gtt${version}_optimalSR_${lumi}.json -o ${version}_optimalSR_lumi_${lumi}_compare_significance -b
done
