*MACRO: Dataset checker;
%MACRO TABLE_CHECK(LIB= /*Library reference name*/
					,TABLE= /*Key section of the dataset name for review*/
					,OUT= /*Dataset output suffix*/
					);	

	proc sql;
		create table check_&OUT. as
		select libname, 
				memname, 
				memtype, 
				crdate, 
				modate, 
				nobs, 
				nvar, 
				num_character, 
				num_numeric
		from dictionary.tables
		where LIBNAME = "&LIB." and MEMNAME like "&TABLE.%"	
		ORDER BY MEMNAME DESC;
	run;

%MEND;

*Run the table_check macro.
NOTE: Have to ensure that the values used are capitalised to allow the search to work properly;
%TABLE_CHECK(LIB=LIB_REF, TABLE=TABLE_REF, OUT=TABLE_OUT);
