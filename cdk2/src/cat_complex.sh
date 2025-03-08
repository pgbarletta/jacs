#!/bin/bash

binders=(17 1h1q 1h1r 1h1s 1oi9 1oiu 1oiy 20 21 22 26 28 29 30 31 32)
prep_dir="/home/pb777/jacs/cdk2/data/preparation"
target="/home/pb777/jacs/cdk2/data/target/target_cdk2.pdb"

for b in ${binders[@]}
do
  mkdir -p ${prep_dir}/complexes/${b}
  cat $prep_dir/$b/aligned_parametrized_${b}.pdb $target > $prep_dir/complexes/$b/raw_${b}.pdb
  cd $prep_dir/complexes/$b/
  pdb4amber -i raw_${b}.pdb -o ${b}.pdb
  cp ${b}.pdb ../../../cdk2/
  cd - 
done
