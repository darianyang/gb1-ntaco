#!/bin/bash
#SBATCH --job-name=pcs_rest_ctd-ntaco_md
#SBATCH --ntasks-per-node=16
#SBATCH --time=23:59:59
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_md.out 
#SBATCH --error=slurm_md.err 

module load nmr/amber/amber20_CUDA

# echo commands to stdout
set -x

# set variables
export DO_PARALLEL="mpirun -np 16"
SANDER=sander.MPI

###################################################
###################################################
###################################################
PDB="2kod_ntaco_solv" 
###################################################
###################################################
###################################################

# 1 ns pcs restrained NPT equilibration Langevin thermostat (298K) MC barostat (1atm)
printf "\nstart pcs restrained equil\n\n" 
$DO_PARALLEL \
    $SANDER -O \
            -i 05_prod.in -o 05_prod.out \
            -p ${PDB}.prmtop -c 04_eq2.rst -r 05_prod.rst &&
printf "\ndone pcs restrained equil\n\n"
