/* Review the days of each week */
DATA TEST;
		FORMAT 	MONTH DATE9.		;
		FORMAT 	MON DATE9.			;

		DO MONTH = '01jan2017'D TO '31dec2017'D; /* loop through every day in date range */
		  MON				  	= INTNX('MONTH',MONTH,0,'B'); /* mon = 1st of every month variable */
		  WEEK_NUM			= WEEK(MONTH, 'W'); /* Number of the week */
		  WEEK_DAY			= WEEKDAY(MONTH); /* Day of the week where 1=Sunday, 2=Monday etc */
		  OUTPUT; /* Display the output */
		END;
RUN;
