#!/bin/bash
#SBATCH --job-name=rest_pcs_gb1_ntaco_PROD_07
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=24
#SBATCH --time=144:00:00 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_prod_07.out 
#SBATCH --error=slurm_prod_07.err 

module load nmr/amber/amber20_CUDA

# echo commands to stdout
set -x

export DO_PARALLEL="mpirun -np 48"

# Executable
SANDER=sander.MPI

# Amber input files and output name
INP=07_prod.in
TOP=gb1-ntaco_solv.prmtop
#CRD=06_min.rst
CRD=05_eq3.rst
OUT=07_prod

$DO_PARALLEL \
$SANDER  -O     -i   $INP   -p   $TOP   -c   $CRD   -r   $OUT.rst \
        -o   $OUT.out   -e   $OUT.ene   -v   $OUT.vel   -inf $OUT.nfo   -x   $OUT.nc

# make cpptraj input file
#echo "parm gb1-ntaco_solv.prmtop"                            > strip_07.in
#echo "trajin 07_prod.nc"                                    >> strip_07.in
#echo "autoimage"                                            >> strip_07.in
#echo "strip :WAT,Cl-,Na+ parmout gb1-ntaco_dry.prmtop"      >> strip_07.in
#echo "trajout 07_prod_dry.nc"                               >> strip_07.in
#echo "go"                                                   >> strip_07.in
#echo "quit"                                                 >> strip_07.in
#
## run cpptraj to strip water
#cpptraj -i strip_07.in > strip_07.out
#
## remove solvated nc file
#if [ -f "07_prod_dry.nc" ] ; then
#    rm 07_prod.nc &&
#    mv 07_prod_dry.nc 07_prod.nc
#fi

