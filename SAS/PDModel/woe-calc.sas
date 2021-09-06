/* Reviews the Weight of Evidence by variables */
%MACRO WOE_CALC(TABLE,LABEL);
/* Step 1 - Print variables being assessed */
	PROC CONTENTS DATA=&TABLE. 
		OUT=TD_VARIABLES NOPRINT;
	RUN;
/* Step 2 - To enable the WOE to be calculated for each individual variable a unique ID
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
	/* Step 5.3 - Count the number of good and bad outcomes within each variable bin. The 2nd
		select statement calculates the total good and bad outcomes to enable the distribution
		of good and bad outcomes to be created in Step 5.5. */
		PROC SQL NOPRINT;
			CREATE TABLE T1_1_&VARIABLE. AS
				SELECT
					&VARIABLE.,
					SUM(CASE WHEN DEFAULT_FLAG=1 THEN 1 ELSE 0 END) AS NUM_GOOD,
					SUM(CASE WHEN DEFAULT_FLAG=0 THEN 1 ELSE 0 END) AS NUM_BAD
				FROM &TABLE.
				GROUP BY &VARIABLE.
				UNION ALL
				SELECT
					'TOTAL' AS VARIABLE,
					SUM(CASE WHEN DEFAULT_FLAG=1 THEN 1 ELSE 0 END) AS NUM_GOOD,
					SUM(CASE WHEN DEFAULT_FLAG=0 THEN 1 ELSE 0 END) AS NUM_BAD
				FROM &TABLE.;
	/* Step 5.4 - Create two macro variables &NUM_GOOD. and &NUM_BAD. to represent
			the total number of goods and total number of bads. */
				SELECT NUM_GOOD INTO: NUM_GOOD FROM T1_1_&VARIABLE. WHERE &VARIABLE. = 'TOTAL';
				SELECT NUM_BAD INTO: NUM_BAD FROM T1_1_&VARIABLE. WHERE &VARIABLE. = 'TOTAL';
				;
		QUIT;
	/* Step 5.5 - Calculate Dist. Good, Dist. Bad, and therefore WOE. */ 
		PROC SQL;
		CREATE TABLE &LABEL._&VARIABLE. AS
			SELECT
				&VARIABLE.,
				NUM_GOOD,
				NUM_BAD,
				NUM_GOOD/&NUM_GOOD. AS GOOD_DIST,
				NUM_BAD/&NUM_BAD. AS BAD_DIST,
				LOG((NUM_GOOD/&NUM_GOOD.)/(NUM_BAD/&NUM_BAD.)) AS WOE_&VARIABLE.
			FROM T1_1_&VARIABLE.
			WHERE &VARIABLE. NE 'TOTAL'
			ORDER BY &VARIABLE.
			;
		QUIT;
	/* Step 5.6 - This step is for further information only. It calculates to IV for
		each variable */
		PROC SQL;
		CREATE TABLE IV_&VARIABLE. AS
			SELECT
				SUM((GOOD_DIST - BAD_DIST)*WOE_&VARIABLE.) AS IV_&VARIABLE.
			FROM &LABEL._&VARIABLE.
			;
		QUIT;
	/* Step 5.7 - Create a temporary table T1_&TABLE. which joins the WOE for each variable
		to the base table. The logistic model will be built on these variables. */
		PROC SQL;
			CREATE TABLE T1_&TABLE. AS
				SELECT
					A.*,
					B.WOE_&VARIABLE. 
				FROM &TABLE. AS A
				LEFT OUTER JOIN &LABEL._&VARIABLE. AS B ON A.&VARIABLE.=B.&VARIABLE.
				;
		QUIT;
	/* Step 5.8 - Overwrite the initial table with this temporary one to ensure the loop
		adds all WOE variables to the table */
		DATA &TABLE.;
			SET T1_&TABLE.;
		RUN;

		PROC DATASETS LIB=WORK NOLIST;
		DELETE T1_:;
		RUN;

	%END;

%MEND WOE_CALC;
