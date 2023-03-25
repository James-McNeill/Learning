/* Array processing with a temporary array goal */
DATA OUTPUT_DATA;
  SYSECHO "DATA OUTPUT_DATA"; *Within the bar that shows the running status of the project this statement will be added via the echo process. Similar to bash;
  SET INPUT_DATA;
  
  array filter_{8} $1.; *Creates eight array values that contain character variable format. Can add binary Y/N segmentation;
  array goal{8} _temporary_ (10 20 30 40 50 60 70 80); *Temporary array that will be shown in final output. Allows for setting of numeric goals;
  
  /* Create filter based on exposure value from goal */
  do i = 1 to 8;
    filter_[i] = "N"; *Set default value;
    if exposure > goal[i] then filter_[i] = "Y"; *Create derived variable value using if statement array processing;
  end;
  drop i; *Remove i variable from final output;
  
RUN;
