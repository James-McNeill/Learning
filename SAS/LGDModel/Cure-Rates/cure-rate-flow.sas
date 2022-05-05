/* Review the default and cure date outputs */
/* Analysing the flow of accounts during each reporting month */

/* Review golden source for date range */
proc sql noprint;
	select min(month) format date9. into: min_date
	       ,max(month) format date9. into: max_date
	from golden_source;
run;

%put &min_date. &max_date.;

*Create template to populate;
data testing;

	format month date9. start_dt date9. end_dt date9.;
	start_dt = "&min_date."d;
	end_dt = "&max_date."d;

	dif = intck('month', start_dt, end_dt);
	do i = 0 to dif;
		month = intnx('month', start_dt, i);
		output;
	end;

run;

*Volume by default date;
proc sql;
	create table def_all as
	select def_date_dt, count(*) as cases
	from default_table_rev
	group by 1
	;
run;

*Volume by cure date;
proc sql;
	create table cure_all as
	select cure_date_dt, count(*) as cases
	from default_table_rev
	group by 1
	;
run;


*Combine the default and cure date values to the template;
proc sql;
	create table flow_review as
	select t1.month, t2.cases as defaults, t3.cases as cures,
		t2.cases / sum(t2.cases, t3.cases) as def_ratio,
		t3.cases / sum(t2.cases, t3.cases) as cure_ratio
	from testing t1
	left join def_all t2
		on t1.month = t2.def_date_dt
	left join cure_all t3
		on t1.month = t3.cure_date_dt
	;
run;

%macro flow_by_brand(input_table= , brand=);

*Volume by default date;
proc sql;
	create table def_all_&brand. as
	select def_date_dt, count(*) as cases
	from &input_table.
	where brand = "&brand."
	group by 1
	;
run;

*Volume by cure date;
proc sql;
	create table cure_all_&brand. as
	select cure_date_dt, count(*) as cases
	from &input_table.
	where brand = "&brand."
	group by 1
	;
run;


*Combine the default and cure date values to the template;
proc sql;
	create table flow_review_&brand. as
	select t1.month, t2.cases as defaults, t3.cases as cures,
		t2.cases / sum(t2.cases, t3.cases) as def_ratio,
		t3.cases / sum(t2.cases, t3.cases) as cure_ratio
	from testing t1
	left join def_all_&brand. t2
		on t1.month = t2.def_date_dt
	left join cure_all_&brand. t3
		on t1.month = t3.cure_date_dt
	;
run;

%mend;

%flow_by_brand(input_table=default_table_rev, brand=A);
