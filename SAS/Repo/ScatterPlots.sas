/*
The SGSCATTER procedure
http://support.sas.com/documentation/cdl/en/grstatproc/62603/HTML/default/viewer.htm#sgscatter-chap.htm
*/

*Creating a scatter plot matrix;
proc sgscatter data=sashelp.iris;
  title "Scatterplot Matrix for Iris Data";
  matrix sepallength petallength sepalwidth petalwidth
         / group=species;
run;

*Creating a graph with multiple independent scatter plots and spline curves;
proc sgscatter data=sashelp.iris(where=(species="Virginica"));
  title "Multi-Celled Spline Curve for Species Virginica";
  plot (sepallength sepalwidth)*(petallength petalwidth)
       / pbspline;
run;

*Creating a simple comparative panel;
proc sgscatter data=sashelp.iris;
  title "Iris Data: Length and Width";
  compare x=(sepallength petallength)
          y=(sepalwidth petalwidth)
          / group=species;
run;

*Creating a comparative panel with regression fits and confidence ellipses;
proc sgscatter data=sashelp.iris(where=(species="Versicolor"));
  title "Versicolor Length and Width";
  compare y=(sepalwidth petalwidth)
          x=(sepallength petallength)
          / reg ellipse=(type=mean) spacing=4;
run;

proc sgscatter data=sashelp.iris(where=(species="Setosa"));
  title "Setosa Length and Width";
  compare y=(sepalwidth petalwidth)
          x=(sepallength petallength)
          / reg ellipse=(type=mean) spacing=4;
run;
