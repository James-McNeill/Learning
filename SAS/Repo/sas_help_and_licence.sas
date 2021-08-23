*One of the SAS dictionary tables
	Contains information about all objects that are in currently defined SAS libraries;
data check;
	set sashelp.vmember;
run;

*Outlines all of the SAS files that are in the SASHELP library;
proc contents data=sashelp._all_;
run;

*Shows when the SAS installation will expire;
proc setinit;
run;
