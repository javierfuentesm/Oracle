-- Drop the tables

drop table ALL_ORDERS;
drop table ASSEMBLY;
drop table CUSTOMER;
drop table CUST_ORDER;
drop table DEPARTMENT;
drop table EMPLOYEE CASCADE CONSTRAINTS;
drop table EMPLOYEE_EXPENSE;
drop table INVENTORY_CLASS;
drop table JOB;
drop table LINE_ITEM;
drop table LOCATION;
drop table MONTHS;
drop table MTD_ORDERS;
drop table ORDERS;
drop table PART;
drop table REGION;
drop table RETAILER;
drop table SALESPERSON;
drop table SUPPLIER;
DROP TABLE DISPUTED_ORDERS;
DROP TABLE REPORT;
DROP TABLE MONTHLY_ORDERS;
DROP TABLE SALES_HISTORY;
DROP TABLE MONTHLY_SALES_ADJUSTMENT;
DROP TABLE EMPLOYEE_COMMENT;



-- Create the tables

CREATE TABLE EMPLOYEE(
    EMP_ID            NUMBER(5)    NOT NULL,
    FNAME             VARCHAR2(20),
    LNAME             VARCHAR2(20),
    DEPT_ID           NUMBER(5)    NOT NULL,
    MANAGER_EMP_ID    NUMBER(5),
    SALARY            NUMBER(5),
    HIRE_DATE         DATE,
    JOB_ID            NUMBER(3),
    CONSTRAINT employee_pk PRIMARY KEY (EMP_ID)
);

CREATE TABLE EMPLOYEE_EXPENSE(
    EMP_ID            NUMBER(5),
    YEAR              NUMBER(4),
    MONTH             NUMBER(2),
    EXPENSE_CLAIM     NUMBER(7,2),
    APPROVED_AMT      NUMBER(7,2),
    PAID_DATE         DATE
);

CREATE TABLE DEPARTMENT(
    DEPT_ID    NUMBER(5)       NOT NULL,
    NAME       VARCHAR2(20),
    LOCATION_ID NUMBER(3),
    CONSTRAINT department_pk PRIMARY KEY (DEPT_ID)
);

CREATE TABLE JOB(
    JOB_ID    NUMBER(3) NOT NULL,
    FUNCTION  VARCHAR2(30),
    CONSTRAINT job_pk PRIMARY KEY (JOB_ID)
);

CREATE TABLE LOCATION(
    LOCATION_ID    NUMBER(3) NOT NULL,
    REGIONAL_GROUP VARCHAR2(20),
    CONSTRAINT location_pk PRIMARY KEY (LOCATION_ID)
);

CREATE TABLE CUSTOMER(
    CUST_NBR    NUMBER(5)       NOT NULL,
    NAME        VARCHAR2(30)    NOT NULL,
    REGION_ID   NUMBER(5),
    INACTIVE_DT DATE,
    INACTIVE_IND CHAR(1),
    TOT_ORDERS  NUMBER(5),
    LAST_ORDER_DT DATE,
    CONSTRAINT customer_pk PRIMARY KEY (CUST_NBR)
);

CREATE TABLE SUPPLIER(
    SUPPLIER_ID    NUMBER(5)     NOT NULL,
    NAME           VARCHAR2(30)  NOT NULL,
    CONSTRAINT supplier_pk PRIMARY KEY (SUPPLIER_ID)
);

CREATE TABLE PART(
    PART_NBR         VARCHAR2(20)        NOT NULL,
    NAME             VARCHAR2(30)        NOT NULL,
    SUPPLIER_ID      NUMBER(5)           NOT NULL,
    STATUS           VARCHAR2(20)        NOT NULL,
    INVENTORY_QTY    NUMBER(6),
    UNIT_COST        NUMBER(8,2),
    RESUPPLY_DATE    DATE,
    CONSTRAINT part_pk PRIMARY KEY (PART_NBR)
);

CREATE TABLE INVENTORY_CLASS(
    INV_CLASS    VARCHAR2(3) NOT NULL,
    LOW_COST     NUMBER(8,2),
    HIGH_COST    NUMBER(8,2),
    CONSTRAINT inv_class_pk PRIMARY KEY (INV_CLASS)
);

CREATE TABLE CUST_ORDER(
    ORDER_NBR           NUMBER(7)           NOT NULL,
    CUST_NBR            NUMBER(5)           NOT NULL,
    SALES_EMP_ID        NUMBER(5)           NOT NULL,
    SALE_PRICE          NUMBER(9,2),
    ORDER_DT            DATE                NOT NULL,
    EXPECTED_SHIP_DT    DATE                NOT NULL,
    CANCELLED_DT        DATE,
    SHIP_DT             DATE,
    STATUS              VARCHAR2(20),
    CONSTRAINT cust_order_pk PRIMARY KEY (ORDER_NBR)
);

CREATE TABLE ASSEMBLY (
    ASSEMBLY_TYPE              VARCHAR2(4) 	NOT NULL,
    ASSEMBLY_ID                NUMBER(6) 		NOT NULL,
    DESCRIPTION                VARCHAR2(20) 	NOT NULL,
    PARENT_ASSEMBLY_TYPE       VARCHAR2(4),
    PARENT_ASSEMBLY_ID         NUMBER(6),
    CONSTRAINT assembly_pk PRIMARY KEY (ASSEMBLY_TYPE, ASSEMBLY_ID)
);


CREATE TABLE RETAILER(
    RTLR_NBR             NUMBER(6)    NOT NULL ,
    NAME                 VARCHAR2(45),
    ADDRESS              VARCHAR2(40),
    CITY                 VARCHAR2(30),
    STATE                VARCHAR2(2),
    ZIP_CODE             VARCHAR2(9),
    AREA_CODE            NUMBER(3),
    PHONE_NUMBER         NUMBER(7),
    SALESPERSON_ID       NUMBER(4),
    CREDIT_LIMIT         NUMBER(9,2),
    COMMENTS             LONG,
    CONSTRAINT RETAILER_PK PRIMARY KEY (RTLR_NBR)
);

CREATE TABLE REGION(
    REGION_ID    NUMBER(5)       NOT NULL,
    NAME       VARCHAR2(20),
    SUPER_REGION_ID NUMBER(5),
    CONSTRAINT region_pk PRIMARY KEY (REGION_ID)
);

CREATE TABLE SALESPERSON(
    SALESPERSON_ID    NUMBER(5) NOT NULL,
    NAME              VARCHAR2(50) NOT NULL,
    PRIMARY_REGION_ID NUMBER(5) NOT NULL,
    CONSTRAINT salesperson_pk PRIMARY KEY (SALESPERSON_ID)
);

CREATE TABLE MONTHS(
    YEAR       NUMBER(4) NOT NULL,
    MONTH      NUMBER(2) NOT NULL,
    CONSTRAINT months_pk PRIMARY KEY (YEAR, MONTH)
);

CREATE TABLE MTD_ORDERS(
    TOT_ORDERS                  NUMBER(7) NOT NULL,
    TOT_SALE_PRICE              NUMBER(11,2) NOT NULL,
    MAX_SALE_PRICE              NUMBER(9,2) NOT NULL,
    EUROPE_TOT_ORDERS           NUMBER(7) NOT NULL,
    EUROPE_TOT_SALE_PRICE       NUMBER(11,2) NOT NULL,
    EUROPE_MAX_SALE_PRICE       NUMBER(9,2) NOT NULL,
    NORTHAMERICA_TOT_ORDERS     NUMBER(7) NOT NULL,
    NORTHAMERICA_TOT_SALE_PRICE NUMBER(11,2) NOT NULL,
    NORTHAMERICA_MAX_SALE_PRICE NUMBER(9,2) NOT NULL
);

CREATE TABLE ORDERS(
    CUST_NBR       NUMBER(5) NOT NULL,
    REGION_ID      NUMBER(5) NOT NULL,
    SALESPERSON_ID NUMBER(5) NOT NULL,
    YEAR           NUMBER(4) NOT NULL,
    MONTH          NUMBER(2) NOT NULL,
    TOT_ORDERS     NUMBER(7) NOT NULL,
    TOT_SALES      NUMBER(11,2) NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY (YEAR, MONTH, CUST_NBR, REGION_ID, SALESPERSON_ID)
);

CREATE TABLE LINE_ITEM(
    ORDER_NBR     NUMBER(9)      NOT NULL,
    PART_NBR      VARCHAR2(20)   NOT NULL,
    QTY           NUMBER(5)      NOT NULL,
    FILLED_QTY    NUMBER(5),
    CONSTRAINT line_item_pk PRIMARY KEY (ORDER_NBR,PART_NBR)
);

CREATE TABLE ALL_ORDERS(
    CUST_NBR       NUMBER(5) NOT NULL,
    REGION_ID      NUMBER(5) NOT NULL,
    SALESPERSON_ID NUMBER(5) NOT NULL,
    YEAR           NUMBER(4) NOT NULL,
    MONTH          NUMBER(2) NOT NULL,
    TOT_ORDERS     NUMBER(7) NOT NULL,
    TOT_SALES      NUMBER(11,2) NOT NULL,
    CONSTRAINT all_orders_pk PRIMARY KEY (YEAR, MONTH, CUST_NBR, REGION_ID, SALESPERSON_ID)
);


CREATE TABLE DISPUTED_ORDERS(
    ORDER_NBR           NUMBER(7)           NOT NULL,
    CUST_NBR            NUMBER(5)           NOT NULL,
    SALES_EMP_ID        NUMBER(5)           NOT NULL,
    SALE_PRICE          NUMBER(9,2),
    ORDER_DT            DATE                NOT NULL,
    EXPECTED_SHIP_DT    DATE                NOT NULL,
    STATUS              VARCHAR2(20),
    CONSTRAINT disputed_orders_pk PRIMARY KEY (ORDER_NBR)
);

CREATE TABLE REPORT (
     REPORT_ID		VARCHAR2(8),
     CREATED_BY		VARCHAR2(20),
     SENT_TO		VARCHAR2(20)
);

CREATE TABLE MONTHLY_ORDERS (
MONTH NUMBER(2) NOT NULL,
YEAR NUMBER(4) 	NOT NULL,
TOT_ORDERS 	NUMBER,
MAX_ORDER_AMT 	NUMBER,
MIN_ORDER_AMT 	NUMBER,
TOT_AMT		NUMBER
);

CREATE TABLE MONTHLY_SALES_ADJUSTMENT(
    MONTH      NUMBER(2) NOT NULL,
    FACTOR     NUMBER(3,2) NOT NULL,
    CONSTRAINT adjust_pl PRIMARY KEY (MONTH)
);

CREATE TABLE employee_comment (
   emp_id NUMBER(5),
   text VARCHAR2(500));




-- Insert Data into the tables.

insert into employee
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
select e.emp_id, e.fname, e.lname, e.dept_id, e.manager_emp_id, e.salary, e.hire_date, e.job_id
from
(
select 7369 emp_id, 'JOHN' fname, 'SMITH' lname, 20 dept_id, 7902 manager_emp_id, 800 salary, '17-DEC-80' hire_date, 667 job_id from dual union all
select 7499 emp_id, 'KEVIN' fname, 'ALLEN' lname, 30 dept_id, 7698 manager_emp_id, 1600 salary, '20-FEB-81' hire_date, 670 job_id from dual union all
select 7521 emp_id, 'CYNTHIA' fname, 'WARD' lname, 30 dept_id, 7698 manager_emp_id, 1250 salary, '22-FEB-81' hire_date, null job_id from dual union all
select 7566 emp_id, 'TERRY' fname, 'JONES' lname, 20 dept_id, 7839 manager_emp_id, 2000 salary, '02-APR-81' hire_date, 671 job_id from dual union all
select 7654 emp_id, 'KENNETH' fname, 'MARTIN' lname, 30 dept_id, 7698 manager_emp_id, 1250 salary, '28-SEP-81' hire_date, 670 job_id from dual union all
select 7698 emp_id, 'MARION' fname, 'BLAKE' lname, 30 dept_id, 7839 manager_emp_id, 2850 salary, '01-MAY-80' hire_date, 671 job_id from dual union all
select 7782 emp_id, 'CAROL' fname, 'CLARK' lname, 10 dept_id, 7839 manager_emp_id, 2450 salary, '09-JUN-81' hire_date, 671 job_id from dual union all
select 7788 emp_id, 'DONALD' fname, 'SCOTT' lname, 20 dept_id, 7566 manager_emp_id, 3000 salary, '19-APR-87' hire_date, 669 job_id from dual union all
select 7839 emp_id, 'FRANCIS' fname, 'KING' lname, 10 dept_id, null manager_emp_id, 5000 salary, '17-NOV-81' hire_date, 672 job_id from dual union all
select 7844 emp_id, 'MARY' fname, 'TURNER' lname, 30 dept_id, 7698 manager_emp_id, 1500 salary, '08-SEP-81' hire_date, 670 job_id from dual union all
select 7876 emp_id, 'DIANE' fname, 'ADAMS' lname, 20 dept_id, 7788 manager_emp_id, 1100 salary, '23-MAY-87' hire_date, null job_id from dual union all
select 7900 emp_id, 'FRED' fname, 'JAMES' lname, 30 dept_id, 7698 manager_emp_id, 950 salary, '03-DEC-81' hire_date, 667 job_id from dual union all
select 7902 emp_id, 'JENNIFER' fname, 'FORD' lname, 20 dept_id, 7566 manager_emp_id, 3000 salary, '03-DEC-81' hire_date, 669 job_id from dual union all
select 7934 emp_id, 'BARBARA' fname, 'MILLER' lname, 10 dept_id, 7782 manager_emp_id, 1300 salary, '23-JAN-82' hire_date, 667 job_id from dual
) e;
commit;

