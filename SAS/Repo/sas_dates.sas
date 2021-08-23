/* Create a dummy date to review the different date formats */
data test;
	month = "01Feb2015"d;
	format month date9.;

	year_month = input(put(month, yymmn6.), 6.); *Number version;

	month_new = month;
	format month_new ddmmyy10.;

	year_month_new = input(put(month_new, yymmn6.), 6.);
run;

data test1;
	month = "01Feb2015"d;
	format month ddmmyy10.;
	month_char = '01/02/2015';
	month_char_new = mdy(substr(month_char, 4, 2), 1, substr(month_char, 7, 4));
	format month_char_new date9.;
run;

data review;
	month = 201502;
	month_sas = input(put(month, 6.), yymmn6.);
	format month_sas date.;
run;
