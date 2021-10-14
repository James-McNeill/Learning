*Examples will be shown using Data step joins. Alternatively, PROC SQL can be used to perform JOINS.;

*Datasets to use for the examples that follow;
data close1;
	set closed
	(/*firstobs=10*/
	obs=20
	keep=account
		brand
		system
		current_balance);
run;

data close2;
	set closed
	(/*firstobs=50 obs=100*/
	obs=10
	keep=account
	brand
	arrears_balance);
run;

*One-to-one merging;
*NOTE - The number of observations in the new data set is the number of observations in the smallest original data set.
The data step stops after it has read the last observation from the smallest data set.;
data one2one;
	set close1;
	set close2;
run;

*Concatenating - append data from two datasets together. 
Read all variables from the first dataset and then all variables from the second. 
NOTE - that the first variable of both datasets require the same formatting.;
data concat;
	set close1 close2;
run;


*Appending;
*Although appending and concatenating are similar, there are some important differences between the two methods. With concatenating
a new dataset was created. PROC APPEND simply adds the observations of one dataset to the end of a BASE dataset.;

*Running this version produces errors. Code searches for the same variables in both tables and when this is not the case SAS will
revert to not producing any updated outputs. ;
/*proc append base=close1 data=close2; run;*/

*Using the FORCE option with unlike structured datasets. Only variables matching the base table will be appended.;
/*proc append base=close1 data=close2 force; run;*/


*Interleaving;
*Intersperses observations from two or more datasets, based on one or more common variables. Each input data set must be sorted or
indexed in ascending order based on the BY variable(s).;
proc sort data=close1 out=close1s; by account; run;
proc sort data=close2 out=close2s; by account; run;

data inter;
	set close1s close2s;
	by account;
run;

*Match-merging;
*Combine observations from two or more data sets into a single observation in a new data set according to the values
of a common variable. Similar to the interleaving each dataset has to be ordered correctly before joining datasets. ;

data match;
	merge close1s close2s;
	by account;
run;

*Renaming variables;
data match1;
	merge close1s 
		  close2s;
	by account;
run;

*Excluding unmatched observations;
*Creating temporary IN= variables. 
Selecting observations from both tables that match;
data match_both;
	merge close1s(in=a)
		  close2s(in=b);
	by account;

	*Two methods to select matching observations from both tables;
/*	if a=1 and b=1;*/
	if a and b;
run;

*Using a left join;
data match_left;
	merge close1s(in=a)
		  close2s(in=b);
	by account;

	if a;
run;

*Using a right join;
data match_right;
	merge close1s(in=a)
		  close2s(in=b);
	by account;

	if b;
run;
