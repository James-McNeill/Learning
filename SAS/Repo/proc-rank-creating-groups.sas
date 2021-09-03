/* Macro used to create grouped values for the input variable */
%macro group_banding(input_data=, output_data=, input_variable=, no_groups=);

/* Create the decile ranked range on the first month */
proc rank data=&input_data. groups=&no_groups. out=hist_groups;
 var &input_variable.;
 ranks score_group;
run;

/* Calculate the minimum and maximum values per rank */
proc summary data=hist_groups nway;
 class score_group;
 var &input_variable.;
 output out=hist_groups_min_max (drop=_:) min= max= / autoname;
run;

/* create dataset with formatted values */
data group_rank_fmt;
 set hist_groups_min_max (rename=(score_group=start));
 retain fmtname 'dec_fmt' type 'N';
 label=catx('-', &input_variable._min, &input_variable._max);
run;

/* Store the max values */
proc sql noprint;
 select &input_variable._max into: band1-:band&no_groups.
 from group_rank_fmt;
run;

/* apply the format to the historic table for all months */
data &output_data.;
 set &input_data.;
 length group_band 8.;
 
 *Apply the bandings - NOTE need to make this more dynamic;
 if &input_variable. <=&band1 then group_band = 1;
 %do i = 2 %to &no_groups.;
  else if &input_variable. <=&&band&i then group_band = &i;
 %end;
 else group_band = &no_groups.;

run;

%mend;

%let groups = 10; *Example to show what a grouped by deciles variable format would look like;

%group_banding(input_data=haircut_data, output_data=haircut_data_review, input_variable=tid, no_groups=&groups.);
