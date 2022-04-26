/* Ranking balances across the portfolio
Perform a review of the current balance for the active portfolio by deciles. 
The analysis could be adjusted to factor in any other form of ranking the current balance.
Also showed the default rate by decile as well. Larger balances have a higher propensity to be in default, could highlight the strategic defaulters
*/

/*Convert the code from a one month assessment to review a longer time period*/

*Input data;
data act_ytd;
  set db.actmgt;
run;

data gs_ytd;
	set db.default_table;
run;

*Display the maximum reporting month;
proc sql noprint;
	select max(month) format date9. into: max_mth
	from work.gs_ytd;
run;

%put max gs month: &max_mth.;

*Add the default flag to the file;
proc sql;
	create table actmgt_gs_ytd as
	select t1.account_no, t1.brand, t1.system, t1.tot_curr_bal_amt, t1.month,
	t2.default_flag
	from act_ytd t1
	left join gs_ytd t2
	  on t1.account_no = t2.account_no and t1.month = t2.month
	;
run;


%let groups = 10;    *Group structure to review, 10 = decile;
%let start_mth = &max_mth.;  *Initial month to assess;
%let end_mth = &max_mth.;  *End month to assess;
/*%let start_mth = 01may2019;  *Initial month to assess;*/
/*%let end_mth = 01may2019;  *End month to assess;*/

%macro group_banding(input_data=, output_data=, input_variable=, no_groups=);

/* Create the decile ranked range on the first month */
proc rank data=&input_data. groups=&no_groups. out=hist_groups;
 var &input_variable.;
 ranks score_group;
run;

/* Calculate the minimum and maximum values per rank */
proc summary data=hist_groups nway;
 class score_group;
 var &input_variable.;
 output out=hist_groups_min_max (drop=_:) min= max= / autoname;
run;

/* create dataset with formatted values */
data group_rank_fmt;
 set hist_groups_min_max (rename=(score_group=start));
 retain fmtname 'dec_fmt' type 'N';
 label=catx('-', &input_variable._min, &input_variable._max);
run;

/* Store the max values */
proc sql noprint;
 select &input_variable._max into: band1-:band&no_groups.
 from group_rank_fmt;
run;

/* apply the format to the historic table for all months */
data &output_data.;
 set &input_data.;
 length group_band 8.;
 
 *Apply the bandings - NOTE need to make this more dynamic;
 if &input_variable. <=&band1 then group_band = 1;
 %do i = 2 %to &no_groups.;
  else if &input_variable. <=&&band&i then group_band = &i;
 %end;
 else group_band = &no_groups.;

run;

%mend;


%macro do_loop(start=, end=);
 /*converts the dates to SAS dates*/
     %let start=%sysfunc(inputn(&start.,anydtdte9.));
     %let end=%sysfunc(inputn(&end.,anydtdte9.));
     /*determines the number of months between the two dates*/
     %let dif=%sysfunc(intck(month,&start.,&end.));

 proc datasets lib=work nodetails;
  delete historic_table;
 run;

     %do i=0 %to &dif.;
     /*advances the date i months from the start date and applys the DATE9. format*/
           %let date=%sysfunc(putn(%sysfunc(intnx(month,&start.,&i.,b)),date9.));
           %let yyyymm=%sysfunc(putn(%sysfunc(intnx(month,&start.,&i.,b)),yymmn6.));
     %let date_adj=%sysfunc(putn(%sysfunc(intnx(month,&start.,&i.,b)),yymmd7.));
     %let yyyy_mm=%sysfunc(tranwrd(&date_adj.,-,_));

     %put &date. &i. &start. &yyyymm. &date_adj. &yyyy_mm. &dif.;

  /*Dataset for running the analysis in the above macro*/
  data act_gs_&yyyy_mm.;
   set actmgt_gs_ytd (where=(month="&date."d));
  run;

  %group_banding(input_data=act_gs_&yyyy_mm., output_data=act_gs_&yyyy_mm._1, input_variable=tot_curr_bal_amt, no_groups=&groups.);

  /*CREATE AN HISTORIC TABLE*/
     /*LIVE COMBINED HISTORY*/
     PROC APPEND BASE=HISTORIC_TABLE DATA=act_gs_&yyyy_mm._1 FORCE;
     QUIT;

     %end;

%mend;

%do_loop(start=&start_mth., end=&end_mth.);

/* Summary outputs */
*Overall current balance by ranked bands;
PROC TABULATE DATA=WORK.HISTORIC_TABLE;
 VAR current_balance;
 CLASS group_band / ORDER=UNFORMATTED MISSING;
 TABLE /* Row Dimension */
  group_band,
  /* Column Dimension */
  N 
  current_balance*(
    Max 
    Mean 
    Median 
    Min 
    P5 
    P95)   ;
 ;
RUN;

*Volume of rank balance by brand and system;
PROC TABULATE DATA=WORK.HISTORIC_TABLE;
 CLASS group_band / ORDER=UNFORMATTED MISSING;
 CLASS Brand / ORDER=UNFORMATTED MISSING;
 CLASS system / ORDER=UNFORMATTED MISSING;
 TABLE /* Row Dimension */
  group_band,
  /* Column Dimension */
  N 
  Brand*
    system*
      N   ;
 ;
RUN;

*Rank balance by default flag;
PROC TABULATE DATA=WORK.HISTORIC_TABLE;
 CLASS group_band / ORDER=UNFORMATTED MISSING;
 CLASS default_flag / ORDER=UNFORMATTED MISSING;
 TABLE /* Row Dimension */
  group_band,
  /* Column Dimension */
  N 
  default_flag*
    N   ;
 ;
RUN;
