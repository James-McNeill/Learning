*Assess the time to re-default;

*Aim is to match the latest cure date to the next default date;

*Identify the loans that cure from the final summary default table;
proc sql;
	create table def_tb as
	select t1.*,
		case
			when missing(t2.account_no) then 0
			else 1
		end as cured
	from default_table_1 t1
	left join	(select distinct account_no
				from default_table_1
				where cure_date_dt <> .
				) as t2
		on t1.account_no = t2.account_no
	order by t1.account_no, t1.def_date_dt
	;
run;

*Add a row id for all the cured loans;
data def_tb_cr;
	set def_tb
	(where=(cured = 1));
	row_id = _N_;
run;

*Create the cure and re-default date table;
proc sql;
	create table def_tb_cr1 as
	select t1.account_no,
		t1.def_date_dt,
		t1.cure_date_dt,
		t1.ttc,
/*		t2.account_no as acct2,*/
		t2.def_date_dt as redef_date_dt,
		case
			when t1.account_no = t2.account_no then 1
			else 0
		end as acct_match
	from def_tb_cr t1
	left join def_tb_cr t2
		on t1.row_id = t2.row_id - 1
	;
run;

*Remove the redefault date if it links to a different loan;
data def_tb_cr1;
	set def_tb_cr1;
	if acct_match = 0 then redef_date_dt = .;
run;

*Volume of re-defaults by loan;
proc sql;
	create table def_tb_cr1_unique as
	select distinct account_no, count(*) as vol
	from def_tb_cr1
	where acct_match = 1
	group by 1
	order by calculated vol desc
	;
run;

*Review the time to re-default for cured loans;
data def_tb_cr2;
	set def_tb_cr1
	(where=(cure_date_dt ^= .) drop=acct_match);
	ttrd = intck('month', cure_date_dt, redef_date_dt);
run;
