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
if EaseOfUse = . ;
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

/*Removing Discrepency*/
proc sort data=reviews_3 nodup dupout=smiliar_data out=reviews_data_4;
by condition drug;
run;

data reviews_data_5;
set reviews_data_4;
Rating=Satisfaction;
run;

/*More reviews drug*/
proc sql outobs=1;
create table More_reveiw as
select condition,drug,max(reviews) from reviews_data_5
group by condition
order by reviews desc;
quit;



/*Effective based on Rating*/
proc sql outobs=1;
create table Effect_bsd_Rat as
select condition,drug,effective,
mean(rating) as avg_rating,
mean(easeofuse) as avg_easeofuse,
mean(effective) as avg_effective
from reviews_data_5
group by drug
order by avg_rating desc;
quit;

/*EaseOfUse*/
proc sql;
create table EaseOfUse_drug as
select condition,drug, easeofuse
from reviews_data_5
where easeofuse > 4; 
quit;

/* Calculate satisfaction scores grouped by both drug and condition */
proc sql;
create table Overall_satis as
select condition, drug,
mean(satisfaction) as avg_satisfaction,
sum(Reviews) as total_reviews
from reviews_data_5
group by drug, Condition
order by avg_satisfaction desc;
quit;

%macro print(datasets);
ods pdf file="C:\Users\GEORGE JENIF\Downloads\drug\&datasets.pdf";
proc print data=&datasets.;
run;
ods pdf close;
%mend print;
%print(More_reveiw);
%print(Effect_bsd_Rat);
%print(EaseOfUse_drug);
%print(Overall_satis);


%macro sort(datasets1,datasets2);
proc sort data=&datasets1. out=&datasets2.;
by condition drug;
run;
%mend sort;

%sort(More_reveiw,More_reveiw1);
%sort(Effect_bsd_Rat,Effect_bsd_Rat1);
%sort(EaseOfUse_drug,EaseOfUse_drug1);
%sort(Overall_satis,Overall_satis1);

data drug;
set More_reveiw1 Effect_bsd_Rat1 EaseOfUse_drug1 Overall_satis1;
by condition drug;
drop _TEMG001;
run;

proc print data=drug;run;

ods pdf file="C:\Users\GEORGE JENIF\Downloads\drug\drug.pdf";
proc report data=drug;
column Condition Drug Effective EaseOfUse avg_rating avg_easeofuse avg_effective avg_satisfaction total_reviews;
define Condition / Group;
define Drug / Display ;
define Effective / Display ;
define avg_rating / Display "Rating";
define avg_easeofuse / Display "Drug EaseOfUse";
define avg_effective / Display "Drug Effective";
define EaseOfUse / Display;
define avg_satisfaction / Display format=8.1 "Over all Satisfaction";
define total_reviews / Display "More Reviews";
run;
ods pdf close; 
/* Print the results */
/*proc print data=satisfaction_by_condition;*/
/*   title "Average Satisfaction and Reviews by Drug and Condition";*/
/*run;*/




