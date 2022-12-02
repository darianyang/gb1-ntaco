#!/bin/bash
# use this script to make multiple slurm submission files

PROD_IN=50ns_prod.in

# loop over and create multiple prod with slurm files
for PROD in {06..45} ; do
    # keep leading zero but prevent octal interpretation, keep base10
    PREV=$(printf "%02d" $((10#$PROD - 1)))
    NEXT=$(printf "%02d" $((10#$PROD + 1)))

    # var for input coordinate file
    # unique values for first prod run
    if [ $PROD == 06 ] ; then
        CRD=05_eq3.rst
        PARMOUT="parmout PDB_TEMP_dry.prmtop"
    else
        CRD=${PREV}_prod.rst
        PARMOUT=""
    fi 

    # make the prod md input file
    cp $PROD_IN ${PROD}_prod.in

# make the slurm submission file
cat << EOF > stb_gpu_prod_${PROD}.slurm
#!/bin/bash
#SBATCH --job-name=vVER_PDB_TEMP_PROD_$PROD
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --time=144:00:00 
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm_prod_${PROD}.out 
#SBATCH --error=slurm_prod_${PROD}.err 

module load nmr/amber/amber20_CUDA

# echo commands to stdout
set -x

#export DO_PARALLEL="mpirun -np 1"

# Executable
SANDER=pmemd.cuda_SPFP

# NPT production Langevin thermostat (298K) MC barostat (1atm)
###############
#\$DO_PARALLEL#
###############
    \$SANDER -O \
            -i ${PROD}_prod.in -o ${PROD}_prod.out -x ${PROD}_prod.nc \
            -p PDB_TEMP_solv.prmtop -c $CRD -r ${PROD}_prod.rst -inf ${PROD}_prod.nfo &&


mkdir strip
# make cpptraj input file
echo "parm PDB_TEMP_solv.prmtop"                            > strip/strip_${PROD}.in
echo "trajin ${PROD}_prod.nc"                               >> strip/strip_${PROD}.in
echo "autoimage"                                            >> strip/strip_${PROD}.in
echo "strip/strip :WAT,Cl-,Na+ $PARMOUT"                    >> strip/strip_${PROD}.in
echo "trajout ${PROD}_prod_dry.nc"                          >> strip/strip_${PROD}.in
echo "go"                                                   >> strip/strip_${PROD}.in
echo "quit"                                                 >> strip/strip_${PROD}.in

# run cpptraj to strip water
cpptraj -i strip/strip_${PROD}.in > strip/strip_${PROD}.out

# remove solvated nc file
if [ -f "${PROD}_prod_dry.nc" ] ; then
    rm ${PROD}_prod.nc &&
    mv ${PROD}_prod_dry.nc ${PROD}_prod.nc
fi

sbatch stb_gpu_prod_${NEXT}.slurm
EOF


done
