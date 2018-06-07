-- *** Chapter Exercises *** --
-- For Example ch01_1b.sql


SET SERVEROUTPUT ON
DECLARE
   v_name VARCHAR2(30); 
   v_dob DATE; 
   v_us_citizen BOOLEAN; 
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_name||'born on'||v_dob);
END; 


-- For Example ch01_2a.sql

SET SERVEROUTPUT ON
DECLARE
   v_name student.first_name%TYPE; 
   v_grade grade.numeric_grade%TYPE; 
BEGIN
   DBMS_OUTPUT.PUT_LINE(NVL(v_name, 'No Name ')||
      ' has grade of '||NVL(v_grade, 0));
END; 


-- For Example ch01_3a.sql
SET SERVEROUTPUT ON
DECLARE
   v_lname VARCHAR2(30); 
   v_regdate DATE; 
   v_pctincr CONSTANT NUMBER(4,2) := 1.50; 
   v_counter NUMBER := 0; 
   v_new_cost course.cost%TYPE; 
   v_YorN BOOLEAN := TRUE; 
BEGIN
v_counter := ((v_counter + 5)*2) / 2; 
v_new_cost := (v_new_cost * v_counter)/4; 
--
   v_counter := COALESCE(v_counter, 0) + 1; 
   v_new_cost := 800 * v_pctincr; 
--
       DBMS_OUTPUT.PUT_LINE(V_COUNTER);
       DBMS_OUTPUT.PUT_LINE(V_NEW_COST);
END; 



-- For Example ch01_4a.sql

set serveroutput on
   << find_stu_num >>

   BEGIN
      DBMS_OUTPUT.PUT_LINE('The procedure 
                  find_stu_num has been executed.');
   END find_stu_num; 


-- For Example ch01_4b.sql

SET SERVEROUTPUT ON
<< outer_block >>
DECLARE
   v_test NUMBER := 123;
BEGIN
   DBMS_OUTPUT.PUT_LINE
      ('Outer Block, v_test: '||v_test);
   << inner_block >>
   DECLARE
      v_test NUMBER := 456;   
   BEGIN   
      DBMS_OUTPUT.PUT_LINE
         ('Inner Block, v_test: '||v_test);
      DBMS_OUTPUT.PUT_LINE
         ('Inner Block, outer_block.v_test: '||
           Outer_block.v_test);
   END inner_block;
END outer_block; 


-- For Example ch01_5a.sql


SET SERVEROUTPUT ON
DECLARE
   e_show_exception_scope EXCEPTION;
   v_student_id           NUMBER := 123;
BEGIN
  DBMS_OUTPUT.PUT_LINE('outer student id is '
     ||v_student_id);
   DECLARE
     v_student_id    VARCHAR2(8) := 125;
   BEGIN
      DBMS_OUTPUT.PUT_LINE('inner student id is '
         ||v_student_id);
      RAISE e_show_exception_scope;
   END;
EXCEPTION
   WHEN e_show_exception_scope
   THEN
      DBMS_OUTPUT.PUT_LINE('When am I displayed?');
      DBMS_OUTPUT.PUT_LINE('outer student id is '
         ||v_student_id);
END; 

