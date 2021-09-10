/* Creating a time series dataset that has the forecasted time periods added to the initial rows in the dataset 
If the forecast is for N periods into the future then the code will add the additional N time periods to the
dataset and these will be populated with the forecasted data. The idea was to create a long stacked dataset
that allows for the same variable name to have multiple time periods appended. The alternative option is to 
build a wide dataset that adds the time period suffix to each variable that is being created when the forecast
is run.
*/

*Base dataset that will be populated.
time_t0: initial dataset month that has the sample of accounts which will have forecasted data created for
var_list_0: list of variables from the first month of the time series that will not change
date0: macro date representing the first month of the time series
time_int: string variable with either monthly (M) or yearly (Y) values
var_list_1: list of variables that will be created during the time series forecast;

data base_samp;
	retain account_no month_st month time;	*Move selected variables to the beginning of the dataset;
	set time_t0 
	(keep=&var_list_0.);	*Keep only variable values that will not change throughout the forecast;
	
	month_st = "&date0."d;

	*LOOP through the time steps - inclusion of output parameter will result in the additional data being created
  for the time period that is being forecast;
	if "&time_int." = "M" then do;
		do time = 0 to 60;
			month = intnx("month", month_st, time);
			output;
		end;
	end;
	else if "&time_int." = "Y" then do;
		do time = 0 to 5;
			month = intnx("month", month_st, time * 12);
			output;
		end;
	end;
	
	*Create the list of variables with a dummy value input;
	retain &var_list_1. 0;

	*Format variables;
	format month_st month date9.;

run;

*Sort the dataset that has been created in the appropriate order;
proc sort data=base_samp; by account_no time; run;
