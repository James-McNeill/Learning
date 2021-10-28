/* Creating the quarters that are before the reporting dates being reviewed */
data dates_review;
	infile datalines dsd dlm='09'x;
	informat Date ddmmyy10.;
	format Date date9. Report_date_1 date9. report_date_2 date9.;
	input Date ;
	report_date_1 = '01Jan2007'd;
	report_date_2 = '01Feb2007'd;
	vintage1 = intck('quarter', date, report_date_1);
	vintage1a = intck('month', date, report_date_1);

	if 0 <= vintage1a < 3 then 
	do;
		vintage1b = floor(int(intck('month', date, report_date_1))/3);
	end;

	vintage2 = intck('quarter', date, report_date_2);
	vintage2a = intck('month', date, report_date_2);
	
	if 0 <= vintage2a < 3 then 
	do;
		vintage2b = floor(int(intck('month', date, report_date_2))/3);
	end;

datalines;
01/09/2005
01/10/2005
01/11/2005
01/12/2005
01/01/2006
01/02/2006
01/03/2006
01/04/2006
01/05/2006
01/06/2006
01/07/2006
01/08/2006
01/09/2006
01/10/2006
01/11/2006
01/12/2006
01/01/2007
01/02/2007
;
run;
