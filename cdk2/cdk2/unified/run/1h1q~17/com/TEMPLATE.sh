#!/usr/bin/env bash
top=`pwd`

parmbase=unisc
rstbase=(stateA stateB)
endstates=(0.00000000 1.00000000)
twostate=true
lams=(0.00000000 0.17964896 0.23357541 0.27400537 0.30806539 0.33836806 0.36621555 0.39237392 0.41734721 0.44149723 0.46510424 0.48840164 0.51159836 0.53489576 0.55850277 0.58265279 0.60762608 0.63378445 0.66163194 0.69193461 0.72599463 0.76642459 0.82035104 1.00000000)
env=com
preminTIstage=eqProt0

#generate initial configurations for lambda windows
mkdir -p current inputs

count=0
for lam in ${endstates[@]};do
        cp ${rstbase[$count]}.rst7  current/${lam}_init.rst7
        #cp ${parmbase}.parm7 unisc.parm7

        init=${lam}_init
        min1=${lam}_min1
        min2=${lam}_min2
        eqpre1P0=${lam}_eqpre1P0
        eqpre2P0=${lam}_eqpre2P0
        eqP0=${lam}_eqP0
        eqNTP4=${lam}_eqNTP4 
        eqV=${lam}_eqV
        eqP=${lam}_eqP
        eqA=${lam}_eqA
        eqProt2=${lam}_eqProt2
        eqProt1=${lam}_eqProt1
        eqProt05=${lam}_eqProt05
        eqProt025=${lam}_eqProt025
        eqProt01=${lam}_eqProt01
        eqProt0=${lam}_eqProt0
        ti=${lam}_ti

        cat<<EOF>inputs/${min1}.mdin
Minimization with Cartesian restraints for the solute
&cntrl
imin            = 1
maxcyc          = 5000
ntmin           = 2
ntx             = 1
ntxo            = 1
ntpr            = 5
cut             = 10

ntr             = 1 
restraintmask 	= '!:WAT,Cl-,K+,Na+ & !@H='
restraint_wt	= 5 

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0

/
EOF
	cat<<EOF>inputs/${min2}.mdin
Minimization of the entire molecular system
&cntrl
imin            = 1
maxcyc          = 5000
ntmin           = 2
ntx             = 1
ntxo            = 1
ntpr            = 5
cut             = 10


ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0

/
EOF
        cat<<EOF>inputs/${eqpre1P0}.mdin
&cntrl
imin            = 0
nstlim          = 50000
dt              = 0.0001
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ntr             = 1
restraint_wt    = 5
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${eqpre2P0}.mdin
&cntrl
imin            = 0
nstlim          = 5000
dt              = 0.001
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ntr             = 1
restraint_wt    = 5
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${eqP0}.mdin
&cntrl
imin            = 0
nstlim          = 500000
dt              = 0.002
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2 
ntf             = 1 
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp		= 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2     
barostat	= 2

ig		= -1

ntr		= 1
restraint_wt	= 5
restraintmask 	= '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass	= 0
/
EOF
        cat<<EOF>inputs/${eqNTP4}.mdin.template
&cntrl
imin            = 0
nstlim          = 500000
dt              = 0.002
irest           = 1
ntx             = 5
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 4
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0

&end
 &ewald
   target_a=ABOX,
   target_b=BBOX,
   target_c=CBOX,
   target_n=500,

/
EOF
        cat<<EOF>inputs/${eqV}.mdin
&cntrl
imin            = 0
nstlim          = 500000
dt              = 0.002
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 1
ntp		= 0
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2

ig              = -1

ntr             = 1
restraint_wt    = 5
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF

        cat<<EOF>inputs/${eqP}.mdin
&cntrl
imin            = 0
nstlim          = 500000 
dt              = 0.002
irest           = 1
ntx             = 5
ntxo            = 1
ntc             = 2 
ntf             = 1 
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2 
ntp		= 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat	= 2

ig              = -1

ntr             = 1
restraint_wt    = 5
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF

        cat<<EOF>inputs/${eqA}.mdin
&cntrl
imin            = 0
nstlim          = 2000000
dt              = 0.004
irest           = 1
ntx             = 5
ntxo            = 1
ntc             = 2 
ntf             = 1 
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 1
tempi           = 300.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2     

ig              = -1

ntr             = 1
restraint_wt    = 5
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

nmropt		= 1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
&wt type='TEMP0', istep1=0,istep2=50000,value1=300.,
           value2=600.,    /
&wt type='TEMP0', istep1=50001, istep2=150000, value1=600.0,
           value2=600.0,     /
&wt type='TEMP0', istep1=150001, istep2=200000, value1=600.0,
           value2=300.0,     /
&wt type='END'  /

EOF

        cat<<EOF>inputs/${eqProt2}.mdin
&cntrl
imin            = 0
nstlim          = 200000
dt              = 0.002
irest           = 1
ntx             = 5
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ntr             = 1
restraint_wt    = 2
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${minProt2}.mdin
Minimization with Cartesian restraints for the solute
&cntrl
imin            = 1
maxcyc          = 5000
ntmin           = 2
ntx             = 1
ntxo            = 1
ntpr            = 5
cut             = 10

