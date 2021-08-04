*Check to see the data type for key input variables
Example: %input_file(lib=INPUT_LIB, table=INPUT_TABLE, month=YYYY_MM, variable=ACCOUNT_NO, tableout=OUTPUT_TABLE);
;

%macro input_file(lib=, table=, month=, variable=, tableout=);

*Check variable data type;
proc sql noprint;
	select TYPE into: dtype
	from dictionary.columns
	where LIBNAME = "&lib." and MEMNAME = "&table."
		AND NAME = "&variable."
	;
run;

*Output the variable type;
%put &table. &dtype.;

*Check if the data type is numeric or character;
%if &dtype. = num %then 
	%do;
		data &tableout._&MONTH.;
			set &lib..&table.;
			MORT_NO = put(&variable., z10.); *Add extra zeros to the input value;
			DROP &variable.;
			RENAME MORT_NO = &variable.;
		RUN;
	%end;

%else %if &dtype. = char %then 
	%do;
		data &tableout._&MONTH.;
			set &lib..&table.;
		RUN;
	%end;

%mend;