INSERT INTO EMPLOYEE_EXPENSE VALUES (7369, 2002, 2, 3072.43, 3072.43, '03-Mar-2002');
INSERT INTO EMPLOYEE_EXPENSE VALUES (7369, 2002, 4, 30, 30, '01-Jun-2002');
INSERT INTO EMPLOYEE_EXPENSE VALUES (7369, 2002, 5, 235.03, 35.03, '01-Jun-2002');
INSERT INTO EMPLOYEE_EXPENSE VALUES (7369, 2002, 9, 5095.98, 5095.08, '31-Oct-2002');
INSERT INTO EMPLOYEE_EXPENSE VALUES (7369, 2002, 12, 1001.01, 1001.01, '01-Feb-2003');
INSERT INTO EMPLOYEE_EXPENSE VALUES (7782, 2002, 1, 111.09, 111.09, '01-Feb-2002');
INSERT INTO EMPLOYEE_EXPENSE VALUES (7782, 2002, 3, 9.85, 9.85, '01-Apr-2002');
INSERT INTO EMPLOYEE_EXPENSE VALUES (7782, 2002, 7, 3987.32, 3987.32, '01-Aug-2002');
INSERT INTO EMPLOYEE_EXPENSE VALUES (7782, 2002, 9, 1200, 1200, '01-Oct-2002');
COMMIT;

insert into department
(DEPT_ID,NAME,LOCATION_ID)
select d.dept_id, d.name, d.location_id
from
(
select 10 dept_id, 'ACCOUNTING' name, 122  location_id from dual union all
select 20 dept_id, 'RESEARCH' name, 124  location_id from dual union all
select 30 dept_id, 'SALES' name, null  location_id from dual union all
select 40 dept_id, 'OPERATIONS' name, 167  location_id from dual
) d;
commit;

insert into job
(JOB_ID,FUNCTION)
select j.id, j.func
from
(
select 667 id,'CLERK' func from dual union all
select 668 id,'STAFF' func from dual union all
select 669 id,'ANALYST' func from dual union all
select 670 id,'SALESPERSON' func from dual union all
select 671 id,'MANAGER' func from dual union all
select 672 id,'PRESIDENT' func from dual union all
select 665 id,'SECRETARY' func from dual
) j;
commit;

insert into location
(LOCATION_ID,REGIONAL_GROUP)
select l.id, l.loc
from
(
select 122 id, 'NEW YORK' loc from dual union all
select 124 id, 'DALLAS' loc from dual union all
select 123 id, 'CHICAGO' loc from dual union all
select 167 id, 'BOSTON' loc from dual union all
select 144 id, 'SAN FRANCISCO' loc from dual
) l;
commit;

insert into customer
(cust_nbr, name, region_id, tot_orders, last_order_dt)
select c.c_nbr, c.c_nm, c.rgn, c.tot_ord, to_date(c.lst_ord, 'DD-MON-YYYY')
from
(
select 1 c_nbr, 'Cooper Industries' c_nm, 5 rgn,  96 tot_ord, '15-JUN-2000' lst_ord from dual union all
select 2 c_nbr, 'Emblazon Corp.' c_nm, 5 rgn,  96 tot_ord, '27-JUN-2000' lst_ord from dual union all
select 3 c_nbr, 'Ditech Corp.' c_nm, 5 rgn,  96 tot_ord, '07-JUL-2000' lst_ord from dual union all
select 4 c_nbr, 'Flowtech Inc.' c_nm, 5 rgn,  96 tot_ord, '15-JUL-2000' lst_ord from dual union all
select 5 c_nbr, 'Gentech Industries' c_nm, 5 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 6 c_nbr, 'Spartan Industries' c_nm, 6 rgn,  96 tot_ord, '10-JUN-2000' lst_ord from dual union all
select 7 c_nbr, 'Wallace Labs' c_nm, 6 rgn,  101 tot_ord, '17-JUN-2000' lst_ord from dual union all
select 8 c_nbr, 'Zantech Inc.' c_nm, 6 rgn,  96 tot_ord, '22-JUN-2000' lst_ord from dual union all
select 9 c_nbr, 'Cardinal Technologies' c_nm, 6 rgn,  96 tot_ord, '25-JUN-2000' lst_ord from dual union all
select 10 c_nbr, 'Flowrite Corp.' c_nm, 6 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 11 c_nbr, 'Glaven Technologies' c_nm, 7 rgn,  96 tot_ord, '05-JUN-2000' lst_ord from dual union all
select 12 c_nbr, 'Johnson Labs' c_nm, 7 rgn,  96 tot_ord, '07-JUN-2000' lst_ord from dual union all
select 13 c_nbr, 'Kimball Corp.' c_nm, 7 rgn,  96 tot_ord, '07-JUN-2000' lst_ord from dual union all
select 14 c_nbr, 'Madden Industries' c_nm, 7 rgn,  101 tot_ord, '05-JUN-2000' lst_ord from dual union all
select 15 c_nbr, 'Turntech Inc.' c_nm, 7 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 16 c_nbr, 'Paulson Labs' c_nm, 8 rgn,  96 tot_ord, '31-MAY-2000' lst_ord from dual union all
select 17 c_nbr, 'Evans Supply Corp.' c_nm, 8 rgn,  96 tot_ord, '28-MAY-2000' lst_ord from dual union all
select 18 c_nbr, 'Spalding Medical Inc.' c_nm, 8 rgn,  96 tot_ord, '23-MAY-2000' lst_ord from dual union all
select 19 c_nbr, 'Kendall-Taylor Corp.' c_nm, 8 rgn,  96 tot_ord, '16-MAY-2000' lst_ord from dual union all
select 20 c_nbr, 'Malden Labs' c_nm, 8 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 21 c_nbr, 'Crimson Medical Inc.' c_nm, 9 rgn,  101 tot_ord, '26-MAY-2000' lst_ord from dual union all
select 22 c_nbr, 'Nichols Industries' c_nm, 9 rgn,  96 tot_ord, '18-MAY-2000' lst_ord from dual union all
select 23 c_nbr, 'Owens-Baxter Corp.' c_nm, 9 rgn,  96 tot_ord, '08-MAY-2000' lst_ord from dual union all
select 24 c_nbr, 'Jackson Medical Inc.' c_nm, 9 rgn, 96 tot_ord, '26-APR-2000' lst_ord from dual union all
select 25 c_nbr, 'Worcester Technologies' c_nm, 9 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 26 c_nbr, 'Alpha Technologies' c_nm, 10 rgn,  96 tot_ord, '21-MAY-2000' lst_ord from dual union all
select 27 c_nbr, 'Phillips Labs' c_nm, 10 rgn,  96 tot_ord, '08-MAY-2000' lst_ord from dual union all
select 28 c_nbr, 'Jaztech Corp.' c_nm, 10 rgn,  101 tot_ord, '23-APR-2000' lst_ord from dual union all
select 29 c_nbr, 'Madden-Taylor Inc.' c_nm, 10 rgn,  96 tot_ord, '06-APR-2000' lst_ord from dual union all
select 30 c_nbr, 'Wallace Industries' c_nm, 10 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual
) c;
commit;

insert into supplier
(supplier_id, name)
select s.sid, s.nm
from
(
select 1 sid, 'Acme Industries' nm from dual union all
select 2 sid, 'Tilton Enterprises' nm from dual union all
select 3 sid, 'Eastern Importers' nm from dual
) s;
commit;

insert into part
(part_nbr, name, supplier_id, status, inventory_qty,  unit_cost)
select p.pno, p.nm, p.sid, 'INSTOCK', p.qty, p.cost
from
(
select 'AI5-4557' pno, 'Acme Part AI5-4557' nm, 1 sid, 5 qty, 2000 cost from dual union all
select 'TZ50828' pno, 'Tilton Part TZ50828' nm, 2 sid, 12 qty, 600 cost from dual union all
select 'EI-T5-001' pno, 'Eastern Part EI-T5-001' nm, 3 sid, 88 qty, 218 cost from dual
) p;
commit;

insert into Inventory_class
(INV_CLASS, LOW_COST, HIGH_COST)
select i.class, i.low, i.high
from
(
select 'C' class, 0 low, 99 high from dual union all
select 'B' class, 100 low, 999 high from dual union all
select 'A' class, 1000 low, 9999 high from dual
) i;
commit;

insert into cust_order
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
select co.ord, co.cust, co.emp, co.price, co.o_dt, co.es_dt, co.c_dt, co.s_dt, co.status
from
(
select 1001 ord,1 cust, 7354 emp,99 price,'22-JUL-01' o_dt, '23-JUL-01' es_dt, null c_dt, null s_dt, 'DELIVERED' status from dual union all
select 1000 ord,1 cust, 7354 emp,null price,'19-JUL-01' o_dt, '24-JUL-01' es_dt, '21-JUL-01' c_dt, null s_dt, 'CANCELLED' status from dual union all
select 1002 ord,5 cust, 7368 emp,null price,'12-JUL-01' o_dt, '25-JUL-01' es_dt, '14-JUL-01' c_dt, null s_dt, 'CANCELLED' status from dual union all
select 1003 ord,4 cust, 7654 emp,56 price,'16-JUL-01' o_dt, '26-JUL-01' es_dt, null c_dt, null s_dt, 'DELIVERED' status from dual union all
select 1004 ord,4 cust, 7654 emp,34 price,'18-JUL-01' o_dt, '27-JUL-01' es_dt, null c_dt, null s_dt, 'PENDING' status from dual union all
select 1005 ord,8 cust, 7654 emp,99 price,'22-JUL-01' o_dt, '24-JUL-01' es_dt, null c_dt, null s_dt, 'DELIVERED' status from dual union all
select 1006 ord,1 cust, 7354 emp,null price,'22-JUL-01' o_dt, '28-JUL-01' es_dt, '24-JUL-01' c_dt, null s_dt, 'CANCELLED' status from dual union all
select 1007 ord,5 cust, 7368 emp,25 price,'20-JUL-01' o_dt, '22-JUL-01' es_dt, null c_dt, null s_dt, 'PENDING' status from dual union all
select 1008 ord,5 cust, 7368 emp,25 price,'21-JUL-01' o_dt, '23-JUL-01' es_dt, null c_dt, null s_dt, 'PENDING' status from dual union all
select 1009 ord,1 cust, 7354 emp,56 price,'18-JUL-01' o_dt, '22-JUL-01' es_dt, null c_dt, null s_dt, 'DELIVERED' status from dual union all
select 1012 ord,1 cust, 7354 emp,99 price,'22-JUL-01' o_dt, '23-JUL-01' es_dt, null c_dt, null s_dt, 'DELIVERED' status from dual union all
select 1011 ord,1 cust, 7354 emp,null price,'19-JUL-01' o_dt, '24-JUL-01' es_dt, '21-JUL-01' c_dt, null s_dt, 'CANCELLED' status from dual union all
select 1015 ord,5 cust, 7368 emp,null price,'12-JUL-01' o_dt, '25-JUL-01' es_dt, '14-JUL-01' c_dt, null s_dt, 'CANCELLED' status from dual union all
select 1017 ord,4 cust, 7654 emp,56 price,'16-JUL-01' o_dt, '26-JUL-01' es_dt, null c_dt, null s_dt, 'DELIVERED' status from dual union all
select 1019 ord,4 cust, 7654 emp,34 price,'18-JUL-01' o_dt, '27-JUL-01' es_dt, null c_dt, null s_dt, 'PENDING' status from dual union all
select 1021 ord,8 cust, 7654 emp,99 price,'22-JUL-01' o_dt, '24-JUL-01' es_dt, null c_dt, null s_dt, 'DELIVERED' status from dual union all
select 1023 ord,1 cust, 7354 emp,null price,'22-JUL-01' o_dt, '28-JUL-01' es_dt, '24-JUL-01' c_dt, null s_dt, 'CANCELLED' status from dual union all
select 1025 ord,5 cust, 7368 emp,25 price,'20-JUL-01' o_dt, '22-JUL-01' es_dt, null c_dt, null s_dt, 'PENDING' status from dual union all
select 1027 ord,5 cust, 7368 emp,25 price,'21-JUL-01' o_dt, '23-JUL-01' es_dt, null c_dt, null s_dt, 'PENDING' status from dual union all
select 1029 ord,1 cust, 7354 emp,56 price,'18-JUL-01' o_dt, '22-JUL-01' es_dt, null c_dt, null s_dt, 'DELIVERED' status from dual
) co;
commit;

insert into assembly
(ASSEMBLY_TYPE, ASSEMBLY_ID, DESCRIPTION, PARENT_ASSEMBLY_TYPE, PARENT_ASSEMBLY_ID)
select a.type, a.id, a.descr, a.pat, a.pid
from
(
select 'A' type, 1234 id, 'Assembly A#1234' descr, null pat, null pid from dual union all
select 'A' type, 1256 id, 'Assembly A#1256' descr, 'A' pat, 1234 pid from dual union all
select 'B' type, 6543 id, 'Part Unit#6543' descr, 'A' pat, 1234 pid from dual union all
select 'A' type, 1675 id, 'Part Unit#1675' descr, 'B' pat, 6543 pid from dual union all
select 'X' type, 9943 id, 'Repair Zone 1' descr, null pat, null pid from dual union all
select 'X' type, 5438 id, 'Repair Unit #5438' descr, 'X' pat, 9943 pid from dual union all
select 'X' type, 1675 id, 'Readymade Unit #1675' descr, 'X' pat, 5438 pid from dual
) a;
commit;

