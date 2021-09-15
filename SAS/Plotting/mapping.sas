/* 
AIM: show the house price by the map of Ireland.
DATA: the input file will relate to the house price values by county code
    maps.ireland: relates to an internal SAS dataset that can be used to show the map of Ireland
*/

*Review the House prices by the map of Ireland;
proc means data = house_price median mean maxdec=1;
	var house_price;
	class county;
	output out = hp_cnty(where=(_type_=1 and _stat_ = "MEAN"));
run;


proc sql;
	create table temp_2_maps as
	select A.*, B.IDNAME, B.ID 
	from hp_cnty A 
	inner join maps.ireland2 B
		on upcase(strip(A.county)) = upcase(strip(B.IDNAME))
	;
quit;


pattern1 v=s c=cxC51B7D; 
pattern2 v=s c=cxE9A3C9; 
pattern3 v=s c=cxFDE0EF; 
pattern4 v=s c=cxE6F5D0; 
pattern5 v=s c=cxA1D76A; 
pattern6 v=s c=cx4D9221; 

legend1 label=(position=top "Mean House Price by County");

proc gmap data=temp_2_maps map=maps.ireland;
	id id;
	choro house_price / levels=6 legend=legend1;
	note 'House Price at sales date' j=l ' Republic of Ireland';
run;
