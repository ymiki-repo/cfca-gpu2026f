#!/usr/bin/env bash
#SBATCH --partition=gpuws
#SBATCH --gres=gpu:1
#SBATCH --time=00:05:00

if [ -z "${PARAM}" ]; then
	PARAM="params.ini"
fi

module purge
module load nvhpc/25.7

cd ${SLURM_SUBMIT_DIR}

ncu \
 --target-processes all --export profile --force-overwrite \
 --kernel-name calc_force_kernel --launch-skip 0 --launch-count 1 "./collapse" ${PARAM}

# L16: options to output file for GUI profiling
# L17: kernel name and launch parameters for profiling (suggested by nsys-ui)
