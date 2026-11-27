/* Macro to review the scorecard outliers */
%macro check_scorecard_outliers(dsn=, var=, date_var=date_var, shrt_var=);

  /* 1. Compute Overall (Pooled/Annual) Benchmarks */
  proc univariate data=&dsn noprint;
    var &var;
    output out=_overall_stats_&shrt_var.
      n=tot_n
      mean=ov_mean
      std=ov_std
      p1=ov_p1
      p50=ov_p50
      p99=ov_p99
      pctlpts=99.5 pctlpre=ov_p_;
  run;

  data _overall_bounds_&shrt_var.;
    set _overall_stats_&shrt_var.;
    ov_upper_3sd = ov_mean + (3 * ov_std);
    ov_lower_3sd = ov_mean - (3 * ov_std);
    call symputx('ov_p99_val', ov_p99);
    call symputx('ov_3sd_val', ov_upper_3sd);
  run;

  /* 2. Compute monthly percentiles & summary stats */
  proc sort data=&dsn out=_sorted_dsn;
    by &date_var;
  run;

  proc univariate data=_sorted_dsn noprint;
    by &date_var;
    var &var;
    output out=_monthly_stats_&shrt_var.
      n=mth_n
      nmiss=mth_nmiss
      mean=mth_mean
      std=mtd_std
      p1=mth_p1
      p50=mth_p50
      p95=mth_p95
      p99=mth_p99
      max=mth_max;
  run;

  /* 3. Flag observations breaching overall 99th pctl & 3SD by month */
  proc sql;
    create table _breach_summary_&shrt_var. as
    select
      a.&date_var,
      count(a.&var) as valid_n,
      sum(case when a.&var > &ov_p99_val then 1 else 0 end) as breach_ov_p99_cnt,
      calculated breach_ov_p99_cnt / calculated valid_n as breach_ov_p99_pct format=percent8.2,
      sum(case when a.&var > &ov_3sd_val then 1 else 0 end) as breach_ov_3sd_cnt,
      calculated breach_ov_3sd_cnt / calculated valid_n as breach_ov_3sd_pct format=percent8.2
    from _sorted_dsn a
    where a.&var is not missing
    group by a.&date_var
    order by a.&date_var;
  quit;

  /* 4. Combine monthly distribution with overall breach rates */
  data out_&shrt_var.;
    merge _monthly_stats_&shrt_var. _breach_summary_&shrt_var.;
    by &date_var;
    ov_p99_benchmark = &ov_p99_val;
    ov_3sd_benchmark = &ov_3sd_val;
  run;

  title1 "Outlier & Drift review for &var (Pooled vs. Monthly)";
  title2 "Pooled 99th Pctl = &ov_p99_val | Pooled +3 SD = &ov_3sd_val";
  proc print data=out_&shrt_var. noobs;
  run;

  /* 5. Inspect top 10 extreme values (to spot sentinel codes / feed issues) */
  proc sort data=_sorted_dsn out=_top_extremes_&shrt_var.;
    by descending &var;
  run;

  title1 "Top 15 Highest Values for &var across dataset";
  proc print data=_top_extremes_&shrt_var.(obs=15) noobs;
    var &date_var &var;
  run;
  title;

%mend check_scorecard_outliers;

/* Testing of the macro */
%check_scorecard_outliers(dsn=input_data, var=balance, date_var=date_var, shrt_var=bal);
