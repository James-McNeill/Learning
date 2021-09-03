/* Population Stability Index review - by deciles for the base month */

/* Input data */
hist_table_final: shows time series data for different features

/* Review the first month from historic table to hold the segment as the base format */
proc sql noprint;
	select min(month) format date9. into: min_date
	from hist_table_final;
run;

proc sql noprint;
	select max(month) format date9. into: max_date
	from hist_table_final;
run;

%put &min_date. &max_date.;

/* Input variables to run code */
%let base_scenario = &min_date.;		*01mar2008;
%let start_dt = &min_date.;				*01mar2008;
%let end_dt = &max_date.;				*01oct2017;
%let groups = 4;						*10 (decile), 4 (quartile);


%macro group_banding(review_date=, no_groups=);
/* Create the decile ranked range on the first month */
proc rank data=hist_table_final (where=(month="&review_date."d)) groups=&no_groups. out=hist_groups;
	var est_total_score;
	ranks score_group;
run;

/* Calculate the minimum and maximum values per rank */
proc summary data=hist_groups nway;
	class score_group;
	var est_total_score;
	output out=hist_groups_min_max (drop=_:) min= max= / autoname;
run;

/* create dataset with formatted values */
data group_rank_fmt;
	set hist_groups_min_max (rename=(score_group=start));
	retain fmtname 'dec_fmt' type 'N';
	label=catx('-',est_total_score_min,est_total_score_max);
run;

/* Store the max values */
proc sql noprint;
	select est_total_score_max into: band1-:band&no_groups.
	from group_rank_fmt;
run;

/*%put &band1. &band7. &band10.;*/

/* apply the format to the historic table for all months */
data historic_table_1;
	set hist_table_final;
	length group_band 8.;
	
	*Apply the bandings;
	if est_total_score <=&band1 then group_band = 1;
	%do i = 2 %to &no_groups.;
		else if est_total_score <=&&band&i then group_band = &i;
	%end;
	else group_band = &no_groups.;

run;

%mend;

%group_banding(review_date=&base_scenario., no_groups=&groups.);

/* Create totals for the PSI comparison */
proc sql;
	create table total as
	select month, count(*) as total_freq
	from historic_table_1
	group by 1
	;
run;

/* Create bands for the PSI comparison */
proc sql;
	create table bands as
	select month, group_band, count(*) as band_freq
	from historic_table_1
	group by 1, 2
	;
run;

/* PSI macro 
The following versions have been tested
1. Fix the base month
	a. Base variable can be an input to the macro
	b. Switch to quartiles instead of deciles
2. Loop through the base months and retain overall PSI summary
	a. Adjust the base variable and remove from the input element of the macro. 
	   Have a do end loop added in to review each potential base month
*/

/*%macro psi_loop(start=,end=,base=);*/
%macro psi_loop(start=,end=/*,base=*/);
     /*converts the dates to SAS dates*/
     %let start=%sysfunc(inputn(&start.,anydtdte9.));
     %let end=%sysfunc(inputn(&end.,anydtdte9.));
/*	 %let base=%sysfunc(inputn(&base.,anydtdte9.));*/
/*	 %let base=%sysfunc(putn(%sysfunc(intnx(month,&base.,0,b)),date9.));*/
     /*determines the number of months between the two dates*/
     %let dif=%sysfunc(intck(month,&start.,&end.));

	proc datasets lib=work nodetails;
		delete psi_summary;
	run;

	/*Loop for each of the base periods to review*/
	%do j=0 %to &dif.;
/*		 %let base=%sysfunc(inputn(&base.,anydtdte9.));*/
		 %let base=%sysfunc(putn(%sysfunc(intnx(month,&start.,&j.,b)),date9.));

     %do i=0 %to &dif.;
     /*advances the date i months from the start date and applys the DATE9. format*/
           %let comp=%sysfunc(putn(%sysfunc(intnx(month,&start.,&i.,b)),date9.));
           
		   %put &base. &i. &start. &comp.;

		/* Test comparing base (currently Mar08) and first month */
		proc sql;
			create table review as
			select "&base."d format date9. as base, "&comp."d format date9. as comp,
				t1.group_band, 
				t1.band_freq as base_freq,
				t2.band_freq as comp_freq
			from bands (where=(month = "&base."d)) t1
			left join bands (where=(month = "&comp."d)) t2
				on t1.group_band = t2.group_band
			;
		run;

		/* Attach the totals */
		proc sql;
			create table review_1 as
			select t1.*, t2.total_freq as base_total, t3.total_freq as comp_total
			from review t1
			left join total t2
				on t1.base = t2.month
			left join total t3
				on t1.comp = t3.month
			;
		run;

		/* Calculate the distributions */
		proc sql;
			create table review_2 as
			select t1.*, t1.base_freq / t1.base_total as base_pct,
				t1.comp_freq / t1.comp_total as comp_pct,
				calculated base_pct - calculated comp_pct as prop_change,
				calculated base_pct / calculated comp_pct as ratio,
				log(calculated ratio) as woe,
				calculated prop_change * calculated woe as psi
			from review_1 t1
			order by t1.group_band
			;
		run;

		/* Sum the total PSI */
		proc sql;
			create table review_3 as
			select base, comp, sum(psi) as psi
			from review_2
			group by 1, 2
			;
		run;

    
     /*CREATE AN HISTORIC TABLE*/
     /*LIVE COMBINED HISTORY*/
     PROC APPEND BASE=psi_summary_&base. DATA=review_3 FORCE;
     QUIT;
/*	 PROC APPEND BASE=psi_summary DATA=review_3 FORCE;*/
/*     QUIT;*/

    %end;

	/* Append each of the base tables to create a master summary */
	proc append base=psi_summary data=psi_summary_&base. force;
	quit;

	%end;
%mend;

/*%psi_loop(start=&start_dt., end=&end_dt., base=&base_scenario.);*/
%psi_loop(start=&start_dt., end=&end_dt./*, base=&base_scenario.*/);
