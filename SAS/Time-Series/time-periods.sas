/* Macro to create a list of time periods to perform forecasts on */

%let max_t = 60;  *This variable can also be created as part of a macro variable;

*Alternative approach to creating max_t - dataset contains a list of input variables that reference the max date being used;
proc sql noprint;
	select max(input(substr(Macro_Variable, find(Macro_Variable,'Y', 'i', -length(Macro_Variable))+1),8.))
		into	:max_t
	from macro_inputs 
	where Macro_Variable like ("HPI%")
	;
run;

*Display the max time period to be used within the project code;
%put max time period for model run: &max_t.;

*Create time period variables;
%macro time_periods(t0=, t1=);
	
	data do_testing;
		do t = &t0. to &t1.;
			output;
		end;
	run;

	proc sql noprint;
		select t into :Time&t0. separated by ' '
		from do_testing;
	run;

	proc datasets lib=work nodetails nolist nowarn;
		delete do_testing;
	run;

%mend;

*Execute the macros;
data _null_;
	call execute('%time_periods(t0=0, t1=&max_t.)');
	call execute('%time_periods(t0=1, t1=&max_t.)');
run;

/* Shows the list of values across the time different being reviewed */
%put Time Periods = &Time0.;
%put Time Periods = &Time1.;
