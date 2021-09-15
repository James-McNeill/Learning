
/*COLOURS*/
%let Col1 = 10,47,100;
%let Col2 = 6,179,187;
%let Col3 = 232,66,97;
%let Col4 = 129,170,40;
%let Col5 = 249,177,34;
%let Col6 = 102,100,101;
%let Col7 = 37,166,233;
%let Col8 = 4,134,140;

%macro hex2(n);
  %local digits n1 n2;
  %let digits = 0123456789ABCDEF;
  %let n1 = %substr(&digits, &n / 16 + 1, 1);
  %let n2 = %substr(&digits, &n - &n / 16 * 16 + 1, 1);
  &n1&n2
%mend hex2;

%macro RGB(r,g,b);
  %cmpres(CX%hex2(&r)%hex2(&g)%hex2(&b))
%mend RGB;

%MACRO SET_UP_COEFFICIENTS(type,name,independent);
	

	PROC CONTENTS data=coefficients_&name(keep=&independent) 
			noprint out=Var_List(keep=Name); 
	QUIT;

	DATA Var_List;
		set Var_List;
		Number = _N_;
	RUN;

	PROC SQL noprint; select max(Number) into: var_no from Var_List;  QUIT;

	%DO i=1 %TO &var_no.;
		PROC SQL noprint; select Name into: var&i. from Var_List where Number=&i.; QUIT;
		%let var&i.=%sysfunc(compress(&&var&i..));
		%put &&var&i.;
	%END;

	data coefficients_rename_&name;
		set coefficients_&name(keep=_TYPE_ &independent
				where=(_TYPE_ = %if &type = P %then %do; "PARMS"  %end; %else %do; "STDERR"  %end;));
			%DO i=1 %TO &var_no.;
				 %if &type = P %then %do;
						rename &&var&i. = &&var&i.._C;
				 %end;
				 %else %do;
						rename &&var&i. = &&var&i.._E;
				 %end;
			%end;
		join = 1;
	run;

%MEND;


%MACRO JACKKNIFE(model_data, dependent, independent,nRemove,model_run);

data jackknife (keep=date &independent &dependent);
	set model_data ;
run;

	data _null_;
	set jackknife nobs=nobs;

	call symput('obs',nobs);
	run;

	%do i = &nRemove %to &obs;
		%let s = %eval(&i-&nRemove +1);

		data jack&s;
		set jackknife nobs=nobs;

		if _n_ <&s or _n_ > &i;
		Sample = &s;
		run; 
	%end;

	data all;
	set 
	%do i = &nRemove %to &obs;
		%let s = %eval(&i-&nRemove +1);
		jack&s
	%end; ;
	run;

	proc reg noprint outest=work.regests data=all;
	by Sample;
	model  &dependent = &independent  ;
    output out=work.pred p=p r=r ;
    run;

	data work.regests;
	set work.regests;
	join = 1;
	run;

	%SET_UP_COEFFICIENTS(P,&model_run.,&independent. );

	data _temp1_;
	merge work.regests (keep=join &independent.)
		  coefficients_rename_&model_run.;

	by join;
	run;

	%SET_UP_COEFFICIENTS(S , &model_run., &independent.);

	data Jackknife_Chart(drop=join);
	merge _temp1_
		  coefficients_rename_&model_run.;

	by join;

	%do i = 1 %to &NModelVars.;
		%let v = %scan(&independent., &i); 
		&v._L = &v._c - (1.96 * &v._e);
		&v._U = &v._c + (1.96 * &v._e);
	%end;

	N= _n_;
	run;

	proc datasets lib=work nodetails nolist nowarn;
		delete 	%do i = &nRemove %to &obs;
					%let s = %eval(&i-&nRemove +1);
					jack&s
				%END;
	run;

	%do i = 1 %to &NModelVars;
		%let v = %scan(&independent, &i); 
		PROC SGPLOT DATA = Jackknife_Chart ;

			SERIES X=N Y = &v /   LEGENDLABEL = "Jackknife Estimates" lineattrs =( color = %RGB(&Col1) pattern=solid thickness=2) ;
			SERIES X=N Y = &v._C /   LEGENDLABEL = "Model Estimate" lineattrs =( color = %RGB(&Col3) pattern=solid thickness=1) ;
			SERIES X=N Y = &v._L /   LEGENDLABEL = "Lower 95% CI" lineattrs =( color = %RGB(&Col6) pattern=dash thickness=1) ;
			SERIES X=N Y = &v._U /   LEGENDLABEL = "Upper 95% CI" lineattrs =( color = %RGB(&Col6) pattern=dash thickness=1) ;
		

			YAXIS label="&v" ;
			TITLE "&v - &model_run";

		run;


	%end;
	
	data jackknife_final_&model_run.;
	set Jackknife_Chart;
	
	keep N
	%do i = 1 %to &NModelVars;
		%let v = %scan(&independent, &i); 
		&v 
	%end;
	;
/*	rename*/
/*	%do i = 1 %to &NModelVars;*/
/*		%let v = %scan(&independent, &i); */
/*		&v =  &short_name._&v*/
/*	%end;*/
/*	;*/
	run;


%MEND JACKKNIFE;

%MACRO CONTROL(INPUT_DATA, MODEL_DATA, DEP_VAR);


proc sql noprint; select count(*) into: tot_model_num from &INPUT_DATA.; run;

%put model_num is: &tot_model_num.;

data vars_jack;
	set &INPUT_DATA.;
	var_id = _N_;
run;

	%DO model_num=1 %TO &tot_model_num.;

	data _null_;
		set vars_jack;
		where var_id = &model_num.;
		call symput("var&model_num.", IND_VARS);
	run;

	%let NModelVars = %sysfunc(countw(&&var&model_num..));


	%put model run=&model_num. model num is: &tot_model_num. number of vars: &NModelVars. and indep vars: &&var&model_num..;


	*Do the loop for each of the model runs through this macro here;
		%JACKKNIFE(&model_data., &DEP_VAR., &&var&model_num..,4, &MODEL_NUM.);

	%END;


%MEND CONTROL;

%CONTROL(FINAL_LIST_TBL, MODEL_DATA, &DEPENDENT.);
