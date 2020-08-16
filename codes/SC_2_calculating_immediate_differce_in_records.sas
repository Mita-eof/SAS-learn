/*******Problem Statement: To find temp differce by creating a new variable *************/

/************INPUT DATASET************/


data want;

date=1;temp=10;output;
date=2;temp=20;output;
date=3;temp=17;output;
date=4;temp=25;output;

run;
/*******************Method :By using DIF Function*************************************************************/

data want_1;
set want;
   delta = dif(temp);
run;

/*******************Method :By using LAG Function*************************************************************/

data want_2;
set want;
  delta = lag(temp);
  diff=temp-delta;
run;

/********************Method :BY creating new variable before set statement***********************************/
data want_3;

new_var=temp;
 
set want;

 diff=temp-new_var;
run;
 

/**********************Method :BY using retain statement******************************************************/
data want_4;
set want;

retain new_var;                    /*NOTE :1. We always RETAIN newly created variable only
                                           2: whenever datastep iteration is done all the values 
                                              of variables are set to missing except for the variable,which is reatined(means it is not reinitialized)*/
if _N_ = 1 then dif = . ;
else dif = temp - new_var ;

 new_var = temp;

run;

/* DRY RUN 
1 10  .  10
2 20  10 20
3 17  -3 17
4 25  8  25     */
 
