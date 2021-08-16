%let SAS_LIB = SAS_LIB_REV; *SAS Library that is being reviewed;

*In Gb, use **2 for mb.;
proc sql;
	select memname, filesize/(1024**3) 
	from dictionary.tables
	where libname='&SAS_LIB.' and memtype='DATA'
	order by filesize desc
	;
quit;


*Check the size of the tables. 
SIZEKMG: nKB for kilobytes, nMB for megabytes and nGB for gigabytes
SIZEK: nK for kilobytes;
PROC SQL ;
  TITLE 'Filesize for CARS Data Set' ;
  SELECT LIBNAME,
         MEMNAME,
         FILESIZE FORMAT=SIZEKMG.,
         FILESIZE FORMAT=SIZEK.
    FROM DICTIONARY.TABLES
      WHERE LIBNAME = 'SASHELP'
        AND MEMNAME = 'CARS'
        AND MEMTYPE = 'DATA' ;
QUIT ;
