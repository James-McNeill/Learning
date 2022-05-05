/* Review the re-default information */

/* 
Dates of interest:
	Default entry date
	Default exit date (cure date)
	Re-default entry date 
*/

*NOTE - added close date to let this feature act as a cure if loans close during default. Assumption
		is that the customer were able to repay the capital outstanding. Have to be careful to remember that
		debt sales would have unintended impacts as well.;

*Switch close feature on and off. Was resulting in very high cure rates. Need to review a more appropriate way of using this analysis for closed loans;
%let close_flag = 0;		*Turn feature on as part of cure rule with 1 as input value. Zero to switch off.;

data golden_source;
	set data.reporting_data;
run;

*Bring in the maximum reporting month to review close dates;
proc sql noprint;
	select max(month) format date. into: max_mth
	from golden_source
	;
run;

*Last reporting month for loans;
proc sort data=golden_source; by account_no descending month; run;

data gs_last_rep_mth;
	set golden_source;
	by account_no;
	if first.account_no;
run;

data gs_last_rep_mth;
	set gs_last_rep_mth;
	closed = 0;
	if month < "&max_mth."d then closed = 1;
run;

*Retain only the closed loans;
data closed_loans;
	set gs_last_rep_mth
	(where=(closed = 1));
run;

/* Retain the variables for the default dates */
proc sql;
	create table gs_test as
	select t1.account_no, t1.brand, t1.system, t1.year_month,
		t1.default_flag as default,
		t1.default_date as default_date,
		t2.year_month as close_mth
	from golden_source t1
	left join closed_loans t2
		on t1.account_no = t2.account_no
	;
run;

proc sort data=gs_test; by account_no year_month; run;

/* Create the month into default and month to cure */
data gs_test_1;
	set gs_test;
	by account_no;
	
	retain def_date cure_date;

	lag_account = lag(account_no);
	lag_default = lag(default);
	lag_default_date = lag(default_date);

	default_event = 0;
	cure_event = 0;
	closed_event = 0;

	if first.account_no then
		do;
			def_date = 0; cure_date = 0;
		end;

	/* Month of default */
	if first.account_no and default = 1 then 
		do;
			default_event = 1;
			def_date = year_month;
		end;
	if lag_account = account_no and lag_default = 0 and default = 1 then 
		do; 
			default_event = 1;
			def_date = year_month;
		end;

	/* Month of cure */
	if lag_account = account_no and lag_default = 1 and default = 0 then 
		do;
			cure_event = 1;
			cure_date = year_month;
		end;

	/* Month of cure - add in the closed cure, the year month represents the last active month if this criteria is met */
	if &close_flag. = 1 and close_mth = year_month then 
		do;
			closed_event = 1;
			cure_event = 1;
			cure_date = close_mth;
		end;
run;


/* Check can the code pick up accounts defaulting on their first month */
proc sql;
	create table min_def_open_dates as
	select distinct account_no, min(year_month) as open_date,
		min(default_date) as min_def_date format date.
	from gs_test_1
	group by account_no
	;
run;

data min_def_open_dates;
	set min_def_open_dates;
	min_def_date_num = input(put(min_def_date, yymmn6.), 6.);
/*	open_date_num = input(put(open_date, 6.), yymmn6.);*/
	def_first_rep_mth = ifn(open_date = min_def_date_num, 1, 0);

/*	format open_date_num date9.;*/
run;

/* Dedup table on default dates */
proc sort data=gs_test_1(where=(def_date ne 0)) nodupkey out=default_dates;
	by account_no def_date;
run;

/* Dedup table on cure dates */
proc sort data=gs_test_1(where=(cure_date ne 0)) nodupkey out=cure_dates;
	by account_no cure_date;
run;

/* Combine the default and cure date tables*/
proc sql;
	create table default_table as
	select t1.account_no, t1.brand, t1.system, t1.def_date,
		case
			when not missing(t2.cure_date) then t2.cure_date
			else .
		end as cure_date,
		t3.def_first_rep_mth
	from default_dates t1
	left join cure_dates t2
		on t1.account_no = t2.account_no and t1.def_date = t2.def_date
	left join min_def_open_dates t3
		on t1.account_no = t3.account_no
	;
run;

/* Review the cure rates by month and year */
proc sort data=default_table out=default_table_1; by account_no def_date; run;

data default_table_1;
	set default_table_1;
	by account_no def_date;

	def_date_dt = input(put(def_date, 6.), yymmn6.);
	cure_date_dt = input(put(cure_date, 6.), yymmn6.);

	format def_date_dt date. cure_date_dt date.;

	def_year = year(def_date_dt);
	
	*Time to Cure, diff between default date and cure date;
	ttc = intck('month', def_date_dt, cure_date_dt);
run;

*Add the current exposure values for the default and cure dates;
proc sql;
	create table default_table_rev as
	select t1.*, t2.current_balance as def_bal,
		t3.current_balance as cure_bal
	from default_table_1 t1
	left join golden_source t2
		on t1.account_no = t2.account_no and t1.def_date_dt = t2.month
	left join golden_source t3
		on t1.account_no = t3.account_no and t1.cure_date_dt = t3.month
	;
run;

*Add a cured flag;
data default_table_rev;
	set default_table_rev;
	cured = ifn(cure_date_dt <> ., 1, 0);
run;

/* Volume weighted Cure Rate */
proc sql;
	create table def_table_summ as
	select def_year, ttc, count(*) as cases
	from default_table_rev
	group by def_year, ttc
	;
run;

/* Value weighted Cure Rate */
proc sql;
	create table def_table_summ_val as
	select def_year, ttc, sum(def_bal) as value, sum(cure_bal) as value_c
	from default_table_rev
	group by def_year, ttc
	;
run;

*Rank the loans by default balance to understand the cure profile;
%group_banding(input_data=default_table_rev, output_data=default_table_rev_1, input_variable=def_bal, no_groups=10);

*Summary analysis for the ranking of default balances;
proc summary data=default_table_rev_1 mean;
	class def_year group_band;
	var cured / weight=def_bal;
	output out=default_table_rev_2;
run;

data default_table_rev_3;
	set default_table_rev_2
	(where=(_TYPE_ = 3 and _STAT_ = "MEAN"));
run;

/* Review the default, re-default and cure numbers by each account */
proc sql;
	create table cure_def as
	select distinct t1.account_no, count(*) as no_of_defs,
		case
			when not missing(t2.cases) then t2.cases
			else 0
		end as no_of_cures
	from default_table t1
		left join (
					select distinct t1.account_no, count(*) as cases
					from default_table t1
					where not missing(t1.cure_date)
					group by t1.account_no
					) t2 on t1.account_no = t2.account_no
	group by t1.account_no
	;
run;


/* Review cures that happen before the probationary period is completed */
data cure_bef_prob;
	set default_table_rev
	(where=(ttc <= 12 and not missing(ttc)))
	;
run;

/* Check accounts against the stacked reporting table */
proc sql;
	create table cure_bef_prob_gs as
	select t1.*
	from gs_test_1 t1
	inner join cure_bef_prob t2
		on t1.account_no = t2.account_no
	;
run;
