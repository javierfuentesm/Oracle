-- *** Chapter Exercises *** --
-- For Example ch10_1a.sql (In chapter 9, this is example ch09_2a.sql)
DECLARE
   v_student_id    STUDENT.STUDENT_ID%TYPE := &sv_student_id;
   v_total_courses NUMBER;
   e_invalid_id    EXCEPTION;
BEGIN
   IF v_student_id < 0 
   THEN
      RAISE e_invalid_id;
   END IF;

   SELECT COUNT(*)
     INTO v_total_courses
     FROM enrollment
    WHERE student_id = v_student_id;
   
   DBMS_OUTPUT.PUT_LINE ('The student is registered for '||v_total_courses||' courses');
   DBMS_OUTPUT.PUT_LINE ('No exception has been raised');
EXCEPTION
   WHEN e_invalid_id 
   THEN
      DBMS_OUTPUT.PUT_LINE ('An id cannot be negative');
END; 

-- For Example ch10_1b.sql 
DECLARE
   v_student_id    STUDENT.STUDENT_ID%TYPE := &sv_student_id;
   v_total_courses NUMBER;
BEGIN
   IF v_student_id < 0 
   THEN
      RAISE_APPLICATION_ERROR (-20000, 'An id cannot be negative'); 
   END IF;

   SELECT COUNT(*)
     INTO v_total_courses
     FROM enrollment
    WHERE student_id = v_student_id;
   
   DBMS_OUTPUT.PUT_LINE ('The student is registered for '|| v_total_courses||' courses');
END;

-- For Example ch10_2a.sql 
DECLARE
   v_student_id STUDENT.STUDENT_ID%TYPE := &sv_student_id;
   v_name       VARCHAR2(50);
BEGIN
   SELECT first_name||' '||last_name
     INTO v_name
     FROM student
    WHERE student_id = v_student_id;
   DBMS_OUTPUT.PUT_LINE (v_name);
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RAISE_APPLICATION_ERROR (-20001, 'This ID is invalid');
END;

-- For Example ch10_3a.sql 
DECLARE
   v_zip ZIPCODE.ZIP%TYPE := '&sv_zip';
BEGIN
   DELETE FROM zipcode
    WHERE zip = v_zip;
   
   DBMS_OUTPUT.PUT_LINE ('Zip '||v_zip||' has been deleted');
   COMMIT;
END;

-- For Example ch10_3b.sql 
DECLARE
   v_zip          ZIPCODE.ZIP%TYPE := '&sv_zip';
   e_child_exists EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_child_exists, -2292);
BEGIN
   DELETE FROM zipcode
    WHERE zip = v_zip;
   
   DBMS_OUTPUT.PUT_LINE ('Zip '||v_zip||' has been deleted');
   COMMIT;
EXCEPTION
   WHEN e_child_exists 
   THEN
      DBMS_OUTPUT.PUT_LINE ('Delete students for this zipcode first');
END;

-- For Example ch10_4a.sql 
DECLARE
   v_zip   VARCHAR2(5) := '&sv_zip';
   v_city  VARCHAR2(15);
   v_state CHAR(2);
BEGIN
   SELECT city, state
     INTO v_city, v_state
     FROM zipcode
    WHERE zip = v_zip;
   
   DBMS_OUTPUT.PUT_LINE (v_city||', '||v_state);

EXCEPTION
   WHEN OTHERS 
   THEN 
      DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;

-- For Example ch10_4b.sql 
DECLARE
   v_zip      VARCHAR2(5) := '&sv_zip';
   v_city     VARCHAR2(15);
   v_state    CHAR(2);
   v_err_code NUMBER;
   v_err_msg  VARCHAR2(200);
BEGIN
   SELECT city, state
     INTO v_city, v_state
     FROM zipcode
    WHERE zip = v_zip;
   
   DBMS_OUTPUT.PUT_LINE (v_city||', '||v_state);

EXCEPTION
   WHEN OTHERS 
   THEN
      v_err_code := SQLCODE;
      v_err_msg  := SUBSTR(SQLERRM, 1, 200);
      DBMS_OUTPUT.PUT_LINE ('Error code: '||v_err_code);
      DBMS_OUTPUT.PUT_LINE ('Error message: '||v_err_msg);
END;

-- For Example ch10_5a.sql 
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Error code: '||SQLCODE);
   DBMS_OUTPUT.PUT_LINE ('Error message1: '||SQLERRM(SQLCODE));
   DBMS_OUTPUT.PUT_LINE ('Error message2: '||SQLERRM(100));
   DBMS_OUTPUT.PUT_LINE ('Error message3: '||SQLERRM(200));
   DBMS_OUTPUT.PUT_LINE ('Error message4: '||SQLERRM(-20000));
END;

-- *** Web Chapter Exercises *** --
-- For Example ch10_6a.sql 
DECLARE
   v_students NUMBER(3) := 0;