insert into retailer
(RTLR_NBR,NAME,ADDRESS,CITY,STATE,ZIP_CODE,SALESPERSON_ID)
select r.num,r.name,r.addr,r.city,r.st,r.zip,r.sid
from
(
select 100 num,'JOCKSPORTS' name,'345 VIEWRIDGE' addr,'BELMONT' city,'CA' st,'96711' zip,7844 sid from dual union all
select 101 num,'TKB SPORT SHOP' name,'490 BOLI RD.' addr,'REDWOOD CITY' city,'CA' st,'94061' zip,7521 sid from dual union all
select 102 num,'VOLLYRITE' name,'9722 HAMILTON' addr,'BURLINGAME' city,'CA' st,'95133' zip,7654 sid from dual union all
select 103 num,'JUST TENNIS' name,'HILLVIEW MALL' addr,'BURLINGAME' city,'CA' st,'97544' zip,7521 sid from dual union all
select 104 num,'EVERY MOUNTAIN' name,'574 SURRY RD.' addr,'CUPERTINO' city,'CA' st,'93301' zip,7499 sid from dual union all
select 105 num,'K + T SPORTS' name,'3476 EL PASEO' addr,'SANTA CLARA' city,'CA' st,'91003' zip,7844 sid from dual union all
select 106 num,'SHAPE UP' name,'908 SEQUOIA' addr,'PALO ALTO' city,'CA' st,'94301' zip,7521 sid from dual union all
select 107 num,'WOMENS SPORTS' name,'VALCO VILLAGE' addr,'SUNNYVALE' city,'CA' st,'93301' zip,7499 sid from dual union all
select 201 num,'STADIUM SPORTS' name,'47 IRVING PL.' addr,'NEW YORK' city,'NY' st,'10003' zip,7499 sid from dual union all
select 202 num,'HOOPS' name,'2345 ADAMS AVE.' addr,'LEICESTER' city,'MA' st,'01524' zip,7499 sid from dual union all
select 203 num,'REBOUND SPORTS' name,'2 E. 14TH ST.' addr,'NEW YORK' city,'NY' st,'10009' zip,7499 sid from dual union all
select 204 num,'THE POWER FORWARD' name,'1 KNOTS LANDING' addr,'DALLAS' city,'TX' st,'75248' zip,7654 sid from dual union all
select 205 num,'POINT GUARD' name,'20 THURSTON ST.' addr,'YONKERS' city,'NY' st,'10956' zip,7499 sid from dual union all
select 206 num,'THE COLISEUM' name,'5678 WILBUR PL.' addr,'SCARSDALE' city,'NY' st,'10583' zip,7499 sid from dual union all
select 207 num,'FAST BREAK' name,'1000 HERBERT LN.' addr,'CONCORD' city,'MA' st,'01742' zip,7499 sid from dual union all
select 208 num,'AL AND BOB''S SPORTS' name,'260 YORKTOWN CT.' addr,'AUSTIN' city,'TX' st,'78731' zip,7654 sid from dual union all
select 211 num,'AT BAT' name,'234 BEACHEM ST.' addr,'BROOKLINE' city,'MA' st,'02146' zip,7499 sid from dual union all
select 212 num,'ALL SPORT' name,'1000 38TH ST.' addr,'BROOKLYN' city,'NY' st,'11210' zip,7844 sid from dual union all
select 213 num,'GOOD SPORT' name,'400 46TH ST.' addr,'SUNNYSIDE' city,'NY' st,'11104' zip,7844 sid from dual union all
select 214 num,'AL''S PRO SHOP' name,'45 SPRUCE ST.' addr,'SPRING' city,'TX' st,'77388' zip,7654 sid from dual union all
select 215 num,'BOB''S FAMILY SPORTS' name,'400 E. 23RD' addr,'HOUSTON' city,'TX' st,'77026' zip,7654 sid from dual union all
select 216 num,'THE ALL AMERICAN' name,'547 PRENTICE RD.' addr,'CHELSEA' city,'MA' st,'02150' zip,7499 sid from dual union all
select 217 num,'HIT name, THROW addr, AND RUN' city,'333 WOOD COURT','GRAPEVINE','TX' st,'76051' zip,7654 sid from dual union all
select 218 num,'THE OUTFIELD' name,'346 GARDEN BLVD.' addr,'FLUSHING' city,'NY' st,'11355' zip,7499 sid from dual union all
select 221 num,'WHEELS AND DEALS' name,'2 MEMORIAL DRIVE' addr,'HOUSTON' city,'TX' st,'77007' zip,7844 sid from dual union all
select 222 num,'JUST BIKES' name,'4000 PARKRIDGE BLVD.' addr,'DALLAS' city,'TX' st,'75205' zip,7844 sid from dual union all
select 223 num,'VELO SPORTS' name,'23 WHITE ST.' addr,'MALDEN' city,'MA' st,'02148' zip,7499 sid from dual union all
select 224 num,'JOE''S BIKE SHOP' name,'4500 FOX COURT' addr,'GRAND PRARIE' city,'TX' st,'75051' zip,7844 sid from dual union all
select 225 num,'BOB''S SWIM, CYCLE AND RUN' name,'300 HORSECREEK CIRCLE' addr,'IRVING' city,'TX' st,'75039' zip,7844 sid from dual union all
select 226 num,'CENTURY SHOP' name,'8 DAGMAR DR.' addr,'HUNTINGTON' city,'NY' st,'11743' zip,7521 sid from dual union all
select 227 num,'THE TOUR' name,'2500 GARDNER RD.' addr,'SOMERVILLE' city,'MA' st,'02144' zip,7499 sid from dual union all
select 228 num,'FITNESS FIRST' name,'5000 85TH ST.' addr,'JACKSON HEIGHTS' city,'NY' st,'11372' zip,7521 sid from dual
) r;
commit;

insert into region (region_id, name, super_region_id)
select r.r_id, r.r_nm, r.spr_id
from
 (select 1 r_id, 'North America' r_nm,  to_number(null) spr_id from dual union all
select 2 r_id, 'Canada' r_nm, 1 spr_id from dual union all
select 3 r_id, 'United States' r_nm, 1 spr_id from dual union all
select 4 r_id, 'Mexico' r_nm, 1 spr_id from dual union all
select 5 r_id, 'New England' r_nm, 3 spr_id from dual union all
select 6 r_id, 'Mid-Atlantic' r_nm, 3 spr_id from dual union all
select 7 r_id, 'Southeast US' r_nm, 3 spr_id from dual union all
select 8 r_id, 'Southwest US' r_nm, 3 spr_id from dual union all
select 9 r_id, 'Northwest US' r_nm, 3 spr_id from dual union all
select 10 r_id, 'Central US' r_nm, 3 spr_id from dual union all
select 11 r_id, 'Europe' r_nm,  to_number(null) spr_id from dual union all
select 12 r_id, 'France' r_nm, 11 spr_id from dual union all
select 13 r_id, 'Germany' r_nm, 11 spr_id from dual union all
select 14 r_id, 'Spain' r_nm, 11 spr_id from dual) r;
commit;

insert into salesperson (salesperson_id, name, primary_region_id)
select s.s_id, s.nm, s.pr_id
from
(
select 1 s_id, 'Jeff Blake' nm, 5 pr_id from dual union all
select 2 s_id, 'Tom Freeman' nm, 5 pr_id from dual union all
select 3 s_id, 'Bob Grossman' nm, 5 pr_id from dual union all
select 4 s_id, 'Chuck Thomas' nm, 5 pr_id from dual union all
select 5 s_id, 'Greg Powers' nm, 6 pr_id from dual union all
select 6 s_id, 'Susan Jones' nm, 6 pr_id from dual union all
select 7 s_id, 'Andy Levitz' nm, 6 pr_id from dual union all
select 8 s_id, 'John Boorman' nm, 6 pr_id from dual union all
select 9 s_id, 'Jim Fletcher' nm, 7 pr_id from dual union all
select 10 s_id, 'Mary Dunn' nm, 7 pr_id from dual union all
select 11 s_id, 'Bill Evans' nm, 7 pr_id from dual union all
select 12 s_id, 'Don Walters' nm, 7 pr_id from dual union all
select 13 s_id, 'Karen Young' nm, 8 pr_id from dual union all
select 14 s_id, 'Sam Houseman' nm, 8 pr_id from dual union all
select 15 s_id, 'Tim McGowan' nm, 8 pr_id from dual union all
select 16 s_id, 'Carl Isaacs' nm, 8 pr_id from dual union all
select 17 s_id, 'Dave Jacobs' nm, 9 pr_id from dual union all
select 18 s_id, 'Barbara King' nm, 9 pr_id from dual union all
select 19 s_id, 'Alex Fox' nm, 9 pr_id from dual union all
select 20 s_id, 'Chris Anderson' nm, 9 pr_id from dual union all
select 21 s_id, 'Lynn Nichols' nm, 10 pr_id from dual union all
select 22 s_id, 'Eric Iverson' nm, 10 pr_id from dual union all
select 23 s_id, 'Laura Peters' nm, 10 pr_id from dual union all
select 24 s_id, 'Mark Russell' nm, 10 pr_id from dual
) s;
commit;

insert into months
(year, month)
select m.yr, m.mn
from
(
select 2000 yr, 1 mn from dual union all
select 2001 yr, 1 mn from dual union all
select 2002 yr, 1 mn from dual union all
select 2000 yr, 2 mn from dual union all
select 2001 yr, 2 mn from dual union all
select 2002 yr, 2 mn from dual union all
select 2000 yr, 3 mn from dual union all
select 2001 yr, 3 mn from dual union all
select 2002 yr, 3 mn from dual union all
select 2000 yr, 4 mn from dual union all
select 2001 yr, 4 mn from dual union all
select 2002 yr, 4 mn from dual union all
select 2000 yr, 5 mn from dual union all
select 2001 yr, 5 mn from dual union all
select 2002 yr, 5 mn from dual union all
select 2000 yr, 6 mn from dual union all
select 2001 yr, 6 mn from dual union all
select 2002 yr, 6 mn from dual union all
select 2000 yr, 7 mn from dual union all
select 2001 yr, 7 mn from dual union all
select 2002 yr, 7 mn from dual union all
select 2000 yr, 8 mn from dual union all
select 2001 yr, 8 mn from dual union all
select 2002 yr, 8 mn from dual union all
select 2000 yr, 9 mn from dual union all
select 2001 yr, 9 mn from dual union all
select 2002 yr, 9 mn from dual union all
select 2000 yr, 10 mn from dual union all
select 2001 yr, 10 mn from dual union all
select 2002 yr, 10 mn from dual union all
select 2000 yr, 11 mn from dual union all
select 2001 yr, 11 mn from dual union all
select 2002 yr, 11 mn from dual union all
select 2000 yr, 12 mn from dual union all
select 2001 yr, 12 mn from dual union all
select 2002 yr, 12 mn from dual
) m;
commit;

