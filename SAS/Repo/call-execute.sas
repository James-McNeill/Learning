/*
The call execute procedure creates the string that is required to run the piece of code. 
Which enables mulitple strings to be created dynamically to run the steps required. 
Instead of writing the same piece of code multiple times. Having a macro input value of INPUT=, 
requires a unique value to be provided. If instead the macro value was INPUT, then a list of values could be supplied
The initial table being created will be used to input the summary data from the insert into code. 
The call execute is used to factor in all of the variables required to create the summary output
*/

*Summary queries;
%MACRO SUMMARY_SQL_1(INPUT=, OUTPUT=, VAR1=, VAR2=, VAR3=, VAR4=, T1=, T2=);
	proc sql;
		create table &output.
			(
			variable char(20),
			varout num
			);
	run;
	%do i = &t1 %to &t2;
		proc sql;
			insert into &OUTPUT.
			set variable = "&var4&i.",
				varout = (select sum((&var1&i / (&var1&i + &var2&i)) * &var3&i) / sum((&var1&i / (&var1&i + &var2&i))) from &input);
		run;
	%end;

%MEND;

*Run the query output;
data _null_;
	call execute('%SUMMARY_SQL_1(input=input_data, output=sum_qry, var1=perf_ead_t, var2=nperf_ead_t, var3=perf_pd_t, var4=PD_all_T, t1=0, t2=5)');
run;
