/*
Review the following aspects
1) # of accounts ever in default
2) # of accounts ever in FB
3) Cumulative total number of payments missed ever
4) Payment missed events as sequences (continuous missed payments treated as one)
	a) Payment missed events
	b) Length of these events: (i) start and (ii) end dates

TODO:
1) latest month that an account first entered default on maturity schedule
2) need to review the payment missed time variable for loans which continued to miss payments and then closed. Therefore
	could adjust the code to pick up the close month date.

*/

/* Golden Source table */
data golden_source;
	set &gs_data..default_table
	(keep=account_no month brand system default_flag payments_missed active_fb_flag);
run;

proc sort data=golden_source; by account_no month; run;

/* Review the golden source table */
data golden_source_1;
	set golden_source;
	by account_no;

	retain def_ever fb_ever pay_miss_tot pay_miss_events;
	retain pm_st_date pm_end_date;

	pay_miss_seq = 0;

	lag_payments_missed = lag(payments_missed);

	if first.account_no then do;
		def_ever = 0; fb_ever = 0; pay_miss_tot = 0; lag_payments_missed = 0; 
		lag_pay_miss_tot = 0; lag_pay_miss_seq = 0; pay_miss_events = 0;
		pm_st_date = .; pm_end_date = .;
	end;

	if default_flag = 1 then def_ever = 1;
	if active_fb_flag = 1 then fb_ever = 1;

	payment_missed_diff = payments_missed - lag_payments_missed;
	
	if payment_missed_diff > 0 then pay_miss_tot = pay_miss_tot + payment_missed_diff;
	lag_pay_miss_tot = lag(pay_miss_tot);

	*Cumulative Payment missed total of zero;
	pay_miss_tot_zero = ifn(pay_miss_tot = 0, 1, 0);

	*Payments missed as event sequences
	pay_miss_tot - Only accumulates the missed payments over time, i.e. any overpayments will not decrease this variable;
	if first.account_no and pay_miss_tot > 0 then pay_miss_seq = 1;
	if pay_miss_tot > lag_pay_miss_tot then pay_miss_seq = 1;
	
	lag_pay_miss_seq = lag(pay_miss_seq);
		
	*Counter for the payment missed events - any amount of payment missed during a month means that the payment missed events continues as one continuous event;
	if lag_pay_miss_seq = 0 and pay_miss_seq = 1 then pay_miss_events + 1;

	*Track the start and end dates of the payment missed counter events;
	if lag_pay_miss_seq = 0 and pay_miss_seq = 1 then pm_st_date = month;
	if lag_pay_miss_seq = 1 and pay_miss_seq = 0 then pm_end_date = month;

	lag_pm_st_date = lag(pm_st_date);

	if pm_st_date > lag_pm_st_date then pm_end_date = .;

	pm_time = intck("month", pm_st_date, pm_end_date);

	format pm_st_date date9. pm_end_date date9. lag_pm_st_date date9.;

run;

*Max duration for continuous payments missed
Maximum length of time that a continuous payments missed sequence lasted, represented by number of months
Where if a loan missed regular small amounts across a series of months then these are all seen as being continuous;
proc sql;
	create table max_pm_dur as
	select distinct account_no, max(pm_time) as max_pm_time
	from golden_source_1
	group by account_no
	order by calculated max_pm_time desc
	;
run;

*Combine the max duration to the golden source table;
proc sql;
	create table gs_data_comb as
	select t1.*, t2.max_pm_time
	from golden_source_1 t1
	left join max_pm_dur t2
		on t1.account_no = t2.account_no
	;
run;

proc sort data=gs_data_comb; by account_no month; run;

* Keep only the last observation for each record;
data golden_source_2;
	set gs_data_comb;
	by account_no;

	if last.account_no then output golden_source_2;
run;

* Review the highest payments missed totals;
proc sql;
	create table pm_tot_sorted as
	select *
	from golden_source_2
	order by pay_miss_tot desc
	;
run;


/* SUMMARY OUTPUT */

TITLE 'Payment missed total time series';
PROC TABULATE DATA=WORK.GOLDEN_SOURCE_1;
	VAR pay_miss_tot;
	CLASS month /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		month,
		/* Column Dimension */
		N 
		pay_miss_tot*(
		  Sum 
		  Max 
		  Median 
		  Mean 
		  Min 
		  P5 
		  P95 
		  QRange) 		;
	;
RUN;
TITLE;

TITLE 'Default and FB ever summary';
PROC TABULATE DATA=WORK.GOLDEN_SOURCE_2;
	CLASS def_ever /	ORDER=UNFORMATTED MISSING;
	CLASS fb_ever /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		def_ever*
		  fb_ever,
		/* Column Dimension */
		N 
		ColPctN 		;
	;
RUN;
TITLE;

TITLE 'Payment missed total by Brand and System';
PROC TABULATE DATA=WORK.GOLDEN_SOURCE_2	;
	VAR pay_miss_tot;
	CLASS Brand /	ORDER=UNFORMATTED MISSING;
	CLASS system /	ORDER=UNFORMATTED MISSING;
	CLASS month /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
	month,
	/* Column Dimension */
	N 
	Brand*
	  system*
	    pay_miss_tot*(
	      Max 
	      Mean 
	      Median 
	      Min 
	      P1 
	      P99) 		;
	;
RUN;
TITLE;

TITLE 'Payment missed total zero time series';
PROC TABULATE DATA=WORK.GOLDEN_SOURCE_2;
	VAR pay_miss_tot;
	CLASS month /	ORDER=UNFORMATTED MISSING;
	CLASS pay_miss_tot_zero /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		month,
		/* Column Dimension */
		N 
		pay_miss_tot_zero*
		  N 
		pay_miss_tot_zero*
		  pay_miss_tot*(
		    Max 
		    Mean 
		    Min) 		;
	;
RUN;
TITLE;

TITLE 'Payment missed events, max pm time and payment missed total';
PROC TABULATE DATA=WORK.GOLDEN_SOURCE_2;
	VAR pay_miss_events max_pm_time pay_miss_tot;
	CLASS month /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		month,
		/* Column Dimension */
		N 
		pay_miss_events*(
		  Max 
		  Mean 
		  Median 
		  Min) 
		max_pm_time*(
		  Max 
		  Mean 
		  Median 
		  Min) 
		pay_miss_tot*(
		  Max 
		  Mean 
		  Median 
		  Min) 		;
	;
RUN;
TITLE;

TITLE 'Max payment missed duration';
PROC TABULATE DATA=WORK.MAX_PM_DUR;
	CLASS max_pm_time /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		max_pm_time,
		/* Column Dimension */
		N 		;
	;
RUN;
TITLE;
