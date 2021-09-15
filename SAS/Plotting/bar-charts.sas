/*
How to make a cluster grouped bar chart graph
https://blogs.sas.com/content/sascom/2011/08/22/how-to-make-a-cluster-grouped-bar-chart-graph-using-sas-sg-procedures/
*/

*Basic bar chart;
title 'Actual Sales by Product';
proc sgplot data=sashelp.prdsale;
  vbar product / response=actual stat=sum nostatlabel;
  xaxis display=(nolabel);
  yaxis grid;
  run;


*Stacked group by bar chart;
title 'Actual Sales by Product and Year';
proc sgplot data=sashelp.prdsale;
  vbar product / response=actual stat=sum group=year nostatlabel;
  xaxis display=(nolabel);
  yaxis grid;
  run;

*Clustered group by bar chart (SAS 9.2);
title 'Actual Sales by Product and Year';
proc sgpanel data=sashelp.prdsale;
  panelby product / layout=columnlattice onepanel
          colheaderpos=bottom rows=1 novarname noborder;
  vbar year / group=year response=actual stat=sum group=year nostatlabel;
  colaxis display=none;
  rowaxis grid;
  run;

*Cluserted group by bar chart (SAS 9.3);
/*title 'Actual Sales by Product and Year';*/
/*proc sgplot data=sashelp.prdsale;*/
/*  vbar product / response=actual stat=sum group=year nostatlabel*/
/*         groupdisplay=cluster;*/
/*  xaxis display=(nolabel);*/
/*  yaxis grid;*/
/*  run;*/
