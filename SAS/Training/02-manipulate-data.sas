*Code that can be used to manipulate datasets;
%let filter = "check";

data input_data_1;
	set input_data;
	where brand = &filter.;
run;

*Sorting the dataset in descending order;
proc sort data=input_data_1 out=output_data_2; by descending account; run;
