/* For each variable compare the actual versus predicted values */
%MACRO ACTUAL_V_PREDICTED(TABLE,LABEL,TYPE);
/* Step 1 - Create a temporary version of the data */
	DATA T1_&TABLE.;
		SET &TABLE.;
		KEEP &LABEL._:;
	RUN;
/* Step 2 - Drop variables which are not binned for WOE calculation and obtain
	a list of remaining variables (these will be in table VARIABLES */
	PROC CONTENTS DATA=T1_&TABLE. 
		OUT=TD_VARIABLES NOPRINT;
	RUN;
/* Step 3 - To enable the WOE to be calculated for each individual variable a unique ID
	must be calculated to identify each one in turn. This step creates a COUNTER variable
	which will be 1 to N (where N is the number of variables within the model) and will
	provide the unique ID required for Step 5. Note: LIBNAME is required to ensure the FIRST.
	procedure can be used to count, and therefore assign a unique ID to each variable. 
	e.g LIBNAME NAME 		COUNTER
		WORK	Variable1	1
		WORK	Variable2	2
		WORK	Variable3	3
		.		.			.
		WORK	VariableN	N	*/
	PROC SORT DATA=TD_VARIABLES (KEEP=LIBNAME NAME) OUT=TD_VARIABLES_1;
	BY LIBNAME NAME;
	RUN;
/* Step 3.1 - This step uses RETAIN and FIRST. to assign the variable COUNTER which
	provides the unique ID for Step 5 */
	DATA TD_VARIABLES_2;
		SET TD_VARIABLES_1;
		RETAIN COUNTER;
		BY LIBNAME NAME;
		IF FIRST.LIBNAME THEN COUNTER=1;
		ELSE COUNTER=COUNTER+1;
	RUN;
/* Step 4 - Count the number of variables within the model (excluding the ID and target variables)
	to ensure Step 5 loops through all variables and calculates the WOE */
	PROC SQL NOPRINT;
		SELECT COUNT(*) INTO: N FROM TD_VARIABLES;
	QUIT;
/* Step 5 - Loop through all variables within the model to calculate an associated WOE */
	%DO I=1 %TO &N.;
	/* Step 5.1 - Select each model variable in turn and create a macro variable &VARIABLE. */
		PROC SQL NOPRINT;
			SELECT COMPRESS(NAME) INTO: VARIABLE FROM TD_VARIABLES_2 WHERE COUNTER=&I.;
		QUIT;
	/* Step 5.2 - Create a macro variable &TOTAL. which is the total number 
		of mortgages within the data set*/
		PROC SQL NOPRINT;
			SELECT COUNT(*) AS TOTAL INTO:TOTAL FROM &TABLE.;
		RUN;
	/* Step 5.3 - Calculate the actual and predicted probabilities within
		across each bin within the variable. */
		PROC SQL;
			CREATE TABLE TD_SUMMARY_TABLE AS 
			SELECT &VARIABLE., 
				COUNT(*)/&TOTAL. AS FREQUENCY, 
				SUM(OUTCOME_&TYPE.)/COUNT(*) AS ACTUAL,
				SUM(PREDICTED_PROB_&TYPE.)/COUNT(*) AS PREDICTED
			FROM &TABLE.
			GROUP BY &VARIABLE.;
		RUN;
	/* Step 5.4 - Plot a histogram with frequency, actual probability and 
		predicted probability */
		PROC GBARLINE DATA= TD_SUMMARY_TABLE;
			BAR &VARIABLE. / SUMVAR=FREQUENCY LEVELS=ALL LEGEND=&VARIABLE.;
			PLOT / SUMVAR=ACTUAL TYPE=MEAN;
			PLOT / SUMVAR=PREDICTED TYPE=MEAN;
		RUN;
	%END;
%mend;
