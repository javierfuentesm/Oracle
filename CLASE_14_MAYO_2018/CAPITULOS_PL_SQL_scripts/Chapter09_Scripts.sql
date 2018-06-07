-- *** Chapter Exercises *** --
-- For Example ch09_1a.sql
DECLARE
   v_student_id NUMBER := &sv_student_id;
   v_name       VARCHAR2(30);
BEGIN
   SELECT RTRIM(first_name)||' '||RTRIM(last_name)
     INTO v_name
     FROM student
    WHERE student_id = v_student_id;

   DBMS_OUTPUT.PUT_LINE ('Student name is '||v_name);
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      DBMS_OUTPUT.PUT_LINE ('There is no such student');
END; 

-- For Example ch09_1b.sql
<<outer_block>>
DECLARE
   v_student_id NUMBER := &sv_student_id;
   v_name       VARCHAR2(30);
   v_total      NUMBER(1);

BEGIN
   SELECT RTRIM(first_name)||' '||RTRIM(last_name)
     INTO v_name
     FROM student
    WHERE student_id = v_student_id;
   
   DBMS_OUTPUT.PUT_LINE ('Student name is '||v_name);
   
   <<inner_block>>
   BEGIN
      SELECT COUNT(*)
        INTO v_total
        FROM enrollment
       WHERE student_id = v_student_id;
      
      DBMS_OUTPUT.PUT_LINE ('Student is registered for '||v_total||' course(s)');
   EXCEPTION
      WHEN VALUE_ERROR OR INVALID_NUMBER 
      THEN
         DBMS_OUTPUT.PUT_LINE ('An error has occurred');
   END;

EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      DBMS_OUTPUT.PUT_LINE ('There is no such student');
END; 

-- For Example ch09_1c.sql
<<outer_block>>
DECLARE
   v_student_id NUMBER := &sv_student_id;
   v_name       VARCHAR2(30);
   v_registered CHAR;

BEGIN
   SELECT RTRIM(first_name)||' '||RTRIM(last_name)
     INTO v_name
     FROM student
    WHERE student_id = v_student_id;
   
   DBMS_OUTPUT.PUT_LINE ('Student name is '||v_name);

   <<inner_block>>
   BEGIN
      SELECT 'Y'
        INTO v_registered
        FROM enrollment
       WHERE student_id = v_student_id;
      
      DBMS_OUTPUT.PUT_LINE ('Student is registered');
   EXCEPTION
      WHEN VALUE_ERROR OR INVALID_NUMBER 
      THEN
         DBMS_OUTPUT.PUT_LINE ('An error has occurred');
   END;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.PUT_LINE ('There is no such student');
END; 

-- For Example ch09_2a.sql
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

-- For Example ch09_3a.sql
<<outer_block>>
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Outer block');
   
   <<inner_block>>
   DECLARE
      e_my_exception EXCEPTION;
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('Inner block');
   EXCEPTION
      WHEN e_my_exception 
      THEN
         DBMS_OUTPUT.PUT_LINE ('An error has occurred');
   END;
   
   IF 10 > &sv_number 
   THEN
      RAISE e_my_exception;
   END IF;
END;

-- For Example ch09_4a.sql
DECLARE
   v_test_var CHAR(3):= 'ABCDE';
BEGIN
   DBMS_OUTPUT.PUT_LINE ('This is a test');
EXCEPTION
   WHEN INVALID_NUMBER OR VALUE_ERROR 
   THEN
      DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;

-- For Example ch09_4b.sql
<<outer_block>>
BEGIN
   <<inner_block>>
   DECLARE
      v_test_var CHAR(3):= 'ABCDE';
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('This is a test');
   EXCEPTION
      WHEN INVALID_NUMBER OR VALUE_ERROR 
      THEN
         DBMS_OUTPUT.PUT_LINE ('An error has occurred in the inner block');
   END;
EXCEPTION
   WHEN INVALID_NUMBER OR VALUE_ERROR 
   THEN
      DBMS_OUTPUT.PUT_LINE ('An error has occurred in the program');
END;

-- For Example ch09_5a.sql
DECLARE
   v_test_var CHAR(3) := 'ABC';
BEGIN
   v_test_var := '1234';
   DBMS_OUTPUT.PUT_LINE ('v_test_var: '||v_test_var);
EXCEPTION
   WHEN INVALID_NUMBER OR VALUE_ERROR 
   THEN
      v_test_var := 'ABCD'; 
      DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;