ntr             = 1
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='
restraint_wt    = 2

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
scmask1         = '@39-41'
scmask2         = '@84-86'

gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${eqProt1}.mdin
&cntrl
imin            = 0
nstlim          = 200000
dt              = 0.002
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ntr             = 1
restraint_wt    = 1 
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${minProt1}.mdin
Minimization with Cartesian restraints for the solute
&cntrl
imin            = 1
maxcyc          = 5000
ntmin           = 2
ntx             = 1
ntxo            = 1
ntpr            = 5
cut             = 10

ntr             = 1
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='
restraint_wt    = 1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
scmask1         = '@39-41'
scmask2         = '@84-86'

gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${eqProt05}.mdin
&cntrl
imin            = 0
nstlim          = 200000
dt              = 0.002
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ntr             = 1
restraint_wt    = 0.5
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${minProt05}.mdin
Minimization with Cartesian restraints for the solute
&cntrl
imin            = 1
maxcyc          = 5000
ntmin           = 2
ntx             = 1
ntxo            = 1
ntpr            = 5

ntr             = 1
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='
restraint_wt    = 0.5

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
scmask1         = '@39-41'
scmask2         = '@84-86'

gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${eqProt025}.mdin
&cntrl
imin            = 0
nstlim          = 200000 
dt              = 0.002
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ntr             = 1
restraint_wt    = 0.25
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${minProt025}.mdin
Minimization with Cartesian restraints for the solute
&cntrl
imin            = 1
maxcyc          = 5000
ntmin           = 2
ntx             = 1
ntxo            = 1
ntpr            = 5

ntr             = 1
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='
restraint_wt    = 0.25

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
scmask1         = '@39-41'
scmask2         = '@84-86'

gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${eqProt01}.mdin
&cntrl
imin            = 0
nstlim          = 200000 
dt              = 0.002
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ntr             = 1
restraint_wt    = 0.1
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${minProt01}.mdin
Minimization with Cartesian restraints for the solute
&cntrl
imin            = 1
maxcyc          = 5000
ntmin           = 2
ntx             = 1
ntxo            = 1
ntpr            = 5

ntr             = 1
restraintmask   = '!:WAT,Cl-,K+,Na+ & !@H='
restraint_wt    = 0.1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
scmask1         = '@39-41'
scmask2         = '@84-86'

gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${eqProt0}.mdin
&cntrl
imin            = 0
nstlim          = 200000 
dt              = 0.002
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
count=$(($count+1))
done

if [ ${twostate} == true ]; then

	truncate -s0 inputs/eqpre1P0.groupfile inputs/eqpre2P0.groupfile inputs/eqP0.groupfile inputs/eqNTP4.groupfile inputs/eqV.groupfile inputs/eqP.groupfile inputs/eqA.groupfile inputs/eqProt2.groupfile inputs/eqProt1.groupfile inputs/eqProt05.groupfile inputs/eqProt025.groupfile inputs/eqProt01.groupfile inputs/eqProt0.groupfile
	for lam in ${endstates[@]};do

        	init=${lam}_init
        	min1=${lam}_min1
        	min2=${lam}_min2
        	eqpre1P0=${lam}_eqpre1P0
        	eqpre2P0=${lam}_eqpre2P0
        	eqP0=${lam}_eqP0
        	eqNTP4=${lam}_eqNTP4
        	eqV=${lam}_eqV
        	eqP=${lam}_eqP
        	eqA=${lam}_eqA
        	eqProt2=${lam}_eqProt2
       	 	eqProt1=${lam}_eqProt1
        	eqProt05=${lam}_eqProt05
        	eqProt025=${lam}_eqProt025
        	eqProt01=${lam}_eqProt01
        	eqProt0=${lam}_eqProt0

        	cat<<EOF>> inputs/eqpre1P0.groupfile
-O -p unisc.parm7 -c current/${min2}.rst7 -i inputs/${eqpre1P0}.mdin -o current/${eqpre1P0}.mdout -r current/${eqpre1P0}.rst7 -x current/${eqpre1P0}.nc -ref current/${min2}.rst7
EOF
        	cat<<EOF>> inputs/eqpre2P0.groupfile
-O -p unisc.parm7 -c current/${eqpre1P0}.rst7 -i inputs/${eqpre2P0}.mdin -o current/${eqpre2P0}.mdout -r current/${eqpre2P0}.rst7 -x current/${eqpre2P0}.nc -ref current/${eqpre1P0}.rst7
EOF
        	cat<<EOF>> inputs/eqP0.groupfile
-O -p unisc.parm7 -c current/${eqpre2P0}.rst7 -i inputs/${eqP0}.mdin -o current/${eqP0}.mdout -r current/${eqP0}.rst7 -x current/${eqP0}.nc -ref current/${eqpre2P0}.rst7
EOF
        	cat<<EOF>> inputs/eqNTP4.groupfile
-O -p unisc.parm7 -c current/${eqP0}.rst7 -i inputs/${eqNTP4}.mdin -o current/${eqNTP4}.mdout -r current/${eqNTP4}.rst7 -x current/${eqNTP4}.nc -ref current/${eqP0}.rst7
EOF
        	cat<<EOF>> inputs/eqV.groupfile
