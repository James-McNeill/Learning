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
