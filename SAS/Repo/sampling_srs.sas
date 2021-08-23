* Simple Random Sampling;
%let INPUT_DATA = INPUT_DATA;
TITLE "Simple Random Sampling - First Sample";
Proc SurveySelect
	Data= &INPUT_DATA. /* Input dataset name */
	Out= &INPUT_DATA._1 /* Output dataset name */
	Method= SRS /* Selection of sampling method */
	Sampsize= 500 /* Selection of sample size */
	Seed= 13571; /* Selection of random number to duplicate sample */
Run; 
TITLE;
