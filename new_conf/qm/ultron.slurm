#!/bin/bash
#SBATCH --job-name=dihis_nta_opt_orca
#SBATCH --ntasks-per-node=1
#SBATCH --time=0:59:59
##SBATCH --mem=32g
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm.out 
#SBATCH --error=slurm.err 

module purge
module load nmr/orca/4.0.1.2

# set variables
#export DO_PARALLEL="mpirun -np 8"

orca --version
#orca opt.inp > opt.out 
