/* The input dataset relates to the variables which have been created by means of WOE. */


*Print out the list of WOE variables for review;
proc sql noprint;
	select name into :wname separated by ' '
	from dictionary.columns
	WHERE LIBNAME = "WORK" AND MEMNAME = "TRAIN_WOE_1" AND SUBSTR(NAME, 1, 3) = "WOE"
	;
run;

*Print to log;
%put &wname.;

*Retain the key variables for the model validation review;
data val_woe_1;
	set val_woe
	(keep=
		account_id target woe_:
	); *Target relates to the binary target being reviewed and woe_: selects all variables with this prefix;
run;


*Multicollinearity testing - check with excluding VIF over a certain level (maybe 4 to 5);
proc reg data=train_woe_1 ;
	MODEL target = WOE_: / vif tol;
run;

*Variable interaction review. Might have to review the log odds in the future;
proc plot data=train_woe_1;
	plot target*(WOE_:);
run;

*Correlation analysis - test for multicollinearity. Look at ways to make this analysis a bit easier to understand. Could look for a heatmap approach;
proc corr data=train_woe_1;
	var WOE_:;
run;


*Building some initial models for review of interactions. ;
*Make use of the selection= option to perform a stepwise review of the x variables. A list of outputs are created
ranking from best to worst the outputs of the selection criteria.;
*A lot of output is being created, need to find options to reduce the volmue of data produced;

*PROC REG variable options
https://support.sas.com/documentation/cdl/en/statug/63962/HTML/default/viewer.htm#statug_reg_sect013.htm
;

proc reg data=train_woe_1 outest=out_models;	*outest = produces the model summary, includes the beta values for the models being selected i.e. variables used;
	model target = woe_: / selection=adjrsq best=50 stop=15;
run;


*Aim is to review the best model output, per adjrq for each increase in independent variables;
%macro model_select(input_data=);

	*Delete the final output table in order to allow the algorithm to operate;
	proc datasets nodetails nolist;
		delete model_sel_out;
	run;

	%do N = 1 %to 50;

		*Perform model selection process to pick each optimum output;
		proc reg data=&input_data. outest=out_&N.;	
			model target = woe_: / selection=adjrsq best=1 stop=&N.;
		run;
		
		*Stacked table of optimum model outputs;
		proc append base=model_sel_out data=out_&N.;

		*Drop the excess tables;
		proc datasets nodetails nolist;
			delete out_&N.;
		run;

	%end;

%mend;

/**Review the training dataset by variable WOE output.;*/
%model_select(input_data=train_woe_1);


*Run an initial version of the logistic regression model and review some of the outputs;
*Get the list of variables to put into the model;

proc reg data=train_woe_1 outest=out_models tableout;
	model target = woe_: / selection=adjrsq best=1 stop=12;
	output out=model_vars press=pres predicted=pred residual=res;
run;

*Transform model variable list;
proc transpose data=out_models out=out_models_1 (where=(col1 <> .));
	by _type_;
run;

*Print out the list of variables;
proc sql noprint;
	select _NAME_ into :cname separated by ' '
	from out_models_1
	where substr(_NAME_,1,3) = "WOE"
	;
run;

*Print to log;
%put &cname.;

ods graphics on;

*Perform a logistic regression model run using the variable list from above;
proc logistic data=train_woe_1 descending outest=log_model plots=roc outmodel=log_model_vars_1;
	model target = &cname. / details link=glogit lackfit rsq;
	output out=res_target resdev=res pred=pred;
	store log_model_vars;
run;

*Score up the estimated predictions;
proc plm source=log_model_vars;
	score data=train_woe_1 out=train_woe_2 predicted=pred_prob / ilink;
run;

*** Graph distribution of estimated probabilities by outcome ***;
proc univariate data=train_woe_2;
	var pred_prob;
	hist pred_prob;
run;

*K-S Stat;
proc sort data=train_woe_2;
	by pred_prob;
run;

proc npar1way data=train_woe_2 D;
	Var pred_prob;
	Class target;
run;


*Score up the validation dataset;
*** Summary perf. stats using nested logistic regr. ***;

Proc logistic inmodel=log_model_vars_1;
	SCORE DATA= val_woe_1 out=val_woe_2 FITSTAT;
RUN;

data val_woe_2;
	set val_woe_2;
	logodds = log(P_1/(1-P_1));
run;

Proc logistic DATA=val_woe_2 desc;
	MODEL target = logodds / DETAILS LINK=GLOGIT LACKFIT RSQ;
RUN;

*** Graph distribution of estimated probabilities by outcome ***;
proc univariate data=val_woe_2;
	var P_1;
	hist P_1;
run;

*K-S Stat;
Proc sort data=val_woe_2;
	by P_1;
run;

Proc npar1way data=val_woe_2 D;
	Var P_1;
	Class target;
run;

*Review a stepwise logistic model;
proc logistic data=train_woe_1 descending outest=log_model_step plots=roc outmodel=log_model_vars_step;
	model target = &wname. / details link=glogit lackfit rsq selection=stepwise;
	output out=res_target_step resdev=res pred=pred;
	store log_model_vars_step;
run;

ods graphics off;
