/* Input : Multiple ADYs across Sub_IDs */
/* Output : Creation of Buckets(0-30,31-60,91-120,....) for ADYs and Flag for Highest ADY in a bucket */

data have;
sub_id=1;
ady=23;
output;
sub_id=1;
ady=30;
output;
sub_id=1;
ady=19;
output;
sub_id=1;
ady=61;
output;
sub_id=1;
ady=49;
output;
sub_id=1;
ady=49;
output;
sub_id=1;
ady=48;
output;
sub_id=2;
ady=675;
output;
sub_id=2;
ady=98;
output;
sub_id=2;
ady=0;
output;
sub_id=2;
ady=60;
output;
sub_id=2;
ady=60;
output;
sub_id=2;
ady=120;
output;
sub_id=2;
ady=61;
output;
sub_id=2;
ady=89;
output;
run;

options mlogic symbolgen mprint;
/*  */
/* %let input = have; */
/* %let output = output; */
/* %let bcks = 30; */
/* %let ancl = ady; */
/* %let bckcl = %sysfunc(catx(_,&ancl.,bucket)); */
/* %put &bckcl.; */

%macro bucket_flg( input = , output = , bcks= , ancl=   );

%let bckcl = %sysfunc(catx(_,&ancl.,bucket));

data input_0(drop = quo low_bound upper_bound );
	set &input.;
		if &ancl.=0 then buck_id = 1;
		else do;
			quo=int(&ancl./&bcks.);
			if mod(&ancl.,&bcks.) ne 0 then buck_id=quo+1;
			else buck_id=quo;
		end;
		
		upper_bound = buck_id*&bcks.;
		if buck_id=1 then low_bound=0;
		else do ;
		low_bound = ((buck_id-1)*&bcks.)+1;
		end;
		&bckcl. = catx("-",put(low_bound,best.),put(upper_bound,best.));
run;
proc sql;
	create table grouped as
		select sub_id,buck_id,max(&ancl.) as maxy
		from input_0
		group by sub_id,buck_id;
quit; 
data grouped_0;
	set grouped;
	flag="Y";
run;
proc sql;
	create table &output. ( drop = buck_id) as
		select a.*,b.flag
		from input_0 a left join grouped_0 b
		on a.sub_id=b.sub_id and a.buck_id=b.buck_id and a.&ancl.=b.maxy;
quit;

%mend bucket_flg;

%bucket_flg( input = have, output = output, bcks= 30, ancl= ady  );


