/* Credit to: *https://communities.sas.com/t5/SAS-Programming/Separate-Character-and-Numeric-Variables-in-the-Macro-Variable/td-p/273985; */

*Create the dummy dataset;
Data Have;
	Length Numeric1 8 Numeric2 8 Character1 $ 32 Character2 $ 32;
	Infile Datalines Missover;
	Input Numeric1 Numeric2 Character1 Character2;
	Datalines;
0.2 0.4 1 0
0.3 0.5 1 2
0.4 0.8 3 1
0.6 0.9 0 2
0.2 0.1 4 3
0.3 0.1 3 2
0.7 0.1 1 4
0.1 0.8 3 3
;
Run;

*Define the variables to keep for review; 
%Let MacroVar=Numeric1 Numeric2 Character1 Character2;

*Filter for the variables to review;
Data Want;
	Set Have (Keep=&MacroVar.);
Run;

*Separate between the numeric and character variables;
proc sql;
	select name into :cname separated by ' ' 
	from dictionary.columns
	where libname="WORK" and memname="WANT"
	and type = 'char';

	select name into :nname separated by ' '
	from dictionary.columns
	where libname="WORK" and memname="WANT"
	and type = 'num';
quit;

*Display the variable listings;
%put character vars are: &cname;
%put numeric vars are: &nname;


*NOTE - the STACKODSOUTPUT is a feature in SAS 9.3 for proc means;
%Macro Control;

Options NoLabel;

	*Run MEANS summary for numeric variables;
	%IF &nname NE " " %THEN %DO;
	ODS OUTPUT Summary=Want2;
		PROC MEANS DATA=Have (keep=&nname) MEAN STD MIN MAX N NMISS P1 P5 MEDIAN P95 P99 /*STACKODSOUTPUT*/;
		VAR _numeric_;
	RUN;
	%END ;

	*Run FREQ summary for character variables;
	%IF &cname NE " " %THEN %DO;
	PROC FREQ Data=Have (keep=&cname);
		Tables _character_ / NoCum Missing;
		Ods Output OneWayFreqs=Want3;
	Run;
	%END ;

%Mend;

%Control;
