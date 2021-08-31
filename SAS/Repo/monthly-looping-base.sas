/* Create a base monthly table */
DATA MONTHS_BASE;
    FORMAT COMMON_VARIABLE $2. MONTH DATE9. MON DATE9.;

    DO COMMON_VARIABLE = 'Y';
        DO MONTH = '01dec2009'D TO '01dec2015'D; /* loop through every day in date range	*/
            MON	= INTNX('MONTH',MONTH,0,'B'); /* mon = 1st of every month variable		*/
            OUTPUT;
        END;
    END; 
RUN;

PROC SORT DATA = MONTHS_BASE (DROP=MONTH) NODUPKEY;
    BY COMMON_VARIABLE MON;
RUN;
