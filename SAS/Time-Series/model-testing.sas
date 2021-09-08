/* Outline the steps to perform initial time series model analysis */

/* Initial dataset being used within the model. The dataset TRAIN_IND has the list of independent variables */
*Maintain a list of the independent variables to be used within the analysis;
proc sql noprint;
	select NAME into :nname separated by ' '
	from dictionary.columns
	where libname="WORK" and memname="TRAIN_IND"
	and type = "num";
quit;

*Display the variable listings;
%put numeric vars are: &nname;

/* MODEL ANALYSIS */

ods graphics on;

*Linear Regression outputs
Multicollinearity testing - check with excluding VIF over a certain level (maybe 4 to 5);
proc reg data=train_model;
	id date;
	model dep_var = &nname. / noint vif tol dwProb acov hcc white;
	output out=model_vars press=pres predicted=pred residual=res rstudent=rstud cookd=c ucl=uc lcl=lc;
run;

proc autoreg data=train_model;
	model dep_var = &nname. / noint dwprob;
	output out=train_model_auto residual=res;
run;

proc autoreg data=train_model_auto;
	model dep_var = &nname. / noint dwprob;
	hetero res / link=linear coef=nonneg;
run;

proc reg data=train_model outest=out_models plots(only label)=(RStudentByPredicted RStudentByLeverage CooksD residuals(smooth) DFFITS DFBETAS ObservedByPredicted); 
	id date;
	model dep_var = &nname. / noint;
run;

*Display the results - actual versus predicted;
proc sgplot data=model_vars;
	series x=date y=pred;
	series x=date y=dep_var;
run;

*Take the co-efficients from the model;
proc transpose data=out_models(drop=dep_var) out=out_models1 (rename=(_name_=variable col1=coefficient) drop=_label_); 
run; 

*Calculate the weights associated to each independent variable;
proc univariate data=train_model outtable=Statistics (keep=_var_ _nobs_ _mean_ _std_) noprint;
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

proc sort data=Statistics; by Variable; run;
proc sort data=out_models1; by Variable; run;

*Combine the co-efficients from the estimated model with the statistics from the independent variables;
data Weights;
merge Statistics (in=a) out_models1 (in=b);
by Variable;
if a and b;
Contribution = abs(Standard_Deviation * Coefficient);
run;

*Store the combined weights total;
proc sql noprint; select sum(Contribution) format=14.11 into: Sum from Weights; quit;

*Calculate the weight distribution by variable;
data Weights;
set Weights;
Weight = Contribution / &Sum.;
run;

*Correlation analysis;
proc corr data=train_model;
	var &nname.;
run;

*Review the residuals;
Title "Residual Analysis - Normality";
proc univariate data=model_vars normaltest;
	var res;
	hist res / normal;
run;
Title;

*White Noise;
ODS OUTPUT ChiSqAuto=WhiteNoise;
PROC ARIMA data=model_vars ;   
	IDENTIFY var=Res;
RUN;

/*NOTE - can't get this piece of code to work*/
/**White Test;*/
/*ods output HeteroTest=hetro;*/
/*Title "Residual Analysis - White Test for Homogeneity";*/
/*proc model data=train_model;*/
/*	fit &wname. / white;*/
/*run;*/
/*Title;*/

ods graphics off;


*ADF analysis - testing for stationarity;


*Perform all of the transformation;
%macro all_trans_rev(input_data=, input_var=, end=, output_data=);

	proc datasets lib=work nodetails nolist;
		delete &output_data.;
	run;

	%do i = 1 %to &end.;

		proc expand data=&input_data. out=out&i.;
			convert &input_var. = dif1 / transformout = (dif 1);
			convert &input_var. = lag1 / transformout = (lag 1);
			convert &input_var. = diflag&i. / tin= (dif 1) transformout = (lag &i.);	
		run;

	%end;

	data &output_data.;
		merge &input_data. out1 - out&end. ;
	run;

	proc datasets lib=work nodetails nolist;
		delete out:;
	run;

%mend;

*TODO: Convert the inputting of the variables to a dynamic list;
%all_trans_rev(input_data=input_file0, input_var=DEP_VAR, end=5, output_data=train_model_dep); *Creates the dependent variable;
%all_trans_rev(input_data=input_file0, input_var=HPI, end=5, output_data=train_model_hpi);  *Creates the HPI variabe;
%all_trans_rev(input_data=input_file0, input_var=UNEMP_RATE, end=5, output_data=train_model_uem); *Creates the unemployment rate variable;


*ADF testing - NOTE check if these need to be levels or the actual variable transformations used within the model;
%macro adf_test(input_data=, input_var=);

TITLE "MODEL RUN DATASET: &input_data.";

	PROC REG DATA = &input_data.;
		MODEL dif1 = lag1 diflag1 diflag2 diflag3 diflag4 diflag5;
	RUN; 

	proc arima data=&input_data.;
		identify var=&input_var. nlag=12 stationarity=(adf=(1,4));
		identify var=dif1 nlag=12 stationarity=(adf=(1,4));
	run;

TITLE;

%mend;

%adf_test(input_data=train_model_dep, input_var=DEP_VAR);
%adf_test(input_data=train_model_hpi, input_var=HPI);
%adf_test(input_data=train_model_uem, input_var=UNEMP_RATE);


*Checking the differencing assumption for the dependent variable;
proc arima data=train_model_dep;
	identify var=DEP_VAR nlag=12 stationarity=(adf=(0,1));
run;

*Reviewing the dependent variable differenced once;
proc arima data=train_model_dep;
	identify var=DEP_VAR(1) nlag=12 stationarity=(adf=0);
run;