insert into orders
(cust_nbr, region_id, salesperson_id, year, month, tot_orders, tot_sales)
select o.c_nbr, o.r_id, o.s_id, o.yr, o.mn, o.tot_o, o.tot_s
from
(
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 8118 tot_s from dual union all
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 13009 tot_s from dual union all
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 39906 tot_s from dual union all
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 57411 tot_s from dual union all
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 30575 tot_s from dual union all
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 45417 tot_s from dual union all
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 72291 tot_s from dual union all
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 49118 tot_s from dual union all
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 10724 tot_s from dual union all
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 4391 tot_s from dual union all
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 67010 tot_s from dual union all
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 51894 tot_s from dual union all
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 67139 tot_s from dual union all
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 14657 tot_s from dual union all
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 61640 tot_s from dual union all
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 33345 tot_s from dual union all
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 19737 tot_s from dual union all
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 41354 tot_s from dual union all
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 3965 tot_s from dual union all
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 11460 tot_s from dual union all
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 22490 tot_s from dual union all
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 4097 tot_s from dual union all
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 18717 tot_s from dual union all
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 34235 tot_s from dual union all
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 20514 tot_s from dual union all
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 70827 tot_s from dual union all
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 38100 tot_s from dual union all
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 66957 tot_s from dual union all
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 41519 tot_s from dual union all
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 33083 tot_s from dual union all
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 67274 tot_s from dual union all
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 42015 tot_s from dual union all
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 25604 tot_s from dual union all
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 21585 tot_s from dual union all
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 73791 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 32891 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 20659 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 34459 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 30923 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 1937 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 6757 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 3750 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 1326 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 12659 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 48901 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 33458 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 37879 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 10046 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 19778 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 34352 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 36120 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 3143 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 3030 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 36144 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 11029 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 36085 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 39232 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 38494 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 6315 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 19302 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 24264 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 29943 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 21862 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 2380 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 9282 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 32730 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 9111 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 38820 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 17633 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 4581 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 2431 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 32999 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 4722 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 25281 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 21578 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 10508 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 9590 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 26239 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 6270 tot_s from dual union all
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 32700 tot_s from dual union all
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 13732 tot_s from dual union all
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 15077 tot_s from dual union all
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 21183 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 1949 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 12509 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 29279 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 37496 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 20295 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 26285 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 28910 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 24404 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 18325 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 37805 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 26187 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 22282 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 29123 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 40117 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 18813 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 438 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 39936 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 47721 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 13713 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 49552 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 2098 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 35669 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 41140 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 19233 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 13978 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 14214 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 9300 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 23214 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 23632 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 23027 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 899 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 44651 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 38352 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 27262 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 17240 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 46076 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 9595 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 22778 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 43081 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 30547 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 21159 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 4993 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 1884 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 14474 tot_s from dual union all
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 41203 tot_s from dual union all
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 17496 tot_s from dual union all
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 5458 tot_s from dual union all
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 23846 tot_s from dual union all
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 38466 tot_s from dual union all
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 39124 tot_s from dual union all
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 33315 tot_s from dual union all
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 45994 tot_s from dual union all
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 27196 tot_s from dual union all
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 534 tot_s from dual union all
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 13817 tot_s from dual union all
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 38628 tot_s from dual union all
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 126 tot_s from dual union all
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 46577 tot_s from dual union all
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 40879 tot_s from dual union all
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 32670 tot_s from dual union all
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 29856 tot_s from dual union all
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 46789 tot_s from dual union all
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 6352 tot_s from dual union all
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 30079 tot_s from dual union all
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 38469 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 17651 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 2805 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 12121 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 36296 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 14703 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 6707 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 7821 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 26117 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 38427 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 41519 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 37491 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 44772 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 20000 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 31212 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 1086 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 1689 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 613 tot_s from dual union all                                        
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 3818 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 25769 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 49091 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 11883 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 20575 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 38371 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 45913 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 2959 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 40003 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 46858 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 610 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 13328 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 15972 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 43908 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 46046 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 25677 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 24245 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 21691 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 29390 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 27847 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 42624 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 38946 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 25902 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 48235 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 6888 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 9021 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 46064 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 9202 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 14141 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 25217 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 20592 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 13659 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 31842 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 45834 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 32074 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 329 tot_s from dual union all                                       
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 34891 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 19155 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 44012 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 13797 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 41860 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 12284 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 25222 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 35863 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 12687 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 45565 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 39348 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 43871 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 17415 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 11216 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 18751 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 2761 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 13434 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 994 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 22250 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 29667 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 9849 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 31440 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 23917 tot_s from dual union all                                    
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 20863 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 2875 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 49763 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 18053 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 22182 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 11114 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 31234 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 29066 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 42391 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 22247 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 38541 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 2417 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 28269 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 24362 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 48825 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 2231 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 26107 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 42036 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 15520 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 47335 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 4928 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 41890 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 27627 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 32799 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 8809 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 44165 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 24777 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 30864 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 36886 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 1690 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 25878 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 8451 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 37432 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 29462 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 6817 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 43173 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 36052 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 23338 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 382 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 31963 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 41485 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 942 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 13721 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 867 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 45300 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 10435 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 2581 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 13017 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 29993 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 4744 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 5042 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 40138 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 23357 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 7118 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 18495 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 46925 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 20443 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 1612 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 39409 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 17530 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 36205 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 31954 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 5983 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 3227 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 19382 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 18761 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 35841 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 37724 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 27623 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 25042 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 46864 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 41975 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 16380 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 47356 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 21605 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 36225 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 25728 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 3609 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 30780 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 37795 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 23786 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 46333 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 5594 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 16355 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 17790 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 32224 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 21220 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 18721 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 45522 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 30370 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 955 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 45660 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 28694 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 29766 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 41407 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 15730 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 6895 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 4477 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 38005 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 46325 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 41205 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 22846 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 47639 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 12986 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 25503 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 43161 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 30512 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 24227 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 30108 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 38883 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 41875 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 33842 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 21348 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 10415 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 7287 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 8182 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 37579 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 41835 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 11104 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 11693 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 14989 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 10199 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 43212 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 25527 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 21873 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 38326 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 354 tot_s from dual union all                                        
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 17113 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 33718 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 10198 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 36699 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 11122 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 49856 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 9739 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 25815 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 21218 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 12898 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 1680 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 18727 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 14280 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 44508 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 36496 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 24035 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 772 tot_s from dual union all                                       
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 69830 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 27533 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 21116 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 15486 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 57999 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 10352 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 73760 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 27756 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 48480 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 6929 tot_s from dual union all                                       
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 67883 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 54719 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 63117 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 32093 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 33707 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 52218 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 40143 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 60920 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 20241 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 69519 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 33035 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 13361 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 20963 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 11474 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 26795 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 875 tot_s from dual union all                                        
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 68795 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 66764 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 72398 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 62186 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 56280 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 67550 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 52131 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 71195 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 13881 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 50910 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 12038 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 38127 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 13527 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 37802 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 31529 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 8036 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 1862 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 51563 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 57383 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 44913 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 19506 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 19595 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 37663 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 44376 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 15972 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 10066 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 49008 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 11412 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 33475 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 37817 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 7661 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 8384 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 28236 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 36198 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 28239 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 38251 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 68 tot_s from dual union all                                         
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 24165 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 33753 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 22088 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 6178 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 23505 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 22575 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 13145 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 16987 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 20855 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 19372 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 38136 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 4123 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 10366 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 5564 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 381 tot_s from dual union all                                        
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 5886 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 28928 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 31639 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 6489 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 27978 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 20677 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 46552 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 44397 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 19382 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 49505 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 37518 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 39107 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 24340 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 40333 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 37071 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 17512 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 22768 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 21825 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 14802 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 46230 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 23592 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 51350 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 50267 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 5091 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 28211 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 12461 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 49256 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 57671 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 40347 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 41963 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 22208 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 6284 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 60221 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 55946 tot_s from dual
) o;
commit;