-O -p unisc.parm7 -c current/${eqNTP4}.rst7 -i inputs/${eqV}.mdin -o current/${eqV}.mdout -r current/${eqV}.rst7 -x current/${eqV}.nc -ref current/${eqNTP4}.rst7
EOF
        	cat<<EOF>> inputs/eqP.groupfile
-O -p unisc.parm7 -c current/${eqV}.rst7 -i inputs/${eqP}.mdin -o current/${eqP}.mdout -r current/${eqP}.rst7 -x current/${eqP}.nc -ref current/${eqV}.rst7
EOF
        	cat<<EOF>> inputs/eqA.groupfile
-O -p unisc.parm7 -c current/${eqP}.rst7 -i inputs/${eqA}.mdin -o current/${eqA}.mdout -r current/${eqA}.rst7 -x current/${eqA}.nc -ref current/${eqP}.rst7
EOF
        	cat<<EOF>> inputs/eqProt2.groupfile
-O -p unisc.parm7 -c current/${eqA}.rst7 -i inputs/${eqProt2}.mdin -o current/${eqProt2}.mdout -r current/${eqProt2}.rst7 -x current/${eqProt2}.nc -ref current/${eqA}.rst7
EOF
        	cat<<EOF>> inputs/eqProt1.groupfile
-O -p unisc.parm7 -c current/${eqProt2}.rst7 -i inputs/${eqProt1}.mdin -o current/${eqProt1}.mdout -r current/${eqProt1}.rst7 -x current/${eqProt1}.nc -ref current/${eqProt2}.rst7
EOF
        	cat<<EOF>> inputs/eqProt05.groupfile
-O -p unisc.parm7 -c current/${eqProt1}.rst7 -i inputs/${eqProt05}.mdin -o current/${eqProt05}.mdout -r current/${eqProt05}.rst7 -x current/${eqProt05}.nc -ref current/${eqProt1}.rst7
EOF
        	cat<<EOF>> inputs/eqProt025.groupfile
-O -p unisc.parm7 -c current/${eqProt05}.rst7 -i inputs/${eqProt025}.mdin -o current/${eqProt025}.mdout -r current/${eqProt025}.rst7 -x current/${eqProt025}.nc -ref current/${eqProt05}.rst7
EOF
        	cat<<EOF>> inputs/eqProt01.groupfile
-O -p unisc.parm7 -c current/${eqProt025}.rst7 -i inputs/${eqProt01}.mdin -o current/${eqProt01}.mdout -r current/${eqProt01}.rst7 -x current/${eqProt01}.nc -ref current/${eqProt025}.rst7
EOF
        	cat<<EOF>> inputs/eqProt0.groupfile
-O -p unisc.parm7 -c current/${eqProt01}.rst7 -i inputs/${eqProt0}.mdin -o current/${eqProt0}.mdout -r current/${eqProt0}.rst7 -x current/${eqProt0}.nc -ref current/${eqProt01}.rst7
EOF

	done
fi


for lam in ${lams[@]}; do

        init2=${lam}_init2
        minTI=${lam}_minTI
        eqpre1P0TI=${lam}_eqpre1P0TI
        eqpre2P0TI=${lam}_eqpre2P0TI
        eqP0TI=${lam}_eqP0TI
        eqATI=${lam}_eqATI
		eqBTI=${lam}_eqBTI
        preTI=${lam}_preTI
        ti=${lam}_ti
        anal=${lam}_analyze

	cat << EOF > inputs/${minTI}.mdin
&cntrl
imin            = 1
maxcyc          = 5000
ntmin           = 2
ntx             = 1
ntxo            = 1
ntpr            = 5
cut             = 10


ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0

/
EOF
        cat<<EOF>inputs/${eqpre1P0TI}.mdin
&cntrl
imin            = 0
nstlim          = 5000
dt              = 0.001
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${eqpre2P0TI}.mdin
&cntrl
imin            = 0
nstlim          = 5000
dt              = 0.001
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<<EOF>inputs/${eqP0TI}.mdin
&cntrl
imin            = 0
nstlim          = 100000
dt              = 0.002
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat << EOF > inputs/${eqATI}.mdin
&cntrl
imin            = 0
nstlim          = 500000
dt              = 0.004
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
&wt
 TYPE='TEMP0',
 ISTEP1=0, ISTEP2=298000,
 VALUE1=0.0, VALUE2=298.0,
&wt
 TYPE='TEMP0',
 ISTEP1=298001, ISTEP2=500000,
 VALUE1=298.0, VALUE2=298.0,
/
&wt TYPE='END' /
EOF
	cat << EOF > inputs/${eqBTI}.mdin
&cntrl
imin            = 0
nstlim          = 2000000
dt              = 0.004
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
	cat << EOF > inputs/${preTI}.mdin
&cntrl
imin            = 0
nstlim          = 2000000
dt              = 0.004
irest           = 0
ntx             = 1
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 125
ntwr            = 5000
ntpr            = 1000
cut             = 10
iwrap           = 1

ntb             = 2
ntp             = 1
tempi           = 5.
temp0           = 300.
ntt             = 3
gamma_ln        = 2.
tautp           = 2
barostat        = 2

ig              = -1

ifsc            = 1
icfe            = 1


