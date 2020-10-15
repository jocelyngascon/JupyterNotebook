cas myses;
caslib _all_ assign;

data RM_MDL.hmeq_bhv_bcp;
set rm_mdl.hmeq_bhv ;
run;


data RM_MDL.hmeq_bhv(promote=yes reuse=yes replace=yes);
set rm_mdl.hmeq_bhv ;

seed1=ranuni(123);
seed2=ranuni(212);
seed3=ranuni(412);
seed4=ranuni(512);
seed5=ranuni(612);

I_MAX_SNP_DPD30_L1M=seed1>0.75;

I_MAX_SNP_TOT_BAL_L1M=I_MAX_SNP_TOT_BAL_L1M*(1+seed1 + seed2/15);
I_MAX_SNP_PAST_DUE_L=I_MAX_SNP_PAST_DUE_L*(1+seed1 + seed3/15);
I_MAX_SNP_PAST_DUE_L1M=I_MAX_SNP_PAST_DUE_L1M*(1+seed1 + seed4/15);
I_MAX_SNP_APPR_AMT_L1M=I_MAX_SNP_APPR_AMT_L1M*(1+seed1 + seed5/15);


I_MAX_SNP_NGT_BLNC_C_L1M=int(seed1*10) +int(seed2*5);
I_MAX_SNP_NGT_BLNC_C_L1M=int(seed1*10) +int(seed3*5);;
I_MAX_SNP_DEL_CNT_L1M=int(seed1*10) +int(seed4*5);;


run;