insert into orders 
(cust_nbr, region_id, salesperson_id, year, month, tot_orders, tot_sales)
select o.c_nbr, o.r_id, o.s_id, o.yr, o.mn, o.tot_o, o.tot_s
from
(
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 12 mn, 1 tot_o, 46011 tot_s from dual union all                              
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 12 mn, 1 tot_o, 44662 tot_s from dual union all                              
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 12 mn, 1 tot_o, 3544 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 1 mn, 2 tot_o, 40253 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 1 mn, 2 tot_o, 71946 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 1 mn, 2 tot_o, 72293 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 1 mn, 2 tot_o, 59831 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 2 mn, 3 tot_o, 1292 tot_s from dual union all                                
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 2 mn, 3 tot_o, 39204 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 2 mn, 3 tot_o, 46953 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 2 mn, 3 tot_o, 70188 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 3 mn, 1 tot_o, 1734 tot_s from dual union all                                
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 3 mn, 1 tot_o, 45420 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 3 mn, 1 tot_o, 50433 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 3 mn, 1 tot_o, 39350 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 4 mn, 2 tot_o, 29511 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 4 mn, 2 tot_o, 66051 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 4 mn, 2 tot_o, 9849 tot_s from dual union all                                
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 4 mn, 2 tot_o, 38420 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 5 mn, 3 tot_o, 41327 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 5 mn, 3 tot_o, 23855 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 5 mn, 3 tot_o, 68183 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 5 mn, 3 tot_o, 62270 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 6 mn, 1 tot_o, 14829 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 6 mn, 1 tot_o, 64689 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 6 mn, 1 tot_o, 23879 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 6 mn, 1 tot_o, 52467 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 7 mn, 2 tot_o, 59492 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 7 mn, 2 tot_o, 26618 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 7 mn, 2 tot_o, 7782 tot_s from dual union all                                
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 7 mn, 2 tot_o, 35930 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 8 mn, 3 tot_o, 372 tot_s from dual union all                                 
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 8 mn, 3 tot_o, 27972 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 8 mn, 3 tot_o, 44369 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 8 mn, 3 tot_o, 26568 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 9 mn, 1 tot_o, 42804 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 9 mn, 1 tot_o, 28106 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 9 mn, 1 tot_o, 57782 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 9 mn, 1 tot_o, 47406 tot_s from dual union all                               
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 10 mn, 2 tot_o, 28986 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 10 mn, 2 tot_o, 26168 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 10 mn, 2 tot_o, 13421 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 10 mn, 2 tot_o, 39482 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 11 mn, 3 tot_o, 52194 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 11 mn, 3 tot_o, 55329 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 11 mn, 3 tot_o, 63356 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 11 mn, 3 tot_o, 71183 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 13 s_id, 2001 yr, 12 mn, 1 tot_o, 31856 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 14 s_id, 2001 yr, 12 mn, 1 tot_o, 13764 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 15 s_id, 2001 yr, 12 mn, 1 tot_o, 48992 tot_s from dual union all                              
select 17 c_nbr, 8 r_id, 16 s_id, 2001 yr, 12 mn, 1 tot_o, 60122 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 1 mn, 2 tot_o, 1927 tot_s from dual union all                                
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 1 mn, 2 tot_o, 14187 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 1 mn, 2 tot_o, 40567 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 1 mn, 2 tot_o, 9769 tot_s from dual union all                                
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 2 mn, 3 tot_o, 29483 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 2 mn, 3 tot_o, 33983 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 2 mn, 3 tot_o, 38075 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 2 mn, 3 tot_o, 39423 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 3 mn, 1 tot_o, 10888 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 3 mn, 1 tot_o, 26786 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 3 mn, 1 tot_o, 42533 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 3 mn, 1 tot_o, 25490 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 4 mn, 2 tot_o, 34086 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 4 mn, 2 tot_o, 28321 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 4 mn, 2 tot_o, 37905 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 4 mn, 2 tot_o, 46905 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 5 mn, 3 tot_o, 38140 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 5 mn, 3 tot_o, 4453 tot_s from dual union all                                
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 5 mn, 3 tot_o, 21227 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 5 mn, 3 tot_o, 26949 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 6 mn, 1 tot_o, 15118 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 6 mn, 1 tot_o, 38914 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 6 mn, 1 tot_o, 25889 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 6 mn, 1 tot_o, 33843 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 7 mn, 2 tot_o, 23808 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 7 mn, 2 tot_o, 11094 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 7 mn, 2 tot_o, 12371 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 7 mn, 2 tot_o, 4525 tot_s from dual union all                                
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 8 mn, 3 tot_o, 24296 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 8 mn, 3 tot_o, 21982 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 8 mn, 3 tot_o, 31702 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 8 mn, 3 tot_o, 35010 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 9 mn, 1 tot_o, 30156 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 9 mn, 1 tot_o, 11977 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 9 mn, 1 tot_o, 12414 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 9 mn, 1 tot_o, 47361 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 10 mn, 2 tot_o, 41933 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 10 mn, 2 tot_o, 35095 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 10 mn, 2 tot_o, 19462 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 10 mn, 2 tot_o, 44246 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 11 mn, 3 tot_o, 31073 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 11 mn, 3 tot_o, 45542 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 11 mn, 3 tot_o, 30497 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 11 mn, 3 tot_o, 11836 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 13 s_id, 2001 yr, 12 mn, 1 tot_o, 15721 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 14 s_id, 2001 yr, 12 mn, 1 tot_o, 20254 tot_s from dual union all                              
select 18 c_nbr, 8 r_id, 15 s_id, 2001 yr, 12 mn, 1 tot_o, 3370 tot_s from dual union all                               
select 18 c_nbr, 8 r_id, 16 s_id, 2001 yr, 12 mn, 1 tot_o, 23254 tot_s from dual union all                              
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 1 mn, 2 tot_o, 9032 tot_s from dual union all                                
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 1 mn, 2 tot_o, 36865 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 1 mn, 2 tot_o, 6092 tot_s from dual union all                                
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 1 mn, 2 tot_o, 20479 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 2 mn, 3 tot_o, 28508 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 2 mn, 3 tot_o, 33371 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 2 mn, 3 tot_o, 2672 tot_s from dual union all                                
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 2 mn, 3 tot_o, 864 tot_s from dual union all                                 
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 3 mn, 1 tot_o, 23504 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 3 mn, 1 tot_o, 23660 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 3 mn, 1 tot_o, 31842 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 3 mn, 1 tot_o, 27182 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 4 mn, 2 tot_o, 20632 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 4 mn, 2 tot_o, 6820 tot_s from dual union all                                
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 4 mn, 2 tot_o, 31011 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 4 mn, 2 tot_o, 7331 tot_s from dual union all                                
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 5 mn, 3 tot_o, 11788 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 5 mn, 3 tot_o, 28350 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 5 mn, 3 tot_o, 48468 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 5 mn, 3 tot_o, 49421 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 6 mn, 1 tot_o, 36819 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 6 mn, 1 tot_o, 45041 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 6 mn, 1 tot_o, 29258 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 6 mn, 1 tot_o, 7384 tot_s from dual union all                                
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 7 mn, 2 tot_o, 23396 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 7 mn, 2 tot_o, 17327 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 7 mn, 2 tot_o, 41711 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 7 mn, 2 tot_o, 25995 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 8 mn, 3 tot_o, 17430 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 8 mn, 3 tot_o, 2661 tot_s from dual union all                                
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 8 mn, 3 tot_o, 30499 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 8 mn, 3 tot_o, 11823 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 9 mn, 1 tot_o, 28639 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 9 mn, 1 tot_o, 32877 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 9 mn, 1 tot_o, 42553 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 9 mn, 1 tot_o, 23793 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 10 mn, 2 tot_o, 21244 tot_s from dual union all                              
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 10 mn, 2 tot_o, 47567 tot_s from dual union all                              
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 10 mn, 2 tot_o, 9276 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 10 mn, 2 tot_o, 27061 tot_s from dual union all                              
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 11 mn, 3 tot_o, 14915 tot_s from dual union all                              
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 11 mn, 3 tot_o, 17659 tot_s from dual union all                              
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 11 mn, 3 tot_o, 6419 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 11 mn, 3 tot_o, 5296 tot_s from dual union all                               
select 19 c_nbr, 8 r_id, 13 s_id, 2001 yr, 12 mn, 1 tot_o, 48321 tot_s from dual union all                              
select 19 c_nbr, 8 r_id, 14 s_id, 2001 yr, 12 mn, 1 tot_o, 38147 tot_s from dual union all                              
select 19 c_nbr, 8 r_id, 15 s_id, 2001 yr, 12 mn, 1 tot_o, 39682 tot_s from dual union all                              
select 19 c_nbr, 8 r_id, 16 s_id, 2001 yr, 12 mn, 1 tot_o, 33736 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 1 mn, 2 tot_o, 43790 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 1 mn, 2 tot_o, 44569 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 1 mn, 2 tot_o, 14185 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 1 mn, 2 tot_o, 47696 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 2 mn, 3 tot_o, 11303 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 2 mn, 3 tot_o, 710 tot_s from dual union all                                 
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 2 mn, 3 tot_o, 45958 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 2 mn, 3 tot_o, 40962 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 3 mn, 1 tot_o, 27593 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 3 mn, 1 tot_o, 21205 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 3 mn, 1 tot_o, 19877 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 3 mn, 1 tot_o, 30658 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 4 mn, 2 tot_o, 45887 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 4 mn, 2 tot_o, 48769 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 4 mn, 2 tot_o, 36088 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 4 mn, 2 tot_o, 31734 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 5 mn, 3 tot_o, 17381 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 5 mn, 3 tot_o, 47798 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 5 mn, 3 tot_o, 29988 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 5 mn, 3 tot_o, 34722 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 6 mn, 1 tot_o, 22211 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 6 mn, 1 tot_o, 48333 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 6 mn, 1 tot_o, 46328 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 6 mn, 1 tot_o, 104 tot_s from dual union all                                 
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 7 mn, 2 tot_o, 19411 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 7 mn, 2 tot_o, 18647 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 7 mn, 2 tot_o, 20724 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 7 mn, 2 tot_o, 15096 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 8 mn, 3 tot_o, 6590 tot_s from dual union all                                
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 8 mn, 3 tot_o, 42343 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 8 mn, 3 tot_o, 35476 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 8 mn, 3 tot_o, 9412 tot_s from dual union all                                
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 9 mn, 1 tot_o, 35298 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 9 mn, 1 tot_o, 29299 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 9 mn, 1 tot_o, 47093 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 9 mn, 1 tot_o, 47864 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 10 mn, 2 tot_o, 23227 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 10 mn, 2 tot_o, 42056 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 10 mn, 2 tot_o, 5737 tot_s from dual union all                               
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 10 mn, 2 tot_o, 25552 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 11 mn, 3 tot_o, 14927 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 11 mn, 3 tot_o, 35832 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 11 mn, 3 tot_o, 22147 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 11 mn, 3 tot_o, 40532 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 13 s_id, 2001 yr, 12 mn, 1 tot_o, 30260 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 14 s_id, 2001 yr, 12 mn, 1 tot_o, 31232 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 15 s_id, 2001 yr, 12 mn, 1 tot_o, 31271 tot_s from dual union all                              
select 20 c_nbr, 8 r_id, 16 s_id, 2001 yr, 12 mn, 1 tot_o, 24131 tot_s from dual union all                              
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 8 mn, 3 tot_o, 14443 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 9 mn, 1 tot_o, 49121 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 9 mn, 1 tot_o, 11522 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 9 mn, 1 tot_o, 29861 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 9 mn, 1 tot_o, 10594 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 10 mn, 2 tot_o, 9467 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 10 mn, 2 tot_o, 49395 tot_s from dual union all                              
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 10 mn, 2 tot_o, 29208 tot_s from dual union all                              
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 10 mn, 2 tot_o, 18323 tot_s from dual union all                              
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 11 mn, 3 tot_o, 8965 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 11 mn, 3 tot_o, 8767 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 11 mn, 3 tot_o, 33043 tot_s from dual union all                              
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 11 mn, 3 tot_o, 25652 tot_s from dual union all                              
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 12 mn, 1 tot_o, 43055 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 5847 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 16686 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 31238 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 40836 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 32795 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 38221 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 16468 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 22554 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 35626 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 125 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 22235 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 16558 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 12631 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 23231 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 2552 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 6814 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 13049 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 38840 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 19139 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 23110 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 16623 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 32682 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 8826 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 13203 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 20448 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 27427 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 9569 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 39969 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 14245 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 31149 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 46148 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 15714 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 23374 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 8235 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 46252 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 16769 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 39636 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 44744 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 25329 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 42246 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 15128 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 19870 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 6030 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 20328 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 41585 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 9411 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 6106 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 13935 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 45998 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 9269 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 4896 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 47771 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 24524 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 17274 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 18110 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 49696 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 17515 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 4929 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 45791 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 45147 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 42772 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 6280 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 38328 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 32402 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 31761 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 2582 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 6729 tot_s from dual union all                                 
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 24330 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 5084 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 3821 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 41165 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 48420 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 7628 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 48569 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 16841 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 1562 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 34505 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 29319 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 25866 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 10151 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 10098 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 12134 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 38856 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 36876 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 40473 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 48558 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 11187 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 20739 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 36565 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 34554 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 35318 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 44188 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 24427 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 37059 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 48050 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 43231 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 43886 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 13840 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 18060 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 13101 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 21009 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 20672 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 35757 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 14969 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 18760 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 38544 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 22735 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 36580 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 19996 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 18842 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 37052 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 48985 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 19393 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 41950 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 8138 tot_s from dual union all                                 
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 9971 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 28316 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 34374 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 57393 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 12408 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 59190 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 23172 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 62882 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 68912 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 65039 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 50226 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 52419 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 37374 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 16992 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 62543 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 57096 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 31625 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 26925 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 54732 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 32669 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 26903 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 36120 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 64077 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 39453 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 9182 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 61202 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 32460 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 7268 tot_s from dual union all                                 
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 30960 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 74861 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 21218 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 58583 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 48222 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 50066 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 60426 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 62457 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 10122 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 42308 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 24924 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 48666 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 56655 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 20678 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 38682 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 54816 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 28749 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 44624 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 23696 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 11100 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 28644 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 28731 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 32233 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 7649 tot_s from dual union all                                 
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 31285 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 25831 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 47475 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 27123 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 33080 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 32041 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 16510 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 47685 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 37045 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 47005 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 29464 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 1492 tot_s from dual union all                                 
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 16615 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 33397 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 12 tot_s from dual union all                                  
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 44933 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 37064 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 18287 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 6088 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 9910 tot_s from dual union all                                 
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 5137 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 37298 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 31725 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 10503 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 20929 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 31916 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 11396 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 41831 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 7065 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 22725 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 35896 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 25328 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 49140 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 9930 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 39579 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 27529 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 27933 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 373 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 20552 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 46300 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 45398 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 13749 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 42660 tot_s from dual union all                              
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 1 mn, 2 tot_o, 47754 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 1 mn, 2 tot_o, 20583 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 1 mn, 2 tot_o, 822 tot_s from dual union all                                 
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 1 mn, 2 tot_o, 34988 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 2 mn, 3 tot_o, 44497 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 2 mn, 3 tot_o, 15136 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 2 mn, 3 tot_o, 4713 tot_s from dual union all                                
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 2 mn, 3 tot_o, 44411 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 3 mn, 1 tot_o, 106 tot_s from dual union all                                 
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 3 mn, 1 tot_o, 10568 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 3 mn, 1 tot_o, 12640 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 3 mn, 1 tot_o, 29451 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 4 mn, 2 tot_o, 25617 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 4 mn, 2 tot_o, 32683 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 4 mn, 2 tot_o, 12679 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 4 mn, 2 tot_o, 7643 tot_s from dual union all                                
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 5 mn, 3 tot_o, 584 tot_s from dual union all                                 
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 5 mn, 3 tot_o, 28169 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 5 mn, 3 tot_o, 24191 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 5 mn, 3 tot_o, 4242 tot_s from dual union all                                
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 6 mn, 1 tot_o, 40410 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 6 mn, 1 tot_o, 30338 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 6 mn, 1 tot_o, 36713 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 6 mn, 1 tot_o, 2635 tot_s from dual union all                                
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 7 mn, 2 tot_o, 17949 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 7 mn, 2 tot_o, 7171 tot_s from dual union all                                
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 7 mn, 2 tot_o, 6058 tot_s from dual union all                                
select 16 c_nbr, 8 r_id, 16 s_id, 2001 yr, 7 mn, 2 tot_o, 25232 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 13 s_id, 2001 yr, 8 mn, 3 tot_o, 5866 tot_s from dual union all                                
select 16 c_nbr, 8 r_id, 14 s_id, 2001 yr, 8 mn, 3 tot_o, 31136 tot_s from dual union all                               
select 16 c_nbr, 8 r_id, 15 s_id, 2001 yr, 8 mn, 3 tot_o, 27849 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 34491 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 37126 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 43638 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 11781 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 35364 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 27306 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 387 tot_s from dual union all                                 
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 33756 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 16728 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 48591 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 12204 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 34756 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 18151 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 4715 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 15898 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 18437 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 25574 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 6087 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 39597 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 25734 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 36465 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 36538 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 12876 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 39508 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 42623 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 28014 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 34614 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 21286 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 33217 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 38653 tot_s from dual
) o;
commit;

