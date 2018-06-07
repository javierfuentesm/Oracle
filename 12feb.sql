spool %ORA_OUT3%\ej_1_12_febrero.txt
	desc hr.employees;
	desc dba_tab_columns;
	column owner format A15;
	column table_name format A20;
	column column_name format A15;
set colsep '*'

select owner,table_name,column_name
		from dba_tab_columns
		where owner 'HR' and table_name='EMPLOYEES';
spool off

ALTER USER HR IDENTIFIED BY HR ACCOUNT UNLOCK;

select table_name,column_name
		from user_tab_columns
		where table_name LIKE '%EMPLOY%';

select owner,table_name,column_name
		from ALL_tab_columns
		where owner='HR' and table_name='EMPLOYEES';

desc ALL_OBJECTS
REM

SET PAGESIZE 00
SET LINESIZE 150
SET COLSEP '|'
SET UNDERLINE '='

COLUMN OWNER  FORMAT A10 JUS CENTER
COLUMN OBJECT_NAME FORMAT A25 JUSTIFY CENTER
COLUMN Tipo  FORMAT A10 JUS CENTER

SELECT OWNER,OBJECT_NAME,OBJECT_TYPE "Tipo"
		FROM ALL_OBJECTS
		WHERE OWNER='HR'
		ORDER BY 3;

DESC ALL_tab_columns
COLUMN OWNER FORMAT A6
COLUMN table_name FORMAT A25
COLUMN column_name FORMAT A18
COLUMN DATA_TYPE FORMAT A10
COLUMN DATA_TYPE_MOD FORMAT A6

SELECT OWNER,table_name,column_name,DATA_TYPE,CHARACTER_SET_NAME
	FROM ALL_tab_columns
	WHERE OWNER='HR'
	ORDER BY 2,3;


column parameter format A25;
column value format A40 wrapped;
set space 7;

select parameter,value
	from nls_session_parameters;

select sysdate from dual;

alter session set NLS_DATE_FORMAT="DAY DD-MONTH-YYYY";
	select sysdate from dual;
alter session NLS_LANGUAGE='ENGLISH';
	select sysdate from dual;
alter session NLS_LANGUAGE='FRENCH';
	select sysdate from dual;

alter session NLS_LANGUAGE='SPANSH';
	select sysdate from dual;

DEFINE GNAME=Sergio
set sqlpromp '&GNAME>'
REM DESPLEGAR VARIAS FECHAS
	select to_char(sysdate,'J') from dual;
	select to_char(to_date('30-03-14'),'J') from dual;
	select to_char(SYSTIMESTAMP,'J') from dual;
	select SYSTIMESTAMP from dual;
	select sysdate,systimestamp from dual;
	set sqlprompt 'SQL>'

CLEAR COLUMNS 
COLUMN FECHA 1 FORMAT A20;
COLUMN FECHA2 FORMAT A32;

	select sysdate FECHA1,systimestamp FECHA2 from dual;
Rem EL 1 DE ENERO DEL AÑO 4712 AC
		select
				TO_CHAR(TO_DATE('1-Ene--4712 12:00 pm','dd-Mon-syyyy hh:mi am'),'J')
				from dual;

Rem EL 1 DE ENERO DEL AÑO 1 DE NUESTRA ERA
		select
				TO_CHAR(TO_DATE('1-Ene-1 12:00 pm','dd-Mon-syyyy hh:mi am'),'J')
				from dual;
Rem EL 12 DE FEBRERO DE 2018A
		select
				TO_CHAR(TO_DATE('12-Feb-2018 7:00 am','dd-Mon-yyyy hh:mi am'),'J')FECHA
				from dual;

REM los dias recortados por Gregorio VII
	select
			TO_CHAR(TO_DATE('04-oct-1582 3:50 pm','dd-Mon-yyyy hh:mi am'),'J')
				from dual;
REM los dias recortados por Gregorio VII
	select
			TO_CHAR(TO_DATE('10-oct-1582 3:50 pm','dd-Mon-yyyy hh:mi am'),'J')
				from dual;

REM los dias recortados por Gregorio VII
	select
			TO_CHAR(TO_DATE('15-oct-1582 3:50 pm','dd-Mon-yyyy hh:mi am'),'J')
				from dual;
REM encontrar diferencia entre fechas 

	select
		TO_CHAR(TO_DATE('12-Feb-2018 7:00 am','dd-Mon-yyyy hh:mi am'),'J')FECHA1,
		TO_CHAR(TO_DATE('29-eNE-2018 7:00 am','dd-Mon-yyyy hh:mi am'),'J')FECHA2,
		(TO_DATE('12-Feb-2018 7:00 AM','dd-Mon-yyyy hh:mi am')-TO_DATE('29-Ene-2018 7:00','dd-Mon-yyyy hh:mi am'))"Dias|transcurridos"
from dual;