/* Calculate the first default event for each account */

/*Default table*/
data def_table;
	set INPUT_TABLE
	(keep=account_no month default_flag Default_date months_in_arrears days_in_arrears);
run;

proc sort data=def_table; by account_no month; run;

/*Latest month in the default table*/
proc sql noprint;
	select max(month) format date9. into: max_date
	from def_table;
quit;

%put &max_date.;

/*Create the default flags for review*/
data def_table;
	set def_table;
	by account_no;

	retain def_ever;	*default ever flag;

	first_def = 0;		*unique first time into default;

	/*Lagged variables*/
	lag_acct = lag(account_no);
	lag_def = lag(default_flag);

	/*Aim to display a default ever flag*/
	if first.account_no then def_ever = 0;
	if first.account_no and default_flag = 1 then def_ever = 1;
	if lag_acct = account_no and default_flag = 1 then def_ever = 1;

	lag_def_ever = lag(def_ever);

	/*Flag the first month into default*/
	if first.account_no and default_flag = 1 then first_def = 1;
	else if lag_acct = account_no and lag_def_ever = 0 and lag_prov = 0 and default_flag = 1 then first_def = 1;

run;

*Review the account drawdown date;
data account_trans;
	set account_transactions
	(keep=account_no month drawdown_dt);
run;

proc sql;
	create table act_def as
	select t1.*, t2.drawdown_dt
	from def_table t1
	left join account_trans t2
		on t1.account_no = t2.account_no and t1.month = t2.month
	;
quit;

/*Create the time on book*/
data act_def;	
	set act_def;
	tob = intck('month', drawdown_dt, month);
run;

/*Review the latest month of first default events*/
proc sql;
	create table first_def_lat_mth as
	select *
	from act_def
	where first_def = 1 and month = "&max_date."d
	order by months_in_arrears desc
	;
quit;

/* Check were there duplicates being created for the first time into default */
proc sql;
	create table dup_check as
	select distinct account_no, sum(first_def) as num_fd
	from def_table
	group by 1
	order by calculated num_fd desc
	;
quit;

/*Retain the last month that the account was ever reported on*/
proc sort data=def_table; by account_no month; run;

data last_mth;
	set def_table;
	by account_no month;

	if last.account_no;
run;


*SUMMARY ANALYSIS;

*Default table summaries: default flag by default date;
title "Default flag by default date";
PROC TABULATE DATA=WORK.def_table;
	CLASS Default_date /	ORDER=UNFORMATTED MISSING;
	CLASS Default_Flag /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		Default_date,
		/* Column Dimension */
		Default_Flag*
		  N 		;
	;
RUN;
title;

title "First default flag by reporting month";
PROC TABULATE DATA=WORK.def_table;
	CLASS month /	ORDER=UNFORMATTED MISSING;
	CLASS first_def /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		month,
		/* Column Dimension */
		N 
		first_def*
		  N 		;
	;
RUN;
title;

title "Default ever and first default flags"; 
PROC TABULATE DATA=WORK.def_table	;
	CLASS month /	ORDER=UNFORMATTED MISSING;
	CLASS def_ever /	ORDER=UNFORMATTED MISSING;
	CLASS first_def /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		month,
		/* Column Dimension */
		def_ever*
		  N 
		first_def*
		  N 		;
	;
RUN;
title;

*Last month for each loan. Understanding if the loan defaulted ever and what default category it finished in.;
title "Last active month: Default ever by default flag";
PROC TABULATE DATA=WORK.LAST_MTH;
	CLASS def_ever /	ORDER=UNFORMATTED MISSING;
	CLASS Default_Flag /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		def_ever,
		/* Column Dimension */
		N 
		Default_Flag*(
		  N 
		  RowPctN) 		;
	;
RUN;
title;

title "Last active month: Defaulted ever by default flag";
PROC TABULATE DATA=WORK.LAST_MTH;
	WHERE( def_ever = 1);
	CLASS month /	ORDER=UNFORMATTED MISSING;
	CLASS Default_Flag /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		month,
		/* Column Dimension */
		N 
		Default_Flag*(
		  N 
		  RowPctN) 		;
	;
RUN;
title;

*Summary of information for the first time that loans enter default throughout their active time series on the books.;
title "Summary of days_in_arrears, months in arrears and time on book for first default month";
PROC TABULATE DATA=WORK.act_def (where=(first_def = 1));
	VAR months_in_arrears days_in_arrears tob;
	CLASS month /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		month,
		/* Column Dimension */
		N 
		days_in_arrears*(
		  Max 
		  Mean 
		  Median 
		  Min 
		  P5 
		  P95) 
		months_in_arrears*(
		  Max 
		  Mean 
		  Median 
		  Min 
		  P5 
		  P95) 
		tob*(
		  Max 
		  Mean 
		  Median 
		  Min 
		  P5 
		  P95) 		;
	;
RUN;
title;

title "Unique first time defaults from population";
PROC TABULATE DATA=WORK.DUP_CHECK;
	CLASS num_fd /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
		num_fd,
		/* Column Dimension */
		N 
		ColPctN 		;
	;
RUN;
title;
