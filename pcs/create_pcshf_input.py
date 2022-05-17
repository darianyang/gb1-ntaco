"""
Create the &pcshf namelist file that is input into amber.
In mdin files: PCSHIFT=pcs.in with &pcshf namelist.
"""

import pdb
import numpy as np

class Create_PCSHF_Input:

    def __init__(self, pdb, pcsnpc, magtensor, angle_units="degrees", 
                 nme=1, nmpmc="CO", optkon=30, out="pcs.in"):
        """
        Class to create the &pcshf namelist file that is input into amber.

        Parameters
        ----------
        pdb : filepath str
            PDB coordinate file.
        pcsnpc : filepath str
            NPC file containing pcs experimental data.
        magtensor : list of 5 floats
            The five parameters of the magnetic anisotropy tensor for the paramagnetic center.
            Amber: optphi(n), opttet(n), optomg(n), opta1(n), opta2(n)
            General: phi, theta, omega, ∆chi_ax, ∆chi_rh
        angle_units : str
            Can be 'degrees' (default) or 'radians'. Will convert degrees to radians.
            Radians are used by default in Amber.
        nme : int (TODO: can only handle 1 for now)
            Number of paramagnetic centers, default 1.
        nmpmc : str
            Name of the paramagnetic atom, default 'CO' (Cobalt).
        optkon : int
            Force constant for the PCS constraints.
        out : filepath str
            Path to and name of the pcshf output file, default 'pcs.in'.
        """
        # save raw file strings as numpy arrays
        with open(pdb, "r") as pdb_file:
            pdb_lines = pdb_file.readlines()
        # only save the backbone NH atom lines
        self.pdb = np.loadtxt([line for line in pdb_lines if line[13:15] == "H "], dtype=str)
        with open(pcsnpc, "r") as npc_file:
            self.pcsnpc = np.loadtxt(npc_file.readlines(), dtype=str)

        # unpack tensor parameters
        if angle_units == "radians":
            self.phi = magtensor[0]
            self.theta = magtensor[1]
            self.omega = magtensor[2]
        # convert to radians if needed
        elif angle_units == "degrees":
            self.phi = magtensor[0] * (np.pi/180)
            self.theta = magtensor[1] * (np.pi/180)
            self.omega = magtensor[2] * (np.pi/180)
        else:
            raise ValueError(f"angle_units={angle_units}, this must be 'radians' or 'degrees'.")
        self.a1 = magtensor[3]
        self.a2 = magtensor[4]

        self.nme = nme
        self.nmpmc = nmpmc
        self.optkon = optkon

        # set up the output file to write
        self.out = open(out, "w+")


    def build_pcshf_header(self):
        """
        Builds a string with info about the paramagnetic center(s).
        """
        header = "&pcshf" + ",\n"
        # number of pseudocontact shifts from npc file
        header += f" nprot={len(self.pcsnpc)}" + ",\n"
        # number of paramagnetic centers
        header += f" nme={self.nme}" + ",\n"
        # name of paramagnetic atom
        header += f" nmpmc='{self.nmpmc}'" + ",\n"
        # phi, theta, omega of each paramagnetic center (just 1 in this case)
        header += f" optphi(1)={self.phi},\n opttet(1)={self.theta},\n optomg(1)={self.omega},\n"
        # ∆chi_ax and ∆chi_rh of each paramagnetic center
        header += f" opta1(1)={self.a1},\n opta2(1)={self.a2},\n"
        # force constant
        header += f" optkon={self.optkon}" + ",\n"

        return header


    def build_pcs_constraints(self, wt=1.0, tolpro=1.0, mltpro=1):
        """
        Builds a string with each pcs constraint from npc file.

        Parameters (TODO; put in init?)
        ----------
        wt : float
            Optional weight of each pcs constraint.
        tolpro : float
            Relative tolerance x mltpro (multiplicity).
        mltpro : int
            Multiplicity, e.g. 3 for methyl groups.
        """
        # multi line string for each pcs constraint
        pcs = " ! beginning writing of each pcs constraint \n"
        # pcsnpc format: 
        # [residue_index | atom_name | pcs | exp_error]
        # ['55', 'HN', '0.299', '0']
        # pdb formatting: 
        # ['ATOM', '839', 'H', 'GLU', '56', '-9.107', '4.313', '3.287', '1.00', '0.00']]
        for num, line in enumerate(self.pcsnpc):
            # match the pcs residue with the pdb residue (col4), then get pdb atom number (col2)
            atom_num = int(self.pdb[np.argwhere(self.pdb[:,4]==line[0]), 1])
            # proton atom number, observed pcs, relative weight
            pcs += f" iprot({num+1})={atom_num}, obs({num+1})={line[2]}, wt({num+1})={wt},"
            pcs += f" tolpro({num+1})={tolpro}, mltpro({num+1})={mltpro}, \n"

        return pcs

    def write_file(self):
        """
        Main public method, writes the pcshf file.
        """
        # write file header
        self.out.write(self.build_pcshf_header())

        # write pcs constraints
        self.out.write(self.build_pcs_constraints())

        # close the file
        self.out.close()


if __name__ == "__main__":
    # phi=60.42, theta=75.172, omega =107.84 ; delta-chi,ax=-6.342; delta-chi,rh=-1.411
    magtensor = [60.42, 75.172, 107.84, -6.342, -1.411]
    pcs = Create_PCSHF_Input("gb1-ntaco_solv.pdb", "dHis-NTA_Co-PCS_HN_full.npc", magtensor)
    pcs.write_file()