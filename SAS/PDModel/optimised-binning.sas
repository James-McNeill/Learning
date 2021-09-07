/*-----------------------------------------*/
/*---Step 1
Start by binning the variable IVVar into a total of NW equal-width bins using the macro
BinEqW2(). But first copy the IVVar and the DVVar into a temporary dataset to make
sure that the original dataset is not disturbed.
*/

%macro GBinBDV(DSin, IVVar, DVVar, NW, Mmax, DSGroups, DSVarMap);
/*
DSin Input dataset
IVVar Continuous variable to be binned
DVVar Dependent variable used to bin IVVar
NW Number of divisions used for initial equal-width binning
MMax Maximum number of bins
DSGroups Dataset with final groups of bins (splits)
DSVarMap Dataset with mapping rules
*/
Data Temp_D;
set &DSin (rename=(&IVVar=IV &DVVAR=DV));
keep IV DV;
run;

%BinEqW2(Temp_D, IV, &NW, Temp_B, Temp_BMap);

/*-----------------------------------------*/
/*---Step 2
Determine the count of each bin and the percentage of the DV=1 and DV=0 in each of
them.We know that the bin numbers are from 1 to NW , but some bins may be empty.
Therefore, we use macro CalcCats() to get the count of only those in the Temp_GB
dataset.
*/

%CalcCats(TEMP_B, IV_Bin, Temp_Cats);

/*-----------------------------------------*/
/*---Step 3
Next, sort Temp_Cats using IV_Bin and convert the bins to macro variables.
*/
proc sort data=Temp_Cats;
by IV_Bin;
run;

Data _null_;
set Temp_Cats;
call symput ("C_" || left(_N_), compress(IV_Bin));
call symput ("n_" || left(_N_), left(count));
call symput ("M", left(_N_));
Run;

/*-----------------------------------------*/
/*---Step 4
Calculate the count (and percentage) of DV=1 and DV=0 in each category using PROC SQL
and store the results values in the dataset Temp_Freqs.
*/
proc sql noprint;
create table Temp_Freqs (Category char(50),
DV1 num, DV0 num,
Ni num, P1 num );
%do i=1 %to &M;
select count(IV) into :n1 from Temp_B
where IV_Bin = &&C_&i and DV=1;
select count(IV) into :n0 from Temp_B
where IV_Bin = &&C_&i and DV=0;
%let p=%sysevalf(&n1 / &&n_&i);
insert into Temp_Freqs
values("&&C_&i", &n1, &n0, &&n_&i, &p);
%end;
quit;

/*-----------------------------------------*/
/*---Step 5
Create the TERM dataset to keep the terminal nodes and their category list, and initialize
the node counter. Store all the categories as a starting point.
*/

data Temp_TERM;
length node $30.;
Node='';
%do j=1 %to &M;
Node = trim(left(Node)) || " " || compress("&&C_&j");
%end;
run;

/*-----------------------------------------*/
/*---Step 6
Start the splitting loop.
*/
%let NNodes=1;
%DO %WHILE (&NNodes <&MMax);
/* Convert all the rows of the splits to macro variables,
we should have exactly NNodes of them. */
Data _Null_;
set Temp_TERM;
call symput ("L_" || left(_N_), Node );
run;
/* Loop on each of these lists, generate possible splits
of terminal nodes, and select the best split using
the GiniRatio. */
%let BestRatio =0;
%DO inode=1 %to &NNodes;
/* The current node list is &&L_&i
Using this list, get the LEFT and RIGHT categories
representing the current best split, and the
Gini measure of these children. */
%let List_L=; %let List_R=; %Let GiniRatio=;
%GSplit(&&L_&inode, Temp_Freqs, List_L, List_R, GiniRatio);
/* Compare the GiniRatio, if this one is better,
and keep a record of it. */

%if %sysevalf(&GiniRatio > &BestRatio) %then %do;
%let BestRatio=&GiniRatio;
%let BestLeft=&List_L;
%let BestRight=&List_R;
%let BestNode=&Inode;
%end;
%End; /* end of the current node list */

/* Add this split to the Temp_TERM by removing the
current node, and adding two new nodes. The contents of the new
nodes are the right and left parts of the current node. */

Data Temp_TERM;
Set Temp_TERM;
if _N_ = &BestNode Then delete;
run;

proc sql noprint;
insert into Temp_TERM values ("&BestLeft");
insert into Temp_TERM values ("&BestRight");
quit;

/* increment NNodes */
%let NNodes=%Eval(&NNodes +1);
%END; /* End of the splitting loop */


/*-----------------------------------------*/
/*---Step 7
Now we should have a set of bin groups, which we need to map to a new set of ranges
for final output and transformation of the input dataset. These new ranges will be
obtained by getting the lower and upper bounds on the smallest and largest bins in
each node. The results are stored in the output dataset DSVarMap.
*/

