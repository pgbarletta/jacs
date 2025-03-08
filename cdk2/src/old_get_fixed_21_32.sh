#!/bin/bash

# cp -r /home/pb777/jacs/cdk2/cdk2/unified/run/21~32 /home/pb777/jacs/cdk2/data/fixing_21/fixed_21_32

cd /home/pb777/jacs/cdk2/data/fixing_21/


# Fix topologies

good_sys=/home/pb777/jacs/cdk2/cdk2/unified/run/21~32/aq
good_box=/home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/aq
mkdir -p fixed_21_32/aq
sed "13165s/.*/$(sed '13165!d; s/[\/&]/\\&/g' $good_box/unisc.parm7)/" $good_sys/unisc.parm7 > fixed_21_32/aq/unisc.parm7
#
#
good_sys=/home/pb777/jacs/cdk2/cdk2/unified/run/21~32/com
good_box=/home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/com
mkdir -p fixed_21_32/com
sed "130232s/.*/$(sed '130232!d; s/[\/&]/\\&/g' $good_box/unisc.parm7)/" $good_sys/unisc.parm7 > fixed_21_32/com/unisc.parm7


# Fix rst7

good_sys=/home/pb777/jacs/cdk2/cdk2/unified/run/21~32/aq/equil/0.00000000_init.rst7
good_box=/home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/aq/equil/0.00000000_init.rst7
sed "4040s/.*/$(sed '4040!d; s/[\/&]/\\&/g' $good_box)/" $good_sys > fixed_21_32/aq/0.00000000_init.rst7

good_sys=/home/pb777/jacs/cdk2/cdk2/unified/run/21~32/aq/equil/1.00000000_init.rst7
good_box=/home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/aq/equil/1.00000000_init.rst7
sed "4040s/.*/$(sed '4040!d; s/[\/&]/\\&/g' $good_box)/" $good_sys > fixed_21_32/aq/1.00000000_init.rst7
#
#
good_sys=/home/pb777/jacs/cdk2/cdk2/unified/run/21~32/com/equil/0.00000000_init.rst7
good_box=/home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/com/equil/0.00000000_init.rst7
sed "31663s/.*/$(sed '31663!d; s/[\/&]/\\&/g' $good_box)/" $good_sys > fixed_21_32/com/0.00000000_init.rst7

good_sys=/home/pb777/jacs/cdk2/cdk2/unified/run/21~32/com/equil/1.00000000_init.rst7
good_box=/home/pb777/jacs/cdk2/bucdk2/unified/run/21~32/com/equil/1.00000000_init.rst7
sed "31663s/.*/$(sed '31663!d; s/[\/&]/\\&/g' $good_box)/" $good_sys > fixed_21_32/com/1.00000000_init.rst7

