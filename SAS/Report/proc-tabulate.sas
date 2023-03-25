/* Tabulate to summarize report with yearly variables */
PROC TABULATE DATA=INPUT_TABLE OUT=OUTPUT_TABLE (DROP=_TYPE_ _PAGE_ _TABLE_);
  WHERE (&FILTER.); *Macro variable refering to a filter clause to be applied to the input table;
  *List of variables to be used. Variable name showing prefix with colon (:) refers to all variables with this prefix being selected;
  VAR BAL_Y0 
    CURR_BAL_Y:
    DEF_BAL_Y:
    BAL_PCT_Y:
   ;
  CLASS PORTFOLIO / ORDER=UNFORMATTED MISSING; *Classification statement is used for segmentation;
  CLASS DEF_IND / ORDER=UNFORMATTED MISSING; 
  *Table statement is used to define the structure of the output table;
  TABLE /* ROW DIMENSION - Classification variables */
    PORTFOLIO*DEF_IND,
    /* COLUMN DIMENSION - Summary variables. Similar to input list, variable prefix with colon shows list of variables to be included */
    N
    BAL_YO*Sum
    (CURR_BAL_Y:)*Sum
    (DEF_BAL_Y:)*Sum
    (BAL_PCT_Y:)*Mean
    ;
  ;
RUN;

/* Understand threshold boundaries for numeric variable */
PROC TABULATE data=input_data;
  VAR EXPOSURE; *variable to assess;
  CLASS class_var / order=unformatted missing; *classification variable;
  TABLE
    class_var,
    N exposure*(Sum min mean median max p5 p95); *range of metrics assessing method of moments and confidence intervals;
  ;
RUN;
