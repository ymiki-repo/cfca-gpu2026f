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

./collapse ${PARAM}
