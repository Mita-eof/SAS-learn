/********** Macros for macrotizing basic code************/
options mlogic mprint symbolgen;

data want;
	set stat1.safety;

	if upcase(type)="SPORT/UTILITY" then
		type="sportu";

	if upcase(region)="N AMERICA" then
		region="namerica";
run;

/*proc sort data=want;
by region;
run; */
%macro rec_cnt_v1(ds=);
	proc sql;
		select count(*) into : n from want;
	quit;

	data _null_;
		if 0 then
			set &ds nobs=cnt;
		call symputx('count', cnt);
		stop;
	run;

%mend rec_cnt_v1;

%macro rec_cnt_v2(ds=);
	proc sql;
		select count(*) into : n from want;
	quit;

	data _null_;
		if 0 then
			set &ds nobs=cnt;
		call symputx('count', cnt);
		stop;
	run;

	&cnt
	
%mend rec_cnt_v2;
	%put &n;

	%macro freq (in=, out=, tabl=, by=, cl=, by_tra=, var=, id=, ar_old=, ar_new=);

		%if condition %then
			%do;

				proc sort data=&in out=&out.1;
					by &by;

				run;

				proc freq data=&out.1;
					tables &tabl /out=&out.2;
					by &by;
				run;

				proc summary completetypes data=&out.1 nway;
					class &cl;
					output out=&out.3_1;
				run;

				proc transpose data=&out.3_1 out=&out.4;
					by &by_tra;
					var &var;
					id &id;
				run;

				data &out;
					/*new*/
					set &out.4;
					length &ar_new $20.;
					array old &ar_old;
					array new $ &ar_new;

					do i=1 to dim(old);
						*if old{i} ne  . then new[i]=old{i}/&n;
						new[i]=strip(put(old{i}, 
							best.))||"/"||strip("&n")||" ("||strip(put((old{i}/&n), best.))||"%)";
					end;
				run;

			%end;
		%else
			%do;
				%put ;
			%end;
	%mend;

	%freq (in=want, out=xyz, tabl=unsafe , by=type, cl=unsafe type, by_tra=unsafe, 
		var=_freq_, id=type, ar_old=large medium small sportu sports, ar_new=col1 
		col2 col3 col4 col5);
	%freq (in=want, out=abc, tabl=unsafe , by=region, cl=unsafe region, 
		by_tra=unsafe, var=_freq_, id=region, ar_old=asia namerica, ar_new=col1 col2);
	
	/*data _arr;
	set wnt_trans;
	 *length col1 col2 col3 col4 col5 $20.;
	array old large medium small sportu sports;
	array new col1-col5;
	do i =1 to dim(old);
	if old{i} ne  . then new[i]=old{i}/&n;
	end;
	run;
	
	
	/**************original**************************/
	data want;
		set stat1.safety;

		if upcase(type)="SPORT/UTILITY" then
			type="sportu";
	run;

	proc sort data=want;
		by type;
	run;

	proc sql;
		select count (*) into : n from want;
	quit;

	%put &n;

	%macro freq (in=, out=, tab1=, by=, cl=, by_tra=, var=, id=, ar_old=, ar_new=);

		proc freq data=want;
			tables unsafe/out=want_freq;
			by type;
		run;

		proc summary completetypes data=want nway;
			class unsafe type;
			output out=want_summ;
		run;

		proc transpose data=want_summ out=wnt_trans;
			by unsafe;
			var _freq_;
			id type;
		run;

		data new;
			set wnt_trans;
			array old large medium small sportu sports;
			array new col1-col5;

			do i=1 to dim(old);
				new[i]=strip(put(olfd[i], 
					best.))||"/"||strip("&n")||" ("||strip(put((col[i]/&n), best.))||"%)";
			end;
		run;

	%mend;

	%freq (in=want, out=, tab1=, by=, cl=, by_tra=, var=, id=, ar_old=, ar_new=) 
		////////////***************/////////////// 
	data _arr;
	set wnt_trans;
	*length col1 col2 col3 col4 col5 $20.;
	array old large medium small sportu sports;
	array new col1-col5;
	do i=1 to dim(old);
	if old{i} ne  . then new[i]=old{i}/&n;
	end;
	run;