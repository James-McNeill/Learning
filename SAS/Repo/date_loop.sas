* Loop through SAS dates using %DO macro;
%macro date_loop(start=,end=);
	
  /*converts the dates to SAS dates*/
	%let start=%sysfunc(inputn(&start.,anydtdte9.));
	%let end=%sysfunc(inputn(&end.,anydtdte9.));
	
  /*determines the number of months between the two dates*/
	%let dif=%sysfunc(intck(month,&start.,&end.));
	
  %do i=0 %to &dif.;
	/*advances the date i months from the start date and applys the DATE9. format*/
		%let date=%sysfunc(putn(%sysfunc(intnx(month,&start.,&i.,b)),date9.));
		%put &date. &i.;
	
  /* PLACE SAS CODE TO LOOP THROUGH HERE */

	%end;
%mend;

%date_loop(start=01aug2009, end=01sep2014);
