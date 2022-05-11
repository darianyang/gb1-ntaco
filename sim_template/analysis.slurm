#!/bin/bash
#SBATCH --job-name=PDB_TEMP_ANAL
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --cluster=smp
#SBATCH --partition=smp
#SBATCH --mem=16g
#SBATCH --time=23:59:59 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_cpp.out 
#SBATCH --error=slurm_cpp.err 

# load appropriate modules.  First purge all modules then load in intel (a prereq for loading in amber) and then amber 
module purge
module load intel/2017.3.196
module load amber/18

# echo commands to stdout
set -x

bash cpptraj.sh
