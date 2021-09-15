%MACRO Lag_Choice(data, var, confidence, max_lag);
%MACRO dummy; %MEND dummy;
options nonotes; 
ods graphics on;



/*************************************************************************************************/
*Step 1: Set Up Table and Variables;
DATA Lag_Test;
set &data.;
where &var. ne .;
keep date &var.;
RUN;

%DO j=0 %TO &max_lag.;
	DATA Lag_Test;
	set Lag_Test;
	D1_&var.		= 	dif(&var.);
	L1_&var.		= 	lag(&var.);
	L&j._D1_&var.	= 	lag&j.(D1_&var.);
	RUN;
%END;



/*************************************************************************************************/
*Step 2: Visual Plot of Time Series and ADF Series;
Title "Time Series Plot";
symbol1 interpol=join;
PROC GPLOT data=Lag_Test;
plot &var. * Date;
RUN;                                                      
QUIT;

Title "ADF Series Plot";
symbol1 interpol=join;
PROC GPLOT data=Lag_Test;
plot D1_&var. * Date;
RUN;												       
QUIT;



/*************************************************************************************************/
*Step 3: Time Series Type;
Title "Time Series Test (Trend)";
PROC REG noprint data=Lag_Test tableout outest=Time_Series_IT;
model &var. = date;
QUIT;

Title "Time Series Test (Single Mean)";
PROC REG noprint data=Lag_Test tableout outest=Time_Series_I;
model &var. = ;
QUIT;

PROC SQL;
create table Time_Series as
select
a._type_
,a.Date
,b.Intercept
from Time_Series_IT a
left join Time_Series_I b
on a._type_ = b._type_;
QUIT;

DATA Time_Series (keep=Variable Type);
set Time_Series (where=(_type_='PVALUE'));
format Variable Type $50. Confidence 4.2;
variable   = "&var.";
confidence = &confidence.;
IF DATE <= confidence THEN DO;
type = 'Trend';
END;
ELSE IF Intercept <= confidence THEN DO;
type = 'Single Mean';
END;
ELSE DO;
type = 'Zero Mean';
END;
RUN;



/*************************************************************************************************/
*Step 4(a): ADF Lag Significance - Trend;
%LET list = ;
%DO j=0 %TO &max_lag.;

	%IF &j.>0 %THEN %DO;
		%LET list = &list. L&j._D1_&var.;
	%END;

	Title "ADF Series Test (Trend Lag &j.)";
	PROC REG noprint data=Lag_Test tableout outest=Lag_Result;
	model D1_&var. = date L1_&var. &list.;
	output out=Residual residual=Residual;
	QUIT;

	*Lag Significance;
	DATA Lag_Result (keep = Variable ADF_Test Lag Lag_Sig);
	set Lag_Result (where=(_type_='PVALUE'));
	format Variable ADF_Test $50. Confidence 4.2 Lag 4.0 Lag_Sig $1.;
	Variable	= "&var.";
	ADF_Test	= "Trend";
	Confidence 	= &confidence.;
	Lag			= &j.;
	if Lag=0 then do;
		Lag_Sig = 'Y';
	end;
	else do;
		if L&j._D1_&var. <= confidence then do;
		Lag_Sig = 'Y';
		end;
		else do;
		Lag_Sig = 'N';
		end;
	end;
	RUN;

	ods graphics off;

	*Autocorrelation Test;
	ods exclude all;
	ods output ChiSqAuto = CHI;
	Title "Autocorrelation Test (Trend Lag &j.)";
	PROC ARIMA data=Residual (where=(Residual ne .));
	identify var=Residual stationarity=(ADF=&max_lag.);
	QUIT;

	%IF %sysfunc(exist(CHI)) %THEN %DO;
		DATA CHI (keep=Lag Autocorrelation);
		set CHI (where=(ToLags=6));
		format Confidence 4.2 Lag 4.0 Autocorrelation $1.;
		Confidence 	= &confidence.;
		Lag = &j.;
		IF ProbChiSq <= confidence THEN DO;
		Autocorrelation = 'Y';
		END;
		ELSE DO;
		Autocorrelation = 'N';
		END;
		RUN;
	%END;

	%ELSE %DO;
		%PUT No ACF produced for &var. at Trend Lag &j.;
		DATA CHI (keep=Lag Autocorrelation);
		format Lag 4.0 Autocorrelation $1.;
		Lag = &j.;
		Autocorrelation = 'N';
		RUN;
	%END;

	DATA Lag_Result;
	merge Lag_Result (in=a) CHI;
	by Lag;
	if a;
	RUN;

	PROC SQL; drop table CHI; QUIT;

	PROC APPEND base=Combined_Results data=Lag_Result; QUIT;

