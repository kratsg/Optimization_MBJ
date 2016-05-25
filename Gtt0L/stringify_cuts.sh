#!/bin/bash

for f in $(find regions/*.json)
do
  filename=$(basename "$f")
  extension="${f##*.}"
  filename="${filename%##*/}"
  filename="${filename%.*}"


  python -c "import sys, os; sys.path.append('../Optimization'); import optimize; import json; print('$filename    '+optimize.cuts_to_selection(json.load(file('$f','r'))))" | grep $filename

done
