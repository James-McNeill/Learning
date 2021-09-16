/************************************************/
/*				macro 1: calculate_MA			*/
/************************************************/
/*calculate a moving average of a given variable for specified period of time
as a mean of the variable and its' lags*/
/***********************************************************/
/*parameters:
var - name of a variable for which moving avergae shall be calculated
MA_factor - moving average factor (i.e. how many observations are averaged
*/
%MACRO calculate_MA(var=,MA_factor=);
%DO ma = 0 %TO &MA_factor.-1;
	&var.L&ma. = LAG&ma.(&var.);
%END;
&var._MA&MA_factor. = ifn((_n_ < &MA_factor.) or (&var.L%eval(&MA_factor.-1) = .),.,mean(of &var.L:));
drop &var.L:;
%MEND calculate_MA;
/************************************************/

/************************************************/
/*				macro 2: all_transformations	*/
/************************************************/
/*PREPARE INPUT DATASET WITH TRANSFORMATION
/************************************************/
/*create all possible transformations:
BASIC TRANSFORMATIONS
_R --> raw series
_Y --> y/y % changes
_Q --> q/q % changes
_D --> 1st difference
_S --> 4th difference (seasonal difference)
ADDITIONAL TRANSFORMATIONS [IF REQUESTED]
_M --> MA smoothing and then y/y % changes
_L --> logit transformation 
_X --> 1st difference of logit [only if logit requested]
_G --> 1st difference of y/y % changes
_J --> 1st difference of q/q % changes
_B --> value at time t / value at time 2 years
_P --> probit transformation
_Z --> 1st difference of probit [only if probit requested]
*/

%MACRO all_transformations(LIB_IN=,DS_IN=,DATE_VAR=DATE,LIB_OUT=,DS_OUT=,
	APPLY_LOGIT=,APPLY_G=,APPLY_J=,APPLY_B=,APPLY_M=,APPLY_PROBIT=);

	/*get names of all variables*/
PROC CONTENTS data=&LIB_IN..&DS_IN.(drop=&DATE_VAR.) noprint out=_VARIABLES(keep=NAME); QUIT;

/*count all variables*/
PROC SQL noprint; select count(*) into :NUM_VARIABLES from _VARIABLES; QUIT;

/*create macro variables with names*/
DATA _null_;
set _VARIABLES;
	do _v=1 to &NUM_VARIABLES.;
		call symput('VARIABLE_'||left(_n_),strip(NAME));
	end;
RUN;

/*delete _VARIABLES dataset*/
PROC DATASETS lib=&LIB_IN. nodetails nolist nowarn; delete _VARIABLES; QUIT;

/*create all possible transformations*/
DATA &LIB_OUT..&DS_OUT.;
retain DATE;
set &LIB_IN..&DS_IN.;
	%do i=1 %to &NUM_VARIABLES.;
/*BASIC TRANSFORMATIONS _Y _Q _D _S */
	/*calculate y/y % change */
		if LAG4(&&VARIABLE_&i)=0 then &&VARIABLE_&i.._Y=.;
		else &&VARIABLE_&i.._Y=(&&VARIABLE_&i./LAG4(&&VARIABLE_&i.) -1)*100;
	/*calculate q/q % change */
		if LAG1(&&VARIABLE_&i)=0 then &&VARIABLE_&i.._Q=.;
		else &&VARIABLE_&i.._Q=(&&VARIABLE_&i/LAG1(&&VARIABLE_&i) -1)*100;
	/*calculate 1st difference */
		&&VARIABLE_&i.._D = DIF1(&&VARIABLE_&i.);
	/*calculate 4th difference */
		&&VARIABLE_&i.._S = DIF4(&&VARIABLE_&i.);
