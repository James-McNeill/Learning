/* Using the array function to replace missing values in variables */
data dates_review;
	infile datalines dsd dlm=' ';
	informat Date ddmmyy10.;
	format Date date9. check_1 $8. check_2 $8. check_3 $8. check_4 $8. check_5 $8.;
	input Date check_1 check_2 check_3 check_4 check_5;
	datalines;
01/09/2005 YES NO YES YES YES
01/10/2005 YES    NO      NO
01/11/2005 YES YES
01/12/2005 NO NO NO
01/01/2006 YES
;
run;

/* 
The following array can be used to populate the missing values. Multiple assessments can
be performed to correct missing values. 
*/
data dates_review_1;
	set dates_review;

	array missing check_:;
		do over missing;
		if missing = '' then missing = 'CLOSED';
	end;

run;