clambda         = ${lam}
timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
gti_syn_mass    = 0
/
EOF
        cat<< EOF >inputs/${ti}.mdin
&cntrl
imin            = 0                 ! = 0, not running minimization; = 1, running minimization
nstlim          = 125       ! simulation steps between each exchange interval
numexchg        = 40000     ! total number of exchange attempts
dt              = 0.004             ! timestep in unit of ps, 0.001ps = 1fs, safest option
irest           = 1                 ! = 0, don't restart a simulation; = 1, restart a simulation
ntx             = 5                 ! = 1, don't read velocity from a restart file; = 5, read velocity from a restart file
ntxo            = 1                 ! final restart file format. = 1, ASCII; = 2, netCDF
ntc             = 2                 ! SHAKE or not. = 1, not perform; = 2, on -H; = 3, on all bonds
ntf             = 1                 ! force evaluation. = 1, evaluate all; = 2, -H omitted; = 3, all omitted
ntwx            = 125       	! coordinates output frequency to the trajectory file
ntwr            = 125       ! restart output frequency
ntpr            = 125       ! energy info output frequency
cut             = 10         ! non-bonded interaction cutoff in unit of Ang
iwrap           = 1                 ! = 1, wrap coordinates to a prime box

ntb             = 2                 ! = 2, periodic boundary condition with constant P
temp0           = 298.              ! reference temperature
ntt             = 3                 ! = 3, Langevin Dynamics Temperature scaling, constant T, use with gamma_ln
gamma_ln        = 2.                ! collision frequency in unit of ps-1
tautp           = 1                 ! time constant for heat bath in unit of ps
ntp             = 1                 ! = 1, constant P MD with isotropic position scaling
barostat        = 2                 ! = 2, Monte Carlo barostat
pres0           = 1.01325           ! reference pressure in unit of bar
taup            = 5.0               ! pressure relaxation time in unit of ps

ifsc            = 1                 ! = 1, turn on softcore potential
icfe            = 1                 ! = 1, turn on free energy calculation

