*Review the potential shortfall for a customer based on the current actual repayments they are making

Loan Payment = Amount / Discount Factor
I = int rate / 12
n = remaining term (based off reporting date and maturity date)
Discount Factor = ((1+i)^n)-1)/(i*(1+i)^n)

Can re-arrange the formula and use current actual payments to see if any shortfall to current outstanding balance will exist
based on the current term to maturity.;

*Bring in the loan level information
repay_amt - actual payment, need to take the drv_trs_amount off from this
trs_amount - mortgage tax relief has been extended by the government and won't finish until January 2021
; 
data shortfall_test;
	set act
	(where=(month = "01dec2018"d)
	keep=account_no
		month
		drawdown_dt
		drawdown_amt
		current_balance
		repay_amt
		TRS_AMOUNT
		INTEREST_RATE
		MATURITY_DT
		REMAINING_TERM
	);

	term_mths = REMAINING_TERM * 12;
	int_rate_mth = (INTEREST_RATE / 100) / 12;

	disc_fact = (((1 + int_rate_mth) ** term_mths) - 1) / (int_rate_mth * (1 + int_rate_mth) ** term_mths);

	repay_excl_trs = repay_amt - trs_amount;
	amount_act = repay_amt * disc_fact;
	amount_trs = trs_amt * disc_fact;
	amount_act_excl_trs = repay_excl_trs * disc_fact;

	*Shortfall review;
	curr_short_act = current_balance - amount_act;
	curr_short_act_etrs = current_balance - amount_act_excl_trs;
	short_bal_pt = curr_short_act / current_balance;

run;

/* Perform a review of the shortfall outputs */
proc univariate data=shortfall_test;
	var curr_short_act short_bal_pt;
	hist curr_short_act short_bal_pt;
	qqplot curr_short_act short_bal_pt;
run;
