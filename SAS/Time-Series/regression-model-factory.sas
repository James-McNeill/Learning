*Regression model output;
%macro Regression_MF(data, dependent, int,input_data);
%macro dummy; %mend dummy;
*options nonotes;
options mprint;
ods graphics on;

%if &int.=N %then %let int=noint;
%else %let int=;

data adf_table;
set work.adf_table;
run;

proc sql noprint; select count(*) into: tot_model_num from &INPUT_DATA.; run;

%put model_num is: &tot_model_num.;

data vars_reg;
	set &INPUT_DATA.;
	var_id = _N_;
run;

%DO model_num=1 %TO &tot_model_num.;

data _null_;
	set vars_reg;
	where var_id = &model_num.;
	call symput("var&model_num.", IND_VARS);
run;

%let NModelVars = %sysfunc(countw(&&var&model_num..));


%put model run=&model_num. model num is: &tot_model_num. number of vars: &NModelVars. and indep vars: &&var&model_num..;


data Development_Data;
set &data.;
keep date &dependent. &&var&model_num..;
where &dependent. ne .;
run;

ods output FitStatistics=procReg_OP_&model_num; 
ods output DiagnosticsPanel=Diagnostics_&model_num;
ods output Corr=corr_&model_num;
ods output CollinDiagNoInt = Colin_&model_num;
ods output ParameterEstimates = VIF_&model_num;
Title "Regression Analysis - PROC REG";
proc reg data=&data. (where=(&dependent. ne .)) outest=reg_&model_num.   rsquare    all  ;
model &dependent.= &&var&model_num.. / &int. ACOV vif collinoint white ;
output out=regOut_&model_num. PREDICTED=p residual=r cookd=c rstudent=s ucl=uc lcl=lc  ;
run;



quit;

proc sort data=VIF_&model_num;
by variable;
run;

 

Title "Regression Analysis - Scoring";
proc glmselect data=&data. (where=(&dependent. ne .));
model &dependent.= &&var&model_num.. / &int. selection=none showpvalues ;
output out=results_model_&model_num. residual=Residual predicted=Prediction;
run;


Title "Regression Analysis - Variance Inflation";
proc reg data=&data. (where=(&dependent. ne .)) tableout outest=Coefficients_&model_num rsquare    all  ;
model &dependent. = &&var&model_num.. / &int. vif outseb adjrsq outvif;
run;



Title "Regression Analysis - Variable Weights";
data CoefficientsA_&model_num;
set Coefficients_&model_num (where=(_type_='PARMS'));
keep &&var&model_num..;
/* %IF &intercept = Y %THEN %DO; INTERCEPT %END;*/
run;

proc transpose data=CoefficientsA_&model_num out=Coefficients2 (rename=(_name_=Variable Col1=Coefficient));
run;

proc univariate data=&data. (where=(&dependent. ne .))
outtable=Statistics (keep=_var_ _nobs_ _mean_ _std_)
noprint;
run;

data Statistics;
set Statistics;
rename 
_var_	= Variable
_nobs_	= Observations
_mean_	= Mean
_std_	= Standard_Deviation
;
run;

proc sort data=Coefficients2; by Variable; run;
proc sort data=Statistics;   by Variable; run;

data Weights;
merge Statistics (in=a) Coefficients2 (in=b);
by Variable;
if a and b;
Contribution = abs(Standard_Deviation * Coefficient);
run;

proc sql noprint; select sum(Contribution) format=14.11 into: Sum from Weights; quit;

data Weights_&model_num;
set Weights;
Weight = Contribution / &Sum.;
run;

proc transpose data=coefficients_&model_num(keep=_TYPE_ &&var&model_num.. 
	/*%if &intercept = Y %then %do; INTERCEPT %end;*/ ) out=coef_&model_num (drop=_LABEL_ rename=(_NAME_=Variable));
id _type_;
run;

proc sort data=coef_&model_num;
by Variable;
run;

proc sort data=weights_&model_num;
by Variable;
run;

data all_estimates_&model_num;
merge coef_&model_num weights_&model_num;
by variable;
run;

proc sort data=all_estimates_&model_num;
by variable;
run;

proc sql; select Variable, Weight from Weights_&model_num; quit;

Title "Residual Analysis";
data Residuals;
set results_model_&model_num.;
keep date Residual;
run;



ods output TestsForNormality=Normality_&model_num;
Title "Residual Analysis - Normality";
proc univariate data=results_model_&model_num. normaltest;
var Residual;
run;
quit;


Title "Residual Analysis - Durbin Watson";
proc reg data=results_model_&model_num. plots=none;
model Residual = /dw ;
run;
quit;

ODS OUTPUT ChiSqAuto=WhiteNoise_&model_num;
PROC ARIMA data=results_model_&model_num;   
	IDENTIFY var=Residual;
RUN;
quit;


Title "Regression Analysis - Variance Inflation";
proc reg data=&data. (where=(&dependent. ne .)) tableout   RSQUARE;
model &dependent. = &&var&model_num.. / &int. vif collin ;
run;

data data_model;
set &data. (where=(&dependent. ne .));
run;
ods output HeteroTest=hetro_&model_num;

Title "Residual Analysis - White Test for Homogeneity";
proc model data=data_model;
	&dependent = 
	%do v = 1 %to &NModelVars;
		est_&v * %scan(&&var&model_num..,&v,' ') 
		%if &v ne &NModelVars %then %do; + %end;
	%end;
/*	%IF &intercept = Y %THEN %DO; + I %END;*/
	;

	fit &dependent / white;

run;
quit;
title; *Closes off the last title;



proc sql; drop table Statistics;   quit;
proc sql; drop table Coefficients2; quit;
proc sql; drop table Residuals;    quit;

%end;

ods graphics off;

%mend;

*Produce the full model output for each candidate models;
*Regression_MF(data, dependent, int,input_data);
%Regression_MF(MODEL_DATA, &DEPENDENT., N,FINAL_LIST_TBL);