ifmbar          = 1                 ! additional output in the energy info
bar_intervall   = 125       ! MBAR evaluation frequency, in unit of step. CAUTION: has to less equal to nstlim!!!
mbar_states     = ${#lams[@]}      ! number of lambda windows
EOF
ilam=0
for l in ${lams[@]}; do
     ilam=$(( ${ilam} + 1 ))
     echo "mbar_lambda(${ilam})     = ${l}" >> inputs/${ti}.mdin
done
        cat<< EOF >> inputs/${ti}.mdin


clambda         = ${lam}           ! current lambda window
timask1         = '@1-45'        ! TI region 1
timask2         = '@46-90'        ! TI region 2
crgmask         = ""
scmask1         = '@39-41'        ! softcore region 1
scmask2         = '@84-86'        ! softcore region 2
scalpha         = 0.5        ! = 0.5 when gti_scale_beta = 1
scbeta          = 1.0         ! = 1.0 when gti_scale_beta = 1

gti_cut         = 1         ! internal softcore non-bonded terms will not be cut, 'cut' has no effect
gti_output      = 1                 ! = 1, output detailed TI results
gti_add_sc      = 25          ! = 25, energy terms to be scaled by lambda
gti_scale_beta  = 1        ! = 1, use the softcore potential form 25.13 in Amber Manual 2023
gti_cut_sc_on   = 8        ! distance to smooth softcore potential begin at, in unit of Ang
gti_cut_sc_off  = 10       ! distance to smooth softcore potential stop at, in unit of Ang
gti_lam_sch     = 1      ! = 1, lambda replaced by smoothstep lambda
gti_ele_sc      = 1       ! = 1, softcore smoothstep electrostatic potential
gti_vdw_sc      = 1       ! = 1, softcore smoothstep vdW potential
gti_cut_sc      = 2       ! = 2, smooth both electrostatic and vdW
gti_ele_exp     = 2      ! = 2, best practice
gti_vdw_exp     = 2      ! = 2, best practice

gremd_acyc      = 1                 ! = 1, not exchange lambda = 0 with lambda = 1 directly
/
 &ewald
 /
EOF

        cat<< EOF >inputs/${anal}.mdin
&cntrl
imin            = 6
nstlim          = 125
numexchg        = 40000
dt              = 0.004
irest           = 1
ntx             = 5
ntxo            = 1
ntc             = 2
ntf             = 1
ntwx            = 0
ntwr            = 0
ntpr            = 1
cut             = 10
iwrap           = 0

ntb             = 2
temp0           = 298.
ntt             = 3
gamma_ln        = 2.
tautp           = 1
ntp             = 1
barostat        = 2
pres0           = 1.01325
taup            = 5.0

ifsc            = 1
icfe            = 1

ifmbar          = 1
bar_intervall   = 1
mbar_states     = ${#lams[@]}
EOF
ilam=0
for l in ${lams[@]}; do
     ilam=$(( ${ilam} + 1 ))
     echo "mbar_lambda(${ilam})     = ${l}" >> inputs/${anal}.mdin
done
        cat<< EOF >> inputs/${anal}.mdin


clambda         = ${lam}

timask1         = '@1-45'
timask2         = '@46-90'
crgmask         = ""
scmask1         = '@39-41'
scmask2         = '@84-86'
scalpha         = 0.5
scbeta          = 1.0

gti_cut         = 1
gti_output      = 1
gti_add_sc      = 25
gti_scale_beta  = 1
gti_cut_sc_on   = 8
gti_cut_sc_off  = 10
gti_lam_sch     = 1
gti_ele_sc      = 1
gti_vdw_sc      = 1
gti_cut_sc      = 2
gti_ele_exp     = 2
gti_vdw_exp     = 2
/
 &ewald
 /

EOF
done

truncate -s0 inputs/eqATI.groupfile inputs/eqBTI.groupfile inputs/preTI.groupfile inputs/ti.groupfile
for lam in ${lams[@]};do
	minTI=${lam}_minTI
	eqpre1P0TI=${lam}_eqpre1P0TI
	eqpre2P0TI=${lam}_eqpre2P0TI
	eqP0TI=${lam}_eqP0TI
	eqATI=${lam}_eqATI
	eqBTI=${lam}_eqBTI
	preTI=${lam}_preTI
	ti=${lam}_ti

	cat<<EOF>> inputs/eqATI.groupfile
-O -p unisc.parm7 -c current/${eqP0TI}.rst7 -i inputs/${eqATI}.mdin -o current/${eqATI}.mdout -r current/${eqATI}.rst7 -x current/${eqATI}.nc -ref current/${minTI}.rst7
EOF
	cat<<EOF>> inputs/eqBTI.groupfile
-O -p unisc.parm7 -c current/${eqATI}.rst7 -i inputs/${eqBTI}.mdin -o current/${eqBTI}.mdout -r current/${eqBTI}.rst7 -x current/${eqBTI}.nc -ref current/${eqATI}.rst7
EOF
	cat<<EOF>> inputs/preTI.groupfile
-O -p unisc.parm7 -c equil/${eqBTI}.rst7 -i inputs/${preTI}.mdin -o current/${preTI}.mdout -r current/${preTI}.rst7 -x current/${preTI}.nc -ref equil/${eqBTI}.rst7
EOF
	cat<<EOF>> inputs/ti.groupfile
-O -p unisc.parm7 -c current/${preTI}.rst7 -i inputs/${ti}.mdin -o current/${ti}.mdout -r current/${ti}.rst7 -x current/${ti}.nc -ref current/${preTI}.rst7
EOF

done

# slurm to submit all trials together
#############
#############

#submit independent jobs

# slurm to submit all trials together
##########
##########
if [ "${twostate}" != true ]; then
# submit group-ed jobs
        cat<<EOF > run_equilibration.slurm
#!/usr/bin/env bash
#SBATCH --job-name="com_eq_1h1q~17.slurm"
#SBATCH --output="eq_1h1q~17.slurm.slurmout"
#SBATCH --error="eq_1h1q~17.slurm.slurmerr"
#SBATCH --partition=rtx
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=${#lams[@]}
##SBATCH --gres=gpu:4
#SBATCH --time=0-24:00:00

top=\${PWD}
endstates=(${endstates[@]})
lams=(${lams[@]})
twostate=${twostate}
full_eqstage=(init min1 min2 eqpre1P0 eqpre2P0 eqP0 eqNTP4 eqV eqP eqA eqProt2 eqProt1 eqProt05 eqProt025 eqProt01 eqProt0 minTI eqpre1P0TI eqpre2P0TI eqP0TI eqATI eqBTI)
# Edit eqstage to only include the stages you want to run
eqstage=(init min1 min2 eqpre1P0 eqpre2P0 eqP0 eqNTP4 eqV eqP eqA eqProt2 eqProt1 eqProt05 eqProt025 eqProt01 eqProt0 minTI eqpre1P0TI eqpre2P0TI eqP0TI eqATI eqBTI)
len_full_eqstage=\${#full_eqstage[@]}
len_eqstage=\${#eqstage[@]}
starting_idx=\$((length1 - length2 - 1))

preminTIstage=${preminTIstage}


# check if AMBERHOME is set
source ~/.bashrc

#if [ -z "\${AMBERHOME}" ]; then echo "AMBERHOME is not set" && exit 0; fi

### CUDA MPS # BEGIN ###
temp_path=/tmp/temp_com_1h1q~17
mkdir -p \${temp_path}
export CUDA_MPS_PIPE_DIRECTORY=\${temp_path}/nvidia-mps
export CUDA_MPS_LOG_DIRECTORY=\${temp_path}/nvidia-log
nvidia-cuda-mps-control -d
### CUDA MPS # END ###

if [ ! -d equil ];then mkdir equil; fi

count=\$starting_idx; alllams=0
for stage in \${eqstage[@]}; do
		count=\$((\${count}+1))
		lastcount=\$((\${count}-1))
		if [ "\${stage}" == "init" ] || [ "\${stage}" == "eqpre1P0TI" ] || [ "\${stage}" == "eqpre2P0TI" ] || [ "\${stage}" == "eqP0TI" ]; then continue; fi
		laststage=\${eqstage[\${lastcount}]}

		if [ "\${stage}" == "minTI" ];then alllams=1; fi

		if [ \${alllams} -eq 0 ];then

				# check if pmemd.cuda is present
				if ! command -v \${AMBERHOME}/bin/pmemd.cuda &> /dev/null; then echo "pmemd.cuda is missing." && exit 0; fi

				export LAUNCH="srun"
				export EXE=\${AMBERHOME}/bin/pmemd.cuda

				lam=\${endstates[0]}
				echo "Running \$stage for lambda \${lam}..."
				echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7"
				cat <<EOF2 > center.in"
				\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7
				cat <<EOF2 > center.in
parm \${top}/unisc.parm7
trajin equil/\${lam}_\${stage}.rst7
autoimage
trajout equil/\${lam}_\${stage}_centered.rst7
go
quit
EOF2
				# check if cpptraj is present
				if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
				cpptraj < center.in
				sleep 1
				mv equil/\${lam}_\${stage}_centered.rst7 equil/\${lam}_\${stage}.rst7

		elif [ \${alllams} -eq 1 ] && [ "\${stage}" == "minTI" ];then
				# check if pmemd.cuda is present
				if ! command -v \${AMBERHOME}/bin/pmemd.cuda &> /dev/null; then echo "pmemd.cuda is missing." && exit 0; fi
				export LAUNCH="srun"
				export EXE=\${AMBERHOME}/bin/pmemd.cuda
		for i in \${!lams[@]}; do
			lam=\${lams[\$i]}
			if [ "\${i}" -eq 0 ]; then
				init=\${endstates[0]}_\${preminTIstage}.rst7
			else
				init=\${lams[\$((\$i-1))]}_eqP0TI.rst7
			fi

						echo "Running \$stage for lambda \${lam}..."

			stage=minTI
			echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${init} -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${init}"
			\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${init} -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${init}
			sleep 1

			laststage=minTI; stage=eqpre1P0TI
			echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7"
			\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7
			sleep 1

			laststage=eqpre1P0TI; stage=eqpre2P0TI
			echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7"
			\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equilam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7
			sleep 1

			laststage=eqpre2P0TI; stage=eqP0TI
			echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7"
			\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7
			sleep 1

						cat <<EOF2 > center.in
parm \${top}/unisc.parm7
trajin equil/\${lam}_\${stage}.rst7
autoimage
trajout equil/\${lam}_\${stage}_centered.rst7
go
quit
EOF2
						if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
						cpptraj < center.in
						sleep 1
						mv equil/\${lam}_\${stage}_centered.rst7 equil/\${lam}_\${stage}.rst7
				done
		laststage=eqP0TI
		else
				# check if pmemd.cuda.MPI is present
				if ! command -v \${AMBERHOME}/bin/pmemd.cuda.MPI &> /dev/null; then echo "pmemd.cuda.MPI is missing." && exit 0; fi

				export LAUNCH="mpirun -np \${#lams[@]}"
				export EXE=\${AMBERHOME}/bin/pmemd.cuda.MPI
				export MV2_ENABLE_AFFINITY=0
				echo "\${LAUNCH} \${EXE} -ng \${#lams[@]} -groupfile inputs/equil_\${stage}.groupfile"
				\${LAUNCH} \${EXE} -ng \${#lams[@]} -groupfile inputs/equil_\${stage}.groupfile

				for lam in \${lams[@]};do
						cat <<EOF2 > center.in
parm \${top}/unisc.parm7
trajin equil/\${lam}_\${stage}.rst7
autoimage
trajout equil/\${lam}_\${stage}_centered.rst7
go
quit
EOF2
						if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
						cpptraj < center.in
						sleep 1
						mv equil/\${lam}_\${stage}_centered.rst7 equil/\${lam}_\${stage}.rst7
				done
		fi
done



### CUDA MPS # BEGIN ###
echo quit | nvidia-cuda-mps-control
### CUDA MPS # END ###

echo "--- DONE ---"

EOF


elif [ "${twostate}" == true ]; then

# submit group-ed jobs
        cat<<EOF > run_equilibration.slurm
#!/usr/bin/env bash
#SBATCH --job-name="com_eq_1h1q~17.slurm"
#SBATCH --output="eq_1h1q~17.slurm.slurmout"
#SBATCH --error="eq_1h1q~17.slurm.slurmerr"
#SBATCH --partition=rtx
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=${#lams[@]}
##SBATCH --gres=gpu:4
#SBATCH --time=0-24:00:00

top=\${PWD}
endstates=(${endstates[@]})
lams=(${lams[@]})
twostate=${twostate}
full_eqstage=(init min1 min2 eqpre1P0 eqpre2P0 eqP0 eqNTP4 eqV eqP eqA eqProt2 eqProt1 eqProt05 eqProt025 eqProt01 eqProt0 minTI eqpre1P0TI eqpre2P0TI eqP0TI eqATI eqBTI)
# Edit eqstage to only include the stages you want to run
eqstage=(init min1 min2 eqpre1P0 eqpre2P0 eqP0 eqNTP4 eqV eqP eqA eqProt2 eqProt1 eqProt05 eqProt025 eqProt01 eqProt0 minTI eqpre1P0TI eqpre2P0TI eqP0TI eqATI eqBTI)
len_full_eqstage=\${#full_eqstage[@]}
len_eqstage=\${#eqstage[@]}
starting_idx=\$((length1 - length2 - 1))

preminTIstage=${preminTIstage}


# check if AMBERHOME is set
source ~/.bashrc

#if [ -z "\${AMBERHOME}" ]; then echo "AMBERHOME is not set" && exit 0; fi

### CUDA MPS # BEGIN ###
temp_path=/tmp/temp_com_1h1q~17
mkdir -p \${temp_path}
export CUDA_MPS_PIPE_DIRECTORY=\${temp_path}/nvidia-mps
export CUDA_MPS_LOG_DIRECTORY=\${temp_path}/nvidia-log
nvidia-cuda-mps-control -d
### CUDA MPS # END ###



if [ ! -d equil ];then mkdir equil; fi

count=\$starting_idx; alllams=0
for stage in \${eqstage[@]}; do
		count=\$((\${count}+1))
		lastcount=\$((\${count}-1))
	if [ "\${stage}" == "init" ] || [ "\${stage}" == "eqpre1P0TI" ] || [ "\${stage}" == "eqpre2P0TI" ] || [ "\${stage}" == "eqP0TI" ]; then continue; fi
		laststage=\${eqstage[\${lastcount}]}

		if [ "\$stage" == "minTI" ]; then alllams=1; fi

		if [ \${alllams} -eq 0 ];then

				if [ "\$stage" == "min1" ] || [ "\$stage" == "min2" ]; then
						# check if pmemd.cuda is present
						if ! command -v \${AMBERHOME}/bin/pmemd.cuda &> /dev/null; then echo "pmemd.cuda is missing." && exit 0; fi

						export LAUNCH="srun"
						export EXE=\${AMBERHOME}/bin/pmemd.cuda

						for lam in \${endstates[@]};do
								echo "Running \$stage for lambda \${lam}..."
								echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7"
								\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7
								cat <<EOF2 > center.in
parm \${top}/unisc.parm7
trajin equil/\${lam}_\${stage}.rst7
autoimage
trajout equil/\${lam}_\${stage}_centered.rst7
go
quit
EOF2
								# check if cpptraj is present
								if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
								cpptraj < center.in
								sleep 1
								mv equil/\${lam}_\${stage}_centered.rst7 equil/\${lam}_\${stage}.rst7
						done

				else
						# check if pmemd.cuda.MPI is present
						if ! command -v \${AMBERHOME}/bin/pmemd.cuda.MPI &> /dev/null; then echo "pmemd.cuda.MPI is missing." && exit 0; fi

						export LAUNCH="mpirun -np \${#endstates[@]}"
						export EXE=\${AMBERHOME}/bin/pmemd.cuda.MPI
						export MV2_ENABLE_AFFINITY=0
						echo "\${LAUNCH} \${EXE} -ng \${#endstates[@]} -groupfile inputs/equil_\${stage}.groupfile"
						\${LAUNCH} \${EXE} -ng \${#endstates[@]} -groupfile inputs/equil_\${stage}.groupfile

						for lam in \${endstates[@]};do
								cat <<EOF2 > center.in
parm \${top}/unisc.parm7
trajin equil/\${lam}_\${stage}.rst7
autoimage
trajout equil/\${lam}_\${stage}_centered.rst7
go
quit
EOF2
								if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
								cpptraj < center.in
								sleep 1
								mv equil/\${lam}_\${stage}_centered.rst7 equil/\${lam}_\${stage}.rst7
						done
				fi

		elif [ "\${alllams}" == 1 ] && [ "\$stage" == "minTI" ]; then

				# check if pmemd.cuda is present
				if ! command -v \${AMBERHOME}/bin/pmemd.cuda &> /dev/null; then echo "pmemd.cuda is missing." && exit 0; fi
				export LAUNCH="srun"
				export EXE=\${AMBERHOME}/bin/pmemd.cuda

		firsthalf=(\${lams[@]::\$((\${#lams[@]} / 2 ))})
		secondhalf=(\${lams[@]:\$((\${#lams[@]} / 2 ))})

		indices=(\${!secondhalf[@]}); tmp=()
		for ((k=\${#indices[@]} - 1; k >= 0; k--)) ; do
			tmp+=("\${secondhalf[indices[k]]}")
		done
		secondhalf=("\${tmp[@]}")
		p=("\${firsthalf[*]}" "\${secondhalf[*]}")

		for l in \${!p[@]};do
			startingconfig=\${endstates[\$l]}_\${preminTIstage}.rst7
			list=(\${p[\$l]})
			for i in \${!list[@]}; do
				lam=\${list[\$i]}
							echo "Running \$stage for lambda \${lam}..."
				
				if [ "\${i}" -eq 0 ]; then
					init=\${startingconfig}
				else
					init=\${list[\$((\$i-1))]}_eqP0TI.rst7
				fi

				stage=minTI
				echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${init} -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${init}"
				\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${init} -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${init}
				sleep 1

				laststage=minTI; stage=eqpre1P0TI
				echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7"
				\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7
				sleep 1

				laststage=eqpre1P0TI; stage=eqpre2P0TI
				echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil.rst7"
				\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7
				sleep 1

				laststage=eqpre2P0TI; stage=eqP0TI
				echo "\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7"
				\${EXE} -O -p \${top}/unisc.parm7 -c equil/\${lam}_\${laststage}.rst7 -i inputs/\${lam}_\${stage}.mdin -o equil/\${lam}_\${stage}.mdout -r equil/\${lam}_\${stage}.rst7 -ref equil/\${lam}_\${laststage}.rst7
				sleep 1

								cat <<EOF2 > center.in
parm \${top}/unisc.parm7
trajin equil/\${lam}_\${stage}.rst7
autoimage
trajout equil/\${lam}_\${stage}_centered.rst7
go
quit
EOF2
							# check if cpptraj is present
							if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
							cpptraj < center.in
							sleep 1
							mv equil/\${lam}_\${stage}_centered.rst7 equil/\${lam}_\${stage}.rst7
					done
			laststage=eqP0TI
		done
		else
				# check if pmemd.cuda.MPI is present
				if ! command -v \${AMBERHOME}/bin/pmemd.cuda.MPI &> /dev/null; then echo "pmemd.cuda.MPI is missing." && exit 0; fi

				export LAUNCH="mpirun -np \${#lams[@]}"
				export EXE=\${AMBERHOME}/bin/pmemd.cuda.MPI
				export MV2_ENABLE_AFFINITY=0
				echo "\${LAUNCH} \${EXE} -ng \${#lams[@]} -groupfile inputs/equil_\${stage}.groupfile"
				\${LAUNCH} \${EXE} -ng \${#lams[@]} -groupfile inputs/equil_\${stage}.groupfile

				for lam in \${lams[@]};do
						cat <<EOF2 > center.in
parm \${top}/unisc.parm7
trajin equil/\${lam}_\${stage}.rst7
autoimage
trajout equil/\${lam}_\${stage}_centered.rst7
go
quit
EOF2
						if ! command -v cpptraj &> /dev/null; then echo "cpptraj is missing." && exit 0; fi
						cpptraj < center.in
						sleep 1
						mv equil/\${lam}_\${stage}_centered.rst7 equil/\${lam}_\${stage}.rst7
				done
		fi


		if [ "\${stage}" == "eqP0" ]; then
		a=0; b=0; c=0
				for lam in \${endstates[@]};do
						box=(\$(tail -1 equil/\${lam}_\${stage}.rst7))
						a=\$(awk "BEGIN {print ( \$a + \${box[0]} ) }")
						b=\$(awk "BEGIN {print ( \$b + \${box[1]} ) }")
						c=\$(awk "BEGIN {print ( \$c + \${box[2]} ) }")
				done
				a=\$(awk "BEGIN {print ( \$a / \${#endstates[@]} ) }")
				b=\$(awk "BEGIN {print ( \$b / \${#endstates[@]} ) }")
				c=\$(awk "BEGIN {print ( \$c / \${#endstates[@]} ) }")

				a=\$(printf "%8.7f" \$a); b=\$(printf "%8.7f" \$b); c=\$(printf "%8.7f" \$c)
				for lam in \${endstates[@]};do
						sed -e "s/ABOX/\${a}/g" -e "s/BBOX/\${b}/g" -e "s/CBOX/\${c}/g" inputs/\${lam}_eqNTP4.mdin.template > inputs/\${lam}_eqNTP4.mdin
				done
				sleep 1
		fi
done



### CUDA MPS # BEGIN ###
echo quit | nvidia-cuda-mps-control
### CUDA MPS # END ###

echo "--- DONE ---"

EOF


fi


##########
##########


truncate -s0 run_production.slurm
cat<<EOF > run_production.slurm
#!/usr/bin/env bash
#SBATCH --job-name="com_pr_1h1q~17.slurm"
#SBATCH --output="pr_1h1q~17.slurm.slurmout"
#SBATCH --partition=rtx
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=${#lams[@]}
##SBATCH --gres=gpu:4
#SBATCH --time=0-24:00:00

lams=(${lams[@]})
# check if AMBERHOME is set
source ~/.bashrc

if [ -z "\${AMBERHOME}" ]; then echo "AMBERHOME is not set" && exit 0; fi

EXE=\${AMBERHOME}/bin/pmemd.cuda.MPI
echo "running replica ti"
echo "mpirun -np \${#lams[@]} \${EXE}  -ng \${#lams[@]} -groupfile inputs/preTI.groupfile"
mpirun -np \${#lams[@]} \${EXE}  -ng \${#lams[@]} -groupfile inputs/preTI.groupfile
echo "mpirun -np \${#lams[@]} \${EXE} -rem 3 -remlog remt\${trial}.log -ng \${#lams[@]} -groupfile inputs/ti.groupfile"
mpirun -np \${#lams[@]} \${EXE} -rem 3 -remlog remt\${trial}.log -ng \${#lams[@]} -groupfile inputs/ti.groupfile
EOF

if [ "${REPEX}" == "false" ]; then
        sed -i -e 's/numexchg/!numexchg/g' -e 's/gremd_acyc = 1/!gremd_acyc = 1/g' inputs/\${lam}_ti.mdin inputs/\${lam}_analyze.mdin
        sed -i 's/ -rem 3 -remlog remt.log//g' inputs/ti.groupfile
fi


########
########



