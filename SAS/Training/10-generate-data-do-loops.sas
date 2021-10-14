/* Generating Data with DO Loops */

/*Execute SAS statements repeatedly by placing them in a DO loop. Using DO loops lets you write
concise DATA steps that are easier to change and debug.*/

*Dataset to be used;
data sample;
	set input_data
	(obs=5
	keep=account current_balance type interest_rate	drawdown_dt
	);
run;

*DO loops;
*DO loop execution;
data sample_do1;

	*DO Loop execution;	
	earned = 10;
	rate = 0.01;
	do months=1 to 12;
		earned + (earned) * rate;
	end;

run;

*Counting iterations of DO loops;
data sample_do2;
	
	value = 2000;
	do counter = 1 to 20;
		interest = value * 0.075;
		value + interest;
			year+1;
	end;

/*	drop counter;*/

run;

*Explicit OUTPUT statements;
data sample_do3;
	
	value = 2000;
	do year = 1 to 20;
		interest = value * 0.075;
		value + interest;
		output;
	end;

run;

*Decrementing DO loops;
data sample_do4;
	
	value = 2000;
	do year = 20 to 1 by -1;
		interest = value * 0.075;
		value + interest;
		output;
	end;

run;

*Specifying a series of items;
data sample_do5;

	*All numeric values;
	value = 2000;
	do year = 1, 5, 10, 15, 20;
		interest = value * 0.075;
		value + interest;
		output;
	end;

run;

*Nesting DO loops;
data sample_do6;
	
	do year = 2000 to 2020;
		capital + 2000;
		do month = 1 to 12;
			interest = capital * (0.075/12);
			capital + interest;
/*			output;*/
		end;	
	end;

run;

*Iteratively processing observations from a data set;
data sample_do_it;
	set sample;

	rate = interest_rate / 100;
	years = intck("year", drawdown_dt, today());
	invest = 5000;
	do i = 1 to years;
		invest + (rate * invest);
		year = year(intnx("year", drawdown_dt, i));
		output;
	end;

/*	format year date9.;*/

run;

*Conditionally executing DO loops;
data sample_do_con;
	
	do until (capital >= 50000);
		capital+ 2000;
		capital + capital * .10;
		year + 1;
		output;
	end;

run;

*Conditionally executing DO loops - DO while statement, this DO loop will not execute. 
Expression is false the first time it is evaluated so the DO loop never executes;
data sample_do_con1;

	capital = 2000;
	do while (capital >= 50000);
		capital + 2000;
		capital + capital * .10;
	end;

run;

*Using conditional clauses with the Itervative Do statement;
data sample_do_con2;
	
	do year = 1 to 10 until (capital >= 50000);
		capital + 4000;
		capital + capital * .10;
	end;
	if year = 11 then year = 10;

run;

*Creating samples;
data sample_do_samp;
	set input_data 
	(obs=10000
	keep=account current_balance type interest_rate	drawdown_dt
	);
run;

*Selecting a sub-sample of data points from the input dataset;
data sample_do_samp1;
	do sample=10 to 5000 by 10;
		set sample_do_samp point=sample;
		output;
	end;
	stop;	*Used to prevent an endless DO loop for the point option;
run;
