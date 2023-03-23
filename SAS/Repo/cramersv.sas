ods graphics on; *produce HTML output;

%let var_list = var1 var2 var3;

/* Cramers V used to understand variable associations. Macro processes through list of input variables */
%macro cramer(inputdata=input, vars=&var_list.);

  *Perform chisq with each macro variable;
  proc freq data=&inputdata.;
    tables variable*&&var&v.. / expected chisq; *&&var&v.. = macro variable within do loop taking value from vars input list;
  run;

%mend cramer;

/* Run macro using default parameters */
%cramer;

ods graphics off; *return to default setting;
