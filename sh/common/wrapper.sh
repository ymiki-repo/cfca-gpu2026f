#!/usr/bin/env bash

# obtain process rank within a node
if [ -n "$OMPI_COMM_WORLD_LOCAL_RANK" ] || [ -n "$MV2_COMM_WORLD_LOCAL_RANK" ]; then
	local_rank=${OMPI_COMM_WORLD_LOCAL_RANK:=${MV2_COMM_WORLD_LOCAL_RANK}}
else
	mpi_rank=${OMPI_COMM_WORLD_RANK:=${MV2_COMM_WORLD_RANK:=${PMI_RANK:=${PMIX_RANK:=0}}}}

	cores_per_node=`LANG=C command lscpu | command sed -n 's/^CPU(s): *//p'`
	mpi_size=${OMPI_COMM_WORLD_SIZE:=${MV2_COMM_WORLD_SIZE:=${PMI_SIZE:=${OMPI_UNIVERSE_SIZE:=1}}}}
	procs_per_node=`expr $mpi_size / $cores_per_node`
	if [ $procs_per_node -lt 1 ]; then
		procs_per_node=$mpi_size
	fi

	local_rank=`expr $mpi_rank % $procs_per_node`
fi

GPU_ID=${local_rank}
export CUDA_VISIBLE_DEVICES=${GPU_ID}

# # for Wisteria-A
# if [ ${GPU_ID} -eq 0 ] || [ ${GPU_ID} -eq 1 ]; then
# 	export UCX_NET_DEVICES=mlx5_0:1
# elif [ ${GPU_ID} -eq 2 ] || [ ${GPU_ID} -eq 3 ]; then
# 	export UCX_NET_DEVICES=mlx5_1:1
# elif [ ${GPU_ID} -eq 4 ] || [ ${GPU_ID} -eq 5 ]; then
# 	export UCX_NET_DEVICES=mlx5_2:1
# elif [ ${GPU_ID} -eq 6 ] || [ ${GPU_ID} -eq 7 ]; then
# 	export UCX_NET_DEVICES=mlx5_3:1
# fi

# for gxa2
export UCX_NET_DEVICES=mlx5_${GPU_ID}:1

$*
