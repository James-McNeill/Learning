*Create a few initial dates that can be converted into functions
BASE_DATE = base month for the run;

*Base month for the project;
%let month=01Dec2019;
%put &month. ;

*Create the dates table with the different time periods required;
data dates;
	
	format date_st date date9.;
	date_st = "&month."d;
	
	*Iterate list of dates;
	do i = 0 to 13;
		date_i = cats("date", i);
		yyyy_mm_i = cats("yyyy_mm", i);
		date = intnx("month", date_st, -i);
		str_date = put(date, date9.);
		yyyy_mm = catx("_",year(date), put(month(date),z2.));
		output;
	end;

run;

*Create the macro date values using the dates dataset;
data _null_;
	set dates;

	call symputx(date_i, str_date);	
	call symputx(yyyy_mm_i, yyyy_mm);	

run;

*Check that the correct values have been assigned to the macro date variables;
proc sql;
	create table macro_dates as
	select name, value
	from dictionary.macros
	where name like "DATE%" or name like "YYYY_MM%"
	order by name
	;
run;