insert into orders 
(cust_nbr, region_id, salesperson_id, year, month, tot_orders, tot_sales)
select o.c_nbr, o.r_id, o.s_id, o.yr, o.mn, o.tot_o, o.tot_s
from
(
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 4 mn, 2 tot_o, 4897 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 4 mn, 2 tot_o, 14002 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 4 mn, 2 tot_o, 42703 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 4 mn, 2 tot_o, 45455 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 5 mn, 3 tot_o, 31866 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 5 mn, 3 tot_o, 4614 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 5 mn, 3 tot_o, 18037 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 5 mn, 3 tot_o, 27333 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 6 mn, 1 tot_o, 30079 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 6 mn, 1 tot_o, 6681 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 6 mn, 1 tot_o, 8209 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 6 mn, 1 tot_o, 41676 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 7 mn, 2 tot_o, 29533 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 7 mn, 2 tot_o, 31522 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 7 mn, 2 tot_o, 10993 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 7 mn, 2 tot_o, 42075 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 8 mn, 3 tot_o, 3736 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 8 mn, 3 tot_o, 29063 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 8 mn, 3 tot_o, 8650 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 8 mn, 3 tot_o, 33240 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 9 mn, 1 tot_o, 45759 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 9 mn, 1 tot_o, 19000 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 9 mn, 1 tot_o, 8093 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 9 mn, 1 tot_o, 27248 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 10 mn, 2 tot_o, 22398 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 10 mn, 2 tot_o, 16055 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 10 mn, 2 tot_o, 27568 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 10 mn, 2 tot_o, 89 tot_s from dual union all                                 
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 11 mn, 3 tot_o, 26228 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 11 mn, 3 tot_o, 37848 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 11 mn, 3 tot_o, 475 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 11 mn, 3 tot_o, 13998 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 12 mn, 1 tot_o, 39245 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 12 mn, 1 tot_o, 18928 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 12 mn, 1 tot_o, 17371 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 12 mn, 1 tot_o, 33718 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 1 mn, 2 tot_o, 28675 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 1 mn, 2 tot_o, 3974 tot_s from dual union all                                
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 1 mn, 2 tot_o, 15598 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 1 mn, 2 tot_o, 26972 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 2 mn, 3 tot_o, 45993 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 2 mn, 3 tot_o, 22542 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 2 mn, 3 tot_o, 47158 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 2 mn, 3 tot_o, 46673 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 3 mn, 1 tot_o, 1451 tot_s from dual union all                                
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 3 mn, 1 tot_o, 50075 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 3 mn, 1 tot_o, 41890 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 3 mn, 1 tot_o, 28017 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 4 mn, 2 tot_o, 34989 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 4 mn, 2 tot_o, 29558 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 4 mn, 2 tot_o, 29135 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 4 mn, 2 tot_o, 22089 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 5 mn, 3 tot_o, 45381 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 5 mn, 3 tot_o, 34219 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 5 mn, 3 tot_o, 13099 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 5 mn, 3 tot_o, 49302 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 6 mn, 1 tot_o, 3458 tot_s from dual union all                                
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 6 mn, 1 tot_o, 11463 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 6 mn, 1 tot_o, 31054 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 6 mn, 1 tot_o, 20960 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 7 mn, 2 tot_o, 15863 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 7 mn, 2 tot_o, 8086 tot_s from dual union all                                
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 7 mn, 2 tot_o, 14733 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 7 mn, 2 tot_o, 7273 tot_s from dual union all                                
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 8 mn, 3 tot_o, 988 tot_s from dual union all                                 
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 8 mn, 3 tot_o, 48980 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 8 mn, 3 tot_o, 48796 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 8 mn, 3 tot_o, 27456 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 9 mn, 1 tot_o, 6409 tot_s from dual union all                                
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 9 mn, 1 tot_o, 31203 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 9 mn, 1 tot_o, 41702 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 9 mn, 1 tot_o, 18856 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 10 mn, 2 tot_o, 22518 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 10 mn, 2 tot_o, 38089 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 10 mn, 2 tot_o, 46682 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 10 mn, 2 tot_o, 32288 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 11 mn, 3 tot_o, 10012 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 11 mn, 3 tot_o, 23384 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 11 mn, 3 tot_o, 21333 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 11 mn, 3 tot_o, 30789 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 17 s_id, 2001 yr, 12 mn, 1 tot_o, 16525 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 18 s_id, 2001 yr, 12 mn, 1 tot_o, 19893 tot_s from dual union all                              
select 23 c_nbr, 9 r_id, 19 s_id, 2001 yr, 12 mn, 1 tot_o, 4421 tot_s from dual union all                               
select 23 c_nbr, 9 r_id, 20 s_id, 2001 yr, 12 mn, 1 tot_o, 4988 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 1 mn, 2 tot_o, 7020 tot_s from dual union all                                
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 1 mn, 2 tot_o, 13024 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 1 mn, 2 tot_o, 11902 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 1 mn, 2 tot_o, 16105 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 2 mn, 3 tot_o, 46205 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 2 mn, 3 tot_o, 40282 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 2 mn, 3 tot_o, 28080 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 2 mn, 3 tot_o, 13786 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 3 mn, 1 tot_o, 33199 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 3 mn, 1 tot_o, 3734 tot_s from dual union all                                
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 3 mn, 1 tot_o, 6900 tot_s from dual union all                                
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 3 mn, 1 tot_o, 21604 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 4 mn, 2 tot_o, 42434 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 4 mn, 2 tot_o, 28235 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 4 mn, 2 tot_o, 45816 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 4 mn, 2 tot_o, 31556 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 5 mn, 3 tot_o, 42980 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 5 mn, 3 tot_o, 26785 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 5 mn, 3 tot_o, 35758 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 5 mn, 3 tot_o, 14126 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 6 mn, 1 tot_o, 38559 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 6 mn, 1 tot_o, 9052 tot_s from dual union all                                
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 6 mn, 1 tot_o, 27779 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 6 mn, 1 tot_o, 11968 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 7 mn, 2 tot_o, 21483 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 7 mn, 2 tot_o, 42164 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 7 mn, 2 tot_o, 45110 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 7 mn, 2 tot_o, 6615 tot_s from dual union all                                
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 8 mn, 3 tot_o, 35027 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 8 mn, 3 tot_o, 8878 tot_s from dual union all                                
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 8 mn, 3 tot_o, 10626 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 8 mn, 3 tot_o, 35441 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 9 mn, 1 tot_o, 5489 tot_s from dual union all                                
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 9 mn, 1 tot_o, 29429 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 9 mn, 1 tot_o, 35429 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 9 mn, 1 tot_o, 29404 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 10 mn, 2 tot_o, 35296 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 10 mn, 2 tot_o, 49721 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 10 mn, 2 tot_o, 35356 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 10 mn, 2 tot_o, 3388 tot_s from dual union all                               
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 11 mn, 3 tot_o, 41660 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 11 mn, 3 tot_o, 27994 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 11 mn, 3 tot_o, 13862 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 11 mn, 3 tot_o, 11645 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 17 s_id, 2001 yr, 12 mn, 1 tot_o, 39726 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 18 s_id, 2001 yr, 12 mn, 1 tot_o, 27464 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 19 s_id, 2001 yr, 12 mn, 1 tot_o, 27329 tot_s from dual union all                              
select 24 c_nbr, 9 r_id, 20 s_id, 2001 yr, 12 mn, 1 tot_o, 9567 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 1 mn, 2 tot_o, 39642 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 1 mn, 2 tot_o, 61535 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 1 mn, 2 tot_o, 64893 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 1 mn, 2 tot_o, 32270 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 2 mn, 3 tot_o, 56159 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 2 mn, 3 tot_o, 74933 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 2 mn, 3 tot_o, 29427 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 2 mn, 3 tot_o, 2859 tot_s from dual union all                                
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 3 mn, 1 tot_o, 32115 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 3 mn, 1 tot_o, 45621 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 3 mn, 1 tot_o, 54131 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 3 mn, 1 tot_o, 68046 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 4 mn, 2 tot_o, 33843 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 4 mn, 2 tot_o, 13718 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 4 mn, 2 tot_o, 41057 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 4 mn, 2 tot_o, 73331 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 5 mn, 3 tot_o, 65151 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 5 mn, 3 tot_o, 72104 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 5 mn, 3 tot_o, 36617 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 5 mn, 3 tot_o, 73301 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 6 mn, 1 tot_o, 72126 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 6 mn, 1 tot_o, 6863 tot_s from dual union all                                
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 6 mn, 1 tot_o, 7152 tot_s from dual union all                                
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 6 mn, 1 tot_o, 62934 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 7 mn, 2 tot_o, 32727 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 7 mn, 2 tot_o, 72740 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 7 mn, 2 tot_o, 43617 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 7 mn, 2 tot_o, 72467 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 8 mn, 3 tot_o, 12279 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 8 mn, 3 tot_o, 42765 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 8 mn, 3 tot_o, 67404 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 8 mn, 3 tot_o, 31970 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 9 mn, 1 tot_o, 9885 tot_s from dual union all                                
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 9 mn, 1 tot_o, 42669 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 9 mn, 1 tot_o, 72702 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 9 mn, 1 tot_o, 68802 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 10 mn, 2 tot_o, 53280 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 10 mn, 2 tot_o, 69528 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 10 mn, 2 tot_o, 15201 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 10 mn, 2 tot_o, 74547 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 11 mn, 3 tot_o, 41373 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 11 mn, 3 tot_o, 67377 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 11 mn, 3 tot_o, 2742 tot_s from dual union all                               
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 11 mn, 3 tot_o, 20798 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 17 s_id, 2001 yr, 12 mn, 1 tot_o, 48404 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 18 s_id, 2001 yr, 12 mn, 1 tot_o, 54194 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 19 s_id, 2001 yr, 12 mn, 1 tot_o, 33149 tot_s from dual union all                              
select 25 c_nbr, 9 r_id, 20 s_id, 2001 yr, 12 mn, 1 tot_o, 62255 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 1 mn, 2 tot_o, 9785 tot_s from dual union all                               
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 1 mn, 2 tot_o, 17513 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 1 mn, 2 tot_o, 50873 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 1 mn, 2 tot_o, 52436 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 2 mn, 3 tot_o, 5564 tot_s from dual union all                               
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 2 mn, 3 tot_o, 6056 tot_s from dual union all                               
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 2 mn, 3 tot_o, 66312 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 2 mn, 3 tot_o, 42527 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 3 mn, 1 tot_o, 19379 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 3 mn, 1 tot_o, 18621 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 3 mn, 1 tot_o, 10158 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 3 mn, 1 tot_o, 71016 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 4 mn, 2 tot_o, 72198 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 4 mn, 2 tot_o, 2874 tot_s from dual union all                               
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 4 mn, 2 tot_o, 5067 tot_s from dual union all                               
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 4 mn, 2 tot_o, 62127 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 5 mn, 3 tot_o, 48392 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 5 mn, 3 tot_o, 11936 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 5 mn, 3 tot_o, 39143 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 5 mn, 3 tot_o, 27773 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 6 mn, 1 tot_o, 20709 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 6 mn, 1 tot_o, 65754 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 6 mn, 1 tot_o, 38682 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 6 mn, 1 tot_o, 66626 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 7 mn, 2 tot_o, 35171 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 7 mn, 2 tot_o, 6023 tot_s from dual union all                               
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 7 mn, 2 tot_o, 54201 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 7 mn, 2 tot_o, 69365 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 8 mn, 3 tot_o, 53840 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 8 mn, 3 tot_o, 404 tot_s from dual union all                                
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 8 mn, 3 tot_o, 10293 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 8 mn, 3 tot_o, 62840 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 9 mn, 1 tot_o, 59669 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 9 mn, 1 tot_o, 47153 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 9 mn, 1 tot_o, 64991 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 9 mn, 1 tot_o, 52944 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 10 mn, 2 tot_o, 1607 tot_s from dual union all                              
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 10 mn, 2 tot_o, 56180 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 10 mn, 2 tot_o, 50453 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 10 mn, 2 tot_o, 10635 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 11 mn, 3 tot_o, 21392 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 11 mn, 3 tot_o, 42962 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 11 mn, 3 tot_o, 37682 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 11 mn, 3 tot_o, 64416 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 21 s_id, 2001 yr, 12 mn, 1 tot_o, 42494 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 22 s_id, 2001 yr, 12 mn, 1 tot_o, 55368 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 23 s_id, 2001 yr, 12 mn, 1 tot_o, 27479 tot_s from dual union all                             
select 26 c_nbr, 10 r_id, 24 s_id, 2001 yr, 12 mn, 1 tot_o, 49866 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 1 mn, 2 tot_o, 23722 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 1 mn, 2 tot_o, 2331 tot_s from dual union all                               
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 1 mn, 2 tot_o, 31248 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 1 mn, 2 tot_o, 8135 tot_s from dual union all                               
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 2 mn, 3 tot_o, 46631 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 2 mn, 3 tot_o, 21289 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 2 mn, 3 tot_o, 29512 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 2 mn, 3 tot_o, 3372 tot_s from dual union all                               
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 3 mn, 1 tot_o, 34259 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 3 mn, 1 tot_o, 6548 tot_s from dual union all                               
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 3 mn, 1 tot_o, 37883 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 3 mn, 1 tot_o, 8782 tot_s from dual union all                               
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 4 mn, 2 tot_o, 27707 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 4 mn, 2 tot_o, 39252 tot_s from dual union all                              
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 12 mn, 1 tot_o, 14753 tot_s from dual union all                              
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 12 mn, 1 tot_o, 12236 tot_s from dual union all                              
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 1 mn, 2 tot_o, 392 tot_s from dual union all                                 
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 1 mn, 2 tot_o, 6376 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 1 mn, 2 tot_o, 13192 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 1 mn, 2 tot_o, 42630 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 2 mn, 3 tot_o, 880 tot_s from dual union all                                 
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 2 mn, 3 tot_o, 37454 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 2 mn, 3 tot_o, 8179 tot_s from dual union all                                
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 2 mn, 3 tot_o, 30704 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 17 s_id, 2001 yr, 3 mn, 1 tot_o, 41251 tot_s from dual union all                               
select 22 c_nbr, 9 r_id, 18 s_id, 2001 yr, 3 mn, 1 tot_o, 217 tot_s from dual union all                                 
select 22 c_nbr, 9 r_id, 19 s_id, 2001 yr, 3 mn, 1 tot_o, 236 tot_s from dual union all                                 
select 22 c_nbr, 9 r_id, 20 s_id, 2001 yr, 3 mn, 1 tot_o, 36250 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 1 mn, 2 tot_o, 38859 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 1 mn, 2 tot_o, 9809 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 1 mn, 2 tot_o, 6025 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 1 mn, 2 tot_o, 2709 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 2 mn, 3 tot_o, 9882 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 2 mn, 3 tot_o, 19953 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 2 mn, 3 tot_o, 10232 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 2 mn, 3 tot_o, 2220 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 3 mn, 1 tot_o, 36618 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 3 mn, 1 tot_o, 8312 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 3 mn, 1 tot_o, 36194 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 3 mn, 1 tot_o, 31311 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 4 mn, 2 tot_o, 34964 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 4 mn, 2 tot_o, 4836 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 4 mn, 2 tot_o, 45048 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 4 mn, 2 tot_o, 13706 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 5 mn, 3 tot_o, 23907 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 5 mn, 3 tot_o, 40373 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 5 mn, 3 tot_o, 48074 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 5 mn, 3 tot_o, 49257 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 6 mn, 1 tot_o, 14228 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 6 mn, 1 tot_o, 6951 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 6 mn, 1 tot_o, 32780 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 6 mn, 1 tot_o, 5711 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 7 mn, 2 tot_o, 42965 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 7 mn, 2 tot_o, 25537 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 7 mn, 2 tot_o, 20789 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 7 mn, 2 tot_o, 24126 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 8 mn, 3 tot_o, 2968 tot_s from dual union all                                
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 8 mn, 3 tot_o, 11542 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 8 mn, 3 tot_o, 47635 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 8 mn, 3 tot_o, 18326 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 9 mn, 1 tot_o, 35436 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 9 mn, 1 tot_o, 152 tot_s from dual union all                                 
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 9 mn, 1 tot_o, 14211 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 9 mn, 1 tot_o, 39873 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 10 mn, 2 tot_o, 35698 tot_s from dual union all                              
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 10 mn, 2 tot_o, 1355 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 10 mn, 2 tot_o, 14966 tot_s from dual union all                              
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 10 mn, 2 tot_o, 4682 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 11 mn, 3 tot_o, 11013 tot_s from dual union all                              
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 11 mn, 3 tot_o, 6691 tot_s from dual union all                               
select 21 c_nbr, 9 r_id, 19 s_id, 2001 yr, 11 mn, 3 tot_o, 43151 tot_s from dual union all                              
select 21 c_nbr, 9 r_id, 20 s_id, 2001 yr, 11 mn, 3 tot_o, 14862 tot_s from dual union all                              
select 21 c_nbr, 9 r_id, 17 s_id, 2001 yr, 12 mn, 1 tot_o, 29705 tot_s from dual union all                              
select 21 c_nbr, 9 r_id, 18 s_id, 2001 yr, 12 mn, 1 tot_o, 15910 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 7 mn, 2 tot_o, 12074 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 8 mn, 3 tot_o, 19674 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 8 mn, 3 tot_o, 17509 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 8 mn, 3 tot_o, 48936 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 8 mn, 3 tot_o, 26874 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 9 mn, 1 tot_o, 20252 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 9 mn, 1 tot_o, 31485 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 9 mn, 1 tot_o, 27779 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 9 mn, 1 tot_o, 44073 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 10 mn, 2 tot_o, 44959 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 10 mn, 2 tot_o, 3949 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 10 mn, 2 tot_o, 38075 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 10 mn, 2 tot_o, 47440 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 11 mn, 3 tot_o, 1486 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 11 mn, 3 tot_o, 45386 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 11 mn, 3 tot_o, 3114 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 11 mn, 3 tot_o, 49961 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 12 mn, 1 tot_o, 49890 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 12 mn, 1 tot_o, 20092 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 12 mn, 1 tot_o, 33951 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 12 mn, 1 tot_o, 45238 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 1 mn, 2 tot_o, 24456 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 1 mn, 2 tot_o, 7522 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 1 mn, 2 tot_o, 4117 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 1 mn, 2 tot_o, 36131 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 2 mn, 3 tot_o, 29270 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 2 mn, 3 tot_o, 36367 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 2 mn, 3 tot_o, 23430 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 2 mn, 3 tot_o, 12875 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 3 mn, 1 tot_o, 1356 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 3 mn, 1 tot_o, 10489 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 3 mn, 1 tot_o, 43610 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 3 mn, 1 tot_o, 39707 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 4 mn, 2 tot_o, 12201 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 4 mn, 2 tot_o, 7173 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 4 mn, 2 tot_o, 102 tot_s from dual union all                                
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 4 mn, 2 tot_o, 22086 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 5 mn, 3 tot_o, 1536 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 5 mn, 3 tot_o, 10936 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 5 mn, 3 tot_o, 11890 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 5 mn, 3 tot_o, 3930 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 6 mn, 1 tot_o, 16604 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 6 mn, 1 tot_o, 25467 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 6 mn, 1 tot_o, 24303 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 6 mn, 1 tot_o, 20509 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 7 mn, 2 tot_o, 4712 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 7 mn, 2 tot_o, 35756 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 7 mn, 2 tot_o, 2899 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 7 mn, 2 tot_o, 14352 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 8 mn, 3 tot_o, 46090 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 8 mn, 3 tot_o, 20734 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 8 mn, 3 tot_o, 11437 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 8 mn, 3 tot_o, 37858 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 9 mn, 1 tot_o, 8497 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 9 mn, 1 tot_o, 7342 tot_s from dual union all                               
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 9 mn, 1 tot_o, 21607 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 9 mn, 1 tot_o, 36194 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 10 mn, 2 tot_o, 45455 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 10 mn, 2 tot_o, 45769 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 10 mn, 2 tot_o, 40598 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 10 mn, 2 tot_o, 7702 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 11 mn, 3 tot_o, 15377 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 11 mn, 3 tot_o, 44790 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 11 mn, 3 tot_o, 22232 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 11 mn, 3 tot_o, 19436 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 21 s_id, 2001 yr, 12 mn, 1 tot_o, 29822 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 22 s_id, 2001 yr, 12 mn, 1 tot_o, 14571 tot_s from dual union all                             
select 28 c_nbr, 10 r_id, 23 s_id, 2001 yr, 12 mn, 1 tot_o, 1243 tot_s from dual union all                              
select 28 c_nbr, 10 r_id, 24 s_id, 2001 yr, 12 mn, 1 tot_o, 26424 tot_s from dual union all                             
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 1 mn, 2 tot_o, 20275 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 1 mn, 2 tot_o, 11594 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 1 mn, 2 tot_o, 27292 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 1 mn, 2 tot_o, 9885 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 2 mn, 3 tot_o, 21223 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 2 mn, 3 tot_o, 18342 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 2 mn, 3 tot_o, 1869 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 2 mn, 3 tot_o, 6853 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 3 mn, 1 tot_o, 16681 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 3 mn, 1 tot_o, 27817 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 3 mn, 1 tot_o, 26114 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 3 mn, 1 tot_o, 1236 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 4 mn, 2 tot_o, 30503 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 4 mn, 2 tot_o, 8270 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 4 mn, 2 tot_o, 1583 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 4 mn, 2 tot_o, 19457 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 5 mn, 3 tot_o, 23450 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 5 mn, 3 tot_o, 11381 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 5 mn, 3 tot_o, 30110 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 5 mn, 3 tot_o, 43344 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 6 mn, 1 tot_o, 38001 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 6 mn, 1 tot_o, 14102 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 6 mn, 1 tot_o, 3189 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 6 mn, 1 tot_o, 40314 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 7 mn, 2 tot_o, 10453 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 7 mn, 2 tot_o, 16257 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 7 mn, 2 tot_o, 3232 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 7 mn, 2 tot_o, 39815 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 8 mn, 3 tot_o, 37494 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 8 mn, 3 tot_o, 49658 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 8 mn, 3 tot_o, 29664 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 8 mn, 3 tot_o, 1612 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 9 mn, 1 tot_o, 2435 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 9 mn, 1 tot_o, 46406 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 9 mn, 1 tot_o, 2361 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 9 mn, 1 tot_o, 1467 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 10 mn, 2 tot_o, 12478 tot_s from dual union all                             
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 10 mn, 2 tot_o, 36708 tot_s from dual union all                             
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 10 mn, 2 tot_o, 7605 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 10 mn, 2 tot_o, 1420 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 11 mn, 3 tot_o, 6122 tot_s from dual union all                              
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 11 mn, 3 tot_o, 22090 tot_s from dual union all                             
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 11 mn, 3 tot_o, 41639 tot_s from dual union all                             
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 11 mn, 3 tot_o, 640 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 21 s_id, 2001 yr, 12 mn, 1 tot_o, 27441 tot_s from dual union all                             
select 29 c_nbr, 10 r_id, 22 s_id, 2001 yr, 12 mn, 1 tot_o, 34416 tot_s from dual union all                             
select 29 c_nbr, 10 r_id, 23 s_id, 2001 yr, 12 mn, 1 tot_o, 560 tot_s from dual union all                               
select 29 c_nbr, 10 r_id, 24 s_id, 2001 yr, 12 mn, 1 tot_o, 18525 tot_s from dual union all                             
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 1 mn, 2 tot_o, 43189 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 1 mn, 2 tot_o, 25744 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 1 mn, 2 tot_o, 2690 tot_s from dual union all                               
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 1 mn, 2 tot_o, 41224 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 2 mn, 3 tot_o, 26130 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 2 mn, 3 tot_o, 27833 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 2 mn, 3 tot_o, 9859 tot_s from dual union all                               
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 2 mn, 3 tot_o, 45870 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 3 mn, 1 tot_o, 31261 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 3 mn, 1 tot_o, 2538 tot_s from dual union all                               
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 3 mn, 1 tot_o, 23101 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 3 mn, 1 tot_o, 42869 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 4 mn, 2 tot_o, 7915 tot_s from dual union all                               
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 4 mn, 2 tot_o, 4393 tot_s from dual union all                               
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 4 mn, 2 tot_o, 31839 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 4 mn, 2 tot_o, 40844 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 5 mn, 3 tot_o, 47625 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 5 mn, 3 tot_o, 48121 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 5 mn, 3 tot_o, 26367 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 5 mn, 3 tot_o, 33616 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 6 mn, 1 tot_o, 31619 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 6 mn, 1 tot_o, 32589 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 6 mn, 1 tot_o, 44278 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 6 mn, 1 tot_o, 2973 tot_s from dual union all                               
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 7 mn, 2 tot_o, 15890 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 7 mn, 2 tot_o, 45151 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 7 mn, 2 tot_o, 17386 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 7 mn, 2 tot_o, 16038 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 8 mn, 3 tot_o, 46911 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 8 mn, 3 tot_o, 22849 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 8 mn, 3 tot_o, 32242 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 8 mn, 3 tot_o, 43861 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 9 mn, 1 tot_o, 17112 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 9 mn, 1 tot_o, 27141 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 9 mn, 1 tot_o, 4442 tot_s from dual union all                               
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 9 mn, 1 tot_o, 12973 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 10 mn, 2 tot_o, 4772 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 10 mn, 2 tot_o, 37075 tot_s from dual union all                             
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 10 mn, 2 tot_o, 29115 tot_s from dual union all                             
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 10 mn, 2 tot_o, 5425 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 11 mn, 3 tot_o, 22347 tot_s from dual union all                             
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 11 mn, 3 tot_o, 47337 tot_s from dual union all                             
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 11 mn, 3 tot_o, 17739 tot_s from dual union all                             
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 11 mn, 3 tot_o, 31161 tot_s from dual union all                             
select 30 c_nbr, 10 r_id, 21 s_id, 2001 yr, 12 mn, 1 tot_o, 8914 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 22 s_id, 2001 yr, 12 mn, 1 tot_o, 2365 tot_s from dual union all                              
select 30 c_nbr, 10 r_id, 23 s_id, 2001 yr, 12 mn, 1 tot_o, 16023 tot_s from dual union all                             
select 30 c_nbr, 10 r_id, 24 s_id, 2001 yr, 12 mn, 1 tot_o, 18102 tot_s from dual union all                             
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 4 mn, 2 tot_o, 13056 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 4 mn, 2 tot_o, 49736 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 5 mn, 3 tot_o, 45620 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 5 mn, 3 tot_o, 26499 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 5 mn, 3 tot_o, 43955 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 5 mn, 3 tot_o, 29536 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 6 mn, 1 tot_o, 12136 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 6 mn, 1 tot_o, 10415 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 6 mn, 1 tot_o, 28088 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 24 s_id, 2001 yr, 6 mn, 1 tot_o, 30076 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 21 s_id, 2001 yr, 7 mn, 2 tot_o, 39999 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 22 s_id, 2001 yr, 7 mn, 2 tot_o, 25624 tot_s from dual union all                              
select 27 c_nbr, 10 r_id, 23 s_id, 2001 yr, 7 mn, 2 tot_o, 15139 tot_s from dual
) o;
commit;

