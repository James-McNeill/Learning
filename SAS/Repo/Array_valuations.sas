/* Input data */
data data_in;
	set data;
	keep acct_id yyyymm balance;
run;

/* Sort the dataset */
proc sort data=data_in; by account_no year_month; run;

/* Transform the dataset */
proc transpose data=data_in out=data_in_trans (drop=_name_ _label_) prefix=bal_; 
	by acct_id;
	var balance;
	id yyyymm;
run;

/* Create the array of balances */
data data_in_trans_1;
	set data_in_trans;
	array bal_move {10} bal_:;
		do i = 1 to 9;
			bal_move{i} = bal_move{i+1} / bal_move{i}; *Movement in balances;
		end;
	drop i;
run;

/* Summary of results */
PROC TABULATE DATA=WORK.data_in_trans_1;
	VAR bal_201607 bal_201608 bal_201609 bal_201610 bal_201611 bal_201612 bal_201701 bal_201702 bal_201703;
	TABLE /* Row Dimension */
			bal_201607 
			bal_201608 
			bal_201609 
			bal_201610 
			bal_201611 
			bal_201612 
			bal_201701 
			bal_201702 
			bal_201703,
			/* Column Dimension */
			Max 
			Mean 
			Median 
			Min 
			N 
			NMiss 		;
	;
RUN;
