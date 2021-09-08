
/* VARIABLE TESTING */

*Review to take place with all of the transformed variables and lags. Add the dependent variable in as well;
proc sql;
	create table IND_TRS_LAG_DEP AS
	SELECT T1.*, T2.DEF_RATE_Q
	FROM IND_TRS_LAG_1 T1
	INNER JOIN DEP_VAR T2
		ON T1.DATE = T2.DATE
	;
RUN;

ods graphics on;

%MACRO VAR_RSQ(INPUT_DATA=, OUTPUT_DATA=, DEP_VAR=, DATE_VAR=);

*delete results to avoid appending to a leftover from previous run;
PROC DATASETS library=WORK nodetails nolist nowarn;
	DELETE &OUTPUT_DATA.;
QUIT; 

options nonotes;

*Create the list of independent variables to review;
proc sql;
	create table vars as
	select memname, name, type
	from dictionary.columns
	where libname="WORK" and memname="&INPUT_DATA." and name not in("&DATE_VAR.", "&DEP_VAR.");
run;

proc sql noprint; select count(*) into: var_num from vars; run;

%put varnum is: &var_num.;

data vars;
	set vars;
	var_id = _N_;
run;

  *Perform the DO LOOP for each of the variables being reviewed;
  %DO V=1 %TO &VAR_NUM.;

  data _null_;
    set vars;
    where var_id = &V.;
    call symput("var&V.", name);
  run;

  *Review the R-square value by each variable;
  proc reg data=&INPUT_DATA. outest=model_out_a&v. covout NOPRINT;
    model &DEP_VAR. = &&var&V.. / noint adjrsq rsquare;
  run;

  data model_out_a&v._1;
    set model_out_a&v.
    (where=(_NAME_ ne "")
    keep=_model_ _name_ _depvar_);
  run;

  data model_out_f&v. (where=(_TYPE_="PARMS") RENAME=_NAME_=VARIABLE);
    merge model_out_a&v. model_out_a&v._1;
    drop _RMSE_ &&var&V.. &DEP_VAR. _IN_ _P_ _EDF_;
  run;

  proc append base=&OUTPUT_DATA. data=model_out_f&v. force; run;

  proc datasets lib=work nodetails nolist nowarn;
    delete model_out:;
  run;

  %END;

ods exclude none;

%MEND;

%VAR_RSQ(INPUT_DATA=IND_TRS_LAG_DEP, OUTPUT_DATA=RESULTS, DEP_VAR=DEF_RATE_Q, DATE_VAR=DATE);

ods graphics off;

*List of remaining variables;
PROC SQL NOPRINT;
	SELECT VARIABLE INTO: VARLIST SEPARATED BY ' '
	FROM RESULTS;
RUN;

%PUT REMAINING VARIABLES: &VARLIST.;

*Run the correlation analysis for the variables under review;
proc corr data=IND_TRS_LAG_DEP outp=corr_analysis;
	var DEF_RATE_Q;
	with &VARLIST.;
run;

*Order the output dataset by correlation value;
proc sql;
	create table corr_analysis_tot as
	select *
	from corr_analysis
	where _NAME_ ne ""
	order by def_rate_q desc
	;
run;

*Run the correlation analysis for the variables against each other;
proc corr data=IND_TRS_LAG_DEP outp=corr_analysis_all;
	var DEF_RATE_Q &VARLIST.;
	WITH DEF_RATE_Q &VARLIST.;
run;

proc sql;
	create table corr_analysis_all_tot as
	select *
	from corr_analysis_all
	where _NAME_ ne ""
	;
run;

*Create the Variable Inflation Factor for each variable;
data MUL_RESULTS;
	set results;
	vif = 1 / (1-_RSQ_);
run;
