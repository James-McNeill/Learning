*Run a macro that creates the list of variables to use and calls the macro to run the code in which it has a time period (T=) value;
%macro run_list_vars(var_list, macro_name);

	*Review the list of variables and create for use;
	%let vars = %sysfunc(countw(&var_list.));

	%put Number of variables = &vars.;

		%do i=1 %to &vars.;
			%let var_vals = %scan(&var_list, &i);
/*			%let var&i = %scan(&var_list, &i);*/
/*			%put &i. &var_vals. &&var&i.;*/
			%put &i. &var_vals.;

			*Run the macro that is requested and the number of time periods needed;
			%&macro_name.(T=&var_vals.);

		%end;

%mend;

*Application of code;
*Create the stressed LGD tables;
%run_list_vars(&Time0., stress_T); *Time0: list of time periods to review (e.g. 0-12), stress_T: name of the macro to create the time period code for;
