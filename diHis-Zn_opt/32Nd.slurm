#!/bin/bash
#SBATCH --job-name=32Nd-dihis_nta_Zn_opt
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
SMDsolvent "DMF"
end
# triple zeta basis on Zn
%basis newgto Zn "def2-TZVP" end end
# constrain CA and CB atoms of diHis (determined by backbone helix)
%geom
Constraints
{C 0 C}
{C 1 C}
{C 12 C}
{C 13 C}
end
end
 * xyzfile -1 1 ../32Nd-28Ne-nta-zn.xyz
EOF

orca opt.inp > opt.out 
