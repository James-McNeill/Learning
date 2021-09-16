/* 
When creating new variables in SAS, functionality is available to run a logic test. 
If the logic test results in a true value then 1 is displayed, 
whereas for any false values a 0 will be displayed.
*/

*Display a 1 for a negative value;
data output_data;
	set input_data;
	ead_neg = ead < 0;
	repay_neg = repay < 0;
run;
