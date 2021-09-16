*Month to create adjustment variables for;
%let curr_month = '01jun2019'd;

/* Create the macro variables using the null dataset */
data _null_;

	*Scoring month - output format = yyyy_mm;
	call symput('score_month',catx('_',substr(put(intnx('month',&curr_month,0),yymmd7.),1,4),substr(put(intnx('month',&curr_month,0),yymmd7.),6,2)));

	*Input the 6 months of input dates - output format = yyyy_mm;
	call symput('month1',catx('_',substr(put(intnx('month',&curr_month,-17),yymmd7.),1,4),substr(put(intnx('month',&curr_month,-17),yymmd7.),6,2)));
	call symput('month2',catx('_',substr(put(intnx('month',&curr_month,-16),yymmd7.),1,4),substr(put(intnx('month',&curr_month,-16),yymmd7.),6,2)));
	call symput('month3',catx('_',substr(put(intnx('month',&curr_month,-15),yymmd7.),1,4),substr(put(intnx('month',&curr_month,-15),yymmd7.),6,2)));
	call symput('month4',catx('_',substr(put(intnx('month',&curr_month,-14),yymmd7.),1,4),substr(put(intnx('month',&curr_month,-14),yymmd7.),6,2)));
	call symput('month5',catx('_',substr(put(intnx('month',&curr_month,-13),yymmd7.),1,4),substr(put(intnx('month',&curr_month,-13),yymmd7.),6,2)));
	call symput('month6',catx('_',substr(put(intnx('month',&curr_month,-12),yymmd7.),1,4),substr(put(intnx('month',&curr_month,-12),yymmd7.),6,2)));

	*First month in the observation window;
	call symput('new_month',put(intnx('month',&curr_month,-12), monyy5.)); *Output format = MMMYY JUN18;
	call symput('new_month2',"'"||put(intnx('month',&curr_month,-12,'E'),date9.)||"'d"); *Output format = DDMMMYYYY, '30JUN2018'd;
		
run;

*Output the variables into log;
%put &score_month;
%put &month1 &month2 &month3 &month4 &month5 &month6;
%put &new_month &new_month2;
