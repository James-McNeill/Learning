*
Computing a one year migration matrix
https://communities.sas.com/t5/SAS-IML-Software-and-Matrix/Computing-1-year-migration-matrix/td-p/339877
;

data Bonds;
length rating next_rating $7;
input bond_id rating $ start_year end_year current_year next_rating $;
datalines;
1   a        2000  2004  2000 a
1   a        2000  2004  2001 a
1   a        2000  2004  2002 a
1   a        2000  2004  2003 a
1   a        2000  2004  2004 b
1   b        2005  2008  2005 b
1   b        2005  2008  2006 b
1   b        2005  2008  2007 b
1   b        2005  2008  2008 c
1   c        2009  2010  2009 c
1   c        2009  2010  2010 default
2   b        2003  2005  2003 b
2   b        2003  2005  2004 b
2   b        2003  2005  2005 a
2   a        2006  2007  2006 a
2   a        2006  2007  2007 default
3   c        2001  2006  2001 c
3   c        2001  2006  2002 c
3   c        2001  2006  2003 c
3   c        2001  2006  2004 c
3   c        2001  2006  2005 c
3   c        2001  2006  2006 default
;
run;

proc iml;
	use Bonds;
	read all var {bond_id rating next_rating};
	close;

	R = unique( rating //  next_rating );
	numR = ncol(R);
	C = j(numR, numR, 0);
	mattrib C rowname=R colname=R;

	do i = 1 to numR;
	   do j = 1 to numR;
	      C[i,j] = sum( rating=R[i] & next_rating=R[j] );
	   end;
	end;
	/* data does not contain any information about default transitions. 
	   Assume default is end state */ 
	C['default','default'] = 1; 

	C = C / C[,+];  /* divide each row by sum of row */
	print C[format=fract20.];
run;
