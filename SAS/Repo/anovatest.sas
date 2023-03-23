ods graphics on; *produce HTML output;

/* ANOVA to perform multivariate factor analysis of variance. Allows for inclusion of multiple dependent variables. */
%macro multifactor_analysis(inputdata=input, ind_var=ind_var, dep_var=dep dep1 dep2);

  title &ind_var.;
  proc glm data=&inputdata.;
    class &ind_var.;
    model &dep_var. = &ind_var.;
    lsmeans &ind_var. / PDIFF ADJUST=TUKEY;
  run;
  title; *close title;

%mend multifactor_analysis;

/* Run macro using default parameters */
%multifactor_analysis;

/* Run with adjustments to specific keyword parameters */
%multifactor_analysis(inputdata=input1, ind_var=ind_var1);
%multifactor_analysis(inputdata=input2, ind_var=ind_var2);

ods graphics off; *return to default setting;
