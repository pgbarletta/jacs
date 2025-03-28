#!/usr/bin/env bash
#SBATCH --job-name="aq_eq_21~32.slurm"
#SBATCH --output="eq_21~32.slurm.slurmout"
#SBATCH --error="eq_21~32.slurm.slurmerr"
#SBATCH --partition=rtx
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
##SBATCH --gres=gpu:4
#SBATCH --time=0-24:00:00

top=${PWD}
endstates=(0.00000000 1.00000000)
lams=(0.00000000 0.17964896 0.23357541 0.27400537 0.30806539 0.33836806 0.36621555 0.39237392 0.41734721 0.44149723 0.46510424 0.48840164 0.51159836 0.53489576 0.55850277 0.58265279 0.60762608 0.63378445 0.66163194 0.69193461 0.72599463 0.76642459 0.82035104 1.00000000)
twostate=true
full_eqstage=(init min1 min2 eqpre1P0 eqpre2P0 eqP0 eqNTP4 eqV eqP eqA minTI eqpre1P0TI eqpre2P0TI eqP0TI eqATI eqBTI)
# Edit eqstage to only include the stages you want to run
eqstage=(init min1 min2 eqpre1P0 eqpre2P0 eqP0 eqNTP4 eqV eqP eqA minTI eqpre1P0TI eqpre2P0TI eqP0TI eqATI eqBTI)
len_full_eqstage=${#full_eqstage[@]}
len_eqstage=${#eqstage[@]}
starting_idx=$((length1 - length2 - 1))

preminTIstage=eqA


# check if AMBERHOME is set
source ~/.bashrc

#if [ -z "${AMBERHOME}" ]; then echo "AMBERHOME is not set" && exit 0; fi

### CUDA MPS # BEGIN ###
temp_path=/tmp/temp_aq_21~32
mkdir -p ${temp_path}
export CUDA_MPS_PIPE_DIRECTORY=${temp_path}/nvidia-mps
export CUDA_MPS_LOG_DIRECTORY=${temp_path}/nvidia-log
nvidia-cuda-mps-control -d
### CUDA MPS # END ###



if [ ! -d equil ];then mkdir equil; fi

count=$starting_idx; alllams=0
for stage in ${eqstage[@]}; do
		count=$((${count}+1))
		lastcount=$((${count}-1))
	if [ "${stage}" == "init" ] || [ "${stage}" == "eqpre1P0TI" ] || [ "${stage}" == "eqpre2P0TI" ] || [ "${stage}" == "eqP0TI" ]; then continue; fi
		laststage=${eqstage[${lastcount}]}

		if [ "$stage" == "minTI" ]; then alllams=1; fi

		if [ ${alllams} -eq 0 ];then

				if [ "$stage" == "min1" ] || [ "$stage" == "min2" ]; then
						# check if pmemd.cuda is present
						if ! command -v ${AMBERHOME}/bin/pmemd.cuda &> /dev/null; then echo "pmemd.cuda is missing." && exit 0; fi

						export LAUNCH="srun"
						export EXE=${AMBERHOME}/bin/pmemd.cuda

						for lam in ${endstates[@]};do
								echo "Running $stage for lambda ${lam}..."
								echo "${EXE} -O -p ${top}/unisc.parm7 -c equil/${lam}_${laststage}.rst7 -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil/${lam}_${laststage}.rst7"
								${EXE} -O -p ${top}/unisc.parm7 -c equil/${lam}_${laststage}.rst7 -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil/${lam}_${laststage}.rst7
								cat <<EOF2 > center.in
parm ${top}/unisc.parm7
trajin equil/${lam}_${stage}.rst7
autoimage
trajout equil/${lam}_${stage}_centered.rst7
go
quit
EOF2
								# check if cpptraj is present
								if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
								cpptraj < center.in
								sleep 1
								mv equil/${lam}_${stage}_centered.rst7 equil/${lam}_${stage}.rst7
						done

				else
						# check if pmemd.cuda.MPI is present
						if ! command -v ${AMBERHOME}/bin/pmemd.cuda.MPI &> /dev/null; then echo "pmemd.cuda.MPI is missing." && exit 0; fi

						export LAUNCH="mpirun -np ${#endstates[@]}"
						export EXE=${AMBERHOME}/bin/pmemd.cuda.MPI
						export MV2_ENABLE_AFFINITY=0
						echo "${LAUNCH} ${EXE} -ng ${#endstates[@]} -groupfile inputs/equil_${stage}.groupfile"
						${LAUNCH} ${EXE} -ng ${#endstates[@]} -groupfile inputs/equil_${stage}.groupfile

						for lam in ${endstates[@]};do
								cat <<EOF2 > center.in
parm ${top}/unisc.parm7
trajin equil/${lam}_${stage}.rst7
autoimage
trajout equil/${lam}_${stage}_centered.rst7
go
quit
EOF2
								if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
								cpptraj < center.in
								sleep 1
								mv equil/${lam}_${stage}_centered.rst7 equil/${lam}_${stage}.rst7
						done
				fi

		elif [ "${alllams}" == 1 ] && [ "$stage" == "minTI" ]; then

				# check if pmemd.cuda is present
				if ! command -v ${AMBERHOME}/bin/pmemd.cuda &> /dev/null; then echo "pmemd.cuda is missing." && exit 0; fi
				export LAUNCH="srun"
				export EXE=${AMBERHOME}/bin/pmemd.cuda

		firsthalf=(${lams[@]::$((${#lams[@]} / 2 ))})
		secondhalf=(${lams[@]:$((${#lams[@]} / 2 ))})

		indices=(${!secondhalf[@]}); tmp=()
		for ((k=${#indices[@]} - 1; k >= 0; k--)) ; do
			tmp+=("${secondhalf[indices[k]]}")
		done
		secondhalf=("${tmp[@]}")
		p=("${firsthalf[*]}" "${secondhalf[*]}")

		for l in ${!p[@]};do
			startingconfig=${endstates[$l]}_${preminTIstage}.rst7
			list=(${p[$l]})
			for i in ${!list[@]}; do
				lam=${list[$i]}
							echo "Running $stage for lambda ${lam}..."
				
				if [ "${i}" -eq 0 ]; then
					init=${startingconfig}
				else
					init=${list[$(($i-1))]}_eqP0TI.rst7
				fi

				stage=minTI
				echo "${EXE} -O -p ${top}/unisc.parm7 -c equil/${init} -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil/${init}"
				${EXE} -O -p ${top}/unisc.parm7 -c equil/${init} -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil/${init}
				sleep 1

				laststage=minTI; stage=eqpre1P0TI
				echo "${EXE} -O -p ${top}/unisc.parm7 -c equil/${lam}_${laststage}.rst7 -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil/${lam}_${laststage}.rst7"
				${EXE} -O -p ${top}/unisc.parm7 -c equil/${lam}_${laststage}.rst7 -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil/${lam}_${laststage}.rst7
				sleep 1

				laststage=eqpre1P0TI; stage=eqpre2P0TI
				echo "${EXE} -O -p ${top}/unisc.parm7 -c equil/${lam}_${laststage}.rst7 -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil.rst7"
				${EXE} -O -p ${top}/unisc.parm7 -c equil/${lam}_${laststage}.rst7 -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil/${lam}_${laststage}.rst7
				sleep 1

				laststage=eqpre2P0TI; stage=eqP0TI
				echo "${EXE} -O -p ${top}/unisc.parm7 -c equil/${lam}_${laststage}.rst7 -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil/${lam}_${laststage}.rst7"
				${EXE} -O -p ${top}/unisc.parm7 -c equil/${lam}_${laststage}.rst7 -i inputs/${lam}_${stage}.mdin -o equil/${lam}_${stage}.mdout -r equil/${lam}_${stage}.rst7 -ref equil/${lam}_${laststage}.rst7
				sleep 1

								cat <<EOF2 > center.in
parm ${top}/unisc.parm7
trajin equil/${lam}_${stage}.rst7
autoimage
trajout equil/${lam}_${stage}_centered.rst7
go
quit
EOF2
							# check if cpptraj is present
							if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
							cpptraj < center.in
							sleep 1
							mv equil/${lam}_${stage}_centered.rst7 equil/${lam}_${stage}.rst7
					done
			laststage=eqP0TI
		done
		else
				# check if pmemd.cuda.MPI is present
				if ! command -v ${AMBERHOME}/bin/pmemd.cuda.MPI &> /dev/null; then echo "pmemd.cuda.MPI is missing." && exit 0; fi

				export LAUNCH="mpirun -np ${#lams[@]}"
				export EXE=${AMBERHOME}/bin/pmemd.cuda.MPI
				export MV2_ENABLE_AFFINITY=0
				echo "${LAUNCH} ${EXE} -ng ${#lams[@]} -groupfile inputs/equil_${stage}.groupfile"
				${LAUNCH} ${EXE} -ng ${#lams[@]} -groupfile inputs/equil_${stage}.groupfile

				for lam in ${lams[@]};do
						cat <<EOF2 > center.in
parm ${top}/unisc.parm7
trajin equil/${lam}_${stage}.rst7
autoimage
trajout equil/${lam}_${stage}_centered.rst7
go
quit
EOF2
						if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
						cpptraj < center.in
						sleep 1
						mv equil/${lam}_${stage}_centered.rst7 equil/${lam}_${stage}.rst7
				done
		fi


		if [ "${stage}" == "eqP0" ]; then
		a=0; b=0; c=0
				for lam in ${endstates[@]};do
						box=($(tail -1 equil/${lam}_${stage}.rst7))
						a=$(awk "BEGIN {print ( $a + ${box[0]} ) }")
						b=$(awk "BEGIN {print ( $b + ${box[1]} ) }")
						c=$(awk "BEGIN {print ( $c + ${box[2]} ) }")
				done
				a=$(awk "BEGIN {print ( $a / ${#endstates[@]} ) }")
				b=$(awk "BEGIN {print ( $b / ${#endstates[@]} ) }")
				c=$(awk "BEGIN {print ( $c / ${#endstates[@]} ) }")

				a=$(printf "%8.7f" $a); b=$(printf "%8.7f" $b); c=$(printf "%8.7f" $c)
				for lam in ${endstates[@]};do
						sed -e "s/ABOX/${a}/g" -e "s/BBOX/${b}/g" -e "s/CBOX/${c}/g" inputs/${lam}_eqNTP4.mdin.template > inputs/${lam}_eqNTP4.mdin
				done
				sleep 1
		fi
done



### CUDA MPS # BEGIN ###
echo quit | nvidia-cuda-mps-control
### CUDA MPS # END ###

echo "--- DONE ---"

