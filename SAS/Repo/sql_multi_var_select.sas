/* Multiple variable select statement */
%macro select_out(output_table, group_vars);

  %local i n var_list;

  %let n = %sysfunc(countw(&group_vars.));
  %let var_list = %scan(&group_vars., 1);

  %do i = 2 %to &n.;
    %let var_list = &var_list, %scan(&group_vars., &i.);
  %end;

  proc sql;
    create table &output_table. as
    select 
      &var_list.,
      count(*) as vol,
      mean(lgd) as mean_lgd,
      sum(balance) as sum_bal
    from input_table
    group by &var_list.
    ;
  quit;

%mend;

/* Run macro, can be single / multiple factor list */
%select_out(out1, band1);
%select_out(out2, band1 year time_in_default portfolio);
