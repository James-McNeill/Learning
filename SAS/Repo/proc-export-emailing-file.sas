/* Location reference within the SAS files folder */
LIBNAME HOME 'SAS library location';

/* Create a testing dataset */
data testing;
	input month ddmmyy11.;
	datalines;
01/11/2017
01/10/2017
01/09/2017
01/08/2017
01/07/2017
01/06/2017
01/05/2017
01/04/2017
01/03/2017
01/02/2017
01/01/2017
01/12/2016
01/11/2016
01/10/2016
01/09/2016
;
run;

/* Add variables to the testing dataset */
data testing;
	set testing;
	format month date9. obs_mth date9. quarter date9. quarter_01 date9.;
	quarter = intnx('quarter', month, 0, 'e');
	quarter_01 = intnx('month', quarter, 0, 'b');
	obs_mth = intnx('month', intnx('month', intnx('quarter', month, 0, 'e'), 0, 'b'), -12, 'b');
run;

/*A few exports methods down to the files folder in the SAS library*/
data home.MTA_EMV_sample;
  set testing;
run;

/* Export the dataset as an excel file to the SAS library location */
proc export data=work.testing
			dbms=xls
			OUTFILE="SAS Library location/output.xlsx" 
			replace;
run;

/*Messing about with the ODS options for creating the exported file*/
ods _all_ close;
ods listing;
*Start the excel report;
ods tagsets.excelxp file="SAS Library location/output.xlsx";

*Start the first tab;
ods tagsets.excelxp options( sheet_name="MySheet1");

proc print data=work.testing;
run;

*Close the report;
ods _all_ close;
ods listing;


/*E-mailing out the attachment but the content is corrupted so need to work on this*/
FILENAME Mailbox EMAIL "email address" ;

data _null_;
curr_month = today();
call symput('curr_date', curr_month);
run;

DATA _NULL_;
FILE Mailbox
attach =("SAS Library location/output.xlsx" content_type="application/excel")
to = ("email address")
Subject='Testing email message';
PUT "Hello ";
PUT "******************************************************** ";
PUT "******************************************************** ";

PUT "Testing excel file output ";
RUN;
