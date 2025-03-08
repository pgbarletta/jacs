from pathlib import Path
from rdkit import Chem
from rdkit.Chem import rdFMCS, AllChem

src_dir = Path(".").resolve()
home_dir = src_dir.parent
data_dir = home_dir / "data"
preparation_dir = data_dir / "preparation"
# fmt: off
binders = ["17", "1h1q", "1h1r", "1h1s", "1oi9", "1oiu", "1oiy", "20", "21", "22", "26", "28", "29", "30", "31", "32"]
# fmt: on

for binder in binders:
    print(binder)
    pdb_docked = Path(preparation_dir, binder, f"binder_{binder}.pdb")
    pdb_minimized = Path(preparation_dir, binder, f"parametrized_binder_{binder}.pdb")

    docked = Chem.MolFromPDBFile(str(pdb_docked), removeHs=False)
    minimized = Chem.MolFromPDBFile(str(pdb_minimized), removeHs=False)

    mcs = rdFMCS.FindMCS([docked, minimized])
    common_smarts = mcs.smartsString
    common_mol = Chem.MolFromSmarts(common_smarts)
    # Map the atoms to find the common atoms
    match_minimized = minimized.GetSubstructMatch(common_mol)
    match_docked = docked.GetSubstructMatch(common_mol)
    # Align the molecules based on the common scaffold.
    AllChem.AlignMol(
        minimized, docked, atomMap=list(zip(match_minimized, match_docked))
    )
    Chem.MolToPDBFile(
        minimized,
        Path(preparation_dir, binder) / f"aligned_parametrized_{binder}.pdb",
        # Don't write CONECT records, let tleap use the .lib and .frcmod info
        flavor=2,
    )
