#!/bin/bash
#SBATCH --job-name=32Nd-dihis_nta_Co_opt_qm2
#SBATCH --ntasks-per-node=1
#SBATCH --time=23:59:59
#SBATCH --cluster=invest
#SBATCH --partition=lchong
#SBATCH --mem=32g
#SBATCH --mail-user=dty7@pitt.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=32Nd/slurm.out 
#SBATCH --error=32Nd/slurm.err 

module load gcc/4.8.5 openmpi/4.1.1
module load orca/5.0.0

# set variables
#export DO_PARALLEL="mpirun -np 8"

cd 32Nd 

cat << EOF > opt.inp
! RI BP86 def2-SVP def2/J D3BJ TIGHTSCF Opt
! CPCM
# memory
%maxcore 32000
# smd solvation model
%cpcm
smd true
SMDsolvent "water"
end
# triple zeta basis on Co
%basis newgto Co "def2-TZVP" end end
# constrain CA and CB atoms of diHis (determined by backbone helix)
# and constrain Co in PCS defined position
%geom
Constraints
{C 1 C}
{C 2 C}
{C 13 C}
{C 14 C}
end
end
 * xyzfile -1 2 ../32Nd-28Ne-nta-co-min.xyz
EOF

orca opt.inp > opt.out 
