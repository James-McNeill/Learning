*Create a new data set from an existing SAS data set;

*Will bring a small sample of loans to show how the following functions can be used;
%let acct_sample1 = 40536055, 40420611, 4537062, 817208, 47123;

*Sample of loans to review;
data fb_read;
	set fb_ytd
	(where=(account_no in (&acct_sample1.)));
run;

*Manipulating data - keep variables for review;
data fb_read_1;
	set fb_read
	(keep=account_no year_month fb_arrangement_type);
run;

*Finding the first and last observations in a group;
proc sort data=fb_read_1 out=fb_read_1_acct; by account_no; run;

data fb_read_1_acct;
	set fb_read_1_acct;
	by account_no;

	*Set initial values for observation variables;
	first_acct = 0;
	last_acct = 0;

	if first.account_no then first_acct = 1;
	if last.account_no then last_acct = 1;

run;

*Finding the first and last observations in a subgroup;
proc sort data=fb_read_1 out=fb_read_1_sub; by account_no fb_arrangement_type; run;

data fb_read_1_sub;
	set fb_read_1_sub;
	by account_no fb_arrangement_type;

	*Set initial values for observation variables;
	first_acct = 0;
	last_acct = 0;

	first_treat = 0;
	last_treat = 0;

	if first.account_no then first_acct = 1;
	if last.account_no then last_acct = 1;

	if first.fb_arrangement_type then first_treat = 1;
	if last.fb_arrangement_type then last_treat = 1;

run;


*Reading observations using direct access;
data fb_topobs;
	obsnum = 10;
	set fb_read_1 point=obsnum;	*Reads the data for the observation point reviewed;
	output;	*Creates the dataset output;
	stop;	*Stops the search loop;
run;

*More complex ways of using direct access;
*Detecting the end of a dataset;
data fb_end;
	set fb_read_1 end=last;
	if last;
run;

*Understanding how data sets are read. Remainder of chapter walks through how the Program Data Vector (PDV) works;
