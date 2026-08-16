#!/usr/bin/env bash
#SBATCH --partition=gpuws
#SBATCH --time=00:05:00
#SBATCH --ntasks=8
#SBATCH --gres=gpu:8

if [ -z "${PARAM}" ]; then
	PARAM="params.ini"
fi

module purge
module load nvhpc-hpcx

cd ${SLURM_SUBMIT_DIR}

# nvidia-smi topo -m

mpiexec -n ${SLURM_NTASKS} sh/common/wrapper.sh ./collapse_mpi ${PARAM}
