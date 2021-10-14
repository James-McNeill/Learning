*Dataset summary level;

%let sas_lib = TEMP; *SAS library that is to be reviewed;

*Review all of the datasets within a SAS library, option prints high level information;
proc contents data=&sas_lib.._all_ nods;
run;

*Review an individual dataset within the SAS library;
proc contents data=&sas_lib..monthy_report varnum; *varnum - order variables by creation order; 
run;

*Review the information in a SAS library;
proc datasets lib=work;
	contents data=&sas_lib..monthly_report varnum;
/*	delete work.utp;*/
run;

*Information review of the work library;
proc datasets;
	contents data=work.input_data varnum;
run;

*Understanding the index implemented within the dataset;
proc datasets;
	contents data=&sas_lib..monthly_report;
run;
