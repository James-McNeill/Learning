/* Create a property valuation map of Ireland */

*Calc data contains the valuation age banding;
proc means data = calc median mean maxdec=1;
var val_age_band;
class county /*band*/ /*INDEX_NEW_NUTS3*/;
output out = age_cnty (where=(_type_=1 and _stat_ = "MEAN"));
run;


proc sql;
  create table temp_2_maps as
  select A.*, B.IDNAME, B.ID 
  from work.age_cnty A inner join maps.ireland2 B
  on upcase(strip(A.drv_county)) = upcase(strip(B.IDNAME));
quit;


pattern1 v=s c=cxC51B7D; 
pattern2 v=s c=cxE9A3C9; 
pattern3 v=s c=cxFDE0EF; 
pattern4 v=s c=cxE6F5D0; 
pattern5 v=s c=cxA1D76A; 
pattern6 v=s c=cx4D9221; 

legend1 label=(position=top "Mean Valuation Age");

proc gmap data=temp_2_maps map=maps.ireland;
  id id;
  choro val_age_band / levels=6 legend=legend1;
  note 'Valuation Age Band Price' j=l ' Republic of Ireland';
run;
