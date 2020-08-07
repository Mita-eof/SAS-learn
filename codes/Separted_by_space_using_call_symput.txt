/*****Create a macro variable separated by space using call symputx
Storing and Using a List of Values in a Macro Variable***********/
data test;
input country $ 20.;
datalines;
india
pakistan
china
sri lanka
;
run;

/**************To create list of macro variable*******************************/
Data _null_;
   Set test;
   Call symputx('varname'||left(_n_), country,'G'); /*'G' indicate Global*/
Run;
%put &varname1 &varname2 &varname3 &varname4;
 
/****1.To create,Store and Using a List of Values in a Macro Variable***********/ 
data _null;
 length allvars $1000;
 retain allvars;
 set test end=eof;
 allvars = trim(left(allvars))||'*'||left(country);
 if eof then call symput('varlist', allvars);
 run;
%put &varlist;

/*****2.same can be done without creating intermediate variable***********/
options mlogic mprint symbolgen;
%let varlist =  ;/*macro variable created with a %LET statement will not
                   include any leading or trailing spaces.*/ 
data _null_;
 set test;
 call symput('varlist',trim(resolve('&varlist'))||' '||trim(country));
 run;
%put &varlist;

/*Note:The single quotation marks
are used to prevent the macro processor from resolving the argument before or while the DATA step is compiled.*/


