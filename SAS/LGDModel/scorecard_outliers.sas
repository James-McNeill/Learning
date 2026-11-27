/* Macro to review the scorecard outliers */
%macro check_scorecard_outliers(dsn=, var=, date_var=date_var, shrt_var=);

%mend check_scorecard_outliers;

/* Testing of the macro */
%check_scorecard_outliers(dsn=input_data, var=balance, date_var=date_var, shrt_var=bal);
