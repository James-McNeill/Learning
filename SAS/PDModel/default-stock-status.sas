/*
Review the movement in the default book over time:
  0) Performing
  1) Default stock
  2) In flow
  3) Out flow

NOTES:
First reporting month we have to assume everyone was in the default stock. It is hard
to determine if the loans flowed in this month or were already present in the stock
from previous months so this flat assumption will have to be used.
If a default date was available to show the months prior to the first reporting month
then we would be able to correct this anomalie.

*/

/*Take the golden source table*/
proc sort data=golden_source out=gs_data; by account_no month; run;

/*Create the default state flag*/
data gs_data;
	set gs_data;
	by account_no;

	lag_default = lag(default_flag);

	*Assign initial value;
	if first.account_no then do;
		lag_default = 0;
		if default_flag = 1 then def_state = 1;
		else def_state = 0;
	end;

	*Create default state flag;
	if lag_default = 0 and default_flag = 0 then def_state = 0;
	else if lag_default = 1 and default_flag = 1 then def_state = 1;
	else if lag_default = 0 and default_flag = 1 then def_state = 2;
	else if lag_default = 1 and default_flag = 0 then def_state = 3;
	
run;

*Summary output;
PROC TABULATE DATA=WORK.GS_DATA	;
	CLASS month /	ORDER=UNFORMATTED MISSING;
	CLASS def_state /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
			month,
			/* Column Dimension */
			N 
			def_state*
			  N 		;
	;
RUN;
