*Example of how to make use of the banding options for variables within PROC SGPLOT;

*The code below takes a time series variable and plots that stationary statistics over the quarters q.;
%let analysis_var = conb_move;

*Bring in the dataset for review;
proc means data=sashelp.citimon mean median ;
	var conb;
	output out=out_conb(drop=_type_ _freq_) mean=avg_conb median=med_conb; 
run;

proc sql;
	create table input as
	select t1.*, t2.avg_conb
	from sashelp.citimon t1, out_conb t2
	;
run;

data input;
	set input;
	q = put(date, yyq.);
	conb_move = conb / avg_conb;
run;

*For the time series to work the class variable has to represent the discrete time convention being assessed;
proc means data=input mean median p25 p75 min max;
	var &analysis_var.;
	class q;
	output out=new(drop=_type_ _freq_) mean= median= q1= q3= min= max= / autoname; 
run;

data new;
	set new;
	format &analysis_var._mean percent7.3
	&analysis_var._median percent7.3
	&analysis_var._Q1 percent7.3
	&analysis_var._Q3 percent7.3
	&analysis_var._max percent7.3
	&analysis_var._min percent7.3;
run;

PROC SGPLOT DATA = new(rename=(&analysis_var._mean=Mean &analysis_var._median=Median 
	&analysis_var._Q1=Q1 &analysis_var._Q3=Q3 &analysis_var._max=Max &analysis_var._min=Min));
	SERIES X = q Y = Q1 /LINEATTRS=(color=black PATTERN=dash THICKNESS=4);
	SERIES X = q Y = Q3 /LINEATTRS=(color=blue PATTERN=dash THICKNESS=4);
	SERIES X = q Y = Median /LINEATTRS=(color=red PATTERN=shortdash THICKNESS=4);
	SERIES X = q Y = Mean /LINEATTRS=(color=green PATTERN=dot THICKNESS=4);
	SERIES X = q Y = min /LINEATTRS=(color=purple PATTERN=solid THICKNESS=4);
	SERIES X = q Y = Max /LINEATTRS=(color=orange PATTERN=solid THICKNESS=4);
	BAND X = q UPPER = Q3 LOWER = Q1 / FILL OUTLINE fillattrs=(color=cx66A5A0) transparency=0.7;
	XAXIS TYPE = DISCRETE LABEL='Quarters';
	YAXIS LABEL='Contribution Percent';
	INSET 'Base Case'/ POSITION = TOPRIGHT BORDER;
	TITLE 'Contribution Percentage by Time';
RUN;
