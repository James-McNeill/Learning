/* Pass through query logic to teradata. Ensures teradata does SQL processing before returning results to SAS */
PROC SQL;
  sysecho "SQL terdata pass through";
  Connect to Teradata as tera ();
  create table output_data as
    select * from connection to tera
      (
      
      );
  Disconnect from tera;
QUIT;
