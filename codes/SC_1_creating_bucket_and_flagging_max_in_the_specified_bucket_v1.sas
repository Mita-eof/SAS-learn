data have;
sub_id=1;
buck_id=1;
x=23;
output;
sub_id=1;
buck_id=1;
x=30;
output;
sub_id=1;
buck_id=1;
x=19;
output;
sub_id=1;
buck_id=3;
x=61;
output;
sub_id=1;
buck_id=2;
x=49;
output;
sub_id=1;
buck_id=2;
x=49;
output;
sub_id=1;
buck_id=2;
x=48;
output;
run;

%let input= have;

data input_0;
	set &input.;
		if x=0 then buck_id =1;
		else do;
			qou=x/30;
			if mod(x,30) ne 0 then buck_id=quo+1;
			else buck_id=quo;
		end;
		
		upper_bound = buck_id*30;
		low_bound = ((buck_id-1)*30)+1;
		
		bucket = catx("-",put(low_bound,best.),put(upper_bound,best.);

run;

proc sql;
	create table grouped as
		select sub_id,buck_id,max(x) as maxy
		from &input.
		group by sub_id,buck_id;
quit; 

data grouped_0;
	set grouped;
	flag="Y";
run;

proc sql;
	create table output as
		select a.*,b.flag
		from &input. a left join grouped_0 b
		on a.sub_id=b.sub_id and a.buck_id=b.buck_id and a.x=b.maxy;
quit;


