*Create a new data set from an existing SAS data set;

*Will bring a small sample of loans to show how the following functions can be used;
%let acct_sample1 = 100, 101, 102, 103, 104;

*Sample of loans to review;
data sample;
	set input_data
	(where=(account in (&acct_sample1.)));
run;

*Manipulating data - keep variables for review;
data sample_1;
	set sample
	(keep=account month arrangement_type);
run;

*Finding the first and last observations in a group;
proc sort data=sample_1 out=sample_1_acct; by account; run;

data sample_1_acct;
	set sample_1_acct;
	by account;

	*Set initial values for observation variables;
	first_acct = 0;
	last_acct = 0;

	if first.account then first_acct = 1;
	if last.account then last_acct = 1;

run;

*Finding the first and last observations in a subgroup;
proc sort data=sample_1 out=sample_1_sub; by account arrangement_type; run;

data sample_1_sub;
	set sample_1_sub;
	by account arrangement_type;

	*Set initial values for observation variables;
	first_acct = 0;
	last_acct = 0;

	first_treat = 0;
	last_treat = 0;

	if first.account then first_acct = 1;
	if last.account then last_acct = 1;

	if first.arrangement_type then first_treat = 1;
	if last.arrangement_type then last_treat = 1;

run;


*Reading observations using direct access;
data sample_topobs;
	obsnum = 10;
	set sample_1 point=obsnum;	*Reads the data for the observation point reviewed;
	output;	*Creates the dataset output;
	stop;	*Stops the search loop;
run;

*More complex ways of using direct access;
*Detecting the end of a dataset;
data sample_1_end;
	set sample_1_sub end=last;
	if last;
run;

*Understanding how data sets are read. Remainder of chapter walks through how the Program Data Vector (PDV) works;
