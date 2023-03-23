ods graphics on; *produce HTML output;

/* TTest to perform binary one factor analysis of variance */
%macro ttest(inputdata=input, ind_var=ind_var1, dep_var=dep);

  title &ind_var1.;
  proc ttest data=&inputdata.;
    class &ind_var.;
    var &dep_var.;
  run;
  title; *close title;

%mend ttest;

/* Run macro using default parameters */
%ttest;

/* Run with adjustments to specific keyword parameters */
%ttest(dep_var=dep1);
%ttest(ind_var=ind_var2);
%ttest(ind_var=ind_var2, dep_var=dep1);

ods graphics off; *return to default setting;
