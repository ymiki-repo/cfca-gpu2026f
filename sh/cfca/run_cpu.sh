#!/usr/bin/env bash
#SBATCH --partition=gpuws
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:05:00

module purge
module load nvhpc/25.7

cd ${SLURM_SUBMIT_DIR}

export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
export OMP_PROC_BIND=close
export OMP_PLACES=cores

./vecadd
