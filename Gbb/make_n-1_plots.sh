#!/bin/bash

python ~/TakeOverTheWorld/totw.py -b --config TOTW/n-1_SR.yml --weights TOTW/weights.yml -i n-1
python ~/TakeOverTheWorld/totw.py -b --config TOTW/n-1_CR.yml --weights TOTW/weights.yml -i n-1
python ~/TakeOverTheWorld/totw.py -b --config TOTW/n-1_VR0L.yml --weights TOTW/weights.yml -i n-1
python ~/TakeOverTheWorld/totw.py -b --config TOTW/n-1_VR1L.yml --weights TOTW/weights.yml -i n-1
