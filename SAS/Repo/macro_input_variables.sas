/* The format of the excel file contains
:macro_variable - contains the macro variable name that will be assigned
:value - contains the value that is to be assigned to the macro_variable name

Example:
macro_variable = "START_VALUE"
value = 100

The result of requesting %put &START_VALUE.; will display 100 within the log
*/

*Create a base dataset using datalines - for testing purposes;
data macro_data_test;
	length macro_variable $9. value 8.;
	input macro_variable $9. value best32.;
	datalines;
START_VALUE_T0 1.0000000
START_VALUE_T1 1.5623000
START_VALUE_T2 1.9632500
START_VALUE_T3 2.8952041
START_VALUE_T4 3.5984817
START_VALUE_T5 4.9985364
	;
run;

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
quit;
