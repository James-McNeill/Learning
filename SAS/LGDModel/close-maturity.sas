/*
Understands the dynamic of customers flipping. Taking out long term mortgages and moving on long before the maturity date. 
Also shows that through time the behaviour of customers has changed. When a recession emerges then the volumne of closures
reduces dramatically. Drawing down the max term available took place more since 2000.
*/

*Reviewing the closed accounts and their maturity dates;
data closed;
	set DATABASE.TABLE
		(keep= account_id
		ACC_INCEP_DT
		DRAWDOWN_DT
		SCHDD_TERM_DT
		DRV_MATURITY_DT
		ACTUAL_CLOSE_DATE);
	
  maturity_dt_miss = missing(drv_maturity_dt);
	close_to_mat = intck("month", actual_close_date, drv_maturity_dt); *Positive (closed early), negative (closed after maturity date);
	acc_incep_dt_01 = intnx("month", acc_incep_dt, 0);
	time_to_maturity = intck("month", drawdown_dt, drv_maturity_dt);

	format acc_incep_dt_01 date9.;
run;

proc sort data=closed; by close_to_mat; run;

*Check the loans that reached their maturity date and closed on it or after it;
data closed_1;
 set closed
 (where=(maturity_dt_miss = 0 and close_to_mat <= 0));
run;

*Summary output;
PROC TABULATE DATA=WORK.CLOSED out=closed_to_mat (drop=_TYPE_ _PAGE_ _TABLE_);
 VAR close_to_mat;
 CLASS acc_incep_dt_01 / ORDER=UNFORMATTED MISSING;
 TABLE /* Row Dimension */
  acc_incep_dt_01,
  /* Column Dimension */
  close_to_mat*(
       N 
       Sum 
       Max 
       Mean 
       Median 
       Min)  ;
 ;
RUN;
