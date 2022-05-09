/* Lifetime close balance */

/* 
Review of the relationship between closing balance and closure date. Aim is to understand if loans on-board and close very quickly
during periods of mass switching within the market.
*/

*Default table;
data gs;
 set db.default_table;
run;

*Monthly reporting table stacked;
data actmgt;
 set db.reporting_data_stacked;
run;

/*
Do we see accounts coming on to the book during the monthly reporting window,
make all the payments required off them and then prepay or finish the 
term that was outlined for them. Want to see are there any short term
mortgages that turn around quickly enough.
*/

/*Accounts opened and closed after 2006*/
proc sql;
 create table actmgt_gs as
 select t1.*
  ,t2.default_flag
 from actmgt t1
 left join gs t2
  on t1.account_no = t2.account_no and t1.month = t2.month;
run;

/*Understand the first and last reporting dates*/
proc sql noprint;
 select max(month) format date9. into: max_rep_mth
 from actmgt_gs
 ;
run;

%put &max_rep_mth.;

proc sql;
 create table act_dates as
 select distinct account_no, brand, system,
  min(month) as min_date format date9.,
  max(month) as max_date format date9.,
  "&max_rep_mth."d as max_rep_mth format date9.,
  intck("month", calculated max_date, calculated max_rep_mth) as max_date_diff
 from actmgt_gs
 group by 1
 ;
run;

proc sql;
 create table act_dates_1 as
 select t1.*, 
  t2.drawdown_amt,
  t2.drawdown_dt,
  t2.current_balance as init_curr_bal,
  t2.TERM_OF_LOAN as init_curr_term,
  t2.REMAINING_TERM as init_rem_term,
  t3.current_balance as max_curr_bal,
  t3.TERM_OF_LOAN as max_curr_term,
  t3.REMAINING_TERM as max_rem_term
 from act_dates t1
 left join actmgt_gs t2
  on t1.account_no = t2.account_no and t1.min_date = t2.month
 left join actmgt_gs t3
  on t1.account_no = t3.account_no and t1.max_date = t3.month
 ;
run;

data act_dates_1;
 set act_dates_1;
 max_bal_gt_init_bal = ifn(max_curr_bal > init_curr_bal, 1, 0);
 drawdown_yr = year(drawdown_dt);
 term_comp = round(init_rem_term*12, 1) - round(max_rem_term*12, 1);
run;

*Dataset that stores the list of closed mortgages;
data closed_mort;
 set db.closed_mort_stacked;
run;

/*Accounts that have completed there mortgage payments*/
data act_dates_2;
 set act_dates_1
 (where=(max_date_diff > 0));
 mths_on_rep = intck("month", min_date, max_date) + 1;
 prin_repay = init_curr_bal - max_curr_bal;
 mth_prin_pay = prin_repay / term_comp;
run;


/*Join the list of closed accounts to the actmgt_gs table*/
proc sql;
 create table actmgt_gs_cls as
 select t1.*, t2.max_date as closed_date, t2.min_date as init_rep_date
 from actmgt_gs t1
 inner join act_dates_2 t2
  on t1.account_no = t2.account_no
 ;
run;

/*
1) What happens to the final outstanding balance if there is one on the last
reporting month? Does this show the final shortfall if the account highlighted
a repay_amt which cleared a certain percentage of the balance remaining
but didn't manage to clear it all? Should the current balance not decrease to
zero?
2) Understanding how many customers maintained or paid more than expected
during their repayment schedule
*/
proc sort data=actmgt_gs_cls; by account_no month; run;

*Only reviewing the last reporting month;
data actmgt_gs_cls_1;
 set actmgt_gs_cls;
 by account_no;

 if last.account_no;
run;

*Create the variables for the output review;
data actmgt_gs_cls_1;
 set actmgt_gs_cls_1;
 drawdown_dt_01 = intnx("month", DRAWDOWN_DT, 0);
 format drawdown_dt_01 date9.;
 lifetime = intck("month", drawdown_dt_01, month);
run;

*Final output;
proc sql;
 create table actmgt_gs_cls_2 as
 select closed_date, brand, system,
  mean(lifetime) as avg_lifetime,
  mean(tot_curr_bal_amt) as avg_close_balance,
  count(*) as volume
 from actmgt_gs_cls_1
 group by closed_date, brand, system
 ;
run;
