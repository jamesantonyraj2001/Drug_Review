
/*Importing External files*/

proc import datafile="C:\Users\GEORGE JENIF\Downloads\drug\drug.csv" out=drug_review DBMS=csv;
run;

proc print data=drug_review;
run;

/*proc sql;*/
/*drop table Drug_review;*/
/*run;*/

/*Checks Dataset Variable Type*/
proc contents data=drug_review;
run;

/*Sorting a data based reviews variable by DESC*/
proc sort data=drug_review out=reviews_data;
by descending reviews;
run;

proc print data=reviews_data;
run;

/*Removing Missing OBS and "Reviews Character"*/
data reviews_1;
set reviews_data;
drop Indication;
Reviews=compress(reviews,"Reviews");/*Remove "Reviews" String*/
if nmiss(of _numeric_) = 0 and cmiss(of _character_) = 0;
run;

proc print data=reviews_1;
run;

data reviews_2;
set reviews_1;
/*where type="RX";*/
/*if Reviews="995 Reviews" then output A;else output B;*/
/*if a and b;*/
Reviews1=input(compress(Reviews), best12.);
run;

proc print data=reviews_2;run;

data reviews_3;
set reviews_2;
drop reviews;
Rename Reviews1=Reviews;
run;
proc print data=reviews_3;run;

proc contents data=reviews_3;run;

/*data A B reviews_4;*/
/*set reviews_3;*/
/*if Reviews>=100 then output A;else output B;*/
/*run;*/
/**/
/*proc print data=B;*/
/*run;*/

/*proc contents data=reviews_3;*/
/*run;*/


/*Removing Discrepency*/
proc sort data=reviews_3 nodup dupout=smiliar_data out=reviews_data_4;
by condition drug;
run;

/*data A B reviews_4;*/
/*set reviews_3;*/
/*if Reviews>=100 then output A;else output B;*/
/*run;*/

/*data High_reviews;*/
/*set reviews_data_4;*/
/*length Rating $20.;*/
/*if Reviews>=100 AND Reviews<=500 then Rating="Average";*/
/*else if Reviews>=500 then Rating="High";*/
/*else if Reviews<=100 then Rating="Low";*/
/*run;*/
/**/
/**/
/*proc print data=High_reviews;*/
/*run;*/
/*Which drug Effective bsd on rating*/
/*proc sql;*/
/*select drug,effective,Rating*/
/*from High_reviews*/
/*group by Rating*/
/*order by effective;*/
/*quit;*/

/*Which drug EaseOfUse*/

/*proc sql;*/
/*select drug,EaseOfUse,Rating*/
/*from High_reviews*/
/*group by Rating*/
/*order by EaseOfUse;*/
/*quit;*/



/*Overall Satisfaction*/
/*proc sql;*/
/*select Satisfaction,Rating*/
/*from High_reviews*/
/*group by Rating*/
/*order by Satisfaction;*/
/*quit;*/

/*Which drug has more review*/
/*proc sql;*/
/*select condition,drug,count(Reviews) as Drug_review, max(reviews) as max_reviews*/
/*from reviews_data_4*/
/*group by drug*/
/*order by drug;*/
/*quit;*/


/*After Sorting dataset by drug & reviews*/
/*proc sort data=reviews_data_4 out=reviews_data_5;*/
/*by Reviews;*/
/*run;*/
/**/
/**/
/*proc print data=reviews_data_5;*/
/*run;*/

/*proc print data=smiliar_data;*/
/*run;*/


/*Finding N and MIN and MAX*/
proc means data=reviews_data_4;
by condition drug;
/*class drug;*/
var reviews effective EaseOfUse satisfaction;
output out= drug_stat;
run;
/*Sorting by condition & drug AESC*/
proc sort data=drug_stat out=drug_stat1;
by condition drug;
run;
/*After KEEP These Variables*/
/*data drug_stat2;*/
/*set drug_stat1;*/
/*keep condition drug _STAT_ Reviews effective EaseOfUse satisfaction;*/
/*where _STAT_ IN("N","MAX","MIN");*/
/*run;*/

/*Keep only N MAX MIN STAT*/
data drug_stat2;
set drug_stat1;
keep condition drug _STAT_ Reviews effective EaseOfUse satisfaction;
where _STAT_ IN("N","MAX","MIN");
run;

/**/
proc print data=drug_stat2;
run;
/*Sorting the COndition _STAT_*/
proc sort data=drug_stat2 out=drug_stat3;
by Condition _STAT_;
run;

proc print data=drug_stat3;
run;


data high_rating;
page_brk=ceil((_N_/10));
set drug_stat3;
/*Rating=round((Reviews/1000)*10);*/
run;

proc print data=high_rating;
run;

/*data high_rating;*/
/*page_brk=ceil((_N_/10));*/
/*set drug_stat3;*/
/*Rating=round((Reviews/1000)*10);*/
/*LENGTH MReview $10.;*/
/*LENGTH ERa $10.;*/
/*LENGTH D_E_U $10.;*/
/*LENGTH Sat_B_R $20.*/
/*IF _STAT_="N" AND  REVIEWS>=5 THEN MReview="More Review";*/
/*IF Rating>=5 AND Effective>=3.5 then ERa="Effective Drug";*/
/*IF EaseOfUse>=3.5 AND Rating>=500 then D_E_U="Ease of Use Drug";*/
/*IF Satisfaction>=3.5 AND Rating>=500 then Sat_B_R="Ease of Use Drug";*/
/*run;*/

/*proc means data=high_rating;*/
/*class _STAT_ condition drug;*/
/*var satisfaction EaseOfUse effective Reviews Rating;*/
/*output out=high_rating1;*/
/*run;*/
/**/
/*data high_rating2;*/
/*set high_rating1;*/
/*run;*/

/*proc print data=high_rating2;run;*/
/*Report Generation*/
ods excel file="C:\Users\GEORGE JENIF\Downloads\drug\drug.xls";
proc report data=high_rating;
column page_brk _STAT_ condition drug satisfaction EaseOfUse effective Reviews Rating;
define page_brk /display ;
define _STAT_ / Display "MAX & MIN of Drug";
define conditon / group ;
define drug / Display ;
define Reviews / Display "More Reviews";
define effective / Display "Effective Drug";
define EaseOfUse / Display "EaseOfUse Drug";
define Satisfaction / Display "Overall Satisfaction";
define Rating / Display;
run;
ods excel close;
