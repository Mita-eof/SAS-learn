/*****problem-to create a new variable on a condition :if any of a variable(either a,b or c) is missing 
then a new variable should be created conditiobally.
/********************************/

data test; /*****a= date b=month c=year******/
    infile datalines delimiter=','; 
    input a $  b $ c $;
datalines;
1,2,2019
2,7,2020
 ,7,2020
 , ,2020
 , ,2019
;
run;

data new1;
    set test;
    cmiss = cmiss(of a--c);
/*  if max(cmiss) > "0" then flag="Y";*/
run;

proc sql;
    create table new2 as
        select max(cmiss) as nomissing from new1;
quit;

%macro imputation;
    data _null_;
        set new2;
        if nomissing >0 then flag='True';
        else flag='False';
        call symputx('flag',flag);
    run;
    %put &flag;


    %if &flag=True %then %do;
        data final;
            set test;
            newvar= catx('-',a,b,c);
/*          newvar = cats(a,b,c); */
/*          if length(newvar) = 8 then newvar= ' '; */
        run;
    %end;
    %else %do;
        data final;
            set test;
        run;
    %end;

%mend imputation;
    
    
%imputation; 
    
    
    