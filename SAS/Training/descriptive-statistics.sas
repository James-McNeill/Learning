*Many different SAS procedures that are designed specifically to produce various types of descriptive statistics
and to display them in meaningful reports;

*Dataset that is going to be reviewed;
%let input_table=testing;

*The MEANS procedure;

*Using the default statistics for Numeric variables;
proc means data=input_table;
run;

*Review certain statistics, select the options;
proc means data=input_table median range;
run;

*Limiting the decimal places;
proc means data=input_table min max maxdec=0;
run;

*Retaining only certain variables for analysis;
proc means data=input_table n nmiss min max maxdec=0;
	var balance_amount repay_amt REMAINING_TERM;
run;

*Group processing using the CLASS option;
proc means data=input_table min max maxdec=0;
	var balance_amount repay_amt REMAINING_TERM;
	class county;
run;

*Group processing using the BY option - NOTE need to sort the input dataset before using the process option
Final output report tables will be in a different format to the CLASS option report;
proc sort data=input_table out=input_table_sort;
	by county;
run;

*Sorted dataset to ensure that the BY option will work;
proc means data=input_table_sort n min max maxdec=0;
	var balance_amount repay_amt REMAINING_TERM;
	by county;
run;


*OUTPUT a SAS dataset from the report that was created;

*Output the default options from the procedure;
proc means data=input_table;
	var balance_amount repay_amt REMAINING_TERM;
	output out=input_table_out;
run;

*Rename the output options;
proc means data=input_table;
	var balance_amount repay_amt REMAINING_TERM;
	class county;
	output out=input_table_out1
		mean=AvgBal AvgPay AvgTerm
		min=MinBal MinPay MinTerm
		max=MaxBal MaxPay MaxTerm;
run;

*Suppress the report from being produced using the NOPRINT option;
proc means data=input_table noprint;
	var balance_amount repay_amt REMAINING_TERM;
	class county;
	output out=input_table_out2
		mean=AvgBal AvgPay AvgTerm
		min=MinBal MinPay MinTerm
		max=MaxBal MaxPay MaxTerm;
run;


*The SUMMARY procedure
Main difference between MEANS and SUMMARY is that the MEANS procedure produces a report by default;

proc summary data=input_table;
	var balance_amount repay_amt REMAINING_TERM;
	class county;
	output out=input_table_out3
		mean=AvgBal AvgPay AvgTerm
		min=MinBal MinPay MinTerm
		max=MaxBal MaxPay MaxTerm;
run;

*Creating a report using the PRINT option;
proc summary data=input_table print;
	var balance_amount repay_amt REMAINING_TERM;
	class county;
	output out=input_table_out4
		mean=AvgBal AvgPay AvgTerm
		min=MinBal MinPay MinTerm
		max=MaxBal MaxPay MaxTerm;
run;


*The FREQ procedure
Create crosstabulation frequency tables that summarize data for one and n-way categorical variables;

*Freq for all unique values in categorical variables will be reported on;
proc freq data=input_table;
	tables county closed_month / missing;
run;

*Suppress the cumulative variables;
proc freq data=input_table;
	tables county closed_month / nocum;
run;

*Creating a two-way table;
proc freq data=input_table;
	tables county*closed_month;
run;

*Creating a n-way table. Be careful with missing data;
proc freq data=input_table;
	tables county*closed_month*rate_type;
run;

*Creating tables in a list format;
proc freq data=input_table;
	tables county*closed_month*rate_type / list;
run;

*Changing the table format;
proc freq data=input_table;
	tables county*closed_month*rate_type / crosslist;
run;

*Suppressing table information. Four table default options:
nofreq
norow
nocol
nopercent;
proc freq data=input_table;
	tables county*closed_month*rate_type / nofreq norow nocol;
run;
