/* Processing variables with Arrays */

/*Understanding SAS arrays
A SAS array is a temporary grouping of SAS variables under a single name. An array exists only
for the duration of the DATA step. One reason for using an array is to reduce the number of 
statements that are required for processing variables.*/

/*General form, ARRAY statement
ARRAY array-name{dimension} <elements>
array-name: specifies the name of the array
dimension: describes the number and arrangement of array elements
elements: lists the variables to include in the array
*/

/*Specifying the array name
array sales{4} qtr1 qtr2 qtr3 qtr4;
*/

/*Specifying the dimension
array sales{4} qrt1 qrt2 qrt3 qrt4
array sales{96:99} totals96 totals97 totals98 totals99
array sales{*} qtr1 qtr2 qtr3 qtr4
Using the asterisk, SAS determines the dimension of the array by counting the number of elements
array sales{4} qtr1-qtr4, using a variable list

All numeric variables
array sales{*} _numeric_
All character variables
array sales{*} _character_
*/


*Referencing elements of an Array;
data arr (drop=jan apr jul oct);
/*data arr;*/

	jan = 10;
	apr = 20;
	jul = 30;
	oct = 40;

	array quarter{4} jan apr jul oct;

/*	yeargoal1 = quarter{1}*1.2;*/
/*	yeargoal2 = quarter{2}*1.2;*/
/*	yeargoal3 = quarter{3}*1.2;*/
/*	yeargoal4 = quarter{4}*1.2;*/

	do qtr=1 to 4;
		yeargoal = quarter{qtr}*1.2;
		output;
	end;

run;

*Review the CLASSFIT data;
data class;
	set sashelp.classfit;
	rename Weight = weight1 predict = weight2 lowermean = weight3 uppermean = weight4 lower = weight5 upper = weight6;
run;

/*data class (drop=i);*/
/*	set class;*/
/**/
/*	array wt{6} weight1-weight6;*/
/*	do i = 1 to 6;*/
/*		wt{i} = wt{i}*2.2046;*/
/*	end;*/
/**/
/*run;*/

*Using the DIM function in an Iterative DO statement
When you use the DIM function, you do not have to re-specify the stop value of an iterative DO statement
if you change the dimension of the array.
;
data class1 (drop=i);
	set class;

	array wt{*} weight1-weight4;
	do i = 1 to dim(wt);
		wt{i} = wt{i}*2.2046;
	end;

run;

*Creating variables in an ARRAY statement;
data class2 (drop=i);
	set class;

	array wt{*} weight1-weight6;
	array wgtdiff{5};	*Default variable names are created by concatenating the array name with numbers;

	do i = 1 to 5;
		wgtdiff{i} = wt{i+1}-wt{i};
	end;

run;

*Assigning initial values to Arrays;

*array goal{4} g1 g2 g3 g4 (9000 9300 9600 9900)
array col{3} $ color1-color3 ('red', 'green', 'blue')
;

*Understand if the weight was achieved;
data class3 (drop=i);
	set class;

	array wt{*} weight1-weight6;
	array goal{6} (100 150 200 250 300 350);
	array achieved{6};	

	do i = 1 to dim(wt);
		achieved{i} = 100*wt{i}/goal{i};
	end;

run;

*The variables goal should not be stored in the data set, because they are needed only to calculate the
values of achieved. The next example shows how to create temporary array elements.;

*Specify _TEMPORARY_ after the array name and the elements do not appear in the resulting data set;
data class4 (drop=i);
	set class;

	array wt{*} weight1-weight6;
	array goal{6} _temporary_ (100 150 200 250 300 350);
	array achieved{6};	

	do i = 1 to dim(wt);
		achieved{i} = 100*wt{i}/goal{i};
	end;

run;

*Defining a multidimensional array
array new{r,c} x1-x12
The two dimensions can be thought of as a table of rows and columns;

*Referencing elements of a two-dimensional array;
data mult_mths;
	
	do i = 1 to 12;
		month = mdy(i, 1, 2018);
		output;
	end;

	format month date9.;

run;

proc transpose data=mult_mths(drop=i) out=mult_mths1 prefix=month; run;

*Creating the quarterly array;
data mult_mths1;
	set mult_mths1;
	array m{4,3} month1-month12;
	array qtr{4};

	*Loop works through each of the elements from the two dimensional array;
	do i = 1 to 4;
		qtr{i}=0;
		do j = 1 to 3;
			qtr{i}+m{i,j};
			output;
		end;
	end;

/*	format qtr1 date9.;*/

run;

*Use array to rotate (transpose) data;
data class_rotate /*(drop=weight1-weight6)*/;
	set class;

	array wght{6} weight1-weight6;
	do month= 1 to 6;
		weight = wght{month};
		output;
	end;

run;
