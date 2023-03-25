/* Pass through query logic to teradata. Ensures teradata does SQL processing before returning results to SAS */
PROC SQL;
  sysecho "SQL terdata pass through";
  Connect to Teradata as tera (user="&User_id.@LDAP" password="&User_id_PASSWORD." server=server mode=TERADATA);
  create table output_data as
    select * from connection to tera *open connection using tera alias;
      (
      
      );
  Disconnect from tera; *Close connection after processing SQL within Teradata;
QUIT;
