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

/*Removing Discrepency*/
proc sort data=reviews_3 nodup dupout=smiliar_data out=reviews_data_4;
by condition drug;
run;

/*proc sql;*/
/*select condition,drug,max(reviews) from reviews_data_4*/
/*group by condition*/
/*order by reviews desc;*/
/*quit;*/


/*Each Condittion records split to diffrent datasets*/
data A_D E_H I_L M_P Q_T U_V Both_type;
   set reviews_data_4;
   if upcase(substr(Condition,1,1)) in ('A', 'B', 'C', 'D') then output A_D;
   else if upcase(substr(Condition,1,1)) in ('E', 'F', 'G', 'H') then output E_H;
   else if upcase(substr(Condition,1,1)) in ('I', 'i', 'L') then output I_L;
   else if upcase(substr(Condition,1,1)) in ('M', 'N', 'O', 'P') then output M_P;
   else if upcase(substr(Condition,1,1)) in ('Q', 'R', 'S', 'T') then output Q_T;
   else if upcase(substr(Condition,1,1)) in ('U', 'V') then output U_V;
   else output Both_type;
   run;
/*Printing variable*/
%macro print(datasets);
proc print data=&datasets.;
run;
%mend print;
%print(A_D);
%print(E_H);
%print(M_P);
%print(Q_T);
%print(U_V);
%print(Both_type);

%macro sort(datasets1,datasets2,variable);
proc sort data=&datasets1. out=&datasets2.;
by descending Reviews;
run;
%mend sort;

%sort(A_D,A_D1,Reviews);
%sort(E_H,E_H1,Reviews);
%sort(I_L,I_L1,Reviews);
%sort(M_P,M_P1,Reviews);
%sort(Q_T,Q_T1,Reviews);
%sort(U_V,U_V1,Reviews);

%macro print(datasets2);
proc print data=&datasets2.;
run;
%mend print;
%print(A_D1);
%print(E_H1);
%print(M_P1);
%print(Q_T1);
%print(U_V1);


data top_drug_data1;
   set A_D1;
   if drug = "Prednisone";
run;

/* Create a report for the top drug */
proc print data=top_drug_data1;
   title "Report for Drug: Prednisone with MAX Reviews";
   var condition drug Reviews ;
run;


/* Filter the dataset for the drug with the most reviews */
data top_drug_data2;
   set E_H1;
   if drug = "Duloxetine";
run;

/* Create a report for the top drug */
proc print data=top_drug_data2;
   title "Report for Drug: Duloxetine with MAX Reviews";
   var condition drug Reviews ;
run;

data top_drug_data3;
   set M_P1;
   if drug = "Simvastatin";
run;

/* Create a report for the top drug */
proc print data=top_drug_data3;
   title "Report for Drug: Simvastatin with MAX Reviews";
   var condition drug Reviews ;
run;


data top_drug_data4;
   set Q_T1;
   if drug = "Modafinil";
run;

/* Create a report for the top drug */
proc print data=top_drug_data4;
   title "Report for Drug: Modafinil with MAX Reviews";
   var condition drug Reviews ;
run;

data top_drug_data5;
   set U_V1;
   if drug = "Tioconazole";
run;

/* Create a report for the top drug */
proc print data=top_drug_data5;
   title "Report for Drug: Tioconazole with MAX Reviews";
   var condition drug Reviews ;
run;


/*proc means data=reviews_data_4;*/
/*/*by condition drug;*/*/
/*class condition drug;*/
/*var reviews effective EaseOfUse satisfaction;*/
/*output out= drug_stat;*/
/*run;*/
/*/*Sorting by condition & drug AESC*/*/
/*proc sort data=drug_stat out=drug_stat1;*/
/*by condition drug;*/
/*run;*/
/**/
/*/*Keep only N MAX MIN STAT*/*/
/*data drug_stat2;*/
/*set drug_stat1;*/
/*keep condition drug _STAT_ Reviews effective EaseOfUse satisfaction;*/
/*where _STAT_ IN("N","MAX","MIN");*/
/*run;*/
/**/
/*/**/*/
/*proc print data=drug_stat2;*/
/*run;*/
/*/*Sorting the COndition _STAT_*/*/
/*proc sort data=drug_stat2 out=drug_stat3;*/
/*by Condition _STAT_;*/
/*run;*/
/**/
/*proc print data=drug_stat3;*/
/*run;*/
/**/
/**/
/*data high_rating;*/
/*page_brk=ceil((_N_/10));*/
/*set drug_stat3;*/
/*/*Rating=round((Reviews/1000)*10);*/*/
/*run;*/
/**/
/*proc print data=high_rating;*/
/*run;*/
 