BEGIN
   SELECT COUNT(*)
     INTO v_students
     FROM enrollment e, section s
    WHERE e.section_id = s.section_id
      AND s.course_no  = 25
      AND s.section_id = 89; 

   DBMS_OUTPUT.PUT_LINE ('Course 25, section 89 has '||v_students||' students');
END;

-- For Example ch10_6b.sql 
DECLARE
   v_students NUMBER(3) := 0;
BEGIN
   SELECT COUNT(*)
     INTO v_students
     FROM enrollment e, section s
    WHERE e.section_id = s.section_id
      AND s.course_no  = 25
      AND s.section_id = 89; 

   IF v_students > 10 
   THEN
      RAISE_APPLICATION_ERROR 
         (-20002, 'Course 25, section 89 has more than 10 students');
   END IF;

   DBMS_OUTPUT.PUT_LINE ('Course 25, section 89 has '||v_students||' students');
END;

-- For Example ch10_7a.sql 
BEGIN
   INSERT INTO course 
      (course_no, description, created_by, created_date)
   VALUES 
      (COURSE_NO_SEQ.NEXTVAL, 'Test Course', USER, SYSDATE);
   COMMIT;
   DBMS_OUTPUT.PUT_LINE ('One course has been added');
END;

-- For Example ch10_7b.sql 
DECLARE
   e_constraint_violation EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_constraint_violation, -1400);
BEGIN
   INSERT INTO course 
      (course_no, description, created_by, created_date)
   VALUES 
      (COURSE_NO_SEQ.NEXTVAL, 'Test Course', USER, SYSDATE);
   COMMIT;
   DBMS_OUTPUT.PUT_LINE ('One course has been added');
EXCEPTION
   WHEN e_constraint_violation 
   THEN
      DBMS_OUTPUT.PUT_LINE ('INSERT statement is violating a constraint');
END;

-- For Example ch10_8a.sql 
BEGIN
   INSERT INTO zipcode 
      (zip, city, state, created_by, created_date, modified_by, modified_date)
   VALUES 
      ('10027', 'NEW YORK', 'NY', USER, SYSDATE, USER, SYSDATE);
   COMMIT;
END;

-- For Example ch10_8b.sql 
BEGIN
   INSERT INTO zipcode
      (zip, city, state, created_by, created_date, modified_by, modified_date)
   VALUES 
      ('10027', 'NEW YORK', 'NY', USER, SYSDATE, USER, SYSDATE);
   COMMIT;
EXCEPTION
   WHEN OTHERS 
   THEN
      DECLARE
         v_err_code NUMBER := SQLCODE;
         v_err_msg VARCHAR2(100) := SUBSTR(SQLERRM, 1, 100);
      BEGIN
         DBMS_OUTPUT.PUT_LINE ('Error code: '||v_err_code);
         DBMS_OUTPUT.PUT_LINE ('Error message: '||v_err_msg);
      END;
END;

-- For Example ch10_9a.sql
DECLARE
   v_section_id        NUMBER := &sv_section_id;
   v_total_students    NUMBER;
BEGIN
   -- Calculate number of students enrolled
   SELECT COUNT(*)
     INTO v_total_students
     FROM enrollment
    WHERE section_id = v_section_id;
         
   IF v_total_students >= 10 
   THEN
      RAISE_APPLICATION_ERROR 
         (-20000, 'There are too many students for section '||v_section_id);
   ELSE
      DBMS_OUTPUT.PUT_LINE 
         ('There are '||v_total_students||' students in section '||v_section_id);
   END IF;
END;

-- For Example ch10_10a.sql
BEGIN
   INSERT INTO instructor 
      (instructor_id, salutation, first_name, last_name, street_address, zip, phone)
   VALUES 
      (INSTRUCTOR_ID_SEQ.NEXTVAL, 'Mr', 'John', 'Smith', '123 Main St.', '00914'
      ,'1234567890');
   COMMIT; 
END;

-- For Example ch10_10b.sql
DECLARE
   e_non_null_value EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_non_null_value, -1400);
BEGIN
   INSERT INTO instructor 
      (instructor_id, salutation, first_name, last_name, street_address, zip, phone)
   VALUES 
      (INSTRUCTOR_ID_SEQ.NEXTVAL, 'Mr', 'John', 'Smith', '123 Main St.', '00914'
      ,'1234567890');
   COMMIT; 
EXCEPTION
   WHEN e_non_null_value 
   THEN
      DBMS_OUTPUT.PUT_LINE 
         ('A NULL value cannot be inserted. '||
          ' Check constraints on the INSTRUCTOR table.');
END;

-- For Example ch10_10c.sql
BEGIN
   INSERT INTO instructor 
      (instructor_id, salutation, first_name, last_name, street_address, zip, phone)
   VALUES 
      (INSTRUCTOR_ID_SEQ.NEXTVAL, 'Mr', 'John', 'Smith', '123 Main St.', '00914'
      ,'1234567890');
   COMMIT; 
EXCEPTION
   WHEN OTHERS 
   THEN
      DBMS_OUTPUT.PUT_LINE ('Error code: '||SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('Error message: '||SUBSTR(SQLERRM, 1, 200));
END;