-- For Example ch09_5b.sql
<<outer_block>>
BEGIN
   <<inner_block>>
   DECLARE
      v_test_var CHAR(3) := 'ABC';
   BEGIN
      v_test_var := '1234';
      DBMS_OUTPUT.PUT_LINE ('v_test_var: '||v_test_var);
   EXCEPTION
      WHEN INVALID_NUMBER OR VALUE_ERROR 
      THEN
         v_test_var := 'ABCD'; 
         DBMS_OUTPUT.PUT_LINE ('An error has occurred in the inner block');
   END;
EXCEPTION
   WHEN INVALID_NUMBER OR VALUE_ERROR 
   THEN
      DBMS_OUTPUT.PUT_LINE ('An error has occurred in the program');
END;

-- For Example ch09_6a.sql
<<outer_block>>
DECLARE
   e_exception1 EXCEPTION;
   e_exception2 EXCEPTION;
BEGIN
   <<inner_block>>
   BEGIN
      RAISE e_exception1;
   EXCEPTION
      WHEN e_exception1 
      THEN
         RAISE e_exception2;
      WHEN e_exception2 
      THEN
         DBMS_OUTPUT.PUT_LINE ('An error has occurred in the inner block');
   END;
EXCEPTION
   WHEN e_exception2 
   THEN
      DBMS_OUTPUT.PUT_LINE ('An error has occurred in the program');
END;

-- For Example ch09_7a.sql
<<outer_block>>
DECLARE
   e_exception EXCEPTION;
BEGIN
   <<inner_block>>
   BEGIN
      RAISE e_exception;
   EXCEPTION
      WHEN e_exception 
      THEN
         RAISE;
   END;
EXCEPTION
   WHEN e_exception 
   THEN
      DBMS_OUTPUT.PUT_LINE ('An error has occurred');
END;

-- *** Web Chapter Exercises *** --
For Example ch09_8a.sql
<<outer_block>>
DECLARE   
   v_zip   VARCHAR2(5) := '&sv_zip'; 
   v_name  VARCHAR2(50);   

BEGIN
   DBMS_OUTPUT.PUT_LINE ('Check if provided zipcode is valid'); 
   SELECT zip
     INTO v_zip
     FROM zipcode
    WHERE zip = v_zip;

   <<inner_block>>
   BEGIN   
      SELECT first_name||' '||last_name
        INTO v_name
        FROM instructor
       WHERE zip = v_zip;

      DBMS_OUTPUT.PUT_LINE ('Instructor name is '||v_name);
   END;
END;

-- For Example ch09_8b.sql
<<outer_block>>
DECLARE
   v_zip   VARCHAR2(5) := '&sv_zip'; 
   v_name  VARCHAR2(50);   

BEGIN
   DBMS_OUTPUT.PUT_LINE ('Check if provided zipcode is valid'); 
   SELECT zip
     INTO v_zip
     FROM zipcode
    WHERE zip = v_zip;

   <<inner_block>>
   BEGIN   
      SELECT first_name||' '||last_name
        INTO v_name
        FROM instructor
       WHERE zip = v_zip;

      DBMS_OUTPUT.PUT_LINE ('Instructor name is '||v_name);
   EXCEPTION
      WHEN TOO_MANY_ROWS
      THEN
         DBMS_OUTPUT.PUT_LINE 
            ('More than one instructor resides in this zip code');
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.PUT_LINE 
            ('There are no instructors residing in this zip code');
   END;
END;

-- For Example ch09_8c.sql
<<outer_block>>
DECLARE
   v_zip   VARCHAR2(5) := '&sv_zip'; 
   v_name  VARCHAR2(50);   

BEGIN
   DBMS_OUTPUT.PUT_LINE ('Check if provided zipcode is valid'); 
   SELECT zip
     INTO v_zip
     FROM zipcode
    WHERE zip = v_zip;

   <<inner_block>>
   BEGIN   
      SELECT first_name||' '||last_name
        INTO v_name
        FROM instructor
       WHERE zip = v_zip;

      DBMS_OUTPUT.PUT_LINE ('Instructor name is '||v_name);
   END;
EXCEPTION
   WHEN TOO_MANY_ROWS
   THEN
      DBMS_OUTPUT.PUT_LINE 
         ('More than one instructor resides in this zip code');
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.PUT_LINE 
         ('There are no instructors residing in this zip code');
END;

-- For Example ch09_9a.sql
DECLARE
   v_instructor_id     NUMBER := &sv_instructor_id;
   v_tot_sections      NUMBER;
   v_name              VARCHAR2(30);
   e_too_many_sections EXCEPTION;
