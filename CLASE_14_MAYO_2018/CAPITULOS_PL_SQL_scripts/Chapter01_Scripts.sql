-- *** Chapter Exercises *** --
-- For Example ch01_1a.sql
DECLARE
   v_first_name VARCHAR2(35);
   v_last_name  VARCHAR2(35);
BEGIN
   SELECT first_name, last_name
     INTO v_first_name, v_last_name
     FROM student
    WHERE student_id = 123;
   
   DBMS_OUTPUT.PUT_LINE ('Student name: '||v_first_name||' '||v_last_name);
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      DBMS_OUTPUT.PUT_LINE ('There is no student with student id 123');
END;

-- For Example ch01_1b.sql
DECLARE
   v_student_id NUMBER := &sv_student_id;
   v_first_name VARCHAR2(35);
   v_last_name  VARCHAR2(35);
BEGIN
   SELECT first_name, last_name
     INTO v_first_name, v_last_name
     FROM student
    WHERE student_id = v_student_id;
   
   DBMS_OUTPUT.PUT_LINE ('Student name: '||v_first_name||' '||v_last_name);
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      DBMS_OUTPUT.PUT_LINE ('There is no such student');
END;

-- For Example ch01_2a.sql
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Today is '||'&sv_day');
   DBMS_OUTPUT.PUT_LINE ('Tomorrow will be '||'&sv_day');
END;

-- For Example ch01_2b.sql
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Today is '||'&&sv_day');
   DBMS_OUTPUT.PUT_LINE ('Tomorrow will be '||'&sv_day'); 
END;

-- *** Web Chapter Exercises *** --
-- For Example ch01_3a.sql
DECLARE
   v_num    NUMBER := 10;
   v_result NUMBER;
BEGIN
   v_result := POWER(v_num, 2); 
END;

-- For Example ch01_3b.sql
DECLARE
   v_num    NUMBER := 10;
   v_result NUMBER;
BEGIN
   v_result := POWER(v_num, 2); 
   DBMS_OUTPUT.PUT_LINE ('The value of v_result is: '||v_result);
END;

-- For Example ch01_3c.sql
DECLARE
   v_num    NUMBER := &sv_num;
   v_result NUMBER;
BEGIN
   v_result := POWER(v_num, 2); 
   DBMS_OUTPUT.PUT_LINE ('The value of v_result is: '||v_result);
END;

-- For Example ch01_4a.sql
DECLARE
   v_radius NUMBER := &sv_radius;
   v_area   NUMBER;
BEGIN
   v_area := POWER(v_radius, 2) * 3.14; 
   DBMS_OUTPUT.PUT_LINE ('The area of the circle is: '||v_area);
END;

-- For Example ch01_5a.sql
DECLARE
   v_date DATE := SYSDATE;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Today is '||to_char(v_date, 'fmDay')||
                         ' at '     ||to_char(v_date, 'hh:mi AM'));
END;



