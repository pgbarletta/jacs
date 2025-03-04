%NPROC=16', f'%MEM=20480MB
%chk=binder_22.antechamber.chk
#P HF/6-31G* OPT(CalcFC) GEOM(ALLCheck) Guess(Read)

Gaussian Calculation

0 1


--Link1--
%NPROC=16', f'%MEM=20480MB
%chk=binder_22.antechamber.chk
#P PBE1PBE/6-31G* OPT(CalcFC) GEOM(ALLCheck) Guess(Read)

Gaussian Calculation

0 1


--Link1--
%NPROC=1', f'%MEM=4096MB
%chk=binder_22.antechamber.chk
#P HF/6-31G* GEOM(AllCheck) Guess(Read) NoSymm Pop=mk IOp(6/33=2) GFInput GFPrint

Gaussian Calculation

0 1


