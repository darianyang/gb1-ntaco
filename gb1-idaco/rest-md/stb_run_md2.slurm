#!/bin/bash
#SBATCH --job-name=pcs_rest_gb1-idaco_md_10ns
#SBATCH --ntasks-per-node=16
#SBATCH --time=143:59:59
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
#SANDER=sander

###################################################
###################################################
###################################################
PDB="gb1_idaco_solv" 
###################################################
###################################################
###################################################

# 10 ns pcs restrained NPT production Langevin thermostat (298K) MC barostat (1atm)
printf "\nstart pcs restrained md\n\n" 
$DO_PARALLEL \
    $SANDER -O \
            -i 06_prod.in -o 06_prod.out \
            -p ${PDB}.prmtop -c 05_prod.rst -r 06_prod.rst &&
printf "\ndone pcs restrained md\n\n"
