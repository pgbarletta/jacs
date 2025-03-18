#!/usr/bin/env bash
#SBATCH --job-name="aq_pr_1h1q~1oiu.slurm"
#SBATCH --output="pr_1h1q~1oiu.slurm.slurmout"
#SBATCH --partition=rtx
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
##SBATCH --gres=gpu:4
#SBATCH --time=0-24:00:00

lams=(0.00000000 0.17964896 0.23357541 0.27400537 0.30806539 0.33836806 0.36621555 0.39237392 0.41734721 0.44149723 0.46510424 0.48840164 0.51159836 0.53489576 0.55850277 0.58265279 0.60762608 0.63378445 0.66163194 0.69193461 0.72599463 0.76642459 0.82035104 1.00000000)
# check if AMBERHOME is set
source ~/.bashrc

if [ -z "${AMBERHOME}" ]; then echo "AMBERHOME is not set" && exit 0; fi

EXE=${AMBERHOME}/bin/pmemd.cuda.MPI
echo "running replica ti"
echo "mpirun -np ${#lams[@]} ${EXE}  -ng ${#lams[@]} -groupfile inputs/preTI.groupfile"
mpirun -np ${#lams[@]} ${EXE}  -ng ${#lams[@]} -groupfile inputs/preTI.groupfile
echo "mpirun -np ${#lams[@]} ${EXE} -rem 3 -remlog remt${trial}.log -ng ${#lams[@]} -groupfile inputs/ti.groupfile"
mpirun -np ${#lams[@]} ${EXE} -rem 3 -remlog remt${trial}.log -ng ${#lams[@]} -groupfile inputs/ti.groupfile
