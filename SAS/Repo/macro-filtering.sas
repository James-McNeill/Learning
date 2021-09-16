/* 
Enables the user to develop a macro with a string component to outline how to filter 
the dataset that the string will be applied to. Ensures that the same macro string 
is used and only has  to be adjusted in one place within the SAS project instead 
of in mutliple locations.
*/

/* Creating a filter to assign to a dataset */
%macro filtering;
	FILTER_FLAG not = 'Y'
  and DATA_FLAG = 'Y'  
  and index(PORT, 'INCL')= 0 
  and DIV_DESC not IN ('NOT PART OF LIST',
                       'MISSING',
                       'OTHER') 
  OR (BALANCE > 0))

%mend filtering;

*NOTE: no semi-colon is required within the macro string as this is not required;

# Calling the macro in the main body of the code
data dummy;
set dummy (
	where=
	(%filtering)
		);
run;
