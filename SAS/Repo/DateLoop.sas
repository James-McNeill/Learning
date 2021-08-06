*Loop through quarters process
Stores each of the runs into a seperate table for easy reference;
%macro dateloop(start_date, end_date);

proc datasets lib=work nolist;
	delete months_out;
run;

data _null_;
	call symput('No_quarters', intck('quarter', "&start_date."d, "&end_date."d));
run;

%put &No_quarters.;

%do i = 0 %to &No_quarters.;

data _null_;
	call symput('quarter_run', put(intnx('month', intnx('quarter', "&start_date."d, &i.,'E'),0) ,date9.));
run;

data _null_;
	call symput('auto_emerge_obs_date', put("&quarter_run."d, date9.));
	call symput('auto_obs_end_date', put(intnx('month', "&quarter_run."d, 12), date9.));
run;

%put &quarter_run.;
%put &auto_emerge_obs_date.;
%put &auto_obs_end_date.;

data months;
format runs 8.;
format month date9.;
format emerge_mth date9.;
format obs_mth date9.;

do;
runs = &i.; 
month = "&quarter_run."d; 
emerge_mth = "&auto_emerge_obs_date."d;
obs_mth = "&auto_obs_end_date."d;
output;
end;
run;

proc append base=months_out data=months force; run;

%end;

%mend;


%dateloop(01sep2006, 01dec2017);
