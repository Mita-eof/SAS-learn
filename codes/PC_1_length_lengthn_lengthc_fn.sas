/* The LENGTH, LENGTHN, and LENGTHC Functions 
1.LENGTHC function- returns the storage length of character variables(counts leading and trailing blanks)
2.LENGTH and LENGTHN - both return the length of a character variable not counting Trailing Blanks,but counts leading blanks.
NOTE:The only difference between LENGTH and LENGTHN is that LENGTHN returns a 0 for a null string 
    while LENGTH returns a 1. */

data how_long;
	one = ' ABC ';
	two = ' '; /* character missing value */
	three = 'ABC XYZ ';
	length_one = length(one);
	lengthn_one = lengthn(one);
	lengthc_one = lengthc(one);
	length_two = length(two);
	lengthn_two = lengthn(two);
	lengthc_two = lengthc(two);
	length_three = length(three);
	lengthn_three = lengthn(three);
	lengthc_three = lengthc(three);
run;
title "Listing of Data Set HOW_LONG";
proc print data=how_long noobs;
run;