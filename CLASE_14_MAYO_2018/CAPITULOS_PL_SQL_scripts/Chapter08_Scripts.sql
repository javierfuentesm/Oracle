-- *** Chapter Exercises *** --
-- For Example ch08_1a.sql
DECLARE
   v_num1   INTEGER := &sv_num1;
   v_num2   INTEGER := &sv_num2;
   v_result NUMBER;
BEGIN
   v_result = v_num1 / v_num2;
   DBMS_OUTPUT.PUT_LINE ('v_result: '||v_result);
END; 

-- For Example ch08_1b.sql
DECLARE
   v_num1   INTEGER := &sv_num1;
   v_num2   INTEGER := &sv_num2;
   v_result NUMBER;
BEGIN
   v_result := v_num1 / v_num2;
   DBMS_OUTPUT.PUT_LINE ('v_result: '||v_result);
EXCEPTION
   WHEN ZERO_DIVIDE 
   THEN
       DBMS_OUTPUT.PUT_LINE ('A number cannot be divided by zero.');
END; 

-- For Example ch08_2a.sql
DECLARE
   v_student_name VARCHAR2(50);
BEGIN
   SELECT first_name||' '||last_name
     INTO v_student_name
     FROM student
    WHERE student_id = 101;

    DBMS_OUTPUT.PUT_LINE ('Student name is '||v_student_name);
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      DBMS_OUTPUT.PUT_LINE ('There is no such student');
END;

-- For Example ch08_3a.sql
DECLARE
   v_student_id NUMBER      := &sv_student_id;
   v_enrolled   VARCHAR2(3) := 'NO';
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Check if the student is enrolled');
   SELECT 'YES'
     INTO v_enrolled
     FROM enrollment
    WHERE student_id = v_student_id;
   
    DBMS_OUTPUT.PUT_LINE ('The student is enrolled into one course'); 
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      DBMS_OUTPUT.PUT_LINE ('The student is not enrolled');

   WHEN TOO_MANY_ROWS 
   THEN
       DBMS_OUTPUT.PUT_LINE ('The student is enrolled in multiple courses');
END;

-- For Example ch08_4a.sql
DECLARE
   v_instructor_id   NUMBER := &sv_instructor_id;
   v_instructor_name VARCHAR2(50);
BEGIN
   SELECT first_name||' '||last_name
     INTO v_instructor_name
     FROM instructor
    WHERE instructor_id = v_instructor_id;

    DBMS_OUTPUT.PUT_LINE ('Instructor name is '||v_instructor_name);
EXCEPTION
   WHEN OTHERS 
   THEN
      DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;

-- *** Web Chapter Exercises *** --
-- For Example ch08_5a.sql
DECLARE 
   v_num NUMBER := &sv_num;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Square root of '||v_num||' is '||SQRT(v_num));
EXCEPTION
   WHEN VALUE_ERROR 
   THEN
      DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;

-- For Example ch08_5b.sql
DECLARE 
   v_num NUMBER := &sv_num;
BEGIN
   IF v_num >= 0
   THEN
      DBMS_OUTPUT.PUT_LINE ('Square root of '||v_num||' is '||SQRT(v_num));
   ELSE
      DBMS_OUTPUT.PUT_LINE ('A number cannot be negative');
   END IF;
END;

-- For Example ch08_6a.sql
DECLARE
   v_exists         NUMBER(1);
   v_total_students NUMBER(1);
   v_zip            CHAR(5):= '&sv_zip';
BEGIN
   SELECT count(*)
     INTO v_exists
     FROM zipcode
    WHERE zip = v_zip; 
   
   IF v_exists != 0 
   THEN
      SELECT COUNT(*)
        INTO v_total_students
        FROM student
       WHERE zip = v_zip;
      
      DBMS_OUTPUT.PUT_LINE ('There are '||v_total_students||' students');
   ELSE
      DBMS_OUTPUT.PUT_LINE (v_zip||' is not a valid zip');
   END IF;

