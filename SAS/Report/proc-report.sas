/* 1a) Capital report */
proc report data=input_data out=output_report;
title1 "&Scenario";
title2 "Balance Comparison";
columns portfolios county EAD Current_Balance 
N (Bal_Diff EAD_pct Case_W_EAD);
define portfolios / group order=freq descending;
define county / group;
define EAD / analysis sum format=comma30.2 'EAD';
define Current_Balance / analysis sum format=comma30.2 'Balance';
define Bal_Diff / computed format=comma30.2;
define EAD_pct / computed format=percent11.8;
define Case_W_EAD / computed format=percent11.8;

compute Bal_Diff;
Bal_Diff=(EAD.sum-Current_Balance.sum);
endcomp;
compute EAD_pct;
EAD_pct=EAD.sum/Current_Balance.sum;
endcomp;

compute Case_W_EAD;
Case_W_EAD=EAD.sum/N;
endcomp;

break after portfolios / summarize skip ul ol;
rbreak after / summarize ul ol;
run;

*Additional proc report tricks - can create a formatting hierarchy that is used to order the report output;
PROC FORMAT;
     INVALUE PARM
     "CURE"=1
     "LOSS"=2
     "SUS"=3
     "UNSUS"=4;
RUN;

%LET SAMPLE = ESTIMATION SAMPLE; /* Report Title */

*comment -> Generate the output for the exposure;
data BAD_POP_DEV_EXP;
set BAD_POP_DEV_EXP;
/* Exposure weighted by predicted probabilities */
prob_cure_exposure = predicted_prob_cure*current_balance;
prob_loss_exposure = predicted_prob_loss*current_balance;
prob_sus_exposure = predicted_prob_sus*current_balance;
prob_unsus_exposure = predicted_prob_unsus*current_balance;
run;

comment -> Generate the Output report by - Estimation and Outcome;
proc report data=BAD_POP_DEV_EXP;
TITLE1 "EXPOSURE - WEIGHTED PROBABILITIES BY OUTCOME";
TITLE2 "&SAMPLE";
COLUMNS OC_OUTCOME_HIERARCHY_GRP CURRENT_BALANCE=CBN PERCNT
CURRENT_BALANCE PERSUM PROB_CURE_EXPOSURE prob_loss_exposure
prob_sus_exposure prob_unsus_exposure 
(CURE_EXP_WGHT LOSS_EXP_WGHT SUS_EXP_WGHT UNSUS_EXP_WGHT);
DEFINE OC_OUTCOME_HIERARCHY_GRP  / GROUP FORMAT=$PARM. 'OUTCOME';
DEFINE CBN / ANALYSIS FORMAT=COMMA13. N 'VOLUME';
DEFINE PERCNT / COMPUTED FORMAT=PERCENT8.1 '% BY VOL.'; /* percent by cases */
DEFINE CURRENT_BALANCE / ANALYSIS SUM FORMAT=COMMA13. 'VALUE';
DEFINE PERSUM / '% OF VAL.' FORMAT=PERCENT8.1; /* percent by balances */
DEFINE PROB_CURE_EXPOSURE / ANALYSIS SUM NOPRINT;
DEFINE PROB_LOSS_EXPOSURE / ANALYSIS SUM NOPRINT;
DEFINE PROB_SUS_EXPOSURE / ANALYSIS SUM NOPRINT;
DEFINE PROB_UNSUS_EXPOSURE / ANALYSIS SUM NOPRINT;
DEFINE CURE_EXP_WGHT / COMPUTED FORMAT=PERCENT8.1 'CURED';
DEFINE LOSS_EXP_WGHT / COMPUTED FORMAT=PERCENT8.1 'LOSS';
DEFINE SUS_EXP_WGHT / COMPUTED FORMAT=PERCENT8.1 'SUST';
DEFINE UNSUS_EXP_WGHT / COMPUTED FORMAT=PERCENT8.1 'UNSUST';
COMPUTE BEFORE;
TOTCOUNT = CBN;
TOTSUM = CURRENT_BALANCE.SUM;
ENDCOMP;
COMPUTE PERCNT;
PERCNT = CBN/TOTCOUNT;
ENDCOMP;
COMPUTE PERSUM;
PERSUM = CURRENT_BALANCE.SUM/TOTSUM;
ENDCOMP;
COMPUTE CURE_EXP_WGHT;
CURE_EXP_WGHT = PROB_CURE_EXPOSURE.SUM / CURRENT_BALANCE.SUM;
ENDCOMP;
COMPUTE LOSS_EXP_WGHT;
LOSS_EXP_WGHT = prob_loss_exposure.SUM / CURRENT_BALANCE.SUM;
ENDCOMP;
COMPUTE SUS_EXP_WGHT;
SUS_EXP_WGHT = prob_sus_exposure.SUM / CURRENT_BALANCE.SUM;
ENDCOMP;
COMPUTE UNSUS_EXP_WGHT;
UNSUS_EXP_WGHT = prob_unsus_exposure.SUM / CURRENT_BALANCE.SUM;
ENDCOMP;

RBREAK AFTER / SUMMARIZE UL OL ;
RUN;
