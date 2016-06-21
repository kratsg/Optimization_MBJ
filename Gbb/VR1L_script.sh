#!/bin/bash

files=$(find ~/hf_tag2.4.11/*.merged ! -name "*Gtt*" ! -name "*data*" -type f)

baseDir="VR1L"
rm -rf $baseDir
mkdir -p $baseDir

for i in 1 3
do
  supercutsLocation="regions/VR1L${i}.json"
  cutsLocation="${baseDir}/VR1L${i}Cuts"

  outputNMinus1="n-1/VR1L-${i}"
  python ../Optimization/do_n-1_cuts.py ${files[*]} --supercuts $supercutsLocation --output $outputNMinus1 --boundaries boundaries.json -f --tree nominal --eventWeight weight_mc

  python ../Optimization/optimize.py cut ${files[*]} --supercuts $supercutsLocation -o $cutsLocation --numpy -b --eventWeight weight_mc --weightsFile ../Optimization/weights.yml --tree nominal

  for lumi in 10
  do

    significancesLocation="${baseDir}/VR1L${i}Significances_${lumi}"

    python ../Optimization/optimize.py optimize --signal 37* --bkgd $(cat bkgdFiles | sed "s/$/.json/g" | tr '\n' ' ') --searchDirectory $cutsLocation -b --o $significancesLocation --bkgdUncertainty=0.3 --bkgdStatUncertainty=0.3 --insignificance=0.5 --lumi $lumi

    outputHashLocation="${baseDir}/outputHash_VR1L${i}_${lumi}"

    python ../Optimization/write_all_optimal_cuts.py --supercuts $supercutsLocation --significances $significancesLocation -o $outputHashLocation --mass_windows ../massWindows_Gbb.txt

    outputFilePlots="VR1L${i}_${lumi}"
    python ../Optimization/graph-grid.py --lumi $lumi --outfile $outputFilePlots --sigdir $significancesLocation --cutdir $cutsLocation --massWindows ../massWindows_Gbb.txt --run1_csvfile ../Optimization/run1_limit.csv --run1_1sigma_csvfile ../Optimization/run1_limit_1sigma.csv --massWindows ../massWindows_Gbb.txt
    python ../Optimization/graph-cuts.py --lumi $lumi --outfile $outputFilePlots --sigdir $significancesLocation --supercuts $supercutsLocation --hashdir $outputHashLocation --massWindows ../massWindows_Gbb.txt
  done
done

# for lumi in 10
# do
#   python ../Optimization/find_optimal_control_region.py --lumi $lumi --basedir $baseDir
# done
