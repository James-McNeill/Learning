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


*LTV and funded collateral by stage;
%macro LTV_Fund_T();

	*Create the LTV variables;
	EAD = SUM(EAD1, EAD2, EAD3);
	LTV = (EAD / VALUE) * 100;

	*Arrays for the variables;
	array COLLATERAL_[3] COLLATERAL_1 COLLATERAL_2 COLLATERAL_3; *Output variables, providing names;
	array ead_{3} EAD_1 EAD_2 EAD_3; *Input variables, providing names;
	array ltv_{3} LTV_1 LTV_2 LTV_3; *Input variables;
	array LTV_EXP_{3} LTV_EXP_1 LTV_EXP_2 LTV_EXP_3; *Output variables;
	
	*Variables by stage;
	do i = 1 to 3;
		if ead_[i] > 0 then ltv_[i] = LTV;
		else ltv_[i] = ead_[i];
		if ead_[i] > 0 then COLLATERAL_[i] = min(ead_[i], (1 / (ltv_[i] / 100)) * ead_[i]);
		else COLLATERAL_[i] = ead_[i];

		LTV_EXP_[i] = SUM((LTV_[i] / 100) * EAD_[i]);
	end;

	drop i;

%mend;

*Applied within the SAS dataset code that contains the input variables being used;
data check;
  set input_data;
  %LTV_Fund_T; *running the macro to create the new variables;
run;
