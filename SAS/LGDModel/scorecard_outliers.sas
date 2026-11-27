/* Macro to review the scorecard outliers */
%macro check_scorecard_outliers(dsn=, var=, date_var=date_var, shrt_var=);

  /* 1. Compute Overall (Pooled/Annual) Benchmarks */
  proc univariate data=&dsn noprint;
  run;

  data ;
    set ;
  run;

  /* 2. Compute monthly percentiles & summary stats */
  proc sort data=&dsn out=_sorted_dsn;
    by &date_var;
  run;

  proc univariate data=_sorted_dsn noprint;

  run;

  /* 3. Flag observations breaching overall 99th pctl & 3SD by month */
  proc sql;

  quit;

  /* 4. Combine monthly distribution with overall breach rates */
  data ;
    set ;
  run;

  title1 "";
  title2 "";
  proc print ;
  run;

  /* 5. Inspect top 10 extreme values (to spot sentinel codes / feed issues) */
  proc sort ;
    by ;
  run;

  title1 "";
  proc print ;
    var ;
  run;
  title;

%mend check_scorecard_outliers;

/* Testing of the macro */
%check_scorecard_outliers(dsn=input_data, var=balance, date_var=date_var, shrt_var=bal);
