/*****to count no of observation in a table*********************/
/***Method_1 : Using Proc Sql Count (Not Efficient)*****/

proc sql;
 select count(*) as N from sashelp.cars;
quit;

/*Note:It returns all rows (missing plus non-missing rows) in a dataset.*/

/***Method_2  a: Using Descriptor Portion (Efficient)***/

data _NULL_;
 if 0 then set sashelp.cars nobs=n;
 put "no. of observations =" n;
 stop;
run;

/*Note: The 'if 0' statement  does not process at execution time because 
IF statement does not hold TRUE. The whole IF THEN statement is used 
to pull the header information of the data set and later hand over to the
 compiler to adjust it to the PDV.
 The STOP statement is used to stop an endless loop.*/
 
 /***Method_2  b: Using Descriptor Portion (Efficient)***/
 
 data _NULL_;
 if 0 then set sashelp.cars nobs=n;
 call symputx('totobs',n);
 stop;
run;
%put no. of observations = &totobs;

/***Method_3 :Proc SQL Dictionary Method (Efficient)****/

proc sql noprint;
 select nobs into :totobs separated by ' ' from dictionary.tables
 where libname='SASHELP' and memname='CARS';
quit;
%put Note: total records = &totobs.;

/****Method_4 : Macro Language Method (Efficient)******/

%macro totobs(mydata);
    %let mydataID=%sysfunc(OPEN(&mydata.,IN));
    %let NOBS=%sysfunc(ATTRN(&mydataID,NOBS));
    %let RC=%sysfunc(CLOSE(&mydataID));
    &NOBS
%mend;
%put %totobs(sashelp.cars);

/****Method_5 : to count no of rows using datastep******/
data _null_;
 set test nobs=total;
   call symputx('totvar', total);
run;
%put Note:  totvar=&totvar;

/****To Check whether dataset is empty or not*****/
    /***without macro***/
	
data _NULL_;
  if 0 then set sashelp.cars nobs=n;
  if n = 0 then put 'empty dataset';
  else put 'Not empty. Total records=' n;
  stop;
run;

   /***with macro*****/
   
%macro emptydataset (inputdata=);
data _NULL_;
 if 0 then set &inputdata. nobs=n;
 call symputx('totobs',n);
 stop;
run;
%if &totobs. = 0 %then %put Empty dataset;
%else %do;
%put TotalObs=&totobs;
%end;
%mend;


