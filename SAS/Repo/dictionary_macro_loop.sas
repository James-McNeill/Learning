/* Variable with cut-off value in KV (Key Value) pair */
%let var_list = balance:100 ltv:0.25 grade:4;

/* Macro - HPSplit (High Performance Split) */
%macro hpsplit_review(data=input_data, varlist=&var_list.);
  /* 1. Count the number of items in the variable list */
  %local num_items i current_pair current_var current_cutoff;
  %let num_items = %sysfunc(countw(&varlist., %str( ))); *str( ) is used to for delimiter reference within var_list dictionary;

  /* 2. Loop through each item using a shared index */
  %do i = 1 %to &num_items.;
    /* Extract Pair */
    %let current_pair = %scan(&varlist., &i., %str( ));

    /* Extract the current variable and its connected cut-off value */
    %let current_var = %scan(&current_pair., 1, %str(:)); *str(:) references the delimiter positions;
    %let current_cutoff = %scan(&current_pair., 2, %str(:));

    /* 3. Execute the SAS code using the values */
    proc freq data=&data. noprint;
      tables &current_var.;
    run;

    proc hpsplit data = &data.
      seed = 1234
      plots = ALL
      assignmissing = similar
      nodes = summary
      minleafsize = 3000 /* 20% of total */
      maxdepth = 1
      maxbranch = 2
      ;
      performance NTHREADS=1;
      ID ACC_ID;
      model dependent_var = &current_var.;
      grow ftest;
    run;

    proc sql; select count(*) from &data. where &current_var.<=&current_cutoff.; quit;
    proc sql; select count(*) from &data. where &current_var.>&current_cutoff.; quit;
    
  %end;

%mend;

/* Run macro */
%hpsplit_review();
