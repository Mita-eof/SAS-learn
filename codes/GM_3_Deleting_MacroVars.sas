/********************************Deleting all global macro variable ******************************/
%put _user_;

%macro deleteALL;

    options nonotes;

    %local vars;

    proc sql ;
             select name into: vars separated by ' '
              from dictionary.macros
                      where scope='GLOBAL'
               and not name contains 'SYS_SQL_IP_';
    quit;

    %symdel &vars;

    options notes;

        %put NOTE: Macro variables deleted.;

%mend deleteALL;

%deleteall
%put _user_;