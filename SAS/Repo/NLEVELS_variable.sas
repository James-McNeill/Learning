*Understanding the number of levels for each variable from a dataset;

*INPUT TABLE;
%LET INPUT_TABLE = INPUT_TABLE;

*Bring in the test dataset;
DATA TEST;
	SET &INPUT_TABLE.;
RUN;

ODS SELECT NLEVELS;	*ODS option for review;
ODS OUTPUT NLEVELS = LEVS_NUM_TEST;	*Output dataset file;

PROC FREQ DATA=TEST NLEVELS;
	/*TABLES _NUMERIC_ / MISSING;	*Review only numeric variables;*/
	TABLES _ALL_ / MISSING; *Review all variables;
RUN;

PROC SORT DATA=LEVS_NUM_TEST; BY DESCENDING NLEVELS; RUN;

/*	 IDENTIFYING FACTORS WITH ONLY 1 LEVEL (SPLIT) AND THE REMAINING MULTI LEVEL FACTORS*/
PROC SQL; 
	SELECT TableVar 
		INTO :NO_LEV_ALL SEPARATED BY " " 
	FROM LEVS_NUM_TEST
	WHERE NLEVELS <=1;
	SELECT TableVar 
		INTO :MUL_LEV_ALL SEPARATED BY " " 
	FROM LEVS_NUM_TEST
	WHERE NLEVELS >1 ;
QUIT;

ODS OUTPUT CLOSE;

*Display the variables with single level;
%put Variables with single level: &NO_LEV_ALL.;

*Display the variables with multiple levels;
%put Variables with multiple levels: &MUL_LEV_ALL.;
