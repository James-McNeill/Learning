%MACRO Stationarity(data, confidence, max_lag);
%MACRO dummy; %MEND dummy;
options nonotes;



/*************************************************************************************************/
*Step 1: Set Up Loop for Variables;
PROC CONTENTS data=&data. (drop=Date) noprint out=Var_List(keep=Name); QUIT;

DATA Var_List;
set Var_List;
Number = _N_;
RUN;

PROC SQL noprint; select max(Number) into: var_no from Var_List;  QUIT;



/*************************************************************************************************/
*Step 2: Stationarity Tests;
%DO i=1 %TO &var_no.;
%put Var &i. out of %sysfunc(compress(&var_no.));


	/********************************************************************************************/
	*2.1: Identify Variable, Number of Observations and Corresponding Critical Values;
	PROC SQL noprint; select Name into: var&i. from Var_List where Number=&i.; QUIT;
	%let var&i.=%sysfunc(compress(&&var&i..));

	PROC SQL noprint; select count(&&var&i..)  into: Obs from &data.    where &&var&i.. ne .;  QUIT;
	PROC SQL noprint; select min(&Obs.-Sample) into: Min from ADF_Table where &Obs.>=Sample;   QUIT;
	DATA Phi_Table (where=(&Obs.-Sample=&Min.));
	set ADF_Table;
	RUN;


	/********************************************************************************************/
	*2.2: Lag Tests;	
	%Lag_Choice(&data., &&var&i.., &confidence., &max_lag.);


	/********************************************************************************************/
	*2.3: Stationarity Output;
	ods graphics on;
	ods output StationarityTests = ADF;

	Title "ADF Output";
	PROC ARIMA data=&data. (where=(&&var&i.. ne .));
	identify var=&&var&i.. stationarity=(ADF=&Max_Lag.);
	QUIT;

	data ADF;
	set ADF;
	IF Type = 'Trend' THEN DO;
	chosen_lag = &Lag_T.;
	END;
	ELSE IF Type = 'Single Mean' THEN DO;
	chosen_lag = &Lag_SM.;
	END;
	ELSE IF Type = 'Zero Mean' THEN DO;
	chosen_lag = &Lag_ZM.;
	END;	
	RUN;

	*Output;
	PROC SQL;
	create table Output as
	select
	"&&var&i.." 			as variable			format=$50. length=50
	,a.Type					as adf_test    		format=$12. length=12
	,a.lags 				as adf_lag	
	,a.rho					as adf_rho	
	,a.probrho				as adf_probrho	
	,a.tau					as adf_tau	
	,a.probtau				as adf_probtau	
	,a.FValue				as adf_fstat	
	,a.probf				as adf_probf	
	,&confidence. 			as confidence 		format=4.2
	,a.chosen_lag 			as chosen_lag
	,"&Time_Series_Type."	as visual_type		format=$50.
	,b.lag_sig				as lag_sig			format=$1.
	,b.autocorrelation		as autocorrelation	format=$1.
	from ADF a
	left join ADF_Series b
	on  a.type = b.adf_test
	and a.lags = b.lag;
	QUIT;


	/********************************************************************************************/
	*2.4: Add Critical Values;
	proc sort data=Output;    by confidence; run;
	proc sort data=Phi_Table; by confidence; run;

	DATA Output;
	merge Output (in=a) Phi_Table (drop=sample);
	by confidence;
	IF a;
	IF adf_test='Trend' THEN order=1;
	ELSE IF adf_test='Single Mean' THEN order=2;
	ELSE IF adf_test='Zero Mean' THEN order=3;
	RUN;

	PROC SORT data=Output; by variable order; QUIT;


	/********************************************************************************************/
	*2.5: BOE Unit Root Test (Tau -> F -> Rho);
	DATA Output;
	set Output;

	format adf_result $50.;

	IF adf_probtau <= confidence THEN DO;
		adf_result='No Unit Root';
	END;
	ELSE IF adf_probtau > confidence THEN DO;
		IF adf_test='Trend' AND adf_fstat < phi_3 THEN DO;
			adf_result='Unit Root';
		END;
		ELSE IF adf_test='Single Mean' AND adf_fstat < phi_1 THEN DO;
			adf_result='Unit Root';
		END;
		ELSE IF adf_test='Zero Mean' THEN DO;
			adf_result='Unit Root';
		END;
		ELSE DO;
			IF adf_probrho <= confidence THEN DO;
				adf_result='No Unit Root';
			END;
			ELSE DO;
				adf_result='Unit Root';
			END;
		END;
	END;

	RUN;


	/********************************************************************************************/
	*2.6: Testing Series Type;
	DATA Output;
	set Output;

	format t_test_series phi_test_adf actual_type $50.;

	*Visual Series Type;
	IF adf_test = visual_type THEN DO;
	visual_type = visual_type;
	END;
	ELSE DO;
	visual_type = 'NA';
	END;

	*Test t-test in Time Series for Cases with No Unit Roots;
	IF adf_result = 'No Unit Root' THEN DO;
	t_test_series = visual_type;
	END;
	ELSE DO;
	t_test_series = 'NA';
	END;

	*Test Phi in ADF Series for Cases with Unit Roots;
	IF adf_probtau > confidence AND adf_test = 'Trend' AND adf_fstat >= phi_3 THEN DO;
	phi_test_adf = 'Trend';
	END;
	ELSE IF adf_probtau > confidence AND adf_test = 'Single Mean' AND adf_fstat >= phi_1 THEN DO;
	phi_test_adf = 'Single Mean';
	END; 
	ELSE IF adf_result = 'Unit Root' AND adf_test = 'Zero Mean' THEN DO;
	phi_test_adf = 'Zero Mean';
	END; 
	ELSE DO;
	phi_test_adf = 'NA';
	END;
	RUN;

	*Making Phi ADF Test Unique Per Lag;
	%DO j=0 %TO &max_lag.;
		DATA Test_&j.;
		set Output;
		where adf_lag=&j.;
		keep variable adf_test phi_test_adf;
		RUN;

		PROC TRANSPOSE data=Test_&j. out=Test_Trans_&j. (drop=_NAME_);
		var phi_test_adf;
		by variable;
		id adf_test;
		QUIT;

		DATA Test_Trans_&j. (keep = variable phi_result_&j.);
		set Test_Trans_&j.;
		IF Trend = 'Trend' THEN DO;
		phi_result_&j. = Trend;
		END;
		ELSE IF 'Single Mean'n = 'Single Mean' THEN DO;
		phi_result_&j. = 'Single Mean'n;
		END;
		ELSE IF 'Zero Mean'n = 'Zero Mean' THEN DO;
		phi_result_&j. = 'Zero Mean'n;
		END;
		ELSE DO;
		phi_result_&j. = 'NA';
		END;
		RUN;

		DATA Output;
		merge Output Test_Trans_&j.;
		by variable;
		RUN;

		DATA Output (drop=phi_result_&j.);
		set Output;
		IF adf_lag = &j. AND adf_test = phi_result_&j. THEN DO;
		phi_test_adf = phi_result_&j.;
		END;
		ELSE IF adf_lag = &j. THEN DO;
		phi_test_adf = 'NA';
		END;
		RUN;

		PROC SQL; drop table Test_&j.;        QUIT;
		PROC SQL; drop table Test_Trans_&j.;  QUIT;
	%END;

	*Actual Type Decision Per Lag;
	DATA Output;
	set Output;
	IF t_test_series ne 'NA' THEN DO;
	actual_type = t_test_series;
	END;
	ELSE IF phi_test_adf ne 'NA' THEN DO;
	actual_type = phi_test_adf;
	END;
	ELSE DO;
	actual_type = 'NA';
	END;
	RUN;

	*Making Actual Type Unique Per Lag;
	%DO j=0 %TO &max_lag.;
		DATA Test_&j.;
		set Output;
		where adf_lag=&j.;
		keep variable adf_test actual_type;
		RUN;

		PROC TRANSPOSE data=Test_&j. out=Test_Trans_&j. (drop=_NAME_);
		var actual_type;
		by variable;
		id adf_test;
		QUIT;

		DATA Test_Trans_&j. (keep = variable actual_type_&j.);
		set Test_Trans_&j.;
		IF Trend = 'Trend' THEN DO;
		actual_type_&j. = Trend;
		END;
		ELSE IF 'Single Mean'n = 'Single Mean' THEN DO;
		actual_type_&j. = 'Single Mean'n;
		end;
		ELSE IF 'Zero Mean'n = 'Zero Mean' THEN DO;
		actual_type_&j. = 'Zero Mean'n;
		END;
		ELSE DO;
		actual_type_&j. = "&Time_Series_Type.";
		END;
		RUN;

		DATA Output;
		merge Output Test_Trans_&j.;
		by variable;
		RUN;

		DATA Output (drop=actual_type_&j.);
		set Output;
		IF adf_lag = &j. and adf_test = actual_type_&j. THEN DO;
		actual_type = actual_type_&j.;
		end;
		ELSE IF adf_lag = &j. THEN DO;
		actual_type = 'NA';
		END;
		RUN;

		PROC SQL; drop table Test_&j.;        QUIT;
		PROC SQL; drop table Test_Trans_&j.;  QUIT;
	%END;


	/********************************************************************************************/
	*2.7: Stationarity Decision;
	DATA Output;
	set Output;
	format stationarity $50.;
	IF actual_type = 'NA' THEN DO;
	stationarity = 'NA';
	END;
	ELSE IF adf_result = 'No Unit Root' THEN DO;
	stationarity = strip(actual_type)||" Stationary";
	END;
	ELSE DO;
	stationarity = 'Non Stationary';
	END;
	RUN;


	/********************************************************************************************/
	*2.8: Final Results Table;
	PROC SQL;
	create table Final_Output as
	select
	variable
	,adf_test
	,adf_lag
	,adf_rho
	,adf_probrho
	,adf_tau
	,adf_probtau
	,adf_fstat
	,adf_probf
	,confidence
	,phi_1 as phi_1
	,phi_2 as phi_2
	,phi_3 as phi_3
	,adf_result
	,visual_type
	,t_test_series
	,phi_test_adf
	,actual_type
	,lag_sig
	,autocorrelation
	,chosen_lag
	,stationarity
	from Output;
	QUIT;

	PROC APPEND base=Combined_Output data=Final_Output force; QUIT;


	/********************************************************************************************/
	*2.9: Final Summary;

	*DF Summary;
	DATA DF_summary (keep= variable adf_test adf_lag stationarity);
	set Output;
	where adf_lag = 0;
	RUN;

	PROC TRANSPOSE data=DF_summary out=Temp_Trans_DF (drop=_NAME_);
	var stationarity;
	by variable;
	id adf_test;
	QUIT;

	DATA Temp_Trans_DF;
	set Temp_Trans_DF;
	format Time_Series_Type Type Result $50.;
	Time_Series_Type = "&Time_Series_Type.";
	IF Trend in ('Trend Stationary' 'Non Stationary') THEN DO;
		Result = Trend;
		Type   = 'Trend';
		Lag    = 0;
	END;
	ELSE IF 'Single Mean'n in ('Single Mean Stationary' 'Non Stationary') THEN DO;
		Result = 'Single Mean'n;
		Type   = 'Single Mean';
		Lag    = 0;
	END;
	ELSE IF 'Zero Mean'n in ('Zero Mean Stationary' 'Non Stationary') THEN DO;
		Result = 'Zero Mean'n;
		Type   = 'Zero Mean';
		Lag    = 0;
	END;
	ELSE IF Time_Series_Type = 'Trend' THEN DO;
		Result = 'Non Stationary';
		Type   = 'Trend';
		Lag    = 0;
	END;
	ELSE IF Time_Series_Type = 'Single Mean' THEN DO;
		Result = 'Non Stationary';
		Type   = 'Single Mean';
		Lag    = 0;
	END;
	ELSE IF Time_Series_Type = 'Zero Mean' THEN DO;
		Result = 'Non Stationary';
		Type   = 'Zero Mean';
		Lag    = 0;
	END;
	RUN;

	*ADF Summary;
	DATA ADF_Summary (keep= variable adf_test chosen_lag stationarity);
	set Output;
	where adf_lag = chosen_lag;
	RUN;

	PROC TRANSPOSE data=ADF_summary out=Temp_Trans_ADF (drop=_NAME_);
	var stationarity;
	by variable;
	id adf_test;
	QUIT;

	DATA Temp_Trans_ADF;
	set Temp_Trans_ADF;
	format Time_Series_Type Type Result $50.;
	Time_Series_Type = "&Time_Series_Type.";
	IF Trend in ('Trend Stationary' 'Non Stationary') THEN DO;
		Result = Trend;
		Type   = 'Trend';
		Lag    = &Lag_T.;
	END;
	ELSE IF 'Single Mean'n in ('Single Mean Stationary' 'Non Stationary') THEN DO;
		Result = 'Single Mean'n;
		Type   = 'Single Mean';
		Lag    = &Lag_SM.;
	END;
	ELSE IF 'Zero Mean'n in ('Zero Mean Stationary' 'Non Stationary') THEN DO;
		Result = 'Zero Mean'n;
		Type   = 'Zero Mean';
		Lag    = &Lag_ZM.;
	END;
	ELSE IF Time_Series_Type = 'Trend' THEN DO;
		Result = 'Non Stationary';
		Type   = 'Trend';
		Lag    = &Lag_T.;
	END;
	ELSE IF Time_Series_Type = 'Single Mean' THEN DO;
		Result = 'Non Stationary';
		Type   = 'Single Mean';
		Lag    = &Lag_SM.;
	END;
	ELSE IF Time_Series_Type = 'Zero Mean' THEN DO;
		Result = 'Non Stationary';
		Type   = 'Zero Mean';
		Lag    = &Lag_ZM.;
	END;
	RUN;

	*Final Summary;
	PROC SQL noprint; select lag    into: lag 	   from Temp_Trans_ADF;  QUIT;
	PROC SQL noprint; select type   into: adf_type from Temp_Trans_ADF;  QUIT;
	PROC SQL noprint; select Result into: adf 	   from Temp_Trans_ADF;  QUIT;
	PROC SQL noprint; select type   into: df_type  from Temp_Trans_DF;  QUIT;
	PROC SQL noprint; select Result into: df 	   from Temp_Trans_DF;  QUIT;

	DATA Temp;
	format variable df_type adf_type df_result adf_result $50. adf_lag Best8. conclusion $50.; 
	variable   = "&&var&i..";
	df_type    = "&df_type.";
	adf_type   = "&adf_type.";
	df_result  = "&df.";
	adf_result = "&adf.";
	adf_lag = &lag.;
	IF adf_lag = 0 THEN DO;
		conclusion=df_result;
	END;
	ELSE IF df_result in ('Trend Stationary' 'Single Mean Stationary' 'Zero Mean Stationary') THEN DO;
		conclusion="Check DF Results";
	END;
	ELSE IF adf_result in ('Trend Stationary' 'Single Mean Stationary' 'Zero Mean Stationary') THEN DO;
		conclusion="Check ADF Results";
	END;
	ELSE DO;
		conclusion="Non Stationary";
	END;
	RUN;

	PROC APPEND base=Summary data=Temp force; QUIT;

%end;



/*************************************************************************************************/
*Step 3: Save Important Tables and Drop Extra Tables;
DATA Stationarity_Results;
set Combined_Output;
RUN;
DATA Stationarity_Summary;
set Summary;
RUN;

PROC DATASETS LIBRARY=WORK nodetails nolist;
DELETE Var_List Phi_Table ADF_Series ADF Output
	   Final_Output Combined_Output DF_Summary
	   Temp_Trans_DF ADF_Summary Temp_Trans_ADF
	   Temp Summary;
QUIT;

ods graphics off;


%MEND Stationarity;
