#!/bin/bash

#files=$(find /Users/kratsg/2.4.19-0-0/${version}/*.root  -not -iname "*Gbb*" -not -iname "*data*")
files+=($(find /faxbox2/user/mleblanc/multib_ichep2k16/hf_tag2.4.11-1-0/optin/user.*.root* -print0 | xargs -0))
#files+=($(find /faxbox2/user/mleblanc/multib_ichep2k16/hf_tag2.4.11-0-0/optin/user.*/user.*.root* -print0 | xargs -0))

baseDir="SR/${version}"
rm -rf $baseDir
mkdir -p $baseDir

for i in 1 2 
do
  supercutsLocation="regions_${version}/SR-${i}.json"
  cutsLocation="${baseDir}/SR${i}Cuts"

  echo 'cut'
  rooptimize cut ${files[*]} --supercuts=$supercutsLocation -o $cutsLocation --numpy -b --eventWeight "weight_mc*weight_btag*weight_elec*weight_muon" --weightsFile weights.json --tree nominal --ncores=12

  for lumi in 10 15
  do
    significancesLocation="${baseDir}/SR${i}Significances_${lumi}"

    echo 'optimize'
    rooptimize optimize --signal 3701* --bkgd 31* 36* 34* 410000 407009 407010 407018 407019 407020 407021 407011 410013 410014 410011 410012 410025 410026 410018 410019 410020 410021 --searchDirectory=$cutsLocation -b -o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi $lumi
    #rooptimize optimize --signal 3701* --bkgd 41* 407* --searchDirectory=$cutsLocation -b -o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi $lumi

    echo 'summary'
    summaryLocation="${baseDir}/summary_SR${i}_${lumi}.json"
    rooptimize summary --searchDirectory $significancesLocation --massWindows ../massWindows_Gtt.txt --output $summaryLocation

    echo 'hash'
    outputHashLocation="${baseDir}/outputHash_SR${i}_${lumi}"
    rooptimize hash $summaryLocation --supercuts $supercutsLocation -o $outputHashLocation --use-summary

    outputFilePlots="SR${i}_${lumi}_${version}"
    python graph-grid-mlb.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots --do-run2 --run2-excl run2_limit.csv --run2-1sigma run2_limit_1sigma.csv -b --g-min=1000 --g-max=2000 --l-max=1600
    python graph-cuts-mlb.py --summary $summaryLocation --lumi $lumi -o $outputFilePlots -b --outputHash $outputHashLocation --supercuts $supercutsLocation --g-min=1000 --g-max=2000 --l-max=1600

  done
done

for lumi in 10 15
do
  python find_optimal_signal_region-mlb.py --lumi $lumi --basedir $baseDir --massWindows ../massWindows_Gtt.txt --do-run2 --run2-excl run2_limit.csv --run2-1sigma run2_limit_1sigma.csv --numSRs 2 --output ${version}

  python ../Optimization/write_optimal_signal_region_summary.py ${baseDir}/summary_SR*.json -o summary_Gtt${version}_optimalSR_${lumi}.json

  python ../Optimization/summary-comparison.py --base-summary summary_baseline_${version}.json --comp-summary summary_Gtt${version}_optimalSR_${lumi}.json -o ${version}_optimalSR_lumi_${lumi}_compare_significance -b --g-min=1000 --g-max=2000 --l-max=1600
done
