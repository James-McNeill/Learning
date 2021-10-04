*Missing value formatting for character and numeric variables;
PROC FORMAT;
	VALUE NM . = '.' OTHER = 'X';
	VALUE $CH ' ' = '.' OTHER = 'X';
RUN;

*Review missing value trend - list of variables (VARIABLE1 - VARIABLEN);
PROC FREQ DATA=DATA_IN;
	TABLE VARIABLE1 * VARIABLE2 * VARIABLEN / LIST MISSING NOCUM;
	FORMAT _NUMERIC_ NM. _CHARACTER_ $CH.;
RUN;
