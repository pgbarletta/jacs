# pato's notes
## target

 - Ran:
```
pdb4amber -i protein.pdb -o target_cdk2.pdb -y
```
 - Then rename the `CA`s at the NME caps to `C`, according to Amber's format.
 - Clean pdb4amber extra output: `rm target_cdk2_*`

### binders

- Ran `/jacs/cdk2/src/extract_sdf.py` to split the `ligands.sdf` into PDBs
- Had to rerun the gaussian calculation for the `22` binder. The HF geom optim
  would end with an error aftern running too many steps. I started a new run
  from the checkpoint file.
- Generated `.lib`, `.frcmod` and `.resp.mol2` files for the ligands at
  `~/reaf_check/jacs/cdk2/data/preparation`.
- Also generated `.pdb` files for the minimized geometries, which I then aligned
  to the original `.pdb` file with `align_parametrized_ligand.py`, so I can later
  form the complex. These files are called `aligned_parametrized_...pdb`
- Copied the `.lib`, `.frcmod` and `.resp.mol2` files into
  `/home/pb777/reaf_check/jacs/cdk2/data/preparation/cdk2`.
- Renamed them to fit `FE-Workflow` naming scheme.

### complex
 - catted the `aligned_parametrized_...pdb` ligands onto the `target_cdk2.pdb`
 and rerun `pdb4amber`. All with `cat_complex.sh`.
   

### setup_fe
After running `setup_fe` with `/home/pb777/reaf_check/jacs/cdk2/input`, a couple
of fixes needed to be done on the SLURM scripts:

```
find . -name run_equilibration.slurm | xargs sed -i '27i dameamber earlystop'
find . -name run_equilibration.slurm | xargs sed -i '4d'
find . -name run_equilibration.slurm | xargs sed -i 's/--ntasks-per-node=24/--ntasks-per-node=12/g'
find . -name run_equilibration.slurm | xargs sed -i 's/--nodes=1/--nodes=2/g'

find . -name run_production.slurm | xargs sed -i '13i dameamber earlystop'
find . -name run_production.slurm | xargs sed -i 's/--ntasks-per-node=24/--ntasks-per-node=12/g'
find . -name run_production.slurm | xargs sed -i 's/--nodes=1/--nodes=2/g'
```

These changes were done to load the necessary environment to run amber, to redirect
stdout and stderr to the same SLURM output file, and to correctly use Frontera's resources.

## Fixing ti mdin's before running TI

```
find . -name *ti.mdin | xargs sed -i 's/numexchg        = 60000/numexchg        = 40000/g'
find . -name *ti.mdin | xargs sed -i 's/ntwr            = 125/ntwr            = 250/g'
find . -name *ti.mdin | xargs sed -i 's/ntpr            = 125/ntpr            = 250/g'
```

##