/* we get all the final lists from the splits */
data _NULL_;
Set Temp_TERM;
call symput("List_"||left(_N_), Node);
call symput("NSplits",compress(_N_));
run;
/* And we create the new explicit mapping dataset */
proc sql noprint;
create table &DSVarMap (BinMin num, BinMax num,
BinNo num);
quit;
%DO ix=1 %to &NSplits;
/* Get the first and last bin number from each list. */
%let First_bin=; %let Last_bin=;
/*%FirstLast(&&List_&ix, First_bin, Last_bin);*/
data _null_;
set Temp_Term;
where node = "&&List_&ix..";
call symput("First_bin", scan(node, 1));
call symput("Last_bin", scan(node, -1));
run;

/**/

/* get the outer limits (minimum first, maximum last)
for these bins */
proc sql noprint;
select BinMin into :Bmin_F from Temp_BMap
where BinNo= input(compress("&First_bin."), 8.);
select BinMax into :Bmax_L from Temp_BMap
where BinNo= input(compress("&Last_bin."), 8.);
/* Store these values in DSVarMap under the
new bin number: ix */
insert into &DSVarMap values (&Bmin_F., &Bmax_L., &ix);
quit;
%END;
/* Generate DSGroups */
data Temp_TERM;
set Temp_TERM;
first=input(scan(Node,1),F10.0);
run;
proc sort data=Temp_TERM;
by first;
run;
Data &DSGroups;
set Temp_TERM (Rename=(Node=OldBin));
NewBin=_N_;
drop first;
run;
/* Because the split number is not representative
of any specific order, we should sort them on
the basis of their values */
proc sort data=&DSVarMap;
by BinMin;
run;
/* and regenerate the values of BinNo accordingly. */
data &DSVarMap;
Set &DsVarMap;
BinNo=_N_;
run;

/*-----------------------------------------*/
/*---Step 8
Clean the workspace and finish the macro.
*/
/* clean up and finish */
/*proc datasets library = work nolist;*/
/*delete temp_b Temp_bmap Temp_cats temp_d*/
/*temp_freqs temp_gcats temp_Term;*/
/*run;quit;*/
%mend;


/*------------Application of bins---------------------*/
/*To apply the determined bins use the following macro, 
which reads the bin limits from the maps dataset and generates the new bin number in the input
dataset*/

/*The binning conditions are extracted.*/

%macro AppBins(DSin, XVar, DSVarMap, XTVar, DSout);
/*
DSin Input dataset
XVar Continuous variable to be binned
DSVarMap Dataset with mapping rules
XTVar The new transformed variable (bin numbers)
DSOut Output dataset
*/

/* extract the conditions */
data _Null_;
set &DSVarMap;
call symput ("Cmin_"||left(_N_), compress(BinMin));
call symput ("Cmax_"||left(_N_), compress(Binmax));
call symput ("M", compress(_N_));
run;

/* Then the new transformed variable is added to the output dataset.
/* now we generate the output dataset */
Data &DSout;
SET &DSin;
/* The condition loop */
IF &Xvar <= &Cmax_1 THEN &XTVar = 1;
%do i=2 %to %eval(&M-1);
IF &XVar > &&Cmin_&i AND &XVar <= &&Cmax_&i
THEN &XTVar = &i ;
%end;
IF &Xvar > &&Cmin_&M THEN &XTVar = &M;
run;
%mend;
/*-----------------------------------------*/



/*-------------Supporting Macros------------*/
%macro BinEqW2(DSin, Var, Nb, DSOut, Map);
/*
DSin Input dataset
Var Variable to be binned
Nb Number of bins
DSOut Output dataset
Map Dataset to store the binning maps
*/

/*Calculate the maximum and minimum of the variable Var, and store these values in
the macro variables Vmax and Vmin. Then calcluate the bin size BS.*/
/* Get max and min values */
proc sql noprint;
select max(&var) into :Vmax from &dsin;
select min(&Var) into :Vmin from &dsin;
run;
quit;
/* calcualte the bin size */
%let Bs = %sysevalf((&Vmax - &Vmin)/&Nb);

/*Loop on each value, using a DATA step, and assign the appropriate bin number to the
new variable &Var._Bin, that is, the original variable name postfixed Bin.*/

/* Now, loop on each of the values and create the bin
limits and count the number of values in each bin */
data &dsout;
set &dsin;
%do i=1 %to &Nb;
%let Bin_U=%sysevalf(&Vmin+&i*&Bs);
%let Bin_L=%sysevalf(&Bin_U - &Bs);
%if &i=1 %then %do;

IF &var >= &Bin_L and &var <= &Bin_U THEN &var._Bin=&i;
%end;
%else %if &i>1 %then %do;
IF &var > &Bin_L and &var <= &Bin_U THEN &var._Bin=&i;
%end;
%end;
run;

