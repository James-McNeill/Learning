*Using the Output Delivery System (ODS);

*Producing HTML and Listing output. OBS function can be used to filter the first N records;
proc print data=input_table (obs=10);
run;

*NOTE - Remember to put a closing statement in when using the ODS framework. We have opened up the destination which will continue
to use system resouces if it is not appropriately closed.;

*Produces the listing output for review;
ods listing;

proc print data=work.input_table (obs=10);
run;

ods listing close;

*Produce only the Listing output. NOTE - HTML is an open destination by default.
User doesn't have appropriate authorisation to open/close HTML destination;
/*ods html close;		*Close HTML destination;*/
ods listing;

proc print data=work.input_table (obs=10);
run;

ods listing close;
/*ods html;		*Open HTML destination;*/

*ODS HTML provides many options which could be used with a higher level of access authority;