BEGIN
   SELECT RTRIM(first_name)||' '||RTRIM(last_name)
     INTO v_name
     FROM instructor
    WHERE instructor_id = v_instructor_id;

   SELECT COUNT(*) 
     INTO v_tot_sections      
     FROM section
    WHERE instructor_id = v_instructor_id;  

   IF v_tot_sections >= 10 
   THEN
      RAISE e_too_many_sections;
   ELSE
      DBMS_OUTPUT.PUT_LINE 
         ('Instructor, '||v_name||', teaches '||v_tot_sections||' sections');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.PUT_LINE ('This is not a valid instructor');

   WHEN e_too_many_sections 
   THEN
      DBMS_OUTPUT.PUT_LINE ('Instructor, '||v_name||', teaches too much');
END;

-- For Example ch09_10a.sql
DECLARE
   v_my_name VARCHAR2(15) := 'THIS IS A REALLY LONG NAME';
BEGIN
   DBMS_OUTPUT.PUT_LINE ('My name is '||v_my_name);
   
   DECLARE
      v_your_name VARCHAR2(15);
   BEGIN
      v_your_name := '&sv_your_name';
      DBMS_OUTPUT.PUT_LINE ('Your name is '||v_your_name);
   EXCEPTION
      WHEN VALUE_ERROR 
      THEN
         DBMS_OUTPUT.PUT_LINE ('Error in the inner block');
         DBMS_OUTPUT.PUT_LINE ('This name is too long');
   END;

EXCEPTION
   WHEN VALUE_ERROR 
   THEN
      DBMS_OUTPUT.PUT_LINE ('Error in the outer block');
      DBMS_OUTPUT.PUT_LINE ('This name is too long');
END;

-- For Example ch09_10b.sql
DECLARE
   v_my_name VARCHAR2(15);
BEGIN
   v_my_name := 'THIS IS A REALLY LONG NAME';
   DBMS_OUTPUT.PUT_LINE ('My name is '||v_my_name);
   
   DECLARE
      v_your_name VARCHAR2(15);
   BEGIN
      v_your_name := '&sv_your_name';
      DBMS_OUTPUT.PUT_LINE ('Your name is '||v_your_name);
   EXCEPTION
      WHEN VALUE_ERROR 
      THEN
         DBMS_OUTPUT.PUT_LINE ('Error in the inner block');
         DBMS_OUTPUT.PUT_LINE ('This name is too long');
   END;

EXCEPTION
   WHEN VALUE_ERROR 
   THEN
      DBMS_OUTPUT.PUT_LINE ('Error in the outer block');
      DBMS_OUTPUT.PUT_LINE ('This name is too long');
END;

-- For Example ch09_10c.sql
DECLARE
   v_my_name VARCHAR2(15) := 'MY NAME';
BEGIN
   DBMS_OUTPUT.PUT_LINE ('My name is '||v_my_name);
   
   DECLARE
      v_your_name VARCHAR2(15) := '&sv_your_name';
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('Your name is '||v_your_name);
   EXCEPTION
      WHEN VALUE_ERROR 
      THEN
         DBMS_OUTPUT.PUT_LINE ('Error in the inner block');
         DBMS_OUTPUT.PUT_LINE ('This name is too long');
   END;

EXCEPTION
   WHEN VALUE_ERROR 
   THEN
      DBMS_OUTPUT.PUT_LINE ('Error in the outer block');
      DBMS_OUTPUT.PUT_LINE ('This name is too long');
END;

-- For Example ch09_10d.sql
DECLARE
   v_my_name VARCHAR2(15) := 'MY NAME';
BEGIN
   DBMS_OUTPUT.PUT_LINE ('My name is '||v_my_name);
   
   DECLARE
      v_your_name VARCHAR2(15);
   BEGIN
      v_your_name := '&sv_your_name';
      DBMS_OUTPUT.PUT_LINE ('Your name is '||v_your_name);
   EXCEPTION
      WHEN VALUE_ERROR 
      THEN
         RAISE;
   END;

EXCEPTION
   WHEN VALUE_ERROR 
   THEN
      DBMS_OUTPUT.PUT_LINE ('Error in the outer block');
      DBMS_OUTPUT.PUT_LINE ('This name is too long');
END;

-- For Example ch09_11a.sql
DECLARE
   v_course_no   NUMBER := 430;
   v_total       NUMBER;
   e_no_sections EXCEPTION;
BEGIN
   BEGIN
      SELECT COUNT(*)
        INTO v_total
        FROM section
       WHERE course_no = v_course_no;
         
      IF v_total = 0 
      THEN
         RAISE e_no_sections;
      ELSE
         DBMS_OUTPUT.PUT_LINE ('Course, '||v_course_no||' has '||v_total||' sections');
      END IF;
   EXCEPTION
      WHEN e_no_sections 
      THEN
         DBMS_OUTPUT.PUT_LINE ('There are no sections for course '||v_course_no);  
   END;
