#!/bin/bash

#files=$(find /Users/kratsg/2.4.19-0-0/${version}/*.root  -not -iname "*Gbb*" -not -iname "*data*")
files+=($(find /faxbox2/user/mleblanc/multib_ichep2k16/hf_tag2.4.11-1-0/optin/user.*.root* -print0 | xargs -0))
#files+=($(find /faxbox2/user/mleblanc/multib_ichep2k16/hf_tag2.4.11-0-0/optin/user.*/user.*.root* -print0 | xargs -0))

mkdir -p cuts

rooptimize cut ${files[*]} --supercuts=supercuts/baseline_${version}.json -o cuts/baseline_${version} --numpy -b --eventWeight "weight_mc*weight_btag*weight_elec*weight_muon" --weightsFile weights.json --tree nominal --ncores=12

#rooptimize cut ${files[*]} --supercuts=supercuts/baseline_${version}.json -o cuts/baseline_${version} --numpy -b --eventWeight "weight_mc*weight_btag*weight_elec*weight_muon*weight_jvt" --weightsFile weights.json --tree nominal --ncores=7
