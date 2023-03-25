/* Add a monotonic row counter (similar to SAS keywork _N) using PROC SQL */
/* Create the list of variables from a SAS dataset */
PROC SQL;
  create table grouping as
  select 
    monontonic() as row *creates a row number for each name within the columns dictionary table for the input table reviewed;
    ,name as group
   from dictionary.columns
   where libname = upcase("work") *have to ensure that the upper case is used to allow for the filter to process. SAS is case sensitive;
    and memname = upcase("input_table") *SAS dataset name is case sensitive;
    and name not in ("var5", "var6") *SAS dataset variable names are case sensitive;
  ;
QUIT;

/* Assign macro variables to each row attribute in the table */
DATA _NULL_; *using SAS keyword, create a blank dataset that will not be stored within libref WORK. Allows for processing steps that do not require output to WORK.;
  set grouping nobs=Count end=eof; *nobs= SAS keyword that assigns number of observations, end= assigns variable to the program data vector referencing last record;
  call symputx('group'||left(_N_), strip(group)); *function creates macro variable for each record. second parameter variable is the name of variable.;
  if eof then call symputx('Count', Count);
RUN;