END;

-- For Example ch09_11b.sql
DECLARE
   v_course_no   NUMBER := 430;
   v_total       NUMBER;
   e_no_sections EXCEPTION;
BEGIN
   BEGIN
      SELECT COUNT(*)
        INTO v_total
        FROM section
       WHERE course_no = v_course_no;
         
      IF v_total = 0 
      THEN
         RAISE e_no_sections;
      ELSE
         DBMS_OUTPUT.PUT_LINE ('Course, '||v_course_no||' has '||v_total||' sections');
      END IF;
   EXCEPTION
      WHEN e_no_sections 
      THEN
         RAISE;
   END;

EXCEPTION
   WHEN e_no_sections 
   THEN
      DBMS_OUTPUT.PUT_LINE ('There are no sections for course '||v_course_no);  
END;

-- For Example ch09_12a.sql
DECLARE
   v_section_id        NUMBER := &sv_section_id;
   v_total_students    NUMBER;
   e_too_many_students EXCEPTION;
BEGIN
   -- Calculate number of students enrolled
   SELECT COUNT(*)
     INTO v_total_students
     FROM enrollment
    WHERE section_id = v_section_id;
         
   IF v_total_students >= 10 
   THEN
      RAISE e_too_many_students;
   ELSE
      DBMS_OUTPUT.PUT_LINE 
         ('There are '||v_total_students||' students in section '||v_section_id);
   END IF;
EXCEPTION
   WHEN e_too_many_students 
   THEN
      DBMS_OUTPUT.PUT_LINE 
         ('There are too many students in section '||v_section_id);  
END;

-- For Example ch09_12b.sql
DECLARE
   v_section_id        NUMBER := &sv_section_id;
   v_total_students    NUMBER;
   e_too_many_students EXCEPTION;
BEGIN
   -- Add inner block
   BEGIN
      -- Calculate number of students enrolled
      SELECT COUNT(*)
        INTO v_total_students
        FROM enrollment
       WHERE section_id = v_section_id;
         
      IF v_total_students >= 10 
      THEN
         RAISE e_too_many_students;
      ELSE
         DBMS_OUTPUT.PUT_LINE 
            ('There are '||v_total_students||' students in section '||
             v_section_id);
      END IF;
   -- Re-raise exception
   EXCEPTION
      WHEN e_too_many_students 
      THEN
         RAISE;
   END;
EXCEPTION
   WHEN e_too_many_students 
   THEN
      DBMS_OUTPUT.PUT_LINE 
         ('There are too many students in section '||v_section_id);  
END;

-- For Example ch09_12c.sql
-- Outer PL/SQL block
BEGIN
   -- This block became inner PL/SQL block
   DECLARE
      v_section_id        NUMBER := &sv_section_id;
      v_total_students    NUMBER;
      e_too_many_students EXCEPTION;
   BEGIN
      -- Calculate number of students enrolled
      SELECT COUNT(*)
        INTO v_total_students
        FROM enrollment
       WHERE section_id = v_section_id;
         
      IF v_total_students >= 10 
      THEN
         RAISE e_too_many_students;
      ELSE
         DBMS_OUTPUT.PUT_LINE 
            ('There are '||v_total_students||' students in section '||
             v_section_id);
      END IF;
   EXCEPTION
      WHEN e_too_many_students 
      THEN
         RAISE;
   END;

EXCEPTION
   WHEN e_too_many_students 
   THEN
      DBMS_OUTPUT.PUT_LINE 
         ('There are too many students in section '||v_section_id);  
END;

-- For Example ch09_12d.sql
-- Outer PL/SQL block
DECLARE
   v_section_id        NUMBER := &sv_section_id;
   e_too_many_students EXCEPTION;
BEGIN
   -- This block became inner PL/SQL block
   DECLARE
      v_total_students NUMBER;
   BEGIN
      -- Calculate number of students enrolled
      SELECT COUNT(*)
        INTO v_total_students
        FROM enrollment
       WHERE section_id = v_section_id;
         
      IF v_total_students >= 10 
      THEN
         RAISE e_too_many_students;
      ELSE
         DBMS_OUTPUT.PUT_LINE 
            ('There are '||v_total_students||' students in section '||
             v_section_id);
      END IF;
   EXCEPTION
      WHEN e_too_many_students 
      THEN
         RAISE;
   END;

EXCEPTION
   WHEN e_too_many_students 
   THEN
      DBMS_OUTPUT.PUT_LINE 
         ('There are too many students for section '||v_section_id);  
END;
