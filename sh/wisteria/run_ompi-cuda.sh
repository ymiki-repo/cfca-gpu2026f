#!/usr/bin/env bash
#PJM -L rscgrp=short-a
#PJM -L node=1
#PJM --mpi proc=8
#PJM -L elapse=00:05:00
#PJM -g gz00

if [ -z "${PARAM}" ]; then
	PARAM="params.ini"
fi

module purge
module load gcc/8.3.1
module load cuda/12.2
module load ompi-cuda/4.1.5-12.2

cd ${PJM_O_WORKDIR}

mpiexec -machinefile ${PJM_O_NODEINF} -n ${PJM_MPI_PROC} -npernode 8 sh/common/wrapper.sh ./collapse_mpi ${PARAM}
