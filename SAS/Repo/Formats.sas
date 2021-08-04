/* Examples of using PROC FORMAT */
proc format;
	value NumToString
	1 = 'One'
	2 = 'Two'
	3 = 'Three'
	other = 'Other';
	invalue StringToNum
	'Yes' = 1
	'No' = 0
	other = 99;
 run;
