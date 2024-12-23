/* local Macro*/

%let root="C:\Users\GEORGE JENIF\Downloads\drug";

/*Importing*/


%macro SDTM (Domain= ) ;

PROC IMPORT DATAFILE= "&root.\&domain..xlsx"
            DBMS=XLSX OUT= SDTM.&domain  ;
     GETNAMES=YES;
RUN;

%mend SDTM ;

%SDTM (Domain = Drug ) ;

/*Datastep Macro*/

%macro drug(dataset,variable);
data Drug_2;
set  &dataset.;
where Reviews>=70 AND Reviews<=100;
%mend drug();
%drug(drug, reviews);

