/* Repayment Schedule methods */

/* 
Seeks to review the options available when assessing the repayment schedule of a loan.
*/

/*Bring in a recent version of the account management table*/
data act_all;
 set udm1.perm_ubdm_actmgt_mortlvl_2017_12
 (where=(/*system = 'GMS' and*/ drv_remaining_term > 0 and FINANCE_INTEREST_RATE > 0
   /*and acc_incep_dt >= "01jun2017"d*/)
 keep=account_no brand system month drawdown_amt 
 tot_curr_bal_amt drv_CURR_TERM_OF_LOAN
 drv_REMAINING_TERM FINANCE_INTEREST_RATE
 drv_expected_payment drv_repay_amt
 drv_payments_missed tot_arr_bal_amt
 drawdown_dt acc_incep_dt);
run;


proc sort data=act_all out=act_all_1; by account_no; run;

/*Review the repayment schedule*/
data act_all_1;
 set act_all_1;
 by account_no;

 *Variables for schedule;
 term_remain_mth = round(drv_REMAINING_TERM * 12);
/* int_rate_mth = (1 + (FINANCE_INTEREST_RATE/100))**(1/12) - 1;*/
 int_rate_mth = (finance_interest_rate / 100) / 12;
 payment = finance("PMT", int_rate_mth, term_remain_mth, -tot_curr_bal_amt);

 *Project the schedule for review;
 do i = 1 to term_remain_mth;
  mth = i;
   mth_pay = payment;
  output;
 end;
 
run;

proc sort data=act_all_1 out=act_all_2; by account_no mth; run;

/*Roll up all of the payments made over the future term*/
data act_all_2;
 set act_all_2;
 by account_no;

 retain pay_made;

 mth_pay_disc = mth_pay * (1+int_rate_mth) ** - mth;

 if first.account_no then pay_made = mth_pay_disc;
 else pay_made = sum(pay_made, mth_pay_disc);

 if last.account_no then output;

run;

/*Retain the final record for review*/
data act_all_3;
 set act_all_2;
 by account_no;

 *Review the shortfall;
 shortfall = tot_curr_bal_amt - pay_made;
 lgd = shortfall / tot_curr_bal_amt;

run;

/*Review the cumulative interest and principal functions*/
data act_all_3_acct;
 set act_all_1 (where=(account_no = 52012784));

 cum_int = abs(finance("CUMIPMT", int_rate_mth, term_remain_mth, tot_curr_bal_amt, 1, mth, 0));
 cum_princ = finance("CUMPRINC", int_rate_mth, term_remain_mth, -tot_curr_bal_amt, 1, mth, 0);
run;