%END;



/*************************************************************************************************/
*Step 4(b): ADF Lag Significance - Single Mean;
%LET list = ;
%DO j=0 %to &max_lag.;

	%IF &j.>0 %THEN %DO;
		%LET list = &list. L&j._D1_&var.;
	%END;

	Title "ADF Series Test (Single Mean Lag &j.)";
	PROC REG noprint data=Lag_Test tableout outest=Lag_Result;
	model D1_&var. = L1_&var. &list.;
	output out=Residual residual=Residual;
	QUIT;

	*Lag Significance;
	DATA Lag_Result (keep = Variable ADF_Test Lag Lag_Sig);
	set Lag_Result (where=(_type_='PVALUE'));
	format Variable ADF_Test $50. Confidence 4.2 Lag 4.0 Lag_Sig $1.;
	Variable	= "&var.";
	ADF_Test	= "Single Mean";
	Confidence 	= &confidence.;
	Lag			= &j.;
	IF Lag=0 THEN DO;
		Lag_Sig = 'Y';
	END;
	ELSE DO;
		IF L&j._D1_&var. <= confidence THEN DO;
		Lag_Sig = 'Y';
		END;
		ELSE DO;
		Lag_Sig = 'N';
		END;
	END;
	RUN;

	ods exclude none;

	*Autocorrelation Test;
	ods exclude all;
	ods output ChiSqAuto = CHI;
	Title "Autocorrelation Test (Single Mean Lag &j.)";
	PROC ARIMA data=Residual (where=(Residual ne .));
	identify var=Residual stationarity=(ADF=&max_lag.);
	RUN;

	%IF %sysfunc(exist(CHI)) %THEN %DO;
		DATA CHI (keep=Lag Autocorrelation);
		set CHI (where=(ToLags=6));
		format Confidence 4.2 Lag 4.0 Autocorrelation $1.;
		Confidence 	= &confidence.;
		Lag = &j.;
		IF ProbChiSq <= confidence THEN DO;
		Autocorrelation = 'Y';
		END;
		ELSE DO;
		Autocorrelation = 'N';
		END;
		RUN;
	%END;

	%ELSE %DO;
		%PUT No ACF produced for &var. at SM Lag &j.;
		DATA CHI (keep=Lag Autocorrelation);
		format Lag 4.0 Autocorrelation $1.;
		Lag = &j.;
		Autocorrelation = 'N';
		RUN;
	%END;

	DATA Lag_Result;
	merge Lag_Result (in=a) CHI;
	by Lag;
	if a;
	RUN;

	PROC SQL; drop table CHI; QUIT;

	PROC APPEND base=Combined_Results data=Lag_Result; QUIT;

%END;



