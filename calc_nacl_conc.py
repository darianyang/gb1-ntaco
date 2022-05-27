
import sys
import numpy as np
np.longfloat

# help documentation
if sys.argv[1] == "-h" or sys.argv[1] == "--help":
    print(
    """
    Calculate the concentration of NaCl needed for a given volume.

    Arguments
    ---------
    1 : int
        [NaCl] in mM
    2 : float
        Volume of a truncated octahedral box in Å^3
    """
    )
    sys.exit(0)

saltconc = int(sys.argv[1])
volume = float(sys.argv[2])

print(f"\n[salt] = {saltconc} mM | volume = {volume} Å^3")

def calc_num_ions(saltconc, volume):
    """
    Returns number of Na+ and Cl- ions to add for the given [salt] and volume.
    """
    # convert Å^3 to liters
    #liters = (volume) * (1**3/10**10**3) * (10**2**3/1**3) * (1/1**3)
    liters = volume * (1/1e27)
    
    print(f"liters: {liters}")

    # chloride ions in one liter of solution at given saltconc
    saltatoms = (saltconc/1) * (1/10**3) * (6.022*10**23/1)

    print(f"atoms: {saltatoms}")

    # chloride ions for the box size
    ions = liters * saltatoms

    return ions

ions = calc_num_ions(saltconc, volume)
print(f"\nAbout {ions:0.3f} Na+ and Cl- ions are needed")
print("\nNote that: Upon equilibration of the system, the volume of the box will decrease as the solute-solvent interactions come into effect. Therefore, the equilibrated salt concentration is larger than the starting concentration for NPT simulations.")
print("\nCalculation based on the following tutorial: \nhttps://ambermd.org/tutorials/basic/tutorial8/index.php\n")
