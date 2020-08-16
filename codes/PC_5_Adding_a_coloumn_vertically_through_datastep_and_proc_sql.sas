/********Testing of: Adding a coloumn vertically through datastep and proc sql*********/

data want;
	input id name $ marbles pen;
	datalines;
1 mita 10 55
2 sita 20 88
3 ram  20 07
4 shyam 60 20
;
run;

data test_1;
	if _n_=1 then
		do;

			do i=1 to n;
				set want nobs=n;
				total + marbles;
			end;
		end;
	set want;
	ratio=marbles/total;
run;

proc sql;
	create table test_2 as select id, marbles, pen, marbles+pen , sum(marbles, pen), 
		sum(marbles+pen) as total from want;
quit;