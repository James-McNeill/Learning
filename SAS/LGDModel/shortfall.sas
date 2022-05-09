/* Reviewing potential shortfalls */

*https://www.thebalance.com/loan-payment-calculations-315564;

/* 
Loan Payment = Amount / Discount Factor
I = int rate / 12
Discount Factor = (1+(i)^n)-1/(i*(1+i)^n)
TotalRepayAmount: the amount a customer could repay with current actual repay amount
  TotalRepayAmount = ActPayment * Discount Factor
WriteOff = current_balance - TotalRepayAmount
*/

data _work1;
	set db.monthly_stacked
	(
	where=(REMAINING_TERM > 0)
	keep=account_no 
		DRAWDOWN_AMT
		current_balance
		REMAINING_TERM
		repay_amt
		INTEREST_RATE
		expected_payment
	);
	int_rate_mth = INTEREST_RATE / 1200;
	term_mth = int(remaining_term * 12);
	dist_fact = (((1 + int_rate_mth) ** term_mth) - 1) / (int_rate_mth * (1 + int_rate_mth) ** term_mth);
	loan_pay = int(current_balance / dist_fact); *Expected monthly payment that should be made;
	loan_pay_comp_exp = (loan_pay / expected_payment) - 1;
	loan_pay_comp_act = (loan_pay / repay_amt) - 1;
run;
