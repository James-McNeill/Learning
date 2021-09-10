/* A number of array methods to create new variables within the final SAS dataset */

*Variables by stage;
%macro probs_T();
	
	*Arrays for the variables;
	array flows_{3} F1_to_3Flow F2_to_3Flow F3_to_3Flow;
	array probs_{3} Prob1 Prob2 Prob3;
	
	*Variables by stage;
	do i = 1 to 3;
		probs_[i] = Prob3 * flows_[i];
	end;

	drop i;

%mend;

*Applied within the SAS dataset code that contains the input variables being used;
data check;
  set input_data;
  %probs_T; *running the macro to create the new variables;
run;
