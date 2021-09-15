/*Code is courtesy of Jeremy Keating.
Curve fitting is a useful way of smoothing development factors and of 
obtaining a tail factor for development past the end of the triangle. This code
shows how to fit an exponential decay curve, an inverse power curve and a 
lognormal distribution curve. The code can be adapted to fit any sensible curve.

Chain Ladder Method (CLM)
*/

%macro create_triangle();
Data loss_triangle; do n = 1 to &Cols.;
Col_1 = 1000 * (1 + uniform(_N_));
output;
end;
run;

data loss_triangle;
set loss_triangle;
%do currentcol = 2 %to &cols.;
%let prevcol = %eval(&currentcol. - 1);
%let middleline = %eval(&cols. - &currentcol. + 2);

if _N_ < &middleline. then
col_&currentcol. = col_&prevcol. * max(rand("normal", (1 / &currentcol.)**0.05, 1 / &currentcol.),
(1 / &currentcol.));
else col_&currentcol. = .;
%end;
run;

data cumulative_loss_triangle(drop=col:); 
set loss_triangle;
cumulative_1 = col_1;
%do currentcol = 2 %to &cols.;
%let prevcol = %eval(&currentcol. - 1);
%let middleline = %eval(&cols. - &currentcol. + 2);
if _N_ <= &middleline.
then cumulative_&currentcol. = cumulative_&prevcol. + col_&currentcol.;
else cumulative_&currentcol. = .;
%end;

%do currentcol = 1 %to &cols.;
%let middleline = %eval(&cols. - &currentcol. + 1);
if &middleline. = _N_ then paid = cumulative_&currentcol.;
%end;
run;
%mend create_triangle;


/*next obtain the development factors. 
This is set to get the weighted 12 months (var = weight) development factors 
and put them into a dataset called Development_Factors_Volume_12.*/
%macro create_development_factors();
data development_factors_volume_&weight.;
format n totalpaid comma12. df comma12.10;
STOP;
run;

%do currentcol = 1 %to &pencol.;
%let nextcol = %eval(&currentcol. + 1);

proc summary data = cumulative_loss_triangle nway missing;
var cumulative_&currentcol.;
where n >= &cols. - &currentcol. - &weight. + 1 and n <= &cols. - &currentcol.;
output out=den(drop=_:) sum=;
run;

proc summary data = cumulative_loss_triangle nway missing;
var cumulative_&nextcol.;
where n >= &cols. - &currentcol. - &weight. + 1 and n <= &cols. - &currentcol.;
output out=num(drop=_:) sum=;
run;

data num_den(drop=cumulative_&nextcol. rename=(cumulative_&currentcol. = totalpaid));
set num; set den;
df = cumulative_&nextcol. / cumulative_&currentcol.;
n = &currentcol.;
run;

proc append base=development_factors_volume_&weight. data=num_den;
run;
%end;

data development_factors_volume_&weight.;
set development_factors_volume_&weight.;
log_df = log(df - 1);
run;
%mend create_development_factors;



%let cols = 44;
%let weight = 12;
%let pencol = %eval(&cols. - 1);
%create_triangle();
%create_development_factors();


/*
Next run the below macro to obtain the cumulative development factors. 
These are used for fitting the lognormal curve to the inverse of the cumulative 
development factors. This macro is passed the name of a dataset and the column 
with the development factors. It outputs the cumulative development factors into
a field with the specified name.
*/

%macro create_cdfs(inputdataset, developmentfactors, cumulativedevelopmentfactors);
data _null_;
set &inputdataset.;
if _n_ = &pencol. then call symput("cdf_&pencol.", &developmentfactors.);
run;

%do colcounter = 1 %to %eval(&pencol. - 1);
%let currentcol = %eval(&pencol. - &colcounter.);
%let prevcol = %eval(&currentcol. + 1);

data _null_;
set &inputdataset.;
if _n_ = &currentcol.
then call symput("cdf_&currentcol.", &developmentfactors. * &&cdf_&prevcol.);
run;
%end;

