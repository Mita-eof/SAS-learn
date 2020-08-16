data test;
input name $ age $;
datalines;
John 55
Srk 55
hrithik 24
salman 8
;
run;
/************************Task-1: Demonstration of Repeat fn*********************
******IT RETURNS N+1 VALUES (n must be greater than or equal to 0)*****************************************************/
data tested;
set test;
   new_col=repeat(name,3);
run;

data one;
   x=repeat('ONE', 2);
   put x=;
run;
/*********************************REVERSE FUNCTION***********************/

data one;
   backward=reverse('xyz ');
   put backward=;
run;

DATA test1;
set test;
   backward=reverse(name);
   put backward=;
run;
/********************************text padding***********************/

proc sql;
   create table padded as
      select "MY Name is" as prefix, name,cat(calculated prefix,name) as new_name
      from test;
   create table tbl as
      select prefix,name,catx("  ",prefix,name) as concated_name
      from padded;
quit;

proc sql ;
   create table test10 as
      select "MY Name is"  || ' ' ||  name || ' '|| "and my age is" || ' ' ||age as newage
      from test;
quit;




