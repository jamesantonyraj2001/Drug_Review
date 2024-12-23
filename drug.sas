/*CSV File Importing*/
proc import datafile="C:\Users\GEORGE JENIF\Downloads\drug\drug.csv" out=drug_review DBMS=csv;
run;

proc print data=drug_review (obs=5);
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

data a reviews_2 (rename=(reviews=reviews_org reviews1=Reviews));
set reviews_1;
/*where type="RX";*/
/*if type="RX" then output A;else output reviews_2;*/
/*if a and b;*/
Reviews1=input(compress(Reviews), best12.);
drop reviews_org;
/*rename reviews=reviews_org reviews1=Reviews;*/
run;

proc print data=reviews_2;
run;

proc contents data=reviews_2;
run;



/*Removing Discrepency*/
proc sort data=reviews_1 nodup dupout=smiliar_data out=reviews_data_2;
by condition;
run;

/*After Sorting dataset by drug & reviews*/
proc sort data=reviews_data_2 out=reviews_data_3;
by condition reviews;
run;

proc print data=reviews_data_3;
run;

proc print data=smiliar_data;
run;
proc means data=reviews_data_3;
by condition;
class drug;
var reviews_drugs;
run;

proc sql;
select condition,drug,count(Reviews) as Drug_review
from reviews_data_3
group by drug
order by Drug_review desc;
quit;

%let root="C:\Users\GEORGE JENIF\Downloads\drug";



%macro CDM (Domain= ) ;

PROC IMPORT DATAFILE= "&root./data/data_excel/CDM/&domain..xlsx"
            DBMS=XLSX OUT= CDM.&domain  ;
     GETNAMES=YES;
RUN;

%mend CDM ;

%CDM (Domain = DRUG ) ;


%macro drug(dataset,variable);
data &dataset.;
set  &dataset.;
where Reviews>=70 AND Reviews<=100;
%mend drug();
%drug(drug, reviews);
