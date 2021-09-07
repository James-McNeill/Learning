*TITLE: Observed Default Rate (ODR) code;

*Step 1a: Bring in the default dataset;
data default_table;
	retain account_no month default_flag;	*Re-order the list of variables displayed in the output;
	set default_data
	(keep=account_no month default_flag);
run;

*Step 1b: Extract the latest quarter date that is available within the default table;
proc sql noprint;
	select 	intnx("month", intnx("qtr", max(month), 0, "B"), 0) format date9. 
	into	:max_qtr
	from default_table;
quit;

*Display the maximum quarter end date;
%put max ODR qtr = &max_qtr.;

*Step 1c: Only need to add on the information for months that loans are in default;
data default_table_def;
	set default_table (where=(default_flag = 1));
run;

*Step 2: Merge the default flags from the forward looking months. Ensures that the next 12 reporting months of data 
	are reviewed.;
proc sql;
	create table default_table_1 as
	select t0.*
		,t1.default_flag as def_1
		,t2.default_flag as def_2
		,t3.default_flag as def_3
		,t4.default_flag as def_4
		,t5.default_flag as def_5
		,t6.default_flag as def_6
		,t7.default_flag as def_7
		,t8.default_flag as def_8
		,t9.default_flag as def_9
		,t10.default_flag as def_10
		,t11.default_flag as def_11
		,t12.default_flag as def_12
	from default_table t0
		left join default_table_def t1 on t0.account_no = t1.account_no and t0.month = intnx("month", t1.month, -1)
		left join default_table_def t2 on t0.account_no = t2.account_no and t0.month = intnx("month", t2.month, -2)
		left join default_table_def t3 on t0.account_no = t3.account_no and t0.month = intnx("month", t3.month, -3)
		left join default_table_def t4 on t0.account_no = t4.account_no and t0.month = intnx("month", t4.month, -4)
		left join default_table_def t5 on t0.account_no = t5.account_no and t0.month = intnx("month", t5.month, -5)
		left join default_table_def t6 on t0.account_no = t6.account_no and t0.month = intnx("month", t6.month, -6)
		left join default_table_def t7 on t0.account_no = t7.account_no and t0.month = intnx("month", t7.month, -7)
		left join default_table_def t8 on t0.account_no = t8.account_no and t0.month = intnx("month", t8.month, -8)
		left join default_table_def t9 on t0.account_no = t9.account_no and t0.month = intnx("month", t9.month, -9)
		left join default_table_def t10 on t0.account_no = t10.account_no and t0.month = intnx("month", t10.month, -10)
		left join default_table_def t11 on t0.account_no = t11.account_no and t0.month = intnx("month", t11.month, -11)
		left join default_table_def t12 on t0.account_no = t12.account_no and t0.month = intnx("month", t12.month, -12)
	;
run;

*Step 3: Create the default in the next 12 months variable;
data default_table_1;
	set default_table_1;

	def_n12m = 0;	*Default value for the default in the next 12 months variable;
	
	*Create array for the defaults;
	array defaults def_:;

	do over defaults;
		if defaults = . then defaults = 0;			*Update the missing values to zero;
		if sum(defaults) > 0 then def_n12m = 1;		*Create default in the next 12 months binary flag;
	end;
run;

*Step 4a: Create the total number of performing and default in next 12 month variables. Additional segmentation if required;

proc sql;
	create table ODR as
	select month
		,sum(CASE WHEN default_flag = 0 THEN 1 ELSE 0 END) as Perf
		,sum(CASE WHEN default_flag = 0 and def_n12m > 0 THEN 1 ELSE 0 END) as New_Def
	from default_table_1
	group by month;
quit;

*Step 4b: Generate the ODR output;
data ODR_1;
	set ODR;
	by month ;
	ODR_Vol = New_Def / Perf;
run;

*Step 5: For the backward looking element of the forecasting model add 12 months to the current month.
Retain ODR values were 12 months of data is available since the review date;
data ODR_QTR;
	retain month_1;
	set ODR_1
	(where=(month < intnx("month", "&max_qtr."d, -12)));
	format month_1 qtr_end date9.;
	month_1 = intnx("month", month, 12);
	qtr_end = intnx("month", intnx("qtr", month_1, 0, "E"), 0);
	qtr_keep = qtr_end = month_1;

	*Keep only the quarter end values;
	if qtr_keep = 1;

	drop month qtr_end qtr_keep; 
run;