/* Finally, create a dataset to store the bin limits to use later to bin scoring views or other
datasets using the same strategy.*/

/* Create the &Map dataset to store the bin limits */
proc sql noprint;
create table &Map (BinMin num, BinMax num, BinNo num);
%do i=1 %to &Nb;
%let Bin_U=%sysevalf(&Vmin+&i*&Bs);
%let Bin_L=%sysevalf(&Bin_U - &Bs);
insert into &Map values(&Bin_L, &Bin_U, &i);
%end;
quit;

%mend;
/*****/


/*-------------Supporting Macros------------*/
%macro CalcCats(DSin, Var, DSCats);
/*
DSin Input dataset
Var Variable to calculate categories for
DSCats Output dataset with the variable categories
*/
proc freq data=&DSin noprint;
tables &Var /missing out=&DSCats.;
run;

%mend;


/*-------------Supporting Macros------------*/
%macro GSplit(Listin, DSFreqs, M_ListL, M_ListR, M_GiniRatio);
/*
Listin Input list of categories
DSFreqs Dataset containing frequencies of categories
M ListL List of categories in the left child node
M ListR List of categories in the right child node
M GiniRatio Resulting Gini ratio of this split
*/

/*Step 1
Decompose the list into the categories and put them in a temporary dataset Temp_GCats,
using the macro Decompose(). Then store these categories in a set of macro variables.
*/

/*%Decompose(&Listin, Temp_GCats);*/
data TEMP_GCats;
length category $10.;
%do i=1 %to %sysfunc(countw("&Listin."));
category = scan("&Listin.", &i., " ");
output;
%end;
run;

data _null_;
set Temp_GCats;
call symput("M",compress(_N_));
call symput("C_"||left(_N_), compress(Category));
run;

/**/
data _null_;
set &DSFreqs.;
call symput("DV1_" || left(_N_), DV1);
call symput("DV0_" || left(_N_), DV0);
call symput("Ni_" || left(_N_), Ni);
run;

/**/

/*Step 2
Start a loop to go over the categories in the list and calculate the Gini term for the
parent node.*/
proc sql noprint;
%let NL=0; %let N1=0; %let N0=0;
%do j=1 %to &M;
%let NL=%Eval(&NL+&&Ni_&j);
%let N1=%eval(&N1+&&DV1_&j);
%let N0=%eval(&N0+&&DV0_&j);
%end;
%let GL = %sysevalf(1 - (&N1 * &N1 + &N0 * &N0)
/(&NL * &NL));
quit;

/*Step 3
Loop on each possible split, calculate the Gini ratio for that split, and monitor the
maximum value and the split representing that current best split. This will be used
later as the best split for this list (terminal node).
*/
%let MaxRatio=0;
%let BestSplit=0;
%do Split=1 %to %eval(&M-1);
/* the left node contains nodes from 1 to Split */
%let DV1_L=0;
%let DV0_L=0;
%let N_L=0;
%do i=1 %to &Split;
%let DV1_L = %eval(&DV1_L + &&DV1_&i);
%let DV0_L = %eval(&DV0_L + &&DV0_&i);
%let N_L = %eval(&N_L + &&Ni_&i);
%end;
/* The right node contains nodes from Split+1 to M */
%let DV1_R=0;
%let DV0_R=0;
%let N_R=0;
%do i=%eval(&Split+1) %to &M;
%let DV1_R = %eval(&DV1_R + &&DV1_&i);
%let DV0_R = %eval(&DV0_R + &&DV0_&i);
%let N_R = %eval(&N_R + &&Ni_&i);
%end;
%let G_L = %sysevalf(1 - (&DV1_L*&DV1_L+&DV0_L*&DV0_L)
/(&N_L*&N_L));
%let G_R = %sysevalf(1 - (&DV1_R*&DV1_R+&DV0_R*&DV0_R)
/(&N_R*&N_R));
%let G_s= %sysevalf( (&N_L * &G_L + &N_R * &G_R)/&NL);
%let GRatio = %sysevalf(1-&G_s/&GL);
%if %sysevalf(&GRatio >&MaxRatio)
%then %do;
%let BestSplit = &Split;
%let MaxRatio= &Gratio;
%end;
%end;

/*Step 4
Now that we know the location of the split, we compose the right and left lists of
categories.*/
/* The left list is: */
%let ListL =;
%do i=1 %to &BestSplit;
%let ListL = &ListL &&C_&i;
%end;
/* and the right list is: */
%let ListR=;
%do i=%eval(&BestSplit+1) %to &M;
%let ListR = &ListR &&C_&i;
%end;

/*
Step 5
Store the results in the output macro variables and finish the macro.*/
/* return the output values */
%let &M_GiniRatio=&MaxRatio;
%let &M_ListL=&ListL;
%let &M_ListR = &ListR;
%mend;
