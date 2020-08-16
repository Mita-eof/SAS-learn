
/***to calculate no of unique values and creating list of unique values***********/

data test;
   input country $;
   datalines;
India
Pakistan
Srilanka
India
India
Pakistan
;
run;

options mprint mlogic symbolgen;
%macro test1(in=,var=country);
   %global c1 c2 c3;
   proc sql;
/* create table test1 as  */
    select count(distinct &var)  into:c1
    from &in;

    select &var,count(&var)  into :c2 separated by "*",
                              :c3 separated by " "
                                
     from &in
    group by &var;
quit;

%mend test1;

%test1 (in=test);
%put &c1 &c2 &c3;

