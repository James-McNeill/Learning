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

