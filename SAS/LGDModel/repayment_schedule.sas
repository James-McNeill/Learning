/* Repayment Schedule methods */

/* 
Seeks to review the options available when assessing the repayment schedule of a loan.
*/

/*Bring in a recent version of the monthly reporting table
VARIABLES: required to create the loan schedule
 LOAN_ID, CURRENT_BALANCE, TERM, INTEREST_RATE, EXISTING_PAYMENT
*/
data act_all;
 set DATABASE.MONTHLY_REPORTING_TABLE
 (where=(remaining_term > 0 and INTEREST_RATE > 0)
 keep=VARIABLES);
run;

proc sort data=act_all out=act_all_1; by account_no; run;

/*Review the repayment schedule*/
data act_all_1;
 set act_all_1;
 by account_no;

 *Variables for schedule. Term was in a yearly format;
 term_remain_mth = round(REMAINING_TERM * 12);
/* int_rate_mth = (1 + (INTEREST_RATE/100))**(1/12) - 1;*/
 int_rate_mth = (interest_rate / 100) / 12;
 payment = finance("PMT", int_rate_mth, term_remain_mth, -current_balance);

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
 shortfall = current_balance - pay_made;
 lgd = shortfall / current_balance;

run;

/*Review the cumulative interest and principal functions*/
data act_all_3_acct;
 set act_all_1 (where=(account_no = SAMPLE_LOAN_ID));

 cum_int = abs(finance("CUMIPMT", int_rate_mth, term_remain_mth, current_balance, 1, mth, 0));
 cum_princ = finance("CUMPRINC", int_rate_mth, term_remain_mth, -current_balance, 1, mth, 0);
run;