data &inputdataset.;
set &inputdataset.;
%do currentcol = 1 %to &pencol.;
if _n_ = &currentcol. then &cumulativedevelopmentfactors. = &&cdf_&currentcol.;
%end;
run;
%mend create_cdfs;

%create_cdfs(development_factors_volume_&weight., df, cdf);

/*
The below code fits the three curves through the data. The curve fitting is done 
using Proc Nlin. The fitting parameters are specified on the Parameters line 
and the values of these parameters are output by the procedure into a dataset.
 weighted by the paid claims but you could weight by any other relevant factor. 
For example the claim counts or a credibility factor. To do this simply change 
the _Weight_ = statement to equal a different field. If you want an unweighted 
fit then you can delete this line.
*/

%macro create_exponential_curve();
proc nlin data=development_factors_volume_&weight.;
parameters gradient = -0.5 constant = 0;
model log_df = gradient * n + constant;
_weight_ = totalpaid;
ods output ParameterEstimates=exponential_parameters;
run;

data _null_;
set exponential_parameters(where=(parameter="gradient"));
call symput("gradient", estimate);
run;

data _null_;
set exponential_parameters(where=(parameter="constant"));
call symput("constant", estimate);
run;

data development_factors_volume_&weight.;
set development_factors_volume_&weight.;
if n ne &pencol. then df_exponentialcurve = exp(&gradient. * n + &constant.) + 1;
else df_exponentialcurve = 1 - exp(&constant. + &gradient. * &pencol.) / &gradient.;
run;
%mend create_exponential_curve;

%create_exponential_curve();

%macro create_inverse_power_curve();
proc nlin data=development_factors_volume_&weight.;
parameters gradient = -0.5 constant = 0 power = 1;
model df = 1 + gradient * (n + constant) ** -power;
_weight_ = totalpaid;
ods output ParameterEstimates=inversepower_parameters;
run;

data _null_;
set inversepower_parameters(where=(parameter="gradient"));
call symput("gradient", estimate);
run;

data _null_;
set inversepower_parameters(where=(parameter="constant"));
call symput("constant", estimate);
run;

data _null_;
set inversepower_parameters(where=(parameter="power"));
call symput("power", estimate);
run;

data development_factors_volume_&weight.;
set development_factors_volume_&weight.;
if n ne &pencol. 
then df_inversepowercurve = 1 + &gradient. * (n + &constant.) ** -&power.;
else df_inversepowercurve = 1 + (&gradient. / ((&power. + 1) 
* ((&pencol. + &constant.) ** (&power. - 1))));
run;
%mend create_inverse_power_curve;

%create_inverse_power_curve(); 

%macro create_lognormal_from_cdf_curve();
proc nlin data=development_factors_volume_&weight.;
parameters mu = 0 sigma = 0.5;
model cdf = 1 / (0.5 * (1 + erf((log(n) - mu)/((2*sigma)**0.5))));
_weight_ = totalpaid;
ods output ParameterEstimates=lognormal_cdf_parameters;
run;

data _null_;
set lognormal_cdf_parameters(where=(parameter="mu"));
call symput("mu", estimate);
run;

data _null_;
set lognormal_cdf_parameters(where=(parameter="sigma"));
call symput("sigma", estimate);
run;

data development_factors_volume_&weight.;
set development_factors_volume_&weight.;
if n ne &pencol. 
then df_lognormalcurve = (0.5 * (1 + erf((log(n+1) - &mu.)/((2*&sigma.)**0.5))))
/ (0.5 * (1 + erf((log(n) - &mu.)/((2*&sigma.)**0.5))));
else df_lognormalcurve = 1 / (0.5 * (1 + erf((log(&pencol.) - &mu.)/
((2*&sigma.)**0.5))));
run;
%mend create_lognormal_from_cdf_curve;

%create_lognormal_from_cdf_curve
