/* Hash tables are a memory efficient method of connecting datasets together. As the Hash table will not take up as much
space in the virtual memory it allows for an efficient method to combine data.
The following examples highlight a number of different features that can be reviewed when using Hash tables
*/

*Append the values to the time periods;
data base_samp;
	if 0 then set base_samp forecast_vals; *initial step that highlights the datasets being combined;

	if _N_ = 1 then do;
		declare hash h1(dataset: "forecast_vals");
			h1.definekey('brand', 'time'); *key that will combine the two datasets;
			h1.definedata('PF_val', 'NP_val', 'PF_val1', 'NP_val1'); *variables that will be assigned to the base_samp;
			h1.definedone(); *Closes out the connection;
	end;

	set work.base_samp; *Bring in the base_samp dataset;
	if h1.find(key: brand, key: time) = 0 then output; *Perform the inner join connection between the datasets and output results;

run;

/* Review list of time periods to perform joins for */
*Time period values from the input variable list;
%let var_num = %sysfunc(countw(&timet.)); *timet: list of time periods (e.g. 0 - 12), countw: method counts total number of values;
%let var_first = %scan(&timet., 1); *scans for the first value in the list;
%let var_last = %scan(&timet., &var_num.); *returns the final value in the list;

*DO LOOP within macro to perform the time period movements;
%do i = &var_first. %to &var_last.;

	*The in_&i. dataset represents the previous time period;
	%if &i. = &var_first. %then %do;
	data in_&i.;
		set base_samp(where=(time = %eval(&i. - 1)));
	run;
	%end;
	%if &i. > &var_first. %then %do;
	data in_&i.;
		set out1_%eval(&i. - 1);
	run;
	%end;

	*Create the output dataset - represents the current time period;	
	data out_&i.;
		set base_samp(where=(time = &i.));
	run;

	*Add the lagged values from in_ to out_ datasets;
	data out_&i.;
		if 0 then set out_&i. in_&i.; *datasets that will be combined;

		if _N_ = 1 then do;
			declare hash h1(dataset: "in_&i."); *declaring the dataset to combine with the base dataset;
				h1.definekey('account_no'); *primary key;
				h1.definedata('s1_ead', 's2_ead', 's3_ead'); *sample list of variables to combine;
				h1.definedone();
		end;

		set work.out_&i.;
		rc = h1.find(); *complete the join between the datasets;

		if rc = 0 then do;
			s1_ead_lag = s1_ead; s2_ead_lag = s2_ead; s3_ead_lag = s3_ead; 
		output;
		end;

	run;
%end;
