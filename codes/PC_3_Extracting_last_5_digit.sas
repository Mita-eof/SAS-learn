data test;
input numbr $20.;
datalines;
897908
899890

00087000
09775
;
run;

/* When you apply SUBSTR() function in case of missing cases, it returns a note in log 'Invalid second argument' */
/* we can use SUBSTRN() which handles missing cases while extracting. */

data test1;
set test;
    num=substrn(numbr,length(numbr)-4);
    string=prxchange('s/.*(\d{5})/$1/',-1,strip(numbr));
run;