EXCEPTION
   WHEN VALUE_ERROR OR INVALID_NUMBER 
   THEN
      DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;

-- For Example ch08_7a.sql
DECLARE
   v_student_id  NUMBER := &sv_student_id;
   v_name        VARCHAR2(30);
   v_enrollments NUMBER;
BEGIN
   SELECT first_name||' '||last_name
     INTO v_name
     FROM student
    WHERE student_id = v_student_id;

   SELECT COUNT(*)
     INTO v_enrollments
     FROM enrollment
    WHERE student_id = v_student_id;
   
   DBMS_OUTPUT.PUT_LINE 
      ('Student '||v_name||' has '||v_enrollments||' enrollments');
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN 
      DBMS_OUTPUT.PUT_LINE ('This student does not exist');
END;

-- For Example ch08_7b.sql
DECLARE
   v_student_id  NUMBER := &sv_student_id;
   v_name        VARCHAR2(30);
   v_enrollments NUMBER;
BEGIN
   SELECT s.first_name||' '||s.last_name, COUNT(*)
     INTO v_name, v_enrollments
     FROM student s, enrollment e
    WHERE s.student_id = e.student_id
      AND s.student_id = v_student_id
   GROUP BY s.first_name||' '||s.last_name;
   
   DBMS_OUTPUT.PUT_LINE 
      ('Student '||v_name||' has '||v_enrollments||' enrollments');
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN 
      BEGIN
         SELECT first_name||' '||last_name
           INTO v_name
           FROM student
          WHERE student_id = v_student_id;

        DBMS_OUTPUT.PUT_LINE ('Student '||v_name||' is not enrolled');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            DBMS_OUTPUT.PUT_LINE ('This student does not exist');
      END;
END;

-- For Example ch08_8a.sql
DECLARE
   v_course_no NUMBER := &sv_course_no;
   v_name      VARCHAR2(50);
   v_sections  NUMBER;
   v_students  NUMBER;
 BEGIN
   SELECT description
     INTO v_name
     FROM course
    WHERE course_no = v_course_no;
   
   -- check how many sections are offered for a given course
   SELECT COUNT(*)
     INTO v_sections
     FROM section
    WHERE course_no = v_course_no;

  -- check how many students are enrolled in a given course
  SELECT COUNT(e.student_id)
    INTO v_students
    FROM section s
        ,enrollment e
   WHERE s.section_id = e.section_id
     AND s.course_no = v_course_no;
   
   DBMS_OUTPUT.PUT_LINE 
      ('Course '||v_course_no||', '||v_name||', has '||v_sections||' section(s)');
   DBMS_OUTPUT.PUT_LINE (v_students||' students are enrolled in this course');
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN 
      DBMS_OUTPUT.PUT_LINE (v_course_no||' is not a valid course');
END;

-- For Example ch08_8b.sql
DECLARE
   v_course_no NUMBER := &sv_course_no;
   v_name      VARCHAR2(50);
   v_sections  NUMBER;
   v_students  NUMBER;
 BEGIN
   SELECT description
     INTO v_name
     FROM course
    WHERE course_no = v_course_no;
   
   -- check how many sections are offered for a given course and
   -- how many students are enrolled in a given course
   SELECT COUNT(UNIQUE e.section_id), COUNT(e.student_id)
     INTO v_sections, v_students
    FROM section    s
        ,enrollment e
   WHERE s.section_id = e.section_id
     AND s.course_no = v_course_no;
   
   DBMS_OUTPUT.PUT_LINE 
      ('Course '||v_course_no||', '||v_name||', has '||v_sections||' section(s)');
   DBMS_OUTPUT.PUT_LINE (v_students||' students are enrolled in this course');
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN 
      DBMS_OUTPUT.PUT_LINE (v_course_no||' is not a valid course');
END;
