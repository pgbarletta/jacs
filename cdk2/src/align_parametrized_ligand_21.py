from pathlib import Path
from rdkit import Chem
from rdkit.Chem import rdFMCS, AllChem

src_dir = Path(".").resolve()
home_dir = src_dir.parent
data_dir = home_dir / "data"
preparation_dir = data_dir / "preparation"
fix_dir = data_dir / "fixing_21"

binder = "21"
print(binder)
pdb_docked = Path(preparation_dir, binder, f"binder_{binder}.pdb")
pdb_minimized = Path(fix_dir, f"good_{binder}.pdb")

docked = Chem.MolFromPDBFile(str(pdb_docked), removeHs=False)
minimized = Chem.MolFromPDBFile(str(pdb_minimized), removeHs=False)

# The ligand comes with the name that FE-workflow gave to it (L08)
minimized.SetProp("_Name", "LIG")
mi = Chem.AtomPDBResidueInfo()
mi.SetResidueName("LIG")
mi.SetResidueNumber(1)
mi.SetOccupancy(0.0)
mi.SetTempFactor(0.0)
[a.SetMonomerInfo(mi) for a in minimized.GetAtoms()]
###

mcs = rdFMCS.FindMCS([docked, minimized])
common_smarts = mcs.smartsString
common_mol = Chem.MolFromSmarts(common_smarts)
# Map the atoms to find the common atoms
match_minimized = minimized.GetSubstructMatch(common_mol)
match_docked = docked.GetSubstructMatch(common_mol)
# Align the molecules based on the common scaffold.
AllChem.AlignMol(minimized, docked, atomMap=list(zip(match_minimized, match_docked)))
Chem.MolToPDBFile(
    minimized,
    Path(fix_dir) / f"aligned_good_{binder}.pdb",
    # Don't write CONECT records, let tleap use the .lib and .frcmod info
    flavor=2,
)
