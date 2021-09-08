/* Create 2 and 3 factor variable combinations */

*Combinations - Three variables. Input data is a list of macro-economic variables to be reviewed via model combinations;
%macro comb_3(input=, out=);

*Create the three variable listing datasets;
data vars_1;
	set &input.;
	rename variable = variable1 variable_ind = variable_ind1 level = level1;
run;

data vars_2;
	set &input.;
	rename variable = variable2 variable_ind = variable_ind2 level = level2;
run;

data vars_3;
	set &input.;
	rename variable = variable3 variable_ind = variable_ind3 level = level3;
run;

*Combine all of the variable datasets;
data all;
  set vars_1;
  do i=1 to n1;
    set vars_2 point=i nobs=n1;
    do j=1 to n2;
      set vars_3 point=j nobs=n2;
      output;
    end;
  end;
run;

*Add additional variables; 
data all_1;
	set all;
	dup1 = 0; 
	dup2 = 0;

	if level1 = level2 then dup1 = 1;
	else if level2 = level3 then dup1 = 1;
	else if level1 = level3 then dup1 = 1;

	if variable_ind1 = variable_ind2 then dup2 = 1;
	else if variable_ind2 = variable_ind3 then dup2 = 1;
	else if variable_ind1 = variable_ind3 then dup2 = 1;
run;

*Re-order the variable names and remove duplicate variations of the combination;
data all_2;
	set all_1
	(where=(dup1 = 0 and dup2 = 0));
	keep variable1 variable2 variable3;
run;

data all_3;
	set all_2;
	array t variable:;
	call sortc(of t(*));
	combine_var = cats(variable1, variable2, variable3);
run;

*Dedup the data;
proc sort data=all_3 out=all_4 nodupkey; by combine_var; run;

*Final dataset;
data &out.;
	set all_4
	(drop=combine_var);
	IND_VARS = CATX(" ", VARIABLE1, VARIABLE2, VARIABLE3);
run;

*Clear the macro dataset library;
proc datasets lib=work nodetails nolist nowarn;
	delete vars_: all:;
run;

%mend;

*Macro run with the independent variable listing;
%comb_3(input=FINAL_LIST_TBL, out=FINAL_LIST_TBL_CVAR3);


*Combinations - Two variables. Similar to the 3 factor macro with only two factors reviewed.;
%macro comb_2(input=, out=);

data vars_1;
	set &input.;
	rename variable = variable1 variable_ind = variable_ind1 level = level1;
run;

data vars_2;
	set &input.;
	rename variable = variable2 variable_ind = variable_ind2 level = level2;
run;

data all;
  set vars_1;
  do i=1 to n1;
    set vars_2 point=i nobs=n1;
    output;
  end;
run;

*Add additional variables; 
data all_1;
	set all;
	dup1 = 0; 
	dup2 = 0;

	if level1 = level2 then dup1 = 1;

	if variable_ind1 = variable_ind2 then dup2 = 1;
run;

*Re-order the variable names and remove duplicate variations of the combination;
data all_2;
	set all_1
	(where=(dup1 = 0 and dup2 = 0));
	keep variable1 variable2;
run;

data all_3;
	set all_2;
	array t variable:;
	call sortc(of t(*));
	combine_var = cats(variable1, variable2);
run;

*Dedup the data;
proc sort data=all_3 out=all_4 nodupkey; by combine_var; run;

*Final dataset;
data &out.;
	set all_4
	(drop=combine_var);
	IND_VARS = CATX(" ", VARIABLE1, VARIABLE2);
run;

*Clear the macro dataset library;
proc datasets lib=work nodetails nolist nowarn;
	delete vars_: all:;
run;

%mend;

%comb_2(input=FINAL_LIST_TBL, out=FINAL_LIST_TBL_CVAR2);
