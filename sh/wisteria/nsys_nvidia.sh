#!/usr/bin/env bash
#PJM -L rscgrp=share-short
#PJM -L gpu=1
#PJM -L elapse=00:05:00
#PJM -g gz00

if [ -z "${PARAM}" ]; then
	PARAM="params.ini"
fi

module purge
module load nvidia/24.11

cd ${PJM_O_WORKDIR}

# -t, --trace=
# 	Possible values are 'cuda', 'nvtx', 'cublas', 'cublas-verbose', 'cusolver',
# 	'cusolver-verbose', 'cusparse', 'cusparse-verbose', 'mpi', 'oshmem', 'ucx',
# 	'osrt', 'cudnn', 'opengl', 'opengl-annotations', 'openacc', 'openmp',
# 	'nvvideo', 'vulkan', 'vulkan-annotations', 'python-gil', 'syscall' or 'none'.
# 	Select the API(s) to trace. Multiple APIs can be selected, separated by commas only
# 	(no spaces).
# 	If '<api>-annotations' is selected, the corresponding API will also be traced.
# 	If 'none' is selected, no APIs are traced.
# 	Default is 'cuda,nvtx,osrt,opengl'. Application scope.

nsys profile --stats=true --trace=osrt,cuda,openacc,openmp,nvtx,mpi,oshmem,ucx \
 ./collapse ${PARAM}
