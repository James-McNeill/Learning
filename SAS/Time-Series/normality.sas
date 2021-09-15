%MACRO Normality_X(Residuals=, confidence=, OUTPUT=);
%MACRO dummy; %MEND dummy;
options nonotes;
ods exclude all;

ods output attributes=FileDetails2;
PROC CONTENTS nodetails data=&Residuals.; QUIT;

DATA _NULL_;
set FileDetails2;
where Label2="Variables";
call symput("Combinations", compress(nValue2));
RUN;

PROC SQL; drop table FileDetails2; QUIT;

%DO i=1 %TO &Combinations.;

	ods output TestsForNormality  = NORMALTEST;
	PROC UNIVARIATE data=&Residuals. normaltest;
	var Resids_&i.;
	QUIT;


	DATA NormalTest;
	set NormalTest;
	format confidence 4.2;
	confidence = &confidence.;
	IF pvalue > confidence THEN DO;
	normal_test = 0;
	END;
	ELSE DO;
	normal_test = 1;
	END;
	RUN;

	PROC SQL noprint; select sum(normal_test) into: normal_test from normaltest; QUIT;
	%IF &normal_test. = 0 %THEN %DO;
		%let normal = Y;
	%END;
	%ELSE %DO;
		%LET normal = N;
	%END;

	DATA Normality;
	ModelNumber = &i.;
	Res_Normality= "&normal.";
	RUN;

	PROC APPEND BASE=Normality_Res DATA=Normality FORCE;	QUIT;

%END;

*Final output file;
data Normality_Res_&OUTPUT.;
	set Normality_Res;
run;

PROC DATASETS LIBRARY=WORK nodetails nolist nowarn;
	DELETE NormalTest Normality Normality_Res;
QUIT;


ods exclude none;
%MEND Normality_X;

%Normality_X(RESIDUALS=Residuals_CAN_model, CONFIDENCE=0.05, OUTPUT=CAN_MODEL);
