/* Default table & account management*/
data gs;
 set db.default_table_monthly
 (keep=account_no month default_flag payments_missed arrears);
run;

/* Monthly account management table */
data actmgt;
 set db.actmgt_ytd
 (keep=account_no month drawdown_dt acc_incep_dt current_balance no_of_subaccts);
run;

/* Keep loans from start date onwards */
proc sql;
 create table actmgt_gs as
 select t1.account_no, t1.month, t1.drawdown_dt, t1.acc_incep_dt,
  t1.current_balance,
  t2.payments_missed, t2.default_flag,
  t2.arrears
 from actmgt t1
 left join gs t2
  on t1.account_no = t2.account_no and t1.month = t2.month
 where t1.acc_incep_dt > "31mar2014"d
 ;
run;

/* Derived variables */
data actmgt_gs;
 set actmgt_gs;
 draw_qtr = intnx("quarter", acc_incep_dt, 0);
 draw_mth = intnx("month", acc_incep_dt, 0);
 format draw_qtr date9. draw_mth date9.;
run;

/*Max reporting date*/
proc sql noprint;
 select max(month) format date9. into :max_month
 from actmgt_gs;
run;

%put &max_month;

/*Do accounts have multiple drawdown dates?
There are a small cohort of accounts which have multiple
drawdown dates when the account is being first drawn down.
Appears to be an issue with the start of the mortgage which
could represent the self-build population
*/
proc sql;
 create table actmgt_gs_draw as
 select distinct account_no, draw_mth, 
  min(month) format date9. as first_rep_mth,
  intck("month", draw_mth, calculated first_rep_mth) as draw_frep_diff,
  max(month) format date9. as last_rep_mth,
  "&max_month"d format date9. as max_month
 from actmgt_gs
 group by account_no, draw_mth
 ;
run;

proc sql;
 create table actmgt_gs_draw_1 as
 select distinct account_no, count(*) as vol
 from actmgt_gs_draw
 group by account_no
 ;
run;

/*Check the default flag for accounts during the first and final
reporting months*/
proc sql;
 create table draw_def_flag as
 select t1.*,  
  t2.default_flag as first_rep_def_flag,
  t3.default_flag as last_rep_def_flag
 from actmgt_gs_draw t1
 left join actmgt_gs t2
  on t1.account_no = t2.account_no and t1.first_rep_mth = t2.month
 left join actmgt_gs t3
  on t1.account_no = t3.account_no and t1.last_rep_mth = t3.month
 ;
run;

/*Check does the first reporting month move into a different quarter compared
with the drawdown date*/
data draw_def_flag;
 set draw_def_flag;
 first_rep_qtr = intnx("quarter", first_rep_mth, 0, "B");
 draw_qtr = intnx("quarter", draw_mth, 0, "B");
 format first_rep_qtr date9. draw_qtr date9.;
 
 date_check = ifn(draw_qtr = first_rep_qtr, 1, 0);

run;

/*Create the origination totals for each quarter end*/
proc sql;
 create table draw_totals_perf as
 select draw_qtr, count(*) as volume
 from draw_def_flag
 where first_rep_def_flag = 0
 group by draw_qtr
 ;
run;

/*Attach the reporting month information to each origination account*/
proc sql;
 create table draw_gs as
 select t1.*, t2.month, t2.default_flag as default_flag_mth
 from draw_def_flag t1
 left join actmgt_gs t2
  on t1.account_no = t2.account_no
 where t1.first_rep_def_flag = 0
 order by t1.account_no, t2.month
 ;
run;

/*Add the additional flags for the default and closed totals*/
data draw_gs;
 set draw_gs;
 by account_no;

 retain default_acct;

 lag_acct = lag(account_no);
 lag_def = lag(default_flag_mth);

 *Closed flag - from last reporting month onwards;
 closed_acct = ifn(month >= last_rep_mth and last_rep_mth < max_month, 1, 0);
 closed_event = ifn(month = last_rep_mth and last_rep_mth < max_month, 1, 0);

 *Default flag - count due to accounts being able to cure;
 default_event = 0;
 if first.account_no then default_acct = 0; 
 if lag_acct = account_no and lag_def = 0 and default_flag_mth = 1 then 
  do; 
   default_acct + 1; default_event = 1;
  end;

run;

/*Review the running totals*/
proc sql;
 create table draw_gs_run_tot as
 select draw_qtr, month, 
  sum(closed_event) as closed_vol,
  sum(default_event) as default_vol
 from draw_gs t1
 group by draw_qtr, month
 ;
run;

/*Check the accounts which have ever had a default event*/
proc sql;
 create table def_draw_gs as
 select distinct account_no
 from draw_gs
 where default_flag_mth = 1
 ;
run;

proc sql;
 create table def_draw_gs_1 as
 select t1.*
 from draw_gs t1
 inner join def_draw_gs t2
  on t1.account_no = t2.account_no
 ;
run;

proc sql;
 create table def_events as
 select distinct account_no, sum(default_event) as num_def, 
  sum(default_flag_mth) as mths_in_def
 from draw_gs 
 group by account_no
 ;
run;

/*Create the final totals*/
/*Take the last record from the draw_gs table*/
proc sort data=draw_gs ; by account_no month; run;

data draw_total;
 set draw_gs;
 by account_no;
 if last.account_no;
run;

*Connect the draw total to the account management table to get the first months exposure;
proc sql;
 create table draw_total_gs as
 select t1.*, t2.current_balance
 from draw_total t1
 left join actmgt_gs t2
  on t1.account_no = t2.account_no and t1.draw_mth = t2.month
 ;
run;

proc sql;
 create table closed_def_totals as
 select draw_qtr, count(*) as open_vol, sum(closed_acct) as closed_vol,
  sum(default_acct) as default_vol, sum(current_balance) as open_exp
 from draw_total_gs
 group by draw_qtr
 ;
run;

/*Review the number of sub accounts connected to these new mortgages*/
proc sql;
 create table draw_total_1 as
 select t1.*,
  t2.no_of_subaccts as first_no_of_subs,
  t3.no_of_subaccts as last_no_of_subs
 from draw_total t1
 left join actmgt t2
  on t1.account_no = t2.account_no and t1.first_rep_mth = t2.month
 left join actmgt t3
  on t1.account_no = t3.account_no and t1.last_rep_mth = t3.month
 ;
run;