/*ADDITIONAL TRANSFORMATIONS _G _J _B _M */
		/*calculate 1st difference of y/y % change */
		%if &APPLY_G. eq Y %then %do;
			if LAG4(&&VARIABLE_&i.)=0 then &&VARIABLE_&i.._G=.;
			else &&VARIABLE_&i.._G=DIF1((&&VARIABLE_&i./LAG4(&&VARIABLE_&i.) -1)*100);
		%end;
	/*calculate 1st difference of q/q % change */
		%if &APPLY_J. eq Y %then %do;
			if LAG1(&&VARIABLE_&i.)=0 then &&VARIABLE_&i.._J=.;
			else &&VARIABLE_&i.._J=DIF1((&&VARIABLE_&i./LAG1(&&VARIABLE_&i.) -1)*100);
		%end;
	/*calculate 2 Years on 2 Years: value at time t / value at time 2 years ago Bi-Yearly*/
		%if &APPLY_B. eq Y %then %do;
			if LAG8(&&VARIABLE_&i)=0 then &&VARIABLE_&i.._B=.;
			else &&VARIABLE_&i.._B=&&VARIABLE_&i./LAG8(&&VARIABLE_&i.);
		%end;
	/*annualise with MA4 smoothing and then calculate y/y% change*/
		%if &APPLY_M. eq Y %then %do;
			%calculate_MA(var=&&VARIABLE_&i..,MA_factor=4);
			if LAG4(&&VARIABLE_&i.._MA4)=0 then &&VARIABLE_&i.._M=.;
			else &&VARIABLE_&i.._M=(&&VARIABLE_&i.._MA4/LAG4(&&VARIABLE_&i.._MA4)-1)*100;
			drop &&VARIABLE_&i.._MA4;
		%end;
/*LOGIT TRANSFORMATIONS _L _X */
    /*apply logit transformation [if requested]*/
	  	%if &APPLY_LOGIT. eq Y %then %do;
			&&VARIABLE_&i.._L =LOG(&&VARIABLE_&i./(1-&&VARIABLE_&i.));
			&&VARIABLE_&i.._X =DIF1(&&VARIABLE_&i.._L);
		%end;
/*PROBIT TRANSFORMATIONS _P _Z*/
	/*apply probit transformation [if requested]*/
		%if &APPLY_PROBIT. eq Y %then %do;
			&&VARIABLE_&i.._P =PROBIT(&&VARIABLE_&i.);
			&&VARIABLE_&i.._Z =DIF1(&&VARIABLE_&i.._P);
		%end;

/*KEEP RAW VARIABLE _R*/
	/*rename for RAW series*/
		rename &&VARIABLE_&i. = &&VARIABLE_&i.._R;
	%end;
RUN;
%MEND all_transformations;

/************************************************/
/*				macro 3: create lags			*/
/************************************************/
%MACRO create_lags(LIB_IN=,DS_IN=,MAX_LAG=,LIB_OUT=,DS_OUT=);
PROC CONTENTS data=&LIB_IN..&DS_IN. out=_10_VAR_DEV_TRANS_(keep=NAME) noprint; QUIT;

PROC SQL noprint;
	select count(*) into :NUM_TRANSFORMED_VARS 
		from _10_VAR_DEV_TRANS_(where=(NAME ne 'DATE'));
	select NAME into :VAR_1 through :VAR_%sysfunc(strip(&NUM_TRANSFORMED_VARS.)) 
		from _10_VAR_DEV_TRANS_(where=(NAME ne 'DATE'));
QUIT;

DATA &LIB_OUT..&DS_OUT.;
retain DATE DR:;
set &LIB_IN..&DS_IN.;
	%do i = 1 %to &NUM_TRANSFORMED_VARS.;
		%do k=0 %to &MAX_LAG.;
			&&VAR_&i.._L&k.=LAG&k.(&&VAR_&i..);
		%end;
		drop &&VAR_&i. ;
	%end;
RUN;
%MEND create_lags;


/* Running the all transformations and lags */
*Transform independent variable(s);
%all_transformations(LIB_IN=WORK,
					DS_IN=IND,
					DATE_VAR=DATE,
					Lib_OUT=WORK,
					DS_out=IND_TRS,
					APPLY_LOGIT=N,
					APPLY_G=N,
					APPLY_J=N,
					APPLY_B=N,
					APPLY_M=N
					);

*Create lags on the transformed from the previous step;
%create_lags(LIB_IN=WORK,DS_IN=IND_TRS,MAX_LAG=4,LIB_OUT=WORK,DS_OUT=IND_TRS_LAG);
