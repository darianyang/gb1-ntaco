"""
Create the &pcshf namelist file that is input into amber.
In mdin files: PCSHIFT=pcs.in with &pcshf namelist.
"""

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
        # files
        self.pdb = pdb
        self.pcsnpc = pcsnpc

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
        newline = "\n "
        header = "&pcshf" + newline
        # number of pseudocontact shifts from npc file
        header += f"nprot=" + newline
        # number of paramagnetic centers
        header += f"nme={self.nme}" + newline
        # name of paramagnetic atom
        header += f"nmpmc='{self.nmpmc}'" + newline
        # phi, theta, omega
        header += f""

        return header


    def build_pcs_constraints(self):
        """
        Builds a string with each pcs constraint from npc file.
        """
        pass

    def write_file(self):
        """
        Main public method, writes the pcshf file.
        """

        # close the file
        self.out.close()

