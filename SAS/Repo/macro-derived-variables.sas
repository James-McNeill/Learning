/* 
Enables the user to develop a macro that creates all of the variables which will be required. 
By not referencing the dataset it means that the variables can be added to any dataset which 
has the correct underlying variables in the same format that the macro 
is using to create additional variables.
*/

%macro derive_additional_variables;
  
  /*ead*/
  if div_desc = 'main' then
    do;
      EAD = EAD_MAIN;		end;
  else
    do;
      EAD = EAD_SUB;
    end;

   /*Create division field*/
   format  division_jun $35.;
   DIVISION = DIV_DESC;
   
%mend derive_additional_variables;

# Calling the macro in the main body of the code
data dummy;
  set dummy;
  %derive_additional_variables;
run;
