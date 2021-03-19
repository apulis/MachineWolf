#!/bin/bash

trap 'onCtrlC' INT
function onCtrlC () {
    echo 'Ctrl+C is captured'
}
n=1

while [ $n -le 100 ]
do
    echo "=============================================================================="Start $n Times "========================================================================"
    horovodrun  --network-interface ib0 -np 16 -hostfile /job/hostfile python /examples/tensorflow2_keras_mnist.py
    sleep 15s
    horovodrun  --network-interface ib0 -np 16 -hostfile /job/hostfile python /examples/pytorch_mnist.py
    ((n++))
    sleep 15s
    echo "=============================================================================="Finish $n Times "========================================================================"
done