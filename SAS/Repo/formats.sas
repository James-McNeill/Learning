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
	invalue NumberRange
	0= 0
	0<-3= 1
	3<-6= 2
	6<-9= 3
	9<-12= 4
	12-high= 5
	other = 99;
 run;
