*Model diagnostics macro that creates the relevant model statistics;
%macro model_run(MODEL_DATA=, INPUT_DATA=, DEP_VAR=, OUTPUT_DATA=, RES_DATA=, MODEL=);

*delete results to avoid appending to a leftover from previous run;
PROC DATASETS library=WORK nodetails nolist nowarn;
	DELETE &OUTPUT_DATA.;
QUIT; 

options nonotes;

proc sql noprint; select count(*) into: var_num from &INPUT_DATA.; run;

%put varnum is: &var_num.;

data vars;
	set &INPUT_DATA.;
	var_id = _N_;
run;

%DO V=1 %TO &VAR_NUM.;

data _null_;
	set vars;
	where var_id = &V.;
	call symput("var&V.", IND_VARS);
run;

%put model run=&V. var num is: &var_num. and indep vars: &&var&V..;

*Run the regression;
proc reg data=&MODEL_DATA. outest=models_out&V. tableout COVOUT NOPRINT outvif;
	model &DEP_VAR. = &&var&V.. / noint ADJRSQ RSQUARE pcomit=0;
	OUTPUT OUT=RESIDS_&V.(KEEP=RESIDS_&V.) R=RESIDS_&V.;
run;

*Store the residuals from the model runs;
DATA &RES_DATA.;
	MERGE &RES_DATA. RESIDS_&V.;
RUN;

*Parameter co-efficients;
proc transpose data=models_out&V. (where=(_TYPE_="PARMS"))  out=models_out_est&v.;
	by _NAME_;
	var &&var&V..;
run;

*Parameter P-values;
proc transpose data=models_out&V. (where=(_TYPE_="PVALUE"))  out=models_out_pval&v.;
	by _NAME_;
	var &&var&V..;
run;

*Parameter VIF values;
proc transpose data=models_out&V. (where=(_TYPE_="IPCVIF"))  out=models_out_vif&v.;
	by _NAME_;
	var &&var&V..;
run;

*Variable names;
data models_out&V._1;
	set models_out&V.
	(where=(_NAME_ ne "")
	keep=_model_ _name_ _depvar_);
run;

*Combine variable names and coefficients;
data models_out&V._1;
	merge models_out&V._1 
		  models_out_est&v.(keep=col1 rename=col1=coeffs) 
		  models_out_pval&v.(keep=col1 rename=col1=pval)
		  models_out_vif&v. (keep=col1 rename=col1=vif)
	;
run;

*Variables;
proc transpose data=models_out&V._1 out=models_out&V._2(drop=_LABEL_) prefix=x;
	var _NAME_;
run;

*Coefficients;
proc transpose data=models_out&V._1 out=models_out&V._3(drop=_LABEL_) prefix=est_x;
	var coeffs;
run;

*P-values;
proc transpose data=models_out&V._1 out=models_out&V._4(drop=_LABEL_) prefix=prob_x;
	var pval;
run;

*VIF values;
proc transpose data=models_out&V._1 out=models_out&V._5(drop=_LABEL_) prefix=vif_x;
	var vif;
run;

*Combine all of the data for the final output;
data models_out_f&v. (where=(_TYPE_="PARMS"));
	merge models_out&V. models_out&V._1 models_out&V._2 models_out&V._3 models_out&V._4 models_out&V._5;
	drop &&var&V.. &DEP_VAR. _IN_ _P_ _EDF_ coeffs pval vif _NAME_ _RIDGE_ _PCOMIT_;
	model = "&MODEL.";
	index = &V.;
run;

proc append base=&OUTPUT_DATA. data=models_out_f&v. force; run;

proc datasets lib=work nodetails nolist nowarn;
	delete models_out: resids_:;
run;

*Order the final output by the adjusted RSquare;
proc sort data=&output_data.; by descending _ADJRSQ_; run;

ods exclude none;

%END;

%mend;

*Macro model run
MODEL_DATA: combined dependent and independent variable time series dataset
INPUT_DATA: list of independent variable combinations that are being used within the model
DEP_VAR: dependent variable transformation that is being used
OUTPUT_DATA: output dataset from the model run code
RES_DATA: residuals dataset produced during each model run
MODEL: highlights the model version that is being run
;
%model_run(MODEL_DATA=MODEL_DATA, INPUT_DATA=FINAL_LIST_TBL_CVAR3, DEP_VAR=&DEPENDENT., OUTPUT_DATA=CVAR3_OUT, RES_DATA=Residuals_CVAR3, MODEL=CVAR3);
