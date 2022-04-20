/*In depth white paper on space saving methods*/
/*https://support.sas.com/resources/papers/proceedings/proceedings/sugi27/p023-27.pdf*/

/*********************************************************************************************/
/**				 Start of review dataset requirements recommendation 						**/
/*********************************************************************************************/
/*Setting the format and length of a variable correctly can impact on file size. In certain*/
/*cases you might not even need a given variable in which case you might want to remove it from the output*/
data work._rec_1_bad;
	format a1 - a5 $5000.;
	length a1 - a5 $5000.;

	do i = 1 to 100000;
		a1 = "A"||i;
		a2 = "B"||i;
		a3 = "C"||i;
		a4 = "D"||i;
		a5 = "E"||i;
		output;
	end;
run;
/*File size: 2.8Gb*/
proc contents data=work._rec_1_bad;run;

/*Identify the max length of the selected variable and put it into a macro token*/
proc sql noprint; select max(length(a1)) into: a1 from work._rec_1_bad; quit;
%put &a1.;

/*Use the macro token to set the format and length of values that are not likely to change*/
/*and set remaining variables to give a buffered length.*/
data work._rec_1_better;
	format 	a1 $&a1.. 
			a2 - a5 $50.;
	length 	a1 $&a1.. 
			a2 - a5 $50.;

	do i = 1 to 100000;
		a1 = "A"||i;
		a2 = "B"||i;
		a3 = "C"||i;
		a4 = "D"||i;
		a5 = "E"||i;
		output;
	end;
run;
/*File size: 22.5Mb*/
proc contents data=work._rec_1_better;run;

/*If a variable isnt needed use the drop statemet*/
data work._rec_1_best(drop=a5);
	format 	a1 $&a1.. 
			a2 - a5 $50.;
	length 	a1 $&a1.. 
			a2 - a5 $50.;

	do i = 1 to 100000;
		a1 = "A"||i;
		a2 = "B"||i;
		a3 = "C"||i;
		a4 = "D"||i;
		a5 = "E"||i;
		output;
	end;
run;
/*File size: 17.8Mb*/
proc contents data=work._rec_1_best;run;

/*********************************************************************************************/
/**				 	End of review dataset requirements recommendation 						**/
/*********************************************************************************************/

/*********************************************************************************************/
/**				 		Start of set compress options recommendation 						**/
/*********************************************************************************************/
/*setting the compression options will allow SAS to compress the dataset as its being created*/

data work._rec_2_bad;
	format a1 - a5 $5000.;
	length a1 - a5 $5000.;

	do i = 1 to 100000;
		a1 = "A"||i;
		a2 = "B"||i;
		a3 = "C"||i;
		a4 = "D"||i;
		a5 = "E"||i;
		output;
	end;
run;
/*File size: 2.8Gb*/
proc contents data=work._rec_2_bad;run;

/*Set compress on a single dataset, will need to be set for each dataset*/
data work._rec_2_better(compress=yes);
	format a1 - a5 $5000.;
	length a1 - a5 $5000.;

	do i = 1 to 100000;
		a1 = "A"||i;
		a2 = "B"||i;
		a3 = "C"||i;
		a4 = "D"||i;
		a5 = "E"||i;
		output;
	end;
run;
/*File size: 12.4Mb*/
proc contents data=work._rec_2_better;run;

/*set the compress option, which can be put into the [Insert custom SAS code before submitted code] area*/
/*that can be found in Tools - Options - SAS Programs. This will cause all datasets to have this enabled*/
options compress=yes;
data work._rec_2_best;
	format a1 - a5 $5000.;
	length a1 - a5 $5000.;

	do i = 1 to 100000;
		a1 = "A"||i;
		a2 = "B"||i;
		a3 = "C"||i;
		a4 = "D"||i;
		a5 = "E"||i;
		output;
	end;
run;
/*File size: 12.4Mb*/
proc contents data=work._rec_2_best;run;

/*********************************************************************************************/
/**					 		End of set compress options recommendation 						**/
/*********************************************************************************************/

/*********************************************************************************************/
/**				Start of overwrite dataset to clear deleted obs recommendation 				**/
/*********************************************************************************************/
/*Using the delete function still keeps it within the dataset, taking up the same space. if you*/
/*dont need the records any more either overwrite the dataset or create a new dataset*/
data work._rec_3_bad;
	format a1 - a5 $5000.;
	length a1 - a5 $5000.;

	do i = 1 to 100000;
		a1 = "A"||i;
		a2 = "B"||i;
		a3 = "C"||i;
		a4 = "D"||i;
		a5 = "E"||i;
		output;
	end;
run;

proc sql; delete * from work._rec_3_bad where i <= 10000; quit;

/*File size: 2.8Gb*/
proc contents data=work._rec_3_bad;run;

data work._rec_3_bad;
	format a1 - a5 $5000.;
	length a1 - a5 $5000.;

	do i = 1 to 100000;
		a1 = "A"||i;
		a2 = "B"||i;
		a3 = "C"||i;
		a4 = "D"||i;
		a5 = "E"||i;
		output;
	end;
run;

proc sql; create table work._rec_3_better as select * from work._rec_3_bad where i > 10000; quit;

/*File size: 2.5Gb*/
proc contents data=work._rec_3_better;run;
/*********************************************************************************************/
/**				End of overwrite dataset to clear deleted obs recommendation 				**/
/*********************************************************************************************/
