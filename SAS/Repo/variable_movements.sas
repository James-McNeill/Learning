*Variable information, want to understand if any monthly movements occured outside a one standard deviation
	compared to the average for the variable;

%macro var_movement(input_data=, variable=, var_cm=, var_pm=);
proc means data=&input_data. mean median stddev p1 p99;
	var &variable.;
	output out=var_move_out;
run;

proc sql noprint;
	select &variable. into: std_dev
	from var_move_out
	where _stat_ = 'STD'
	;
quit;

proc sql noprint;
	select &variable. into: mean
	from var_move_out
	where _stat_ = 'MEAN'
	;
quit;

%put &std_dev. &mean.;

proc sql;
	create table var_move_data_&variable. as
	select t1.account_no, t1.&variable., t1.&var_cm., t1.&var_pm.
	from &input_data. t1
	where t1.&variable. > (&mean. + &std_dev.) or t1.&variable. < (&mean. - &std_dev.)
			and t1.&variable. is not null
	order by t1.&variable.
	;
quit;

proc univariate data=var_move_data_&variable.;
	var &variable.;
	hist &variable.;
	qqplot &variable.;
run;

%mend;

%var_movement(input_data=input, variable=val_move, var_cm=val_cm, var_pm=val_pm);
