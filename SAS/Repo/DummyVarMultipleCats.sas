/* 
Creating dummy variables for multiple categories in a variable 
example: %cat(data_in, data_out, location);
out: create dummy values by location
*/
%macro cat(indata,outdata, variable);
proc sql noprint;
	select distinct &variable. 
		into :mvals separated by '|'
	from &indata.;
	%let mdim=&sqlobs;
quit;

data &outdata.;
	set &indata.;
	%do _i=1 %to &mdim.;
		%let _v = %scan(&mvals., &_i., |);
		if VType(&variable)='C' then do;
	    	if &variable. = "&_v." then &_v. = 1;
	     	else &_v = 0;
	  	end;
	  	else do;
	    	if &variable. = &_v. then &_v. = 1;
	     	else &_v = 0;
	    end;
	%end;
run;
%mend;
