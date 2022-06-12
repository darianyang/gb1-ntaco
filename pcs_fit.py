"""
Calc and plot the agreement with a pdb and the experimental pcs.
"""

from paramagpy import protein, fit, dataparse, metal
import matplotlib.pyplot as plt
import numpy as np

# biopython import warnings with amber pdb files
import warnings
warnings.filterwarnings("ignore")

def pcs_fitting(pdb, pcs, model=0, chain=" ", residue=27, atom="NZ"):
	"""
	Parameters
	----------
	pdb : str
		Path to pdb file.
	pcs : str
		Path to pcs file (npc format).
	model : int
		For initial metal position: Model number, default 0.
	chain : str
		For initial metal position: Chain identifier, default no chain id.
	residue : int
		For initial metal position: Residue index, default 27.
	atom : str
		For initial metal position: Atom name, default 'NZ'.

	Returns
	-------
	data : list
	"""
	# Load the PDB file
	prot = protein.load_pdb(pdb)

	# Load the PCS data
	rawData = dataparse.read_pcs(pcs)

	# Associate PCS data with atoms of the PDB
	parsedData = prot.parse(rawData)

	# Define an initial tensor
	mStart = metal.Metal()

	# Set the starting position to an atom close to the metal
	mStart.position = prot[model][chain][residue][atom].position

	# Calculate an initial tensor from an SVD gridsearch
	[mGuess], [data] = fit.svd_gridsearch_fit_metal_from_pcs(
		[mStart],[parsedData], radius=10, points=10, offsetShift=False)

	# Refine the tensor using non-linear regression
	[mFit], [data] = fit.nlr_fit_metal_from_pcs([mGuess], [parsedData], 
												useracs=True, userads=True)

	# Calculate the Q-factor
	qfac = fit.qfactor(data)

	# Save the fitted tensor to file
	#mFit.save('4ipy_intra_PCS_tensor.txt')


	#### Plot the correlation ####
	fig, ax = plt.subplots(figsize=(5,5))

	# Plot the data
	ax.plot(data['exp'], data['cal'], marker='o', lw=0, ms=3, c='r', 
		label="Q-factor = {:5.4f}".format(qfac))

	# Plot a diagonal
	l, h = ax.get_xlim()
	ax.plot([l,h],[l,h],'-k',zorder=0)
	ax.set_xlim(l,h)
	ax.set_ylim(l,h)

	# Make axis labels and save figure
	ax.set_xlabel("Experiment")
	ax.set_ylabel("Calculated")
	ax.legend()
	#fig.savefig("pcs_fit.png")
	fig.tight_layout()
	plt.show()

# gb1 ntaco
# pcs_fitting("gb1-ntaco/test_adj_rest_md/15_prod.pdb", 
# 			"pcs/dHis-NTA_Co-PCS_H_full.npc",
#             residue=57, atom="CO")

# gba idaco
pcs_fitting("gb1-idaco/rest-md/06_prod.pdb", 
			"pcs/dHis-IDA_Co-PCS_H_addT55.npc",
            residue=57, atom="CO")