# QM Opt

qm: using the min structure of best guess diHis NTA-Co with CA and CB constrainted
    * Note that this wasn't the true Co starting position determined from PCS
    * But I wonder, will it move to that position?
    * Strange result because of the non-protonated carbons

qm2: I realized I used NTA without the protons
    * Added the protons, redid constrained min in Avogadro
    * Then ran constrained QM again
    * After alignment, it seems like the Co did not gravitate towards the PCS position

qm3: Now I will try it again with HIS CA/CB and Co restrained 
    * Starting from WZ structure/PCS Co position, then adding in NTA form xtal
    * The resulting opt seems to peel away from the Nd coordination
        * Perhaps the CB needs to be mobile

qm4: This time I am using constraints only on CA and Co
    * Ideally I would use a soft constraint on CB but this isn't possible in ORCA (I think)
    * So now the same tautomers but with only CA and Co constrainted energy min then QM opt
