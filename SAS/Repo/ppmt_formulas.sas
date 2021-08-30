/* Aiming to review the capital + interest payment, capital payment and interest payment of a loan schedule */
DATA TEST;
  SET INPUT;
  
  term_remain_mth = round(term_remaining * 12);
	int_rate_mth = (1 + (daily_interest_rate/100))**(1/12) - 1;
	period_of_pay = orig_term - term_remain_mth;
  
  /* Total Payment */
	orig_payment = finance('PMT', int_rate_mth, orig_term, -drawdown_amt);
	curr_payment = finance('PMT', int_rate_mth, term_remain_mth, -tot_curr_bal_amt);

	/* Principal component */
	orig_principal = finance('PPMT', int_rate_mth, period_of_pay, orig_term, -drawdown_amt);
	curr_principal = finance('PPMT', int_rate_mth, 1, term_remain_mth, -current_balance);

	/* Interest component */
	orig_interest = finance('IPMT', int_rate_mth, period_of_pay, orig_term, -drawdown_amt);
	curr_interest = finance('IPMT', int_rate_mth, 1, term_remain_mth, -current_balance);

	/* Stepup payment - if positive (negative) then ahead of (behind) schedule*/
	orig_pay_shock = (expected_payment / orig_payment) - 1;
	curr_pay_shock = (expected_payment / curr_payment) - 1;	
RUN;
