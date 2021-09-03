/* Calculate mean values after removing outliers (1 and 99 percentiles) */

%macro mean_by_segment(input_data, var, segment, out);
    proc sort out=&out._ranks data=&input_data.(keep=&segment. &var.);
        by &segment.;
        where &var. ne .;
    run;

    proc rank data=&out._ranks out=&out._pctl(where=(pctle not in (0,99))) groups=100;
        by &segment.;
        ranks pctle;
        var &var.;
    run;

    proc means data=&out._pctl nway noprint;
        by &segment.;   
        var &var.;
        output out=&out. mean=avg; 
    run;
%mend;

%mean_by_segment(input_data, balance, county, county_avg);
