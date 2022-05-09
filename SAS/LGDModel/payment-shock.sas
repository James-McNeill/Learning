/* Payment shock analysis 
Reviewing the potential to be ahead / behind of schedule
*/

/* Data required for analysis 
 latest drawdown amount
 current balance
 original term by months
 remaining term by years (need to convert)
 interest rate
 payment expected
 payment received
*/

/* Exclude accounts which have none of the key variable populated appropriately */
data mthly_data;
	set db.stacked_reporting_table
	(where=(expected_payment <> 0 and remaining_term > 0 and INTEREST_RATE > 0)
	
  keep=account_no drawdown_amt current_balance TERM_OF_LOAN
	REMAINING_TERM INTEREST_RATE expected_payment repay_amt);

	term_remain_mth = round(REMAINING_TERM * 12);
	int_rate_mth = (1 + (INTEREST_RATE/100))**(1/12) - 1; *conversion;
	period_of_pay = TERM_OF_LOAN - term_remain_mth;

	/* Total Payment */
	orig_payment = finance('PMT', int_rate_mth, TERM_OF_LOAN, -drawdown_amt);
	curr_payment = finance('PMT', int_rate_mth, term_remain_mth, -current_balance);

	/* Principal component */
	orig_principal = finance('PPMT', int_rate_mth, period_of_pay, TERM_OF_LOAN, -drawdown_amt);
	curr_principal = finance('PPMT', int_rate_mth, 1, term_remain_mth, -current_balance);

	/* Interest component */
	orig_interest = finance('IPMT', int_rate_mth, period_of_pay, TERM_OF_LOAN, -drawdown_amt);
	curr_interest = finance('IPMT', int_rate_mth, 1, term_remain_mth, -current_balance);

	/* Check payment variable - totals reconcile */
	/* orig_pay_check = sum(orig_principal, orig_interest);*/
	/* curr_pay_check = sum(curr_principal, curr_interest);*/

	/* Stepup payment - if positive (negative) then ahead (behind) in schedule*/
	orig_pay_shock = (expected_payment / orig_payment) - 1;
	curr_pay_shock = (expected_payment / curr_payment) - 1; 

run;

/* Review payment shocks were values are available */
proc sort data=mthly_data out=mthly_data_orig_ps; by descending orig_pay_shock; run;

proc univariate data=mthly_data (where=(orig_pay_shock <> .));
 var orig_pay_shock;
 hist orig_pay_shock;
run;

proc sort data=mthly_data out=mthly_data_curr_ps; by descending curr_pay_shock; run;

proc univariate data=mthly_data (where=(curr_pay_shock <> .));
 var curr_pay_shock;
 hist curr_pay_shock;
run;

/* Rank the output into deciles of payment shock */
proc rank data=mthly_data_curr_ps out=mthly_data_curr_ps_rank groups=10 ties=high;
 var curr_pay_shock;
 ranks curr_pay_shock_rk;
run; 
