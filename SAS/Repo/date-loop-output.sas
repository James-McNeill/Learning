/* Create a six monthly output of the prospective loan being reviewed */
data testing;
	set &source.
	(where=(account_no = 00000000)
	keep=account_no);
  *Create the start and end dates;
	format TAPE_DATE date9. start_dt date9. end_dt date9.;
	start_dt = "01may2012"d;
	end_dt = "01may2017"d;

	dif = intck('semiyear', start_dt, end_dt);
  *Perform the output operation for each of the six month periods;
	do i = 1 to dif;
		TAPE_DATE = intnx('month', start_dt, i*6) ;
		output;
	end;

run;
