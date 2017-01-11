#!/bin/bash

for f in $(find regions_${version}/*R-*.json)
do
  filename=$(basename "$f")
  extension="${f##*.}"
  filename="${filename%##*/}"
  filename="${filename%.*}"


  python -c "import sys, os; sys.path.append('../Optimization'); from root_optimize.utils import cuts_to_selection; import json; print('$filename    '+cuts_to_selection(json.load(file('$f','r'))))" | grep $filename

done
