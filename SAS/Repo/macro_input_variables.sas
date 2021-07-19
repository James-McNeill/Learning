/* The format of the excel file contains
:macro_variable - contains the macro variable name that will be assigned
:value - contains the value that is to be assigned to the macro_variable name

Example:
macro_variable = "START_VALUE"
value = 100

The result of requesting %put &START_VALUE.; will display 100 within the log
*/

*Bring in the macro variables from an excel file;
proc sql noprint;
	select macro_variable, value
		into 	:vars separated by ',',
				:values separated by ','
	from macro_inputs;
	%let numobs=&sqlobs;
quit;

*Print the values from the excel file;
%put variables are &vars;
%put values are &values;
%put number of obs &numobs;

*Create the macro variable names;
data _null_;
	set macro_inputs;
	call symputx(macro_variable, value);
run;

*Check that the correct values have been assigned to the macro variables;
proc sql;
	create table macro_vars as
	select name, value
	from dictionary.macros
	where name in (select upcase(macro_variable) from macro_inputs)
	order by name
	;
run;
