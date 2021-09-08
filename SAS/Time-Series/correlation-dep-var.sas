*Run the correlation analysis for the variables under review with the dependent variable;
%macro CORR_DEP(MODEL_DATA=, INPUT_DATA=, DEP_VAR=, OUTPUT_DATA=);

*delete results to avoid appending to a leftover from previous run;
PROC DATASETS library=WORK nodetails nolist nowarn;
	DELETE &OUTPUT_DATA.;
QUIT; 

options nonotes;

proc sql noprint; select count(*) into: var_num from &INPUT_DATA.; run;

%put varnum is: &var_num.;

data vars_c;
	set &INPUT_DATA.;
	var_id = _N_;
run;

%DO V=1 %TO &VAR_NUM.;

data _null_;
	set vars_c;
	where var_id = &V.;
	call symput("var&V.", IND_VARS);
run;

%put model run=&V. var num is: &var_num. and indep vars: &&var&V..;

*Correlation analysis;
proc corr data=&MODEL_DATA. outp=corr_analysis noprint;
	var &DEP_VAR.;
	with &&var&V..;
run;

proc sql;
	create table corr_analysis_&V. as
	select *
	from corr_analysis
	where _NAME_ ne ""
	order by _NAME_
	;
run;

PROC TRANSPOSE DATA=corr_analysis_&V. OUT=corr_analysis_&V._1 PREFIX=VAR_; 
	VAR _NAME_;
RUN;

PROC TRANSPOSE DATA=corr_analysis_&V. OUT=corr_analysis_&V._2 PREFIX=CORR_; 
	VAR &DEP_VAR.;
RUN;

DATA corr_analysis_&V._1;
	MODEL_ID = &V.;
	MERGE corr_analysis_&V._1 corr_analysis_&V._2;
RUN;

proc append base=&OUTPUT_DATA. data=corr_analysis_&V._1 force; run;

proc datasets lib=work nodetails nolist nowarn;
	delete corr_analysis:;
run;

ods exclude none;

%END;

%mend;

*Create the correlation analysis for the dependent variable review
MODEL_DATA: contains all of the time series data for the macro-economic and dependent variables
INPUT_DATA: list of macro-economic variables to be reviewed during the analysis. Tables are taken from the combination file of 2 and 3 factor models
DEP_VAR: dependent variable transformation that is being reviewed
;
%CORR_DEP(MODEL_DATA=MODEL_DATA, INPUT_DATA=INDEPENDENT_VAR_LIST, DEP_VAR=&DEPENDENT., OUTPUT_DATA=CORR_DEP);
