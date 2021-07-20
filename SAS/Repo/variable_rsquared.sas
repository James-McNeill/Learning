/* 
Perform r-squared analysis of the independent variable list and the dependent variable.

Params:
:INPUT_DATA - Dataset containing the list of independent and dependent variables for review
:OUTPUT_DATA - Name of the dataset that will contain the final results
:DEP_VAR - Dependent variable transformation
:DATE_VAR - Date variable that is used within the time series

Example:
%VAR_RSQ(INPUT_DATA=IND_TRS_LAG_DEP, OUTPUT_DATA=RESULTS, DEP_VAR=DEF_RATE_Q, DATE_VAR=DATE);
*/

%MACRO VAR_RSQ(INPUT_DATA=, OUTPUT_DATA=,DEP_VAR=, DATE_VAR=);

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
