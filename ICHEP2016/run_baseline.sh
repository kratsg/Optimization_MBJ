#!/bin/bash

rm -rf cuts/baseline_*/
rm -rf significances/baseline_*/
rm summary_baseline_*.json
rm -rf outputHash/baseline_*/
rm plots/baseline*.pdf

version=0L . cuts.sh
version=0L . optimize.sh
version=0L . optimal_cuts.sh
version=0L . make_comparison.sh
version=0L . make_plots.sh

version=1L3b . cuts.sh
version=1L3b . optimize.sh
version=1L3b . optimal_cuts.sh
version=1L3b . make_comparison.sh
version=1L3b . make_plots.sh

version=1L4b . cuts.sh
version=1L4b . optimize.sh
version=1L4b . optimal_cuts.sh
version=1L4b . make_comparison.sh
version=1L4b . make_plots.sh