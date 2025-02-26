Protein structure from Schrodinger public benchmark set was reprepared with Protein preparation wizard in Maestro Schrodinger suite version 2023-2 with capped termini (replace hydrogens was switched off to fix protonation states and tautomers for histidines and optimized hbond assignments.
No cofactors present.
TPO was turned back to Thr.
Ligands structures were taken from the Schrodinger public benchmark set without modification.


# pato's notes

## equil
#### The following ran into issues with MPI when they were about to finish (eqBTI step).
```
1h1s~32/aq

```
The run was actually finished, so all I had to do was run the last `cpptraj` centering step
with `last_cpptraj_step.sh`

#### These got stuck at some point, for no reason:

```
1h1q~31/aq // at step eqP
1h1s~32/com // at step eqA
```
I just restarted them.

#### 21~32 had an actual error on eqpre1P0
`0.00000000_eqpre1P0.rst7` had overflowed coordinates, the potential energy was positive
When I checked `21.pdb` the minimized ligand was clashing with CDK2.

I fixed this ligand in `~/jacs/cdk2/cdk2/unified/run/21~32/com/equil` by running both
endpoints with `clambda=0.5`, so the `21` ligand would settle properly.
I copied the resulting coordinates with `get_fixed_21_32.sh` to `/home/pb777/jacs/cdk2/data/fixing_21/fixed_21_32`
and then moved the folder onto Frontera at `/scratch1/10321/pb777/cdk2/cdk2/unified/run/21~32/fixed_21_32`, where I ran 
`/scratch1/10321/pb777/cdk2/cdk2/unified/run/21~32/get_fixed_starting_structs.shget_fixed_starting_structs.sh`
to get the good initial structures.


####################################
the system structure in `/home/pb777/jacs/cdk2/data/fixing_21/0.00000000_min2.pdb`.
Then `/home/pb777/jacs/cdk2/src/align_parametrized_ligand_21.py` aligned the fixed
ligand to the original position.
Then `/home/pb777/jacs/cdk2/src/cat_complex_21.sh` used `/home/pb777/jacs/cdk2/data/fixing_21/aligned_good_21.pdb`
to generate a new starting complex.
`/home/pb777/jacs/cdk2/data/fixing_21/old_21.pdb` is the backup of the old bad complex.

Also had to fix `21_0.mol2`, now located at `/home/pb777/jacs/cdk2/data/fixing_21/old_21_0.mol2`.
I did this by hand, generating a new mol2 file:

```
antechamber -i aligned_good_21.pdb -fi pdb -o aligned_good_21.mol2 -fo mol2 -pf y -at gaff2
```
And copied the coordinates from `aligned_good_21.mol2` into `old_21_0.mol2`, generating the new
`21_0.mol2`, that I copied back into `/home/pb777/jacs/cdk2/data/cdk2/` .

Then I backed up the old cdk2 workflow to `/home/pb777/jacs/cdk2/bucdk2` and rerun FE-Workflow.


Then I ran `/home/pb777/jacs/cdk2/src/get_fixed_21_32.sh` to get the newly generated `21~32` edge
and to fix the box size since it came out a bit different.

Moved `fixed_21_32` over to Frontera and inside `/scratch1/10321/pb777/cdk2/cdk2/unified/run/21~32` I did:

```
cp ./fixed_21/aq/equil/0.00000000_init.rst7 ./aq/equil/0.00000000_init.rst7
cp ./fixed_21/aq/equil/1.00000000_init.rst7 ./aq/equil/1.00000000_init.rst7

cp ./fixed_21/com/equil/0.00000000_init.rst7 ./com/equil/0.00000000_init.rst7
cp ./fixed_21/com/equil/1.00000000_init.rst7 ./com/equil/1.00000000_init.rst7
```
#############################################
Finally, I reran the edge equil.

## production

Fix production scripts to get a production script per trial by running 
`/scratch1/10321/pb777/cdk2/cdk2/unified/run/fix_prod.sh`

