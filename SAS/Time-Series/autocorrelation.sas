%MACRO AutoCorrelation_X(Residuals=, confidence=, OUTPUT=);
%MACRO dummy; %MEND dummy;
options nonotes;
ods exclude all;

ods output attributes=FileDetails2;
PROC CONTENTS data=&Residuals.; QUIT;

DATA _NULL_;
set FileDetails2;
where Label2="Variables";
call symput("Combinations", compress(nValue2));
RUN;

PROC SQL; drop table FileDetails2; QUIT;

%DO i=1 %TO &Combinations.;


	ods output ChiSqAuto = CHI;
	PROC ARIMA data=&Residuals. (where=(resids_&i. ne .));
	identify var=resids_&i. stationarity=(ADF=0);
	RUN;


	%IF %sysfunc(exist(CHI)) %THEN %DO;
		DATA CHI (keep=autocorrelation);
		set CHI (where=(ToLags=6));
		format confidence 4.2 autocorrelation $1.;
		confidence 	= &confidence.;
		IF ProbChiSq <= confidence THEN DO;
		autocorrelation = 'Y';
		END;
		ELSE DO;
		autocorrelation = 'N';
		END;
		RUN;
	%END;


	%ELSE %DO;
		%PUT Warning: Autocorrelation Test (No ACF produced);
		DATA CHI (keep=autocorrelation);
		format autocorrelation $1.;
		autocorrelation = 'N';
		RUN;
	%END;

	DATA AutoCorrelation;
	ModelNumber = &i.;
	set CHI;	
	RUN;

	PROC APPEND BASE=AutoCorr_Res_out DATA=AutoCorrelation FORCE;	QUIT;	

%END;

*Final output file;
data AutoCorr_Res_&output.;
	set AutoCorr_Res_out;
run;

proc datasets lib=work nodetails nolist nowarn;
	delete AutoCorrelation chi AutoCorr_Res_out;
run;

ods exclude none;

%MEND AutoCorrelation_X;

%AutoCorrelation_X(RESIDUALS=Residuals_CAN_model, CONFIDENCE=0.05, OUTPUT=CAN_MODEL);
