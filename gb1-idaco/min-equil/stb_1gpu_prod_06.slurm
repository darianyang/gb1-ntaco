#!/bin/bash
#SBATCH --job-name=vVER_PDB_TEMP_PROD_06
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=4
#SBATCH --gres=gpu:4
#SBATCH --time=144:00:00 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_prod_06.out 
#SBATCH --error=slurm_prod_06.err 

module load nmr/amber/amber20_CUDA

# echo commands to stdout
set -x

export DO_PARALLEL="mpirun -np 4"

# Executable
SANDER=pmemd.cuda_SPFP.MPI

# Amber input files and output name
INP=06_prod.in
TOP=PDB_TEMP_solv.prmtop
CRD=05_eq3.rst
OUT=06_prod

$DO_PARALLEL \
$SANDER  -O     -i   $INP   -p   $TOP   -c   $CRD   -r   $OUT.rst \
        -o   $OUT.out   -e   $OUT.ene   -v   $OUT.vel   -inf $OUT.nfo   -x   $OUT.nc &&

# make cpptraj input file
echo "parm PDB_TEMP_solv.prmtop"                            > strip_06.in
echo "trajin 06_prod.nc"                                    >> strip_06.in
echo "autoimage"                                            >> strip_06.in
echo "strip :WAT,Cl-,Na+ parmout PDB_TEMP_dry.prmtop"       >> strip_06.in
echo "trajout 06_prod_dry.nc"                               >> strip_06.in
echo "go"                                                   >> strip_06.in
echo "quit"                                                 >> strip_06.in

# run cpptraj to strip water
cpptraj -i strip_06.in > strip_06.out

# remove solvated nc file
if [ -f "06_prod_dry.nc" ] ; then
    rm 06_prod.nc &&
    mv 06_prod_dry.nc 06_prod.nc
fi

sbatch stb_1gpu_prod_07.slurm
