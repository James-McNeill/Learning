/* Macro: Annual rolling CSI */
%macro annual_rolling_csi(
  data=,                  /* Input Dataset */
  date_var=,              /* Month-end SAS date variable (e.g., '31DEC2007'd) */
  vars=,                  /* Space-separated list of raw variables */
  start_date=,            /* First month end-date (e.g., '31DEC2007'd) */
  end_date=,              /* Final month end-date (e.g., '31DEC2024'd) */
  bins=10,                /* Number of quantile bins for continuous numeric vars */
  where_clause=,          /* Optional dataset filter (without the 'WHERE' keyword) */
  out_summary=csi_out,    /* Output high-level summary dataset */
  out_detail=csi_detail   /* Output bin-level drill-down dataset */ 
);

  /* Clear previous outputs */
  proc datasets library=work nolist;
    delete &out_summary &out_detail;
  quit;

  /* Apply option filter once up front */
  data _filtered_data;
    set &data(keep=&date_var &vars);
    %if %length(&where_clause) > 0 %then %do;
      where &where_clause;
    %end;
  run;

  /* Calculate number of annual steps */
  %let num_years = %sysfunc(intck(YEAR, &start_date, &end_date));
  %let num_vars = %sysfunc(countw(&vars));

  /* Loop through each consecutive date pair e.g. 31DEC */
  %do y = 0 %to %eval(&num_years - 1);

    /* Advance strictly by 12 months keeping month-end alignment (Dec 31 -> Dec 31) */
    %let base_date = %sysfunc(intnx(MONTH, &start_date, %eval(&y * 12), END));
    %let curr_date = %sysfunc(intnx(MONTH, &base_date, 12, END));

    /* Loop through each variable */
    %do v = 1 %to &num_vars;
      %let curr_var = %scan(&vars, &v);

      /* Check variable type */
      data _null_;
        set _filtered_data(obs=1);
        call symputx('vtype', vtype(&curr_var));
      run;

      /* Exact month-end subsetting for Year T and Year T+1 */
      data _base;
        set _filtered_data(keep=&date_var &curr_var);
        where &date_var = &base_date;
      run;

      data _curr;
        set _filtered_data(keep=&date_var &curr_var);
        where &date_var = &curr_date;
      run;

      /* Binning logic: Quantiles for Numeric, Raw Values for Character */
      %if &vtype = N %then %do;
        proc rank data=_base group=&bins out=_base_ranked;
          var &curr_var;
          ranks bin_num;
        run;

        /* Capture boundaries and create clean string join key (bin) */
        proc sql;
          create table _bin_bounds as
          select bin_num,
                  case
                    when bin_num is missing then "MISSING"
                    else strip(put(bin_num, 8.))
                  end length=100 as bin,
                  min(&curr_var) as min_val,
                  max(&curr_var) as max_val,
                  case
                    when bin_num is missing then "MISSING"
                    else cats(put(min(&curr_var), best12.), " to ", put(max(&curr_var), best12.))
                  end length=100 as Bin_Label
          from _base_ranked
          group by bin_num;
        quit;

        /* Standard DATA Step using missing() function */
        data _base_binned;
          set _base_ranked;
          length bin $100;
          if missing(bin_num) then bin = "MISSING";
          else bin = strip(put(bin_num, 8.));
        run;

        proc sql;
          create table _curr_binned as
          select a.&curr_var,
                  case
                    when a.&curr_var is missing then "MISSING"
                    else strip(put(b.bin_num, 8.))
                  end length=100 as bin
          from _curr as a
          left join _bin_bounds as b
          on (a.&curr_var >= b.min_val and a.&curr_var <= b.max_val)
          or (b.bin_num = 0 and a.&curr_var < b.max_val)
          or (b.bin_num = %eval(&bins - 1) and a.&curr_var > b.min_val);
        quit;
      %end;
      %else %do;
        data _base_binned;
          set _base;
          length bin $100;
          if missing(&curr_var) then bin = "MISSING";
          else bin = strip(&curr_var);
        run;

        data _curr_binned;
          set _curr;
          length bin $100;
          if missing(&curr_var) then bin = "MISSING";
          else bin = strip(&curr_var);
        run;

        /* Consistent bounds table structure for character variables */
        proc sql;
          create table _bin_bounds as
          select distinct bin,
                  bin length=100 as Bin_Label
          from _base_binned;
        quit;
      %end;

      /* Calculate Counts & Proportions */
      proc sql;
        create table _base_dist as
        select bin,
                count(*) as Base_Count,
                calculated Base_Count / (select count(*) from _base_binned) as Base_Pct format=percent8.2
        from _base_binned group by bin;

        create table _curr_dist as
        select bin,
                count(*) as Compare_Count,
                calculated Compare_Count / (select count(*) from _curr_binned) as Compare_Pct format=percent8.2
        from _curr_binned group by bin;

        /* Build Bin-Level Detail table (clean string-to-string join on bin) */
        create table _step_detail as
        select "&curr_var" length=32 as variable,
                &base_date format=date9. as Base_Date,
                &curr_date format=date9. as Compare_Date,
                coalesce(b.bin, c.bin) length=20 as Bin_ID,
                coalesce(lbl.Bin_Label, c.bin, "Unseen Category") length=100 as Bin_Range_or_Value,
                coalesce(b.Base_Count, 0) as Base_Count format=comma12.,
                coalesce(c.Compare_Count, 0) as Compare_Count format=comma12.,
                coalesce(b.Base_Pct, 0) as Base_Pct format=percent8.2,
                coalesce(c.Compare_Pct, 0) as Compare_Pct format=percent8.2,
                (coalesce(c.Compare_Pct, 0) - coalesce(b.Base_Pct, 0)) as Pct_Diff format=percent8.2,
                (coalesce(c.Compare_Pct, 0.0001) - coalesce(b.Base_Pct, 0.0001)) *
                log(coalesce(c.Compare_Pct, 0.0001) / coalesce(b.Base_Pct, 0.0001)) as Bin_CSI_Contribution format=8.4
        from _base_dist as b
        full join _curr_dist as c
          on b.bin = c.bin
        left join _bin_bounds as lbl
          on coalesce(b.bin, c.bin) = lbl.bin
        order by Bin_ID;

        /* Roll up Detail table into High-Level summary */
        create table _step_csi as
        select Variable,
                Base_Date,
                Compare_Date,
                sum(Base_Count) as Total_Base_N format=comma12.,
                sum(Compare_Count) as Total_Compare_N format=comma12.,
                sum(Bin_CSI_Contribution) as CSI_Score format=8.4
        from _step_detail
        group by Variable, Base_Date, Compare_Date;
      quit;

      proc append base=&out_detail data=_step_detail force; run;
      proc append base=&out_summary data=_step_csi; run;
    %end;
  %end;

  /* Add stability flags to summary */
  data &out_summary;
    set &out_summary;
    length Status $25;
    if CSI_Score < 0.10 then Status = "No Significant Shift";
    else if CSI_Score < 0.25 then Status = "Moderate Shift (Monitor)";
    else Status = "Major Shift (Action Req)";
  run;

  /* Clean up temporary tables */
  proc datasets library=work nolist;
    delete _filtered_data _base _curr _base_ranked _based_binned _curr_binned _bin_bounds _base_dist _curr_dist _step_detail _step_csi;
  quit;

%mend annual_rolling_csi;

/* Run macro */
%annual_rolling_csi(
  data=input_data,
  date_var=date_var,
  vars=balance arrears tid mia ltv pay_ratio,
  start_date='31DEC2007'd,
  end_date='31DEC2024'd,
  bins=10,
  where_clause=,
  out_summary=csi_out_port1,
  out_detail_csi=csi_detail_port1
);

/* where_clause=%str(account_status = 'ACTIVE' and portfolio = 'RETAIL'); */
