#!/bin/bash

# cp -r /home/pb777/jacs/cdk2/cdk2/unified/run/21~32 /home/pb777/jacs/cdk2/data/fixing_21/fixed_21_32

mkdir -p /home/pb777/jacs/cdk2/data/fixing_21/fixed_21_32/aq
mkdir -p /home/pb777/jacs/cdk2/data/fixing_21/fixed_21_32/com

cp /home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/aq/equil/0.00000000_min2.rst7  /home/pb777/jacs/cdk2/data/fixing_21/fixed_21_32/aq/0.00000000_init.rst7
cp /home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/aq/equil/1.00000000_min2.rst7  /home/pb777/jacs/cdk2/data/fixing_21/fixed_21_32/aq/1.00000000_init.rst7

cp /home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/com/equil/0.00000000_min2.rst7  /home/pb777/jacs/cdk2/data/fixing_21/fixed_21_32/com/0.00000000_init.rst7
cp /home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/com/equil/1.00000000_min2.rst7  /home/pb777/jacs/cdk2/data/fixing_21/fixed_21_32/com/1.00000000_init.rst7
