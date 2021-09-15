%MACRO Weights_X(MasterTable=,Final_Results=,var_no=, OUTPUT=);
%MACRO dummy; %MEND dummy;

PROC UNIVARIATE data=&MasterTable. outtable=statistics (keep=_var_ _nobs_ _mean_ _std_) noprint;
QUIT;

DATA statistics;
set statistics;
rename 
_var_	= variable
_nobs_	= observations
_mean_	= mean
_std_	= standard_deviation
;
RUN;

PROC SQL noprint; select max(index)into: comb_no from &Final_Results.; QUIT;

%DO k=1 %TO &comb_no.; 

	%DO i=1 %TO &var_no.;

		DATA _NULL_;
		set &Final_results.;
		Where index=&k.;
		call symput("Var_&i.",x&i.);
		call symput("Coefficient_x&i.",est_x&i. );
		RUN; 

	 	DATA _NULL_;
		set statistics;
		where variable= "&&Var_&i.";
		call symput("Std_v&i.", standard_deviation);
		RUN;
		
	%END;


	DATA _Contr;
	%DO i=1 %TO &var_no.;
	contribution = abs(&&Coefficient_x&i.. * &&Std_v&i..);
	output;
	%END;
	RUN;

	PROC SQL noprint; select sum(contribution) format=14.11 into: sum from _Contr; QUIT;
	%put   sum=&sum;

	DATA Weights;
	%DO i=1 %TO &var_no.;
	contribution = abs(&&Coefficient_x&i.. * &&Std_v&i..);
	Weight= contribution/&sum.;
	output;
	%END;
	RUN;

	PROC TRANSPOSE DATA=weights(KEEP=Weight) OUT= Weights_Tr; QUIT;

	DATA Weights_tr;
	Index=&k.;
	set Weights_Tr ;
	DROP _NAME_;
	%DO i=1 %to &var_no.;
		RENAME Col&i.=Weight_X&i.;
	%END;
	RUN;

	PROC APPEND BASE=Weight_out DATA=Weights_Tr FORCE; QUIT;

%END;

*Final output file;
data Weight_&OUTPUT.;
	set Weight_out;
run;


PROC DATASETS LIB=WORK nodetails nolist nowarn;
DELETE statistics Weights Weights_Tr _Contr Weight_out;
QUIT;


%MEND Weights_X;

%Weights_X(MASTERTABLE=Model_data, FINAL_RESULTS=MODEL_OUT, VAR_NO=3, OUTPUT=CAN_MODEL);