update orders 
set tot_sales = tot_sales + 1716 
where year = 2001
and salesperson_id = 15 
and month = 12 
and cust_nbr = 20;
commit;


insert into all_orders 
(cust_nbr, region_id, salesperson_id, year, month, tot_orders, tot_sales)
select o.c_nbr, o.r_id, o.s_id, o.yr, o.mn, o.tot_o, o.tot_s
from
(
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 8118 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 13009 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 39906 tot_s from dual union all                                    
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 57411 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 30575 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 45417 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 72291 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 49118 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 10724 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 4391 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 67010 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 51894 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 67139 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 14657 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 61640 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 33345 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 19737 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 41354 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 3965 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 11460 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 22490 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 4097 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 18717 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 34235 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 20514 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 70827 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 38100 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 66957 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 41519 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 33083 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 67274 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 42015 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 25604 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 21585 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 73791 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 32891 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 20659 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 34459 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 30923 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 1937 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 6757 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 3750 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 1326 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 12659 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 48901 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 33458 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 37879 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 10046 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 19778 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 34352 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 36120 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 3143 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 3030 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 36144 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 11029 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 36085 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 39232 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 38494 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 6315 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 19302 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 24264 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 29943 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 21862 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 2380 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 9282 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 32730 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 9111 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 38820 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 17633 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 4581 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 2431 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 32999 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 4722 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 25281 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 21578 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 10508 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 9590 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 26239 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 6270 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 32700 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 13732 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 15077 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 21183 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 1949 tot_s from dual union all                                       
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 12509 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 29279 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 37496 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 20295 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 26285 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 28910 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 24404 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 18325 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 37805 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 26187 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 22282 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 29123 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 40117 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 18813 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 438 tot_s from dual union all                                        
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 39936 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 47721 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 13713 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 49552 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 2098 tot_s from dual union all                                       
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 35669 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 41140 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 19233 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 13978 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 14214 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 9300 tot_s from dual union all                                       
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 23214 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 23632 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 23027 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 899 tot_s from dual union all                                        
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 44651 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 38352 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 27262 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 17240 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 46076 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 9595 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 22778 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 43081 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 30547 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 21159 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 4993 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 1884 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 14474 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 41203 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 17496 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 5458 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 23846 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 38466 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 39124 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 33315 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 45994 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 27196 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 534 tot_s from dual union all                                        
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 13817 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 38628 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 126 tot_s from dual union all                                        
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 46577 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 40879 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 32670 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 29856 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 46789 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 6352 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 30079 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 38469 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 17651 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 2805 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 12121 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 36296 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 14703 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 6707 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 7821 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 26117 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 38427 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 41519 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 37491 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 44772 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 20000 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 31212 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 1086 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 1689 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 613 tot_s from dual union all                                        
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 3818 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 25769 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 49091 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 11883 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 20575 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 38371 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 45913 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 2959 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 40003 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 46858 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 610 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 13328 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 15972 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 43908 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 46046 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 25677 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 24245 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 21691 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 29390 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 27847 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 42624 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 38946 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 25902 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 48235 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 6888 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 9021 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 46064 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 9202 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 14141 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 25217 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 20592 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 13659 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 31842 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 45834 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 32074 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 329 tot_s from dual union all                                       
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 34891 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 19155 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 44012 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 13797 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 41860 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 12284 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 25222 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 35863 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 12687 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 45565 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 39348 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 43871 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 17415 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 11216 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 18751 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 2761 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 13434 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 994 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 22250 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 29667 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 9849 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 31440 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 23917 tot_s from dual union all                                    
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 20863 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 2875 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 49763 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 18053 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 22182 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 11114 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 31234 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 29066 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 42391 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 22247 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 38541 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 2417 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 28269 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 24362 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 48825 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 2231 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 26107 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 42036 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 15520 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 47335 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 4928 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 41890 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 27627 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 32799 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 8809 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 44165 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 24777 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 30864 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 36886 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 1690 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 25878 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 8451 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 37432 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 29462 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 6817 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 43173 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 36052 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 23338 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 382 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 31963 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 41485 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 942 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 13721 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 867 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 45300 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 10435 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 2581 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 13017 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 29993 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 4744 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 5042 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 40138 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 23357 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 7118 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 18495 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 46925 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 20443 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 1612 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 39409 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 17530 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 36205 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 31954 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 5983 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 3227 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 19382 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 18761 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 35841 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 37724 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 27623 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 25042 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 46864 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 41975 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 16380 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 47356 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 21605 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 36225 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 25728 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 3609 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 30780 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 37795 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 23786 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 46333 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 5594 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 16355 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 17790 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 32224 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 21220 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 18721 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 45522 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 30370 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 955 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 45660 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 28694 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 29766 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 41407 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 15730 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 6895 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 4477 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 38005 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 46325 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 41205 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 22846 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 47639 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 12986 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 25503 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 43161 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 30512 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 24227 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 30108 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 38883 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 41875 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 33842 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 21348 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 10415 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 7287 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 8182 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 37579 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 41835 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 11104 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 11693 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 14989 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 10199 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 43212 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 25527 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 21873 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 38326 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 354 tot_s from dual union all                                        
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 17113 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 33718 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 10198 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 36699 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 11122 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 49856 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 9739 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 25815 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 21218 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 12898 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 1680 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 18727 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 14280 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 44508 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 36496 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 24035 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 772 tot_s from dual union all                                       
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 69830 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 27533 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 21116 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 15486 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 57999 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 10352 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 73760 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 27756 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 48480 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 6929 tot_s from dual union all                                       
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 67883 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 54719 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 63117 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 32093 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 33707 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 52218 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 40143 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 60920 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 20241 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 69519 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 33035 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 13361 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 20963 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 11474 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 26795 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 875 tot_s from dual union all                                        
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 68795 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 66764 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 72398 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 62186 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 56280 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 67550 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 52131 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 71195 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 13881 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 50910 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 12038 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 38127 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 13527 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 37802 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 31529 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 8036 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 1862 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 51563 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 57383 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 44913 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 19506 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 19595 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 37663 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 44376 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 15972 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 10066 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 49008 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 11412 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 33475 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 37817 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 7661 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 8384 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 28236 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 36198 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 28239 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 38251 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 68 tot_s from dual union all                                         
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 24165 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 33753 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 22088 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 6178 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 23505 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 22575 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 13145 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 16987 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 20855 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 19372 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 38136 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 4123 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 10366 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 5564 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 381 tot_s from dual union all                                        
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 5886 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 28928 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 31639 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 6489 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 27978 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 20677 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 46552 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 44397 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 19382 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 49505 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 37518 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 39107 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 24340 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 40333 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 37071 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 17512 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 22768 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 21825 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 14802 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 46230 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 23592 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 51350 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 50267 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 5091 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 28211 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 12461 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 49256 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 57671 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 40347 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 41963 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 22208 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 6284 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 60221 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 55946 tot_s from dual
) o;
commit;

