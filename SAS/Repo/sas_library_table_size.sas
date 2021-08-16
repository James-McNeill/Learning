%let SAS_LIB = SAS_LIB_REV; *SAS Library that is being reviewed;

*In Gb, use **2 for mb.;
proc sql;
	select memname, filesize/(1024**3) 
	from dictionary.tables
	where libname='&SAS_LIB.' and memtype='DATA'
	order by filesize desc
	;
quit;
