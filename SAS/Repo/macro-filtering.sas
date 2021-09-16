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
# Calling the macro in the main body of the code
data dummy;
set dummy (
	where=
	(%filtering)
		);
run;
