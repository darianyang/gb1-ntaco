#!/bin/bash
#SBATCH --job-name=dihis_nta_opt_orca
#SBATCH --ntasks-per-node=1
#SBATCH --time=23:59:59
#SBATCH --cluster=invest
#SBATCH --partition=lchong
#SBATCH --mem=32g
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm.out 
#SBATCH --error=slurm.err 

module load gcc/4.8.5 openmpi/4.1.1
module load orca/5.0.0

# set variables
#export DO_PARALLEL="mpirun -np 8"

orca opt.inp > opt.out 
