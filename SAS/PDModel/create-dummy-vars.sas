/* Creating dummy variables */
proc iml;
	use sashelp.class;
	read all var {sex};
	close;
		vnames=unique(sex);
		d=design(sex);
	create want from d[r=sex c=vnames];
	append from d[r=sex];
	close;
quit;

proc print;run;
