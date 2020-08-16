/*Problem:To concatenate only captital letters of name column delimited by '-'  
Restriction-this code only works for first three capital words found in name   */


data have;
input name $ 50.;
datalines;
MitaSingh              
DrKabirSingh
AbhiKrSharma
AmIoRlKu
;
run;
/*output:M-S*/

/*data want;
set have;
x=substr(name,1,anyupper(name,2)-1);
y=substr(name,anyupper(name,2),anyupper(name,3)-1);
run;*/

data want;
set have;

    Pone = anyupper(name,1);
    
    char1 = substr(name,pone,1);
    
    Ptwo= anyupper(name,pone+1);
    
    char2 = substr(name,ptwo,1);
    
    pthree = anyupper(name,ptwo+1);
    
    char3 = substr(name,pthree,1);
    
    sht = catx('-',char1,char2,char3);
run;
/*****Substituting values of pone,ptwo,pthree in char1,char2,char3 respectively**********/
data want;
set have;
    char1=substr(name,anyupper(name,1),1);
    char2=substr(name,anyupper(name,anyupper(name,1)+1),1);
    char3=substr(name,anyupper(name,anyupper(name,anyupper(name,1)+1)+1),1);
    sht= catx('-',char1,char2,char3);
    /*other way to find sht:by substituting values of char1,char2,char3 values respectively*/
    sht1 = catx('-',substr(name,anyupper(name,1),1),substr(name,anyupper(name,anyupper(name,1)+1),1),substr(name,anyupper(name,anyupper(name,anyupper(name,1)+1)+1),1));
run;
