/*
Review of missing value replacement
https://communities.sas.com/t5/SAS-Procedures/Replacing-missing-values-by-previous-observation/td-p/26707
*/

data testing;
	input id presribeddate ddmmyy11. drug $ quantity;
	format presribeddate date9.;
	datalines;
1 08/01/2008 A 28
1 08/02/2008 A 14
1 08/03/2008 A .
1 08/04/2008 B 56
1 08/05/2008 B .
2 08/01/2008 A 30 
2 08/03/2009 B .
2 28/03/2008 A 30 
2 08/03/2008 B 14 
3 08/01/2008 B .
3 08/03/2009 B 56
3 08/03/2008 A .
4 08/01/2008 A .
4 08/02/2008 A .
4 08/03/2008 A 14
4 08/04/2008 B .
4 08/05/2008 B .
;
run;

/*Retains the latest value. But this can relate to a different record ID.*/
data testing1;
	set testing;
	retain tot;
	if quantity >. then tot = quantity;
run;


data testing2;
 set testing;
 n=_n_;
 if missing(quantity) then
  do;
   do until (not missing(quantity));
     n=n-1;
     set testing(keep=quantity) point=n;  *second SET statement;
   end;
 end;
run;
