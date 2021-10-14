/* Transforming Data with SAS functions */

*In-built functions that provide programming shortcuts for many calculations and manipulations of data;

*Dataset to be used;
data sample;
	set input_data (obs=100);
run;

*Example of a SAS function;
data sample_a;
	set sample
	(keep=account brand current_balance drawdown_amt);
	Avg_amt_1 = mean(current_balance, drawdown_amt);
run;

*Character to Numeric conversion - INPUT function, requires the informat that the variable is being changed to;
data sample_b;
	set sample
	(keep=account app_seq);
	app_seq_num = input(app_seq, 2.);
run;

*Numeric to Character conversion - PUT function, requires the format that the variable is currently in;
data sample_c;
	set sample
	(keep=account branch_no);
	acct_char = put(account, 6.);
	branch_char = put(branch_no, 6.);

	acct_branch = account||branch_no;
	acct_branch_1 = put(account, 6.)||put(branch_no, 6.);
	acct_branch_2 = cats(account, branch_no);
run;

*Manipulating SAS date values with functions;

*SAS stores a date value as the number of days from 01/01/1960;
*A SAS time value is stored as the number of seconds since midnight;
*A SAS datetime value is stored as the number of seconds since midnight on 01/01/1960;

data sample_dates;
	set sample
	(keep=account incep_dt drawdown_dt maturity_dt);

	incep_draw = incep_dt - drawdown_dt;

	*Typical SAS date functions;
	date = mdy(month(incep_dt), 1, year(incep_dt));
	now = today();
	now1 = date();
	curtime = time();
	day = day(incep_dt);
	weekday = weekday(incep_dt);	*1 = Sunday, 7 = Saturday;
	month = month(incep_dt);
	yr = year(incep_dt);

	*INTCK function - date difference;
	k1 = intck("day", incep_dt, maturity_dt);
	k2 = intck("week", incep_dt, maturity_dt);
	k3 = intck("month", incep_dt, maturity_dt);
	k4 = intck("qtr", incep_dt, maturity_dt);
	k5 = intck("year", incep_dt, maturity_dt);

	*INTNX function - date addition;
	x1 = intnx("day", incep_dt, 1);
	x2 = intnx("week", incep_dt, 1);
	x3 = intnx("month", incep_dt, 1);
	x4 = intnx("qtr", incep_dt, 1);
	x5 = intnx("year", incep_dt, 1);

/*	format x1 - x5 date9.;*/

	*Additional functions;
	*DATDIF - days between two dates;
	d1 = datdif(incep_dt, maturity_dt, "act/act");
	d2 = datdif(incep_dt, maturity_dt, "30/360");
	d3 = datdif(incep_dt, maturity_dt, "act/360");
	d4 = datdif(incep_dt, maturity_dt, "ACT/365");
	*YRDIF - years between two dates;
	y1 = yrdif(incep_dt, maturity_dt, "act/act");
	y2 = yrdif(incep_dt, maturity_dt, "30/360");
	y3 = yrdif(incep_dt, maturity_dt, "ACT/360");
	y4 = yrdif(incep_dt, maturity_dt, "act/365");

run;

data sample_dates_checking;
	set sample
	(keep=account incep_dt drawdown_dt drv_maturity_dt);

	*Keying incorrect dates - warnings will be displayed in log but code will still execute;
	date = mdy(15, 1, 2019);

run;

*Modifying character values with functions;
data sample_charact;
	set sample
	(keep=account);
/*	(keep=account _character_); *display all remaining character variables;*/
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
data sample_numeric;
	set sample
	(keep=account current_balance);

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
data sample_nest;
	set sample
	(keep=account system drawdown_dt current_balance);

	name = "hello, world";

	second_name_initial = substr(scan(name, 2), 1, 1);
	years_open = intck("year", drawdown_dt, today());

run;
