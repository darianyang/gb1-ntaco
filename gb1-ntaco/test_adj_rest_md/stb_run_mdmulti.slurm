#!/bin/bash
#SBATCH --job-name=pcs_rest_gb1-ntaco_md_multi_to_10ns
#SBATCH --ntasks-per-node=16
#SBATCH --time=143:59:59
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_mdm.out 
#SBATCH --error=slurm_mdm.err 

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
PDB="gb1_ntaco_solv" 
###################################################
###################################################
###################################################

# 10 ns pcs restrained NPT production Langevin thermostat (298K) MC barostat (1atm)
#printf "\nstart pcs restrained md\n\n" 
#$DO_PARALLEL \
#    $SANDER -O \
#            -i 06_prod.in -o 06_prod.out \
#            -p ${PDB}.prmtop -c 05_prod.rst -r 06_prod.rst &&
#printf "\ndone pcs restrained md\n\n"

for PROD in {14..15} ; do
    # keep leading zero but prevent octal interpretation, keep base10
    PREV=$(printf "%02d" $((10#$PROD - 1)))
    # 1 ns pcs restrained NPT production Langevin thermostat (298K) MC barostat (1atm)
    printf "\nstart $PROD prod pcs restrained md\n\n" 
    $DO_PARALLEL \
        $SANDER -O \
                -i ${PROD}_prod.in -o ${PROD}_prod.out \
                -p ${PDB}.prmtop -c ${PREV}_prod.rst -r ${PROD}_prod.rst &&
    printf "\ndone $PROD prod pcs restrained md\n\n"
done
