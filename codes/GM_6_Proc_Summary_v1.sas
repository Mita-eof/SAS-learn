%macro Ncount (_inds =, _var= );
    options mprint mlogic symbolgen;
    %global _gvar list cnt n1 n2;
    %let _gvar = &_var.;
    proc sql ;
          select distinct (&_gvar.) into : list separated by '"*"'
          from &_inds.;
    quit;
    %put &list;
    
    %let cnt = %sysfunc(countw(&list,'"*"'));
    %put &cnt;
    
    %let list = "&list";
    %put &list;
    /*
    %let delims = '",';
    %let cnt = %sysfunc(countw(&list,&delims));
    %put &cnt;*/
    
    
    proc sql;
         %do i = 1 %to &cnt;
              select count(&_gvar.) into : n&i. from &_inds. where &_gvar. = "%sysfunc(scan(&list,&i,"*"))";
         %end;
    quit;
    
    %put &list &cnt &n1 &n2;

%mend;
*%Ncount(_inds = stat1.safety, _var = region);


%macro g_count (_inds=, _ouds=, _var=, _varfmt=, _whe=, pct ="Y");
    %let _dacnt1=%sysfunc(tranwrd(&_ouds, %str(~), %str( )));
    %let _dacnt = %sysfunc(countw(&_dacnt1));
    
    %do _ij=1 %to &_dacnt;
        %let _newinds = %scan(&_inds, &_ij, %str(~));
        %let _newouds = %scan(&_ouds, &_ij, %str(~));
        %let _newvar = %scan(&_var, &_ij, %str(~));
        %let _newfmt = %scan(&_varfmt, &_ij, %str(~));
        %let _newwhe = %scan(&_whe, &_ij, %str(~));
        
        %if &_newvar ne "" %then
           %do;
        
              proc summary data=&_newinds completetypes nway;
              %if &_newfmt ne %then
                %do;
                   format &_newfmt;
                   class &_newvar /preloadfmt;
                %end;
              %else %if &_newfmt eq %then
                %do;
                   class &_newvar;
                %end;
        
             %if &_newwhe ne %then
                %do;
                   where &_newwhe;
                %end;
             output out=&_newouds;
             run;
    
         %end;
    %end;
    
    %if &pct = "Y" %then %do;
         %Ncount(_inds = stat1.safety, _var = region);
    
         data &_newouds;
         set &_newouds;
         if _freq_ ne 0 then do;
            %do i = 1 %to &cnt;
            if &_gvar = "%sysfunc(scan(&list,&i,"*"))" then
            cntpct = strip(put(_freq_,best.))||"/"||strip(put(&&n&i.,best.))||" ("||strip(put((_freq_/&&n&i.)*100,7.1))||"%)";
           %end;
         end;
         else do;
           cntpct = "0";
         end;
         if index(scan(cntpct,2,"("),"100.0")>0 then cntpct = tranwrd(cntpct,"100.0","100");
         run;
    %end;
    

%mend g_count;
 
%g_count (_inds=stat1.safety, _ouds=safe, _var= Region Type, pct = "Y");

/*

%macro pct;
data safe1;
set safe;
if _freq_ ne 0 then do;
%do i = 1 %to &cnt;
if region = "%sysfunc(scan(&list,&i,"*"))" then
cntpct = strip(put(_freq_,best.))||"/"||strip(put(&&n&i.,best.))||" ("||strip(put((_freq_/&&n&i.)*100,7.1))||"%)";
%end;
end;
else do;
cntpct = "0";
end;
if index(scan(cntpct,2,"("),"100.0")>0 then cntpct = tranwrd(cntpct,"100.0","100");
run;
%mend;
%pct;






