/* Creating three separate strings and re-ordering the data */
data testing;
	input team_a $3. team_b $3. team_c $3.;
	datalines;
abcdefghi
defghiabc
ghiabcdef
abcghidef
;
run;

*Using the sortc method to re-arrange the string values;
data testing_1;
	set testing;
	array t team:;
	call sortc(of t(*));
run;
