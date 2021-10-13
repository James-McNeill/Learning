/* Chapter 10 - Creating and managing variables */

*Will bring a small sample of loans to show how the following functions can be used;
%let acct_sample = 100, 101, 102, 103, 104;

*Sample of loans to review;
data sample;
	set input_data
	(where=(account in (&acct_sample.)));
run;

proc sort data=sample out=sample1; by account month; run;

*Accumulating totals - review arrangment type;
data sample1;
	set sample1;
	by account;

	*First method;
	*Initialising the variable to store total;
	if first.account then arrange_mths = .;

	arrange_active = not missing(arrangement_type);	*If true then 1 else 0 is provided;
	arrange_mths + arrange_active;	*Maintains a cumulative total;

	*Second method;
	*Retain statement;
/*	retain arrange_mths;*/
/**/
/*	if first.account then arrange_mths = .;*/
/**/
/*	arrange_active = not missing(arrangement_type);	*If true then 1 else 0 is provided;*/
/*	arrange_mths = sum(arrange_mths, arrange_active);	*Add to the retained variable;*/

run;

*Review the final totals by each loan;
data arrange_last_mth arrange_first_mth; *Multiple datasets can be created if they are referenced within the body of the data step as outputs;
	set sample1
	(keep=account month arrangement_type arrange_mths arrange_active last_arrange_month);
	by account;

	if first.account then output arrange_first_mth;
	if last.account then output arrange_last_mth;
run;

*Combine the datasets together;
data arrange_comb;
	set arrange_first_mth arrange_last_mth;
run;

*Assigning values conditionally;
data sample2;
	set sample1;
	by account;

	*IF statement for checking argument;
	if arrange_mths > 12 then arrange_gt_year = "YES";

	*Comparison and logical operators;
	if arrange_mths > 0 and arrange_mths <= 6 then arrange_short = 1;

	*IF/ELSE statement - output values will be truncated as the variable length is created using the first input value from the IF statement;
	if arrangement_type = "FIRST" then arrange = "F";
	else if arrangement_type = "SECOND" then arrange = "S";
	else if not missing(arrangement_type) then arrange = "OTHER";
	else arrange = "NONE";

	*Specifying length for variables - make sure that the length statement is used before the variable is created;
	length arrange_new $8.;	*For example it is included here but makes more sense to include at the beginning of the data step;
	if arrangement_type = "FIRST" then arrange_new = "F";
	else if arrangement_type = "SECOND" then arrange_new = "S";
	else if not missing(arrangement_type) then arrange_new = "OTHER";
	else arrange_new = "NONE";

/*	length arrange_new $8.;	*Using the statement here has no impact on the output values being produced, so make sure to put this statement before;*/

	*Use delete statement to remove records from a dataset;
/*	if arrange_new = "NONE" then delete;*/

run;

*Selecting variables from a dataset - KEEP and DROP
Both the KEEP and DROP statements can be used in similar ways and positions. Decision to use one statement or the other depends
on the number of variables that you require from a dataset. NOTE - using the parenthesis enables different features.;

/*data sample3(keep=active_arrange_flag);*/
data sample3;

*Method 1 - saves memory. Brings in only the variables requested from input dataset;
/*	set sample2*/
/*	(keep=account month active_arrange_flag arrangement_type*/
/*	drop=active_arrange_flag);*/

*Method 2 - brings in all of the input dataset and then processes;
	set sample2;
	keep account month active_arrange_flag arrangement_type;
	drop active_arrange_flag;

run;

*Assigning permanent labels and formats
NOTE - both of these do not affect how data is stored in the data set, but only how it appears in output;
*Accumulating totals - review arrangment type;
data sample_label;
	set sample1;
	by account;

	*First method;
	*Initialising the variable to store total;
	if first.account then arrange_mths = .;

	arrange_active = not missing(arrangement_type);	*If true then 1 else 0 is provided;
	arrange_mths + arrange_active;	*Maintains a cumulative total;

	label arrange_mths="Number of active months on arrangement";
	format arrange_mths z2.;

run;

*Print the observations using the labels. NOTE - Most SAS procedures automatically use permanent labels and formats in output.;
proc print data=sample_label(obs=10) label; run;

*Assigning values conditionally using SELECT groups;
data sample_select;
	set sample1;
	by account;

	*Specifying length for variables - make sure that the length statement is used before the variable is created;
	length group $8.;	

	*SELECT group in a data step;
	select (arrangement_type);
		when ("FIRST") group = "F";
		when ("SECOND") group = "S";
		when (" ") group = "NONE";
		otherwise group = "OTHER";
	end;

	*SELECT statements with expressions;
	length group_1 $8.;	

	select (arrangement_type);
		when ("FIRST") group_1 = "F";
		when ("SECOND") group_1 = "S";
		when (" ") group_1 = "NONE";
		otherwise 
			do; 
				group_1 = "OTHER"; 
				put "Check arrangement: " arrangement_type=;	*Record of additional arrangement treatments;
			end;
	end;

	*SELECT statements without expressions;
	length group_2 $8.;
	select;
		when (arrangement_type = "FIRST") group_2 = "F";
		when (arrangement_type = "SECOND") group_2 = "S";
		when (arrangement_type = " ") group_2 = "NONE";
		otherwise;	*A null value will be output;
	end;

run;

*Grouping statements using DO groups;
data sample_do;
	set sample1;
	by account;

	*IF statement;
	length group $8.;	
	if arrangement_type = "FIRST" then group = "F";
	else if arrangement_type = "SECOND" then group = "S";
	else if not missing(arrangement_type) then
		do;
			if arrangement_type = "THIRD" then group = "T";
			else if arrangement_type = "FOURTH" then group = "FO";
			else group = "OTHER";
		end;
	else group = "NONE";

	*SELECT statement;
	length group_1 $8.;	

	select (arrangement_type);
		when ("FIRST") group_1 = "F";
		when ("SECOND") group_1 = "S";
		when (" ") group_1 = "NONE";
		otherwise 
			do; 
				group_1 = "OTHER"; 
				put "Check arrangement: " arrangement_type=;	*Record of additional arrangement treatments;
			end;
	end;

run;
