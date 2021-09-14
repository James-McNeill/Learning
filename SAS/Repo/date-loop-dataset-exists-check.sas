/* 
AIM: Check that a dataset exists within the SAS library. If the dataset does not exist then add details
to a log dataset that helps to monitor which datasets are not present during the review.
*/

*A log dataset that can be used to store the details of datasets that do not exist;
data CustomLog;
length MyTable $ 50 TableError $ 150;
run;

*Macro that adds details to the log dataset to keep track of the review being performed;
%macro Add2Log (MyTable,TableError);
     proc sql;
     insert into CustomLog
     values (&MyTable,&TableError);
     quit;
%mend Add2Log;


* Loop through SAS dates using %DO macro;
%macro date_loop(start=,end=,inputtable=);
     /*converts the dates to SAS dates*/
     %let start=%sysfunc(inputn(&start.,anydtdte9.));
     %let end=%sysfunc(inputn(&end.,anydtdte9.));
     /*determines the number of months between the two dates*/
     %let dif=%sysfunc(intck(month,&start.,&end.));

  *Create a historic table that will stack each of the input datasets;
	proc datasets lib=work nodetails;
		delete historic_table;
	run;

     %do i=0 %to &dif.;
     /*advances the date i months from the start date and applys the DATE9. format*/
           %let date=%sysfunc(putn(%sysfunc(intnx(month,&start.,&i.,b)),date9.));
           %let yyyymm=%sysfunc(putn(%sysfunc(intnx(month,&start.,&i.,b)),yymmn6.));
		   %let date_adj=%sysfunc(putn(%sysfunc(intnx(month,&start.,&i.,b)),yymmd7.));
		   %let yyyy_mm=%sysfunc(tranwrd(&date_adj.,-,_));

		   %put &date. &i. &start. &yyyymm. &date_adj. &yyyy_mm.;

    /* Bring in the monthly table to review */
	%if %sysfunc(exist(&inputtable.&yyyymm.)) %then %do;
	data output_&yyyy_mm. ;
		set &inputtable.&yyyymm.
		(keep= account_no fb_arrange_detail adj_arrears arrears_banding)
		indsname=dset; *Can take the dataset name string and use these details to extract the date value (yyyy_mm);
		length date $10.;
		date = substr(dset, 28);
		month = mdy(substr(date, 6, 2), 1, substr(date, 1, 4));
		format month date9.; 
	run;
	
     /*CREATE AN HISTORIC TABLE*/
     /*LIVE COMBINED HISTORY*/
     PROC APPEND BASE=HISTORIC_TABLE DATA=output_&yyyy_mm. FORCE;
     QUIT;
	%end;

	 /* File doesn't exist */
	%else %do;
		data _null_;
			file print;
			put "Data set &inputtable.&yyyy_mm. does not exist";
			%Add2Log("&inputtable.&yyyy_mm.", "Data set does not exist");
		run;
	%end;

    %end;
%mend;

%date_loop(start=01jun2016, end=01jun2017, inputtable=INPUT_DATA_);
