from pathlib import Path

from rdkit import Chem
from rdkit.Chem import AllChem

from ligandparam.recipes import LazyLigand


home_dir = Path("/home/pb777/reaf_check/jacs/cdk2")
data_dir = home_dir / "data"

# mols = Chem.SDMolSupplier(Path(data_dir, "binders") / "ligands.sdf", removeHs=False)
# for mol in mols:
#
#     name = mol.GetProp("_Name")
#     for  atm  in  mol.GetAtoms():
#         atm.SetMonomerInfo(Chem.AtomPDBResidueInfo(atomName = "",residueName=name, residueNumber=1, isHeteroAtom=True))
#
#     binder_dir = Path(data_dir, name)
#     Path.mkdir(binder_dir, exist_ok=True)
#     Chem.MolToPDBFile(mol, Path(binder_dir, f"binder_{name}.pdb"))

name = "1h1q"
binder_dir = Path(data_dir, name)
# Load the pdb as a instance of the FreeLigand class
binder_fn = Path(binder_dir, f"binder_{name}.pdb")
parametrize_ligand = LazyLigand(str(binder_fn), netcharge=0, nproc=12, mem='32GB', cwd=binder_dir)
parametrize_ligand.setup()
parametrize_ligand.list_stages()

parametrize_ligand.execute(dry_run=False)