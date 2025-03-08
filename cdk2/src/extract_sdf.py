from pathlib import Path
from rdkit import Chem


home_dir = Path("..").resolve()
data_dir = home_dir / "data"

mols = Chem.SDMolSupplier(data_dir / "ligands.sdf", removeHs=False)
for mol in mols:
    name = mol.GetProp("_Name")
    print(name)
    mol.SetProp("_Name", "LIG")
    for atm in mol.GetAtoms():
        atm.SetMonomerInfo(
            Chem.AtomPDBResidueInfo(
                atomName="", residueName="LIG", residueNumber=1, isHeteroAtom=True
            )
        )

    target_dir = Path(data_dir, "preparation", name)
    Path.mkdir(target_dir, exist_ok=True)
    Chem.MolToPDBFile(mol, Path(target_dir, f"binder_{name}.pdb"))
