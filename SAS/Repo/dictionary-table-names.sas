/* 
Display the list of table names that are reviewed with a certain reference name.
---
NOTES
Selecting the MEMNAME will show the SAS dataset name that is assigned. 
By reviewing the LIKE option then any datasets that begin with the TIME value for this example will be selected. 
The % sign is used as the wildcard within this analysis
*/

proc sql noprint;
	select MEMNAME into :tbl_names separated by " "
	from dictionary.tables
	where libname = "WORK" and MEMNAME LIKE ("TIME%")
/*	order by name*/
	;
run;

*Display the list of table names within the WORK space;
%put &tbl_names.;
