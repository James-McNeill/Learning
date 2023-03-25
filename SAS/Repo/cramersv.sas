ods graphics on; *produce HTML output;

%let var_list = var1 var2 var3;

/* Cramers V used to understand variable associations. Macro processes through list of input variables */
%macro cramer(inputdata=input, vars=&var_list.);

  *Create independent variable list to process;
  proc sql;
   create table vars as
   select name
   from dictionary.columns
   where libname = upcase("work")
    and memname = upcase("&inputdata.")
    and name in &vars.
   ;
  quit;
  
  *Count of words;
  proc sql noprint; select count(*) into :var_num from vars; quit;
  
  %put var_num is: &var_num.;
  
  *Assign id number to words;
  data vars;
   set vars;
   var_id = _N_;
  run;

  *Perform DO loop to produce variable level chisquare analysis;
  %DO V = 1 %TO &var_num.;
  
   *Assign the variable name to macro var[1:N];
   
  
   *Perform chisq with each macro variable;
   proc freq data=&inputdata.;
     tables variable*&&var&v.. / expected chisq; *&&var&v.. = macro variable within do loop taking value from vars input list;
   run;
  
  %END;

%mend cramer;

/* Run macro using default parameters */
%cramer;

ods graphics off; *return to default setting;
