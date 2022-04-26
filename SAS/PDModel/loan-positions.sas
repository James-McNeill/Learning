/* Loan positions - MoM
Review the current positions of loans between; stock, opened and closed
*/

*Bring in the monthly default table;
data gs;
 set db.default_table;
run;

*Review: 1) Stock, 2) Opened, 3) Closed, movements over time;
proc sort data=gs; by account_no month; run;

*Store the latest month from the default table;
proc sql noprint;
 select max(month) format date9. into: max_mth
 from gs;
run;

%put &max_mth.;

*Create the position for each loan;
data gs;
 set gs;
 by account_no;

 lag_acct = lag(account_no);

 *Pos variable is to show what bucket loans are in;
 if first.account_no then pos = 2; *Opened - this will result in elevated levels for the first instance when reporting begins and any migrations occur;
 if lag_acct = account_no then pos = 1; *Stock;
 if last.account_no and lag_acct = account_no and month < "&max_mth."d then pos = 3; *Closed position;

run;

*Summary output;
PROC TABULATE DATA=WORK.GS;
 VAR current_balance;
 CLASS month / ORDER=UNFORMATTED MISSING;
 CLASS pos / ORDER=UNFORMATTED MISSING;
 TABLE /* Row Dimension */
  month,
  /* Column Dimension */
  pos*
    current_balance*(
      N 
      Sum)   ;
 ;
RUN;

*Summary output closures by default flag;
PROC TABULATE DATA=WORK.GS;
 WHERE( pos = 3);
 VAR current_balance;
 CLASS month / ORDER=UNFORMATTED MISSING;
 CLASS default_flag / ORDER=UNFORMATTED MISSING;
 CLASS pos / ORDER=UNFORMATTED MISSING;
 TABLE /* Row Dimension */
  month,
  /* Column Dimension */
  N 
  default_flag*
    pos*
      current_balance*(
        N 
        Sum)   ;
 ;

RUN;
