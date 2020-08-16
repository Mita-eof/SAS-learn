/*to extract only values ending with den (length=3)*/
data test;
input name $13.;
datalines;
mitaden
sitaden

gitahen
nitazden
;
run;

data test1;
set test;
    newvar=substrn(name,length(name)-2);
    if upcase(newvar)="DEN";
run;
/**************Macro**************************************/

options mlogic mprint symbolgen;
%macro suffx(in=,out=,var=,col=,extct=);
    data &out;
    length &var $15.;
    set &in;
       user_len=length("&extct");
       &var=substrn(&col,length(&col)-(user_len-1));
       if upcase(&var)="&extct";
    run; 
%mend suffx;

%suffx(in=test,out=test1,var=newvar,col=name,extct=%upcase(zDeN));