/*************************************************************************************************/
*Step 4(c): ADF Lag Significance - Zero Mean;
%LET list = ;
%DO j=0 %to &max_lag.;

	%IF &j.>0 %THEN %DO;
		%LET list = &list. L&j._D1_&var.;
	%END;

	Title "ADF Series Test (Zero Mean Lag &j.)";
	PROC REG noprint data=Lag_Test tableout outest=Lag_Result;
	model D1_&var. = L1_&var. &list. / noint;
	output out=Residual residual=Residual;
	QUIT;

	*Lag Significance;
	DATA Lag_Result (keep = Variable ADF_Test Lag Lag_Sig);
	set Lag_Result (where=(_type_='PVALUE'));
	format Variable ADF_Test $50. Confidence 4.2 Lag 4.0 Lag_Sig $1.;
	Variable	= "&var.";
	ADF_Test	= "Zero Mean";
	Confidence 	= &confidence.;
	Lag			= &j.;
	IF Lag=0 THEN DO;
		Lag_Sig = 'Y';
	END;
	ELSE DO;
		IF L&j._D1_&var. <= confidence THEN DO;
		Lag_Sig = 'Y';
		END;
		ELSE DO;
		Lag_Sig = 'N';
		END;
	END;
	RUN;

	ods exclude none;

	*Autocorrelation Test;
	ods exclude all;
	ods output ChiSqAuto = CHI;
	Title "Autocorrelation Test (Zero Mean Lag &j.)";
	PROC ARIMA data=Residual (where=(Residual ne .));
	identify var=Residual stationarity=(ADF=&max_lag.);
	QUIT;

	%IF %sysfunc(exist(CHI)) %THEN %DO;
		DATA CHI (keep=Lag Autocorrelation);
		set CHI (where=(ToLags=6));
		format Confidence 4.2 Lag 4.0 Autocorrelation $1.;
		Confidence 	= &confidence.;
		Lag = &j.;
		IF ProbChiSq <= confidence THEN DO;
		Autocorrelation = 'Y';
		END;
		ELSE DO;
		Autocorrelation = 'N';
		END;
		RUN;
	%END;

	%ELSE %DO;
		%PUT No ACF produced for &var. at ZM Lag &j.;
		DATA CHI (keep=Lag Autocorrelation);
		format Lag 4.0 Autocorrelation $1.;
		Lag = &j.;
		Autocorrelation = 'N';
		RUN;
	%END;

	DATA Lag_Result;
	merge Lag_Result (in=a) CHI;
	by Lag;
	if a;
	RUN;

	PROC SQL; drop table CHI; QUIT;

	PROC APPEND base=Combined_Results data=Lag_Result; RUN;

%END;



/*************************************************************************************************/
*Step 5: Selecting Appropriate Lag;
%global Lag_T Lag_SM Lag_ZM Time_Series_Type;
%global Test_T Test_SM Test_ZM;

DATA Trend;
set Combined_Results;
where ADF_Test = "Trend" and Autocorrelation='N';
RUN;

DATA SM;
set Combined_Results;
where ADF_Test = "Single Mean" and Autocorrelation='N';
RUN;

DATA ZM;
set Combined_Results;
where ADF_Test = "Zero Mean" and Autocorrelation='N';
RUN;

PROC SQL noprint; select count(*) into: Test_T  from Trend; QUIT;
PROC SQL noprint; select count(*) into: Test_SM from SM; QUIT;
PROC SQL noprint; select count(*) into: Test_ZM from ZM; QUIT;

%LET Test_T   = %sysfunc(compress(&Test_T.));
%LET Test_SM  = %sysfunc(compress(&Test_SM.));
%LET Test_ZM  = %sysfunc(compress(&Test_ZM.));


%IF &Test_T.=0 %THEN %DO;
	%PUT Warning: Stationarity Test (Still Autocorrelation at Trend Lag &max_lag.);
	%LET Lag_T  = &max_lag.;
%END;
%ELSE %DO;
	PROC SQL noprint; select min(Lag) into: Lag_T  from Trend;	QUIT;
%END;


%IF &Test_SM.=0 %THEN %DO;
	%PUT Warning: Stationarity Test (Still Autocorrelation at SM Lag &max_lag.);
	%LET Lag_SM = &max_lag.;
%END;
%ELSE %DO;
	PROC SQL noprint; select min(Lag) into: Lag_SM from SM; 	QUIT;
%END;


%IF &Test_ZM.=0 %THEN %DO;
	%PUT Warning: Stationarity Test (Still Autocorrelation at ZM Lag &max_lag.);
	%let Lag_ZM = &max_lag.;
%END;
%ELSE %DO;
	PROC SQL noprint; select min(Lag) into: Lag_ZM from ZM; 	QUIT;
%END;


%LET Lag_T  = %sysfunc(compress(&Lag_T.));
%LET Lag_SM = %sysfunc(compress(&Lag_SM.));
%LET Lag_ZM = %sysfunc(compress(&Lag_ZM.));


PROC SQL noprint; select Type into: Time_Series_Type from Time_Series; 	QUIT;



/*************************************************************************************************/
*Step 6: Save Important Tables and Drop Extra Tables;
DATA ADF_Series;
set Combined_Results;
RUN;

PROC DATASETS Library=WORK nodetails nolist;
DELETE  Lag_Test Lag_Result 
        Time_Series_IT   Time_Series_I   Time_Series
		Trend   SM  ZM  Combined_Results  Residual;
QUIT;


ods exclude none;

%MEND Lag_Choice;
