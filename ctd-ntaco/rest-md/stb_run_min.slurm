#!/bin/bash
#SBATCH --job-name=pcs_rest_gb1-ntaco_min
#SBATCH --ntasks-per-node=8
#SBATCH --time=23:59:59
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_min.out 
#SBATCH --error=slurm_min.err 

module load nmr/amber/amber20_CUDA

# echo commands to stdout
set -x

# set variables
export DO_PARALLEL="mpirun -np 8"
SANDER=sander.MPI

###################################################
###################################################
###################################################
PDB="2kod_ntaco_solv" 
###################################################
###################################################
###################################################

# 10000 step minimization (500 steepest descent)
printf "\nstart min\n\n" 
$DO_PARALLEL \
    $SANDER -O \
            -i 02_min.in -o 02_min.out \
            -p ${PDB}.prmtop -c ${PDB}.inpcrd -r 02_min.rst &&
printf "\ndone min\n\n" 

