/* Transforming Data with SAS functions */

*In-built functions that provide programming shortcuts for many calculations and manipulations of data;

*Dataset to be used;
data act_trans;
	set actmgt (obs=100);
run;

*Example of a SAS function;
data act_a;
	set act_trans
	(keep=account_no brand system tot_arr_bal_amt drawdown_amt);
	Avg_amt_1 = mean(tot_arr_bal_amt, drawdown_amt);
run;

*Character to Numeric conversion - INPUT function, requires the informat that the variable is being changed to;
data act_b;
	set act_trans
	(keep=account_no app_seq);
	app_seq_num = input(app_seq, 2.);
run;

*Numeric to Character conversion - PUT function, requires the format that the variable is currently in;
data act_c;
	set act_trans
	(keep=account_no branch_no);
	acct_char = put(account_no, 6.);
	branch_char = put(branch_no, 6.);

	acct_branch = account_no||branch_no;
	acct_branch_1 = put(account_no, 6.)||put(branch_no, 6.);
	acct_branch_2 = cats(account_no, branch_no);
run;

*Manipulating SAS date values with functions;

*SAS stores a date value as the number of days from 01/01/1960;
*A SAS time value is stored as the number of seconds since midnight;
*A SAS datetime value is stored as the number of seconds since midnight on 01/01/1960;

data act_dates;
	set act_trans
	(keep=account_no acc_incep_dt drawdown_dt rbs_applic_date schdd_term_dt drv_maturity_dt);

	incep_draw = acc_incep_dt - drawdown_dt;
	incep_rbs = acc_incep_dt - rbs_applic_date;

	*Typical SAS date functions;
	date = mdy(month(acc_incep_dt), 1, year(acc_incep_dt));
	now = today();
	now1 = date();
	curtime = time();
	day = day(acc_incep_dt);
	weekday = weekday(acc_incep_dt);	*1 = Sunday, 7 = Saturday;
	month = month(acc_incep_dt);
	yr = year(acc_incep_dt);

	*INTCK function;
	k1 = intck("day", acc_incep_dt, rbs_applic_date);
	k2 = intck("week", acc_incep_dt, rbs_applic_date);
	k3 = intck("month", acc_incep_dt, rbs_applic_date);
	k4 = intck("qtr", acc_incep_dt, rbs_applic_date);
	k5 = intck("year", acc_incep_dt, rbs_applic_date);

	*INTNX function;
	x1 = intnx("day", acc_incep_dt, 1);
	x2 = intnx("week", acc_incep_dt, 1);
	x3 = intnx("month", acc_incep_dt, 1);
	x4 = intnx("qtr", acc_incep_dt, 1);
	x5 = intnx("year", acc_incep_dt, 1);

/*	format x1 - x5 date9.;*/

	*Additional functions;
	*DATDIF - days between two dates;
	d1 = datdif(acc_incep_dt, rbs_applic_date, "act/act");
	d2 = datdif(acc_incep_dt, rbs_applic_date, "30/360");
	d3 = datdif(acc_incep_dt, rbs_applic_date, "act/360");
	d4 = datdif(acc_incep_dt, rbs_applic_date, "ACT/365");
	*YRDIF - years between two dates;
	y1 = yrdif(acc_incep_dt, rbs_applic_date, "act/act");
	y2 = yrdif(acc_incep_dt, rbs_applic_date, "30/360");
	y3 = yrdif(acc_incep_dt, rbs_applic_date, "ACT/360");
	y4 = yrdif(acc_incep_dt, rbs_applic_date, "act/365");

run;

data act_dates_checking;
	set act_trans
	(keep=account_no acc_incep_dt drawdown_dt rbs_applic_date schdd_term_dt drv_maturity_dt);

	*Keying incorrect dates - warnings will be displayed in log but code will still execute;
	date = mdy(15, 1, 2019);

run;

*Modifying character values with functions;
data act_charact;
	set act_trans
	(keep=account_no );
/*	(keep=account_no _character_);*/
	name = "hello, world";
	name1 = "bloggs, john doe";
	name2 = "bloggs, john    ";

	*SCAN function;
	scan_name_1 = scan(name, 1);	*Default of blank and comman for delimiter option;
	scan_name_2 = scan(name, 2);

	scan_name1_1 = scan(name1, 1);
	scan_name1_2 = scan(name1, 2);
	scan_name1_3 = scan(name1, 3);

	*SUBSTR function;
	sub_name1_1 = substr(name1, 1, 6);
	sub_name1_2 = substr(name1, 9, 4);
	sub_name1_3 = substr(name1, 14);

	*Replacing a value in a variable using SUBSTR function;
/*	substr(name1, 9, 4) = "george";*/
/*	substr(name1, 9) = "george";*/
/*	if substr(name1, 9, 4) = "john" then substr(name1, 9) = "george";*/

	*TRIM function;
	trim_name2 = trim(name2);

	*CATX function;
	cat_name = catx(",", scan_name1_1, scan_name1_2, scan_name1_3);
	cat_name1 = catx("_", scan_name1_1, scan_name1_2, scan_name1_3);
	cat_name2 = catx("-", scan_name1_1, scan_name1_2, scan_name1_3);

	*INDEX function;
	ind_name = index(name, "llo");
	ind_name1 = index(name, "llo") >0;
	ind_name2 = index(name, "LLO") >0;

	*Adjust the input strings to UPPER or lower case in order to avoid missing different versions of a string;
	ind_name_str = index(upcase(name), "LLO");
	ind_name_str1 = index(lowcase(name), "llo");

	*FIND function;
	find_name = find(name, "llo");
	find_name1 = find(name, "LLO");

	*CASE functions;
	upper_name = upcase(name);
	lower_name = lowcase(name);
	proper_name = propcase(name);

	*TRANWRD function;
	tranwrd_name = tranwrd(name, "l", "K");

run;

*Modifying numeric values with functions;
data act_numeric;
	set act_trans
	(keep=account_no tot_curr_bal_amt
	rename=(tot_curr_bal_amt = current_balance));

	*INT function - remove values after decimal place;
	int_bal = int(current_balance);

	*ROUND function;
	rnd_bal = round(current_balance);
	rnd_bal_05 = round(current_balance, .5);
	rnd_bal_001 = round(current_balance, .01);
	rnd_bal_1 = round(current_balance, 1);
	rnd_bal_10 = round(current_balance, 10);
	rnd_bal_100 = round(current_balance, 100);

run;

*Nesting SAS functions;
data act_nest;
	set act_trans
	(keep=account_no system drawdown_dt tot_curr_bal_amt);

	name = "hello, world";

	second_name_initial = substr(scan(name, 2), 1, 1);
	years_open = intck("year", drawdown_dt, today());

run;
