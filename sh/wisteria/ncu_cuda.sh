#!/usr/bin/env bash
#PJM -L rscgrp=share-short
#PJM -L gpu=1
#PJM -L elapse=00:05:00
#PJM -g gz00

if [ -z "${PARAM}" ]; then
	PARAM="params.ini"
fi

module purge
module load cuda/12.6

cd ${PJM_O_WORKDIR}

ncu \
 --target-processes all --export profile --force-overwrite \
 --kernel-name calc_force_kernel --launch-skip 0 --launch-count 1 "./collapse" ${PARAM}

# L17: options to output file for GUI profiling
# L18: kernel name and launch parameters for profiling (suggested by nsys-ui)
