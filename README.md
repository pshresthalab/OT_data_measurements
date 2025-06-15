# Shrestha-et-al-Nucleic Acids Research 2025
This is a repository of codes to accompany the paper,

Single-Molecule Mechanostructural Fingerprinting of Nucleic Acids Conformations

Prakash Shrestha1,2,3,5*, William M. Shih3,4,5, and Wesley P. Wong2,3,5*

1 Department of Chemistry, University of Kentucky

2 Program in Cellular and Molecular Medicine, Boston Children’s Hospital.

3 Wyss Institute for Biologically Inspired Engineering, Harvard University.

4 Department of Cancer Biology, Dana-Farber Cancer Institute.

5 Department of Biological Chemistry and Molecular Pharmacology, Blavatnik Institute, Harvard Medical School.

OT_data_measurement files contain all the scripts to extract parameters measured using optical tweezers. These include calibration routines to determine the trap stiffness, which is used for calculating molecular force. The change in molecular extension due to unlooping of DNA nanoswitch caliper is measured at specific forces used to shear a DNA handle attached to the target biomolecule. The distance change is calculated by subtracting the extension before and after unlooping at the shearing force. Distributions of the measured extension changes are subsequently analyzed using Igor Pro 6.32. 
The function, OT_Qick_Process_FX_Plot_Cal is used to extract the measured parameters and OT_deltaX_measure function is used to measure the distance change due to unlooping of DNC at the shearing force. The dx_constantForce function is used to measure the change in distance at the constant force before and after unlooping during the directional unfolding experiments.
