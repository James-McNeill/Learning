/* Create a list of dates for review */
data testing;
	input month ddmmyy11.;
	datalines;
01/11/2017
01/10/2017
01/09/2017
01/08/2017
01/07/2017
01/06/2017
01/05/2017
01/04/2017
01/03/2017
01/02/2017
01/01/2017
01/12/2016
01/11/2016
01/10/2016
01/09/2016
;
run;

/* Create the new variables */
data testing;
	set testing;
	format month date9. obs_mth date9. quarter date9. quarter_01 date9.;
	quarter = intnx('quarter', month, 0, 'e');
	quarter_01 = intnx('month', quarter, 0, 'b');
	obs_mth = intnx('month', intnx('month', intnx('quarter', month, 0, 'e'), 0, 'b'), -12, 'b');
	mth = month(month);
	mth_01 = put(mth, z2.);
	year_month = cat(year(month),mth_01);
run;
