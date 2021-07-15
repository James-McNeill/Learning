/* Provisions PH2 table review - */

data ph2;
	set uulster.perm_provisions_ph2_2016_07 - uulster.perm_provisions_ph2_2016_12
		uulster.perm_provisions_ph2_2017_01 - uulster.perm_provisions_ph2_2017_04;
	keep account_no brand system yyyymm current_balance drv_indexed_val_amt;
run;

proc sort data=ph2; by account_no yyyymm; run;

proc transpose data=ph2 out=ph2_trans (drop=_name_ _label_) prefix=val_; 
	by account_no;
	var drv_indexed_val_amt;
	id yyyymm;
run;

data ph2_trans_1;
	set ph2_trans;
	array val_move {10} val_:;
		do i = 1 to 9;
			val_move{i} = val_move{i+1} / val_move{i}; *Movement in valuations;
		end;
	drop i val_201704;
run;

/* Summary of results */
PROC TABULATE DATA=WORK.PH2_TRANS_1	;
	VAR val_201607 val_201608 val_201609 val_201610 val_201611 val_201612 val_201701 val_201702 val_201703;
	TABLE /* Row Dimension */
			val_201607 
			val_201608 
			val_201609 
			val_201610 
			val_201611 
			val_201612 
			val_201701 
			val_201702 
			val_201703,
			/* Column Dimension */
			Max 
			Mean 
			Median 
			Min 
			N 
			NMiss 		;
	;
RUN;