insert into all_orders 
(cust_nbr, region_id, salesperson_id, year, month, tot_orders, tot_sales)
select o.c_nbr, o.r_id, o.s_id, o.yr, o.mn, o.tot_o, o.tot_s
from
(
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 5847 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 16686 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 31238 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 40836 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 32795 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 38221 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 16468 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 22554 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 35626 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 125 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 22235 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 16558 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 12631 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 23231 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 2552 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 6814 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 13049 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 38840 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 19139 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 23110 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 16623 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 32682 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 8826 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 13203 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 20448 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 27427 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 9569 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 39969 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 14245 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 31149 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 46148 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 15714 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 23374 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 8235 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 46252 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 16769 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 39636 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 44744 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 25329 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 42246 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 15128 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 19870 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 6030 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 20328 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 41585 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 9411 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 6106 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 13935 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 45998 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 9269 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 4896 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 47771 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 24524 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 17274 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 18110 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 49696 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 17515 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 4929 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 45791 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 45147 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 42772 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 6280 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 38328 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 32402 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 31761 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 2582 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 6729 tot_s from dual union all                                 
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 24330 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 5084 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 3821 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 41165 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 48420 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 7628 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 48569 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 16841 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 1562 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 34505 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 29319 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 25866 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 10151 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 10098 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 12134 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 38856 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 36876 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 40473 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 48558 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 11187 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 20739 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 36565 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 34554 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 35318 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 44188 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 24427 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 37059 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 48050 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 43231 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 43886 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 13840 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 18060 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 13101 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 21009 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 20672 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 35757 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 14969 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 18760 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 38544 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 22735 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 36580 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 19996 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 18842 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 37052 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 48985 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 19393 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 41950 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 8138 tot_s from dual union all                                 
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 9971 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 28316 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 34374 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 57393 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 12408 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 59190 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 23172 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 62882 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 68912 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 65039 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 50226 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 52419 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 37374 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 16992 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 62543 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 57096 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 31625 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 26925 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 54732 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 32669 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 26903 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 36120 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 64077 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 39453 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 9182 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 61202 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 32460 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 7268 tot_s from dual union all                                 
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 30960 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 74861 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 21218 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 58583 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 48222 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 50066 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 60426 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 62457 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 10122 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 42308 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 24924 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 48666 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 56655 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 20678 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 38682 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 54816 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 28749 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 44624 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 23696 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 11100 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 28644 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 28731 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 32233 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 7649 tot_s from dual union all                                 
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 31285 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 25831 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 47475 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 27123 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 33080 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 32041 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 16510 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 47685 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 37045 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 47005 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 29464 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 1492 tot_s from dual union all                                 
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 16615 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 33397 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 12 tot_s from dual union all                                  
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 44933 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 37064 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 18287 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 6088 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 9910 tot_s from dual union all                                 
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 5137 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 37298 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 31725 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 10503 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 20929 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 31916 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 11396 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 41831 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 7065 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 22725 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 35896 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 25328 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 49140 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 9930 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 39579 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 27529 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 27933 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 373 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 20552 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 46300 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 45398 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 13749 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 42660 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 34491 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 37126 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 43638 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 11781 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 35364 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 27306 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 387 tot_s from dual union all                                 
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 33756 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 16728 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 48591 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 12204 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 34756 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 18151 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 4715 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 15898 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 18437 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 25574 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 6087 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 39597 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 25734 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 36465 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 36538 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 12876 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 39508 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 42623 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 28014 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 34614 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 21286 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 33217 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 38653 tot_s from dual
) o;
commit; 


insert into all_orders
select CUST_NBR, REGION_ID, SALESPERSON_ID, 2000, MONTH, 2*TOT_ORDERS, 2*TOT_SALES
from all_orders;
commit;

insert into DISPUTED_ORDERS 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,STATUS)
select co.ord, co.cust, co.emp, co.price, to_date(co.o_dt, 'DD-MON-YYYY HH:MI:SS'), co.es_dt, co.status
from
(
select 1001 ord,1 cust, 7354 emp,99 price,'22-JUL-2001 09:23:32' o_dt, '23-JUL-01' es_dt, 'DELIVERED' status from dual union all
select 1000 ord,1 cust, 7354 emp,null price,'19-JUL-2001 09:23:32' o_dt, '24-JUL-01' es_dt, null status from dual union all
select 1002 ord,5 cust, 7368 emp,null price,'12-JUL-2001 09:23:32' o_dt, '25-JUL-01' es_dt, null status from dual union all
select 1003 ord,4 cust, 7654 emp,56 price,'16-JUL-2001 09:23:32' o_dt, '26-JUL-01' es_dt, 'DELIVERED' status from dual union all
select 1004 ord,4 cust, 7654 emp,34 price,'18-JUL-2001 09:23:32' o_dt, '27-JUL-01' es_dt, 'PENDING' status from dual union all
select 1005 ord,8 cust, 7654 emp,99 price,'22-JUL-2001 09:23:32' o_dt, '24-JUL-01' es_dt, 'DELIVERED' status from dual union all
select 1006 ord,1 cust, 7354 emp,null price,'22-JUL-2001 09:23:32' o_dt, '28-JUL-01' es_dt, null status from dual union all
select 1007 ord,5 cust, 7368 emp,25 price,'20-JUL-2001 09:23:32' o_dt, '22-JUL-01' es_dt,  'PENDING' status from dual union all
select 1008 ord,5 cust, 7368 emp,25 price,'21-JUL-2001 09:23:32' o_dt, '23-JUL-01' es_dt,  'PENDING' status from dual union all
select 1009 ord,1 cust, 7354 emp,56 price,'18-JUL-2001 09:23:32' o_dt, '22-JUL-01' es_dt,  'DELIVERED' status from dual union all
select 1012 ord,1 cust, 7354 emp,99 price,'22-JUL-2001 09:23:32' o_dt, '23-JUL-01' es_dt,  'DELIVERED' status from dual union all
select 1011 ord,1 cust, 7354 emp,null price,'19-JUL-2001 09:23:32' o_dt, '24-JUL-01' es_dt, null status from dual union all
select 1015 ord,5 cust, 7368 emp,null price,'12-JUL-2001 09:23:32' o_dt, '25-JUL-01' es_dt, null status from dual union all
select 1017 ord,4 cust, 7654 emp,56 price,'16-JUL-2001 09:23:32' o_dt, '26-JUL-01' es_dt,  'DELIVERED' status from dual union all
select 1019 ord,4 cust, 7654 emp,34 price,'18-JUL-2001 09:23:32' o_dt, '27-JUL-01' es_dt,  'PENDING' status from dual union all
select 1021 ord,8 cust, 7654 emp,99 price,'22-JUL-2001 09:23:32' o_dt, '24-JUL-01' es_dt,  'DELIVERED' status from dual union all
select 1023 ord,1 cust, 7354 emp,null price,'22-JUL-2001 09:23:32' o_dt, '28-JUL-01' es_dt, null status from dual union all
select 1025 ord,5 cust, 7368 emp,25 price,'20-JUL-2001 09:23:32' o_dt, '22-JUL-01' es_dt,  'PENDING' status from dual union all
select 1027 ord,5 cust, 7368 emp,25 price,'21-JUL-2001 09:23:32' o_dt, '23-JUL-01' es_dt,  'PENDING' status from dual union all
select 1029 ord,1 cust, 7354 emp,56 price,'18-JUL-2001 09:23:32' o_dt, '22-JUL-01' es_dt,  'DELIVERED' status from dual
) co;
commit;

INSERT INTO REPORT
(REPORT_ID, CREATED_BY, SENT_TO)
SELECT rep.id, rep.source, rep.dest
FROM
(
select '01011999' id, 'John' source, 'Manager' dest from dual union all
select '01121999' id, 'Mike' source, 'Director' dest from dual union all
select '01231999' id, 'David' source, 'Vice President' dest from dual
) rep;
commit;


CREATE TABLE SALES_HISTORY AS
SELECT REGION_ID, YEAR, MONTH, SUM(TOT_SALES) SALES
FROM ALL_ORDERS
GROUP BY REGION_ID, YEAR, MONTH;

update sales_history
set sales = NULL
where month = 12;

insert into sales_history
select * from sales_history
where month = 11;

commit;

insert into MONTHLY_SALES_ADJUSTMENT 
(month, factor)
select a.mn, a.fc
from
(
select 1 mn,  0.90 fc from dual union all
select 2 mn,  0.93 fc from dual union all
select 3 mn,  0.88 fc from dual union all
select 4 mn,  1.03 fc from dual union all
select 5 mn,  1.04 fc from dual union all
select 6 mn,  0.96 fc from dual union all
select 7 mn,  0.92 fc from dual union all
select 8 mn,  0.90 fc from dual union all
select 9 mn,  0.98 fc from dual union all
select 10 mn, 0.82 fc from dual union all
select 11 mn, 1.10 fc from dual union all
select 12 mn, 1.25 fc from dual
) a;
commit;

INSERT INTO employee_comment VALUES (7369,
'126 Varnum, Edmore MI 48829, 989 313-5351');

INSERT INTO employee_comment VALUES (7499,
'1105 McConnell Court
Cedar Lake MI 48812
Home: 989-387-4321
Cell: (237) 438-3333');

INSERT INTO employee_comment VALUES (7521,
'Her address is: 12646 Bramell. Her city and state are Vestaburg, MI 48891
Home phone is 387-1698');

INSERT INTO employee_comment VALUES (7566,
'Phone number: 989.387.4444, Address: 23 Fleepy Lane, Edmore, MI, 48829');

INSERT INTO employee_comment VALUES (7654,
'231-898-9823
1873 Lilac
Howard City MI 49329');

INSERT INTO employee_comment VALUES (7698,
'Marion Blake
N1375 Lakeshore Drive
Vestaburg MI 48891
(989) 388-1234');

INSERT INTO employee_comment VALUES (7782,
'Academy Apartments, #138, Cedar Lake MI 48812');

INSERT INTO employee_comment VALUES (7788,
'#1 Water Tower Lane
Cedar Lake MI 48812');

INSERT INTO employee_comment VALUES (7839,
'100 Magnetic Drive, Edmore MI 48829');

INSERT INTO employee_comment VALUES (7844,
'989-387.5359');

INSERT INTO employee_comment VALUES (7876,'Home phone: (231) 453-9999');

INSERT INTO employee_comment VALUES (7900,
'Cares for 100-year-old aunt during the day. Schedule only for evening and night shifts.');

COMMIT;


