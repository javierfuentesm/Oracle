-- *** Chapter Exercises *** --
-- For Example ch16_1a.sql
DECLARE
   course_rec course%ROWTYPE;
BEGIN
   SELECT *
     INTO course_rec
     FROM course
    WHERE course_no = 25;

   DBMS_OUTPUT.PUT_LINE ('Course No: '||course_rec.course_no);
   DBMS_OUTPUT.PUT_LINE ('Course Description: '||course_rec.description);
   DBMS_OUTPUT.PUT_LINE ('Prerequisite: ¬'||course_rec.prerequisite);
END;

-- For Example ch16_2a.sql
DECLARE
   CURSOR student_cur IS
      SELECT first_name, last_name, registration_date
        FROM student
       WHERE rownum <= 4;
    
   student_rec student_cur%ROWTYPE;
BEGIN
   OPEN student_cur;
   LOOP
      FETCH student_cur INTO student_rec;
      EXIT WHEN student_cur%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE 
         ('Name: '||student_rec.first_name||' '||student_rec.last_name);
      DBMS_OUTPUT.PUT_LINE 
         ('Registration Date: ¬'||to_char(student_rec.registration_date, 'MM/DD/YYYY'));
   END LOOP;
END;

-- For Example ch16_2b.sql
DECLARE
   student_rec student_cur%ROWTYPE;

   CURSOR student_cur IS
      SELECT first_name, last_name, registration_date
      FROM student
      WHERE rownum <= 4;
    
BEGIN
   OPEN student_cur;
   LOOP
      FETCH student_cur INTO student_rec;
      EXIT WHEN student_cur%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE 
         ('Name: '||student_rec.first_name||' '||student_rec.last_name);
      DBMS_OUTPUT.PUT_LINE 
      ('Registration Date: ¬'|| to_char(student_rec.registration_date, 'MM/DD/YYYY'));
   END LOOP;
END;

-- For Example ch16_3a.sql
DECLARE
   TYPE time_rec_type IS RECORD
      (curr_date DATE,
       curr_day  VARCHAR2(12),
       curr_time VARCHAR2(8) := '00:00:00');

   time_rec TIME_REC_TYPE; 
BEGIN
   SELECT sysdate
     INTO time_rec.curr_date
     FROM dual;

   time_rec.curr_day  := TO_CHAR(time_rec.curr_date, 'DAY');
   time_rec.curr_time := TO_CHAR(time_rec.curr_date, 'HH24:MI:SS');

   DBMS_OUTPUT.PUT_LINE ('Date: '||to_char(time_rec.curr_date, 'MM/DD/YYYY HH24:MI:SS'));
   DBMS_OUTPUT.PUT_LINE ('Day:  '||time_rec.curr_day);
   DBMS_OUTPUT.PUT_LINE ('Time: '||time_rec.curr_time);
END;

-- For Example ch16_4a.sql
DECLARE
   TYPE sample_type IS RECORD
      (field1 NUMBER(3),
       field2 VARCHAR2(3) NOT NULL);
   
   sample_rec sample_type;

BEGIN
   sample_rec.field1 := 10;
   sample_rec.field2 := 'ABC';
  
   DBMS_OUTPUT.PUT_LINE ('sample_rec.field1 = '||sample_rec.field1);
   DBMS_OUTPUT.PUT_LINE ('sample_rec.field2 = '||sample_rec.field2);
END;

-- For Example ch16_4b.sql
DECLARE
   TYPE sample_type IS RECORD
      (field1 NUMBER(3),
       field2 VARCHAR2(3) NOT NULL := 'ABC'); -- ¬initialize a NOT NULL field

   sample_rec sample_type;

BEGIN
   sample_rec.field1 := 10;
  
   DBMS_OUTPUT.PUT_LINE ('sample_rec.field1 = '||sample_rec.field1);
   DBMS_OUTPUT.PUT_LINE ('sample_rec.field2 = '||sample_rec.field2);
END;

-- For Example ch16_5a.sql
DECLARE
   TYPE name_type1 IS RECORD
      (first_name VARCHAR2(15),
       last_name  VARCHAR2(30));

   TYPE name_type2 IS RECORD
      (first_name VARCHAR2(15),
       last_name  VARCHAR2(30));

   name_rec1 name_type1;
   name_rec2 name_type2;
BEGIN
   name_rec1.first_name := 'John';
   name_rec1.last_name  := 'Smith';
   name_rec2 := name_rec1; -- illegal assignment
END;

-- For Example ch16_5b.sql
DECLARE
   TYPE name_type1 IS RECORD
      (first_name VARCHAR2(15),
       last_name  VARCHAR2(30));

   name_rec1 name_type1;
   name_rec2 name_type1;
BEGIN
   name_rec1.first_name := 'John';
   name_rec1.last_name  := 'Smith';
   name_rec2 := name_rec1; -- no longer illegal assignment
END;

-- For Example ch16_6a.sql
DECLARE
   CURSOR course_cur IS
      SELECT *
        FROM course
       WHERE rownum < 2;

   TYPE course_type IS RECORD
      (course_no     NUMBER(38)
      ,description   VARCHAR2(50)
      ,cost          NUMBER(9,2)
      ,prerequisite  NUMBER(8)
      ,created_by    VARCHAR2(30)
      ,created_date  DATE
      ,modified_by   VARCHAR2(30)
      ,modified_date DATE);

   course_rec1 course%ROWTYPE;      -- table-based record
   course_rec2 course_cur%ROWTYPE;  -- cursor-based record
   course_rec3 course_type;         -- user-defined record
BEGIN
   -- Populate table-based record
   SELECT *
     INTO course_rec1
     FROM course
    WHERE course_no = 10;

   -- Populate cursor-based record
   OPEN course_cur;
   LOOP
      FETCH course_cur INTO course_rec2;
      EXIT WHEN course_cur%NOTFOUND;
   END LOOP;
   
   -- Assign COURSE_REC2 to COURSE_REC1 and COURSE_REC3
   course_rec1 := course_rec2;
   course_rec3 := course_rec2; 

   DBMS_OUTPUT.PUT_LINE (course_rec1.course_no||' - '||course_rec1.description);
   DBMS_OUTPUT.PUT_LINE (course_rec2.course_no||' - '||course_rec2.description);
   DBMS_OUTPUT.PUT_LINE (course_rec3.course_no||' - '||course_rec3.description);
END;

-- For Example ch16_7a.sql
DECLARE
   TYPE name_type IS RECORD
      (first_name VARCHAR2(15),
       last_name  VARCHAR2(30));

   TYPE person_type IS RECORD
      (name   name_type,
       street VARCHAR2(50),
       city   VARCHAR2(25),
       state  VARCHAR2(2),
       zip    VARCHAR2(5));

   person_rec person_type;

BEGIN
   SELECT first_name, last_name, street_address, city, state, zip
     INTO person_rec.name.first_name, person_rec.name.last_name,  
          person_rec.street, person_rec.city, person_rec.state, 
          person_rec.zip
     FROM student 
     JOIN zipcode USING (zip)
    WHERE rownum < 2;

   DBMS_OUTPUT.PUT_LINE ('Name:   '||
      person_rec.name.first_name||' '||person_rec.name.last_name);
   DBMS_OUTPUT.PUT_LINE ('Street: '||person_rec.street);
   DBMS_OUTPUT.PUT_LINE ('City:   '||person_rec.city);
   DBMS_OUTPUT.PUT_LINE ('State:  '||person_rec.state);
   DBMS_OUTPUT.PUT_LINE ('Zip:    '||person_rec.zip);
END;

-- For Example ch16_8a.sql
DECLARE
   TYPE last_name_type IS TABLE OF student.last_name%TYPE
      INDEX BY PLS_INTEGER;

   TYPE zip_info_type IS RECORD
      (zip          VARCHAR2(5),
      last_name_tab last_name_type);

   CURSOR name_cur (p_zip VARCHAR2) IS
      SELECT last_name
        FROM student
       WHERE zip = p_zip;
   
   zip_info_rec zip_info_type;
   v_zip        VARCHAR2(5) := '&sv_zip';
   v_index      PLS_INTEGER := 0;
BEGIN
   zip_info_rec.zip := v_zip;
   DBMS_OUTPUT.PUT_LINE ('Zip: '||zip_info_rec.zip);

   FOR name_rec IN name_cur (v_zip) 
   LOOP
      v_index := v_index + 1;
      zip_info_rec.last_name_tab(v_index) := name_rec.last_name;
      DBMS_OUTPUT.PUT_LINE 
         ('Names('||v_index||'): '||zip_info_rec.last_name_tab(v_index));
   END LOOP;
END;

-- For Example ch16_9a.sql
DECLARE
   CURSOR name_cur IS
      SELECT first_name, last_name
        FROM student
       WHERE ROWNUM <= 4;

   TYPE name_type IS TABLE OF name_cur%ROWTYPE
      INDEX BY PLS_INTEGER;
   
   name_tab name_type;
   v_index  INTEGER := 0;
BEGIN
   FOR name_rec IN name_cur 
   LOOP
      v_index := v_index + 1;
      
      name_tab(v_index).first_name := name_rec.first_name;
      name_tab(v_index).last_name := name_rec.last_name;

      DBMS_OUTPUT.PUT_LINE('First Name('||v_index ||'): '||
         name_tab(v_index).first_name);
      DBMS_OUTPUT.PUT_LINE('Last Name('||v_index ||'): '||
         name_tab(v_index).last_name);
   END LOOP;
END;

-- For Example ch16_9b.sql
DECLARE
   CURSOR name_cur IS
      SELECT first_name, last_name
        FROM student
       WHERE ROWNUM <= 4;

   TYPE name_type IS TABLE OF name_cur%ROWTYPE;
  
   name_tab name_type := name_type();
   v_index INTEGER  := 0;
BEGIN
   FOR name_rec IN name_cur 
   LOOP
      v_index := v_index + 1;
      name_tab.EXTEND;
      
      name_tab(v_index).first_name := name_rec.first_name;
      name_tab(v_index).last_name := name_rec.last_name;

      DBMS_OUTPUT.PUT_LINE('First Name('||v_index||'): '||
         name_tab(v_index).first_name);
      DBMS_OUTPUT.PUT_LINE('Last Name('||v_index||'): '||
         name_tab(v_index).last_name);
   END LOOP;
END;

-- For Example ch16_10a.sql
DECLARE
   CURSOR enroll_cur IS
      SELECT first_name, last_name, COUNT(*) total
        FROM student 
        JOIN enrollment USING (student_id)
      GROUP BY first_name, last_name;

   TYPE enroll_rec_type IS RECORD
      (first_name  VARCHAR2(15),
       last_name   VARCHAR2(30),
       enrollments INTEGER);

   TYPE enroll_array_type IS TABLE OF enroll_rec_type
      INDEX BY PLS_INTEGER;
   
   enroll_tab enroll_array_type;
   v_index    INTEGER := 0;
BEGIN
   FOR enroll_rec IN enroll_cur 
   LOOP
      v_index := v_index + 1;

      enroll_tab(v_index).first_name  := enroll_rec.first_name;
      enroll_tab(v_index).last_name   := enroll_rec.last_name;
      enroll_tab(v_index).enrollments := enroll_rec.total;

      IF v_index <= 4 THEN
         DBMS_OUTPUT.PUT_LINE('First Name('||v_index||'): '||
            enroll_tab (v_index).first_name);
         DBMS_OUTPUT.PUT_LINE('Last Name('||v_index||'): '||
            enroll_tab (v_index).last_name);
         DBMS_OUTPUT.PUT_LINE('Enrollments('||v_index||'): '||
            enroll_tab (v_index).enrollments);
         DBMS_OUTPUT.PUT_LINE ('--------------------');
      END IF;
   END LOOP;
END;

-- *** Web Chapter Exercises *** --
-- For Example ch16_11a.sql
DECLARE
   zip_rec zipcode%ROWTYPE;

BEGIN
   SELECT *
     INTO zip_rec
     FROM zipcode
    WHERE rownum < 2;
END;

-- For Example ch16_11b.sql
DECLARE
   zip_rec zipcode%ROWTYPE;

BEGIN
   SELECT *
     INTO zip_rec
     FROM zipcode
    WHERE rownum < 2;

   DBMS_OUTPUT.PUT_LINE ('Zip:           '||zip_rec.zip);
   DBMS_OUTPUT.PUT_LINE ('City:          '||zip_rec.city);
   DBMS_OUTPUT.PUT_LINE ('State:         '||zip_rec.state);
   DBMS_OUTPUT.PUT_LINE ('Created By:    '||zip_rec.created_by);
   DBMS_OUTPUT.PUT_LINE ('Created Date:  '||zip_rec.created_date);
   DBMS_OUTPUT.PUT_LINE ('Modified By:   '||zip_rec.modified_by);
   DBMS_OUTPUT.PUT_LINE ('Modified Date: '||zip_rec.modified_date);
END;

-- For Example ch16_11c.sql
DECLARE
   CURSOR zip_cur IS
      SELECT *
        FROM zipcode
       WHERE rownum < 4;

   zip_rec zip_cur%ROWTYPE;
BEGIN
   OPEN zip_cur;
   LOOP
      FETCH zip_cur INTO zip_rec;
      EXIT WHEN zip_cur%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE ('Zip:           '||zip_rec.zip);
      DBMS_OUTPUT.PUT_LINE ('City:          '||zip_rec.city);
      DBMS_OUTPUT.PUT_LINE ('State:         '||zip_rec.state);
      DBMS_OUTPUT.PUT_LINE ('Created By:    '||zip_rec.created_by);
      DBMS_OUTPUT.PUT_LINE ('Created Date:  '||zip_rec.created_date);
      DBMS_OUTPUT.PUT_LINE ('Modified By:   '||zip_rec.modified_by);
      DBMS_OUTPUT.PUT_LINE ('Modified Date: '||zip_rec.modified_date);
   END LOOP;
END;

-- For Example ch16_11d.sql
DECLARE
   CURSOR zip_cur IS
      SELECT city, state, z.zip, COUNT(*) students
        FROM zipcode z, student s
       WHERE z.zip = s.zip
      GROUP BY city, state, z.zip;

   zip_rec zip_cur%ROWTYPE;
BEGIN
   OPEN zip_cur;
   LOOP
      FETCH zip_cur INTO zip_rec;
      EXIT WHEN zip_cur%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE ('Zip:      '||zip_rec.zip);
      DBMS_OUTPUT.PUT_LINE ('City:     '||zip_rec.city);
      DBMS_OUTPUT.PUT_LINE ('State:    '||zip_rec.state);
      DBMS_OUTPUT.PUT_LINE ('Students: '||zip_rec.students);
   END LOOP;
END;

-- For Example ch16_11e.sql
DECLARE
   CURSOR zip_cur IS
      SELECT city, state, z.zip, COUNT(*) students
        FROM zipcode z, student s
       WHERE z.zip = s.zip
      GROUP BY city, state, z.zip;

   zip_rec zip_cur%ROWTYPE;
   v_counter INTEGER := 0;
BEGIN
   OPEN zip_cur;
   LOOP
      FETCH zip_cur INTO zip_rec;
      EXIT WHEN zip_cur%NOTFOUND;

      v_counter := v_counter + 1;

      IF v_counter <= 4 
      THEN
         DBMS_OUTPUT.PUT_LINE ('Zip:      '||zip_rec.zip);
         DBMS_OUTPUT.PUT_LINE ('City:     '||zip_rec.city);
         DBMS_OUTPUT.PUT_LINE ('State:    '||zip_rec.state);
         DBMS_OUTPUT.PUT_LINE ('Students: ¬'||zip_rec.students);
      END IF;
   END LOOP;
END;

-- For Example ch16_12a.sql
DECLARE
   CURSOR zip_cur IS
      SELECT zip, COUNT(*) students
        FROM student
      GROUP BY zip;

   TYPE zip_info_type IS RECORD
      (zip_code VARCHAR2(5)
      ,students INTEGER);

   zip_info_rec zip_info_type;
BEGIN
   FOR zip_rec IN zip_cur 
   LOOP
      zip_info_rec.zip_code := zip_rec.zip; 
      zip_info_rec.students := zip_rec.students;
   END LOOP;
END;

-- For Example ch16_12b.sql
DECLARE
   CURSOR zip_cur IS
      SELECT zip, COUNT(*) students
        FROM student
      GROUP BY zip;

   TYPE zip_info_type IS RECORD
      (zip_code VARCHAR2(5)
      ,students INTEGER);

   zip_info_rec zip_info_type;
   v_counter INTEGER := 0;
BEGIN
   FOR zip_rec IN zip_cur 
   LOOP
      zip_info_rec.zip_code := zip_rec.zip; 
      zip_info_rec.students := zip_rec.students;

      v_counter := v_counter + 1;
      IF v_counter <= 5 
      THEN
         DBMS_OUTPUT.PUT_LINE ('Zip Code: '||zip_info_rec.zip_code);
         DBMS_OUTPUT.PUT_LINE ('Students: '||zip_info_rec.students);
         DBMS_OUTPUT.PUT_LINE ('--------------------');
      END IF;
   END LOOP;
END;

-- For Example ch16_12c.sql
DECLARE
   CURSOR zip_cur IS
      SELECT zip
        FROM zipcode
       WHERE ROWNUM <= 5;

   TYPE zip_info_type IS RECORD
      (zip_code    VARCHAR2(5)
      ,students    INTEGER
      ,instructors INTEGER);

   zip_info_rec zip_info_type;
BEGIN
   FOR zip_rec IN zip_cur 
   LOOP
      zip_info_rec.zip_code := zip_rec.zip; 

      SELECT COUNT(*) 
        INTO zip_info_rec.students
        FROM student
       WHERE zip = zip_info_rec.zip_code;

      SELECT COUNT(*)
        INTO zip_info_rec.instructors
        FROM instructor
       WHERE zip = zip_info_rec.zip_code;

      DBMS_OUTPUT.PUT_LINE ('Zip Code:    '||zip_info_rec.zip_code);
      DBMS_OUTPUT.PUT_LINE ('Students:    '||zip_info_rec.students);
      DBMS_OUTPUT.PUT_LINE ('Instructors: '||zip_info_rec.instructors);
      DBMS_OUTPUT.PUT_LINE ('--------------------');
   END LOOP;
END;

-- For Example ch16_12d.sql
DECLARE
   CURSOR zip_cur IS
      SELECT z.zip, COUNT(student_id) students, ¬COUNT(instructor_id) instructors
        FROM zipcode z, student s, instructor i
       WHERE z.zip = s.zip (+)
         AND z.zip = i.zip (+)
      GROUP BY z.zip;

   TYPE zip_info_type IS RECORD
      (zip_code    VARCHAR2(5)
      ,students    INTEGER
      ,instructors INTEGER);

   zip_info_rec zip_info_type;
   v_counter INTEGER := 0;
BEGIN
   FOR zip_rec IN zip_cur 
   LOOP
      zip_info_rec.zip_code    := zip_rec.zip; 
      zip_info_rec.students    := zip_rec.students;
      zip_info_rec.instructors := zip_rec.instructors;

      v_counter := v_counter + 1;
      IF v_counter <= 5 
      THEN
         DBMS_OUTPUT.PUT_LINE ('Zip Code:    '||zip_info_rec.zip_code);
         DBMS_OUTPUT.PUT_LINE ('Students:    '||zip_info_rec.students);
         DBMS_OUTPUT.PUT_LINE ('Instructors: '||zip_info_rec.instructors);
         DBMS_OUTPUT.PUT_LINE ('--------------------');
      END IF;
   END LOOP;
END;

-- For Example ch16_13a.sql
DECLARE
   TYPE last_name_type IS TABLE OF student.last_name%TYPE INDEX BY PLS_INTEGER;

   TYPE zip_info_type IS RECORD
      (zip          VARCHAR2(5)
      ,last_name_tab last_name_type);

   CURSOR name_cur (p_zip VARCHAR2) IS
      SELECT last_name
        FROM student
       WHERE zip = p_zip;
   
   zip_info_rec zip_info_type;
   v_zip        VARCHAR2(5) := '&sv_zip';
   v_counter    INTEGER := 0;
BEGIN
   zip_info_rec.zip := v_zip;

   FOR name_rec IN name_cur (v_zip) 
   LOOP
      v_counter := v_counter + 1;
      zip_info_rec.last_name_tab(v_counter) := name_rec.last_name;
   END LOOP;
END;

-- For Example ch16_13b.sql
DECLARE
   TYPE last_name_type IS TABLE OF student.last_name%TYPE INDEX BY PLS_INTEGER;

   TYPE zip_info_type IS RECORD
      (zip          VARCHAR2(5)
      ,last_name_tab last_name_type);

   CURSOR name_cur (p_zip VARCHAR2) IS
      SELECT last_name
        FROM student
       WHERE zip = p_zip;
   
   zip_info_rec zip_info_type;
   v_zip        VARCHAR2(5) := '&sv_zip';
   v_counter    INTEGER := 0;
BEGIN
   zip_info_rec.zip := v_zip;
   DBMS_OUTPUT.PUT_LINE ('Zip: '||zip_info_rec.zip);

   FOR name_rec IN name_cur (v_zip) 
   LOOP
      v_counter := v_counter + 1;
      zip_info_rec.last_name_tab(v_counter) := name_rec.last_name;

      DBMS_OUTPUT.PUT_LINE ('Names('||v_counter||'): '||
         zip_info_rec.last_name_tab(v_counter));
   END LOOP;
END; 

-- For Example ch16_13c.sql
DECLARE
   TYPE last_name_type IS TABLE OF student.last_name%TYPE INDEX BY PLS_INTEGER;

   TYPE zip_info_type IS RECORD
      (zip          VARCHAR2(5)
      ,last_name_tab last_name_type);

   CURSOR zip_cur IS
      SELECT zip, COUNT(*)
        FROM student
      GROUP BY zip
      HAVING COUNT(*) > 1;

   CURSOR name_cur (p_zip VARCHAR2) IS
      SELECT last_name
        FROM student
       WHERE zip = p_zip;
   
   zip_info_rec zip_info_type;
   v_counter    INTEGER;
BEGIN
   FOR zip_rec IN zip_cur 
   LOOP
      zip_info_rec.zip := zip_rec.zip;
      DBMS_OUTPUT.PUT_LINE ('Zip: '||zip_info_rec.zip);

      v_counter := 0;
      FOR name_rec IN name_cur (zip_info_rec.zip) 
      LOOP
         v_counter := v_counter + 1;
         zip_info_rec.last_name_tab(v_counter) := name_rec.last_name;

         DBMS_OUTPUT.PUT_LINE ('Names('||v_counter||'): '||
            zip_info_rec.last_name_tab(v_counter));
      END LOOP;
      DBMS_OUTPUT.PUT_LINE ('----------');
   END LOOP;
END;

-- For Example ch16_9c.sql
DECLARE
   CURSOR name_cur IS
      SELECT first_name, last_name
        FROM student
       WHERE ROWNUM <= 4;

   TYPE name_type IS VARRAY(4) OF name_cur%ROWTYPE;
  
   name_tab name_type := name_type();
   v_index INTEGER := 0;
BEGIN
   FOR name_rec IN name_cur 
   LOOP
      v_index := v_index + 1;
      name_tab.EXTEND;
      
      name_tab(v_index).first_name := name_rec.first_name;
      name_tab(v_index).last_name  := name_rec.last_name;

      DBMS_OUTPUT.PUT_LINE('First Name('||v_index ||'): '||
         name_tab(v_index).first_name);
      DBMS_OUTPUT.PUT_LINE('Last Name('||v_index ||'): '||
         name_tab(v_index).last_name);
   END LOOP;
END;

-- For Example ch16_9d.sql
DECLARE
   CURSOR name_cur IS
      SELECT first_name, last_name
        FROM student
       WHERE ROWNUM <= 4;
   
   TYPE name_rec_type IS RECORD
      (first_name  VARCHAR2(15)
      ,last_name   VARCHAR2(30));
   
   TYPE name_type IS VARRAY(4) OF name_rec_type;
  
   name_rec name_rec_type; 
   name_tab name_type := name_type();
   v_index  INTEGER := 0;
BEGIN
   FOR rec IN name_cur 
   LOOP
      name_rec := rec;
      v_index := v_index + 1;
      name_tab.EXTEND;
      
      name_tab(v_index).first_name := name_rec.first_name;
      name_tab(v_index).last_name  := name_rec.last_name;

      DBMS_OUTPUT.PUT_LINE('First Name('||v_index ||'): '||
         name_tab(v_index).first_name);
      DBMS_OUTPUT.PUT_LINE('Last Name('||v_index ||'): '||
         name_tab(v_index).last_name);
   END LOOP;
END;

-- For Example ch16_9d.sql
DECLARE
   CURSOR name_cur IS
      SELECT first_name, last_name
        FROM student
       WHERE ROWNUM <= 4;
   
   TYPE name_rec_type IS RECORD
      (first_name  VARCHAR2(15)
      ,last_name   VARCHAR2(30));
   
   TYPE name_type IS VARRAY(4) OF name_rec_type;
  
   name_tab name_type := name_type();
   v_index  INTEGER := 0;
BEGIN
   FOR rec IN name_cur 
   LOOP
      v_index := v_index + 1;
      name_tab.EXTEND;
      
      name_tab(v_index).first_name := rec.first_name;
      name_tab(v_index).last_name  := rec.last_name;

      DBMS_OUTPUT.PUT_LINE('First Name('||v_index ||'): '||
         name_tab(v_index).first_name);
      DBMS_OUTPUT.PUT_LINE('Last Name('||v_index ||'): '||
         name_tab(v_index).last_name);
   END LOOP;
END;

-- For Example ch16_14a.sql
DECLARE
   CURSOR instructor_cur IS
      SELECT first_name, last_name, COUNT(UNIQUE s.course_no) courses
        FROM instructor i
        LEFT OUTER JOIN section s
          ON (s.instructor_id = i.instructor_id)
      GROUP BY first_name, last_name;

   TYPE rec_type IS RECORD
      (first_name     INSTRUCTOR.FIRST_NAME%TYPE
      ,last_name      INSTRUCTOR.LAST_NAME%TYPE
      ,courses_taught NUMBER);

   TYPE instructor_type IS TABLE OF REC_TYPE INDEX BY PLS_INTEGER;

   instructor_tab instructor_type;
  
   v_index INTEGER := 0;
BEGIN
   FOR instructor_rec IN instructor_cur 
   LOOP
      v_index := v_index + 1;

      -- Populate associative array of records
      instructor_tab(v_index).first_name     := instructor_rec.first_name;
      instructor_tab(v_index).last_name      := instructor_rec.last_name;
      instructor_tab(v_index).courses_taught := instructor_rec.courses; 
      
      DBMS_OUTPUT.PUT_LINE ('Instructor, '|| 
         instructor_tab(v_index).first_name||' '||
         instructor_tab(v_index).last_name||', teaches '||
         instructor_tab(v_index).courses_taught||' courses.');
   END LOOP;
END;

-- For Example ch16_14b.sql
DECLARE
   CURSOR instructor_cur IS
      SELECT first_name, last_name, COUNT(UNIQUE s.course_no) courses
        FROM instructor i
        LEFT OUTER JOIN section s
          ON (s.instructor_id = i.instructor_id)
      GROUP BY first_name, last_name;

   TYPE rec_type IS RECORD
      (first_name     INSTRUCTOR.FIRST_NAME%TYPE
      ,last_name      INSTRUCTOR.LAST_NAME%TYPE
      ,courses_taught NUMBER);

   TYPE instructor_type IS TABLE OF REC_TYPE;
   instructor_tab instructor_type := instructor_type();
  
   v_index INTEGER := 0;
BEGIN
   FOR instructor_rec IN instructor_cur 
   LOOP
      v_index := v_index + 1;
      instructor_tab.EXTEND;

      -- Populate nested table of records
      instructor_tab(v_index).first_name     := instructor_rec.first_name;
      instructor_tab(v_index).last_name      := instructor_rec.last_name;
      instructor_tab(v_index).courses_taught := instructor_rec.courses; 
      
      DBMS_OUTPUT.PUT_LINE ('Instructor, '|| 
         instructor_tab(v_index).first_name||' '||
         instructor_tab(v_index).last_name||', teaches '||
         instructor_tab(v_index).courses_taught||' courses.');
   END LOOP;
END;

-- For Example ch16_14c.sql
DECLARE
   CURSOR instructor_cur IS
      SELECT first_name, last_name, COUNT(UNIQUE s.course_no) courses
        FROM instructor i
        LEFT OUTER JOIN section s
          ON (s.instructor_id = i.instructor_id)
      GROUP BY first_name, last_name;

   TYPE rec_type IS RECORD
      (first_name     INSTRUCTOR.FIRST_NAME%TYPE
      ,last_name      INSTRUCTOR.LAST_NAME%TYPE
      ,courses_taught NUMBER);

   TYPE instructor_type IS VARRAY(10) OF REC_TYPE;
   instructor_tab instructor_type := instructor_type();
  
   v_index INTEGER := 0;
BEGIN
   FOR instructor_rec IN instructor_cur 
   LOOP
      v_index := v_index + 1;
      instructor_tab.EXTEND;

      -- Populate varray of records
      instructor_tab(v_index).first_name     := instructor_rec.first_name;
      instructor_tab(v_index).last_name      := instructor_rec.last_name;
      instructor_tab(v_index).courses_taught := instructor_rec.courses; 
      
      DBMS_OUTPUT.PUT_LINE ('Instructor, '|| 
         instructor_tab(v_index).first_name||' '||
         instructor_tab(v_index).last_name||', teaches '||
         instructor_tab(v_index).courses_taught||' courses.');
   END LOOP;
END;

-- For Example ch16_15a.sql
DECLARE
   CURSOR c_cur IS
      SELECT course_no, description, cost, prerequisite
        FROM course
       WHERE prerequisite IS NOT NULL
         AND rownum <= 10;

   TYPE prerequisite_type IS RECORD
      (prereq_no   NUMBER
      ,prereq_desc VARCHAR(50)
      ,prereq_cost NUMBER);

   TYPE course_type IS RECORD
      (course_no        NUMBER
      ,description      VARCHAR2(50)
      ,cost             NUMBER
      ,prerequisite_rec PREREQUISITE_TYPE);

   course_rec COURSE_TYPE;
BEGIN
   FOR c_rec in c_cur 
   LOOP
      course_rec.course_no   := c_rec.course_no;
      course_rec.description := c_rec.description;
      course_rec.cost        := c_rec.cost;

      SELECT course_no, description, cost
        INTO course_rec.prerequisite_rec.prereq_no,
             course_rec.prerequisite_rec.prereq_desc,
             course_rec.prerequisite_rec.prereq_cost
        FROM course
       WHERE course_no = c_rec.prerequisite;
      
      DBMS_OUTPUT.PUT_LINE ('Course: '||
         course_rec.course_no||' – '||course_rec.description); 
      DBMS_OUTPUT.PUT_LINE ('Cost: '|| course_rec.cost);
      DBMS_OUTPUT.PUT_LINE ('Prerequisite: '||
         course_rec.prerequisite_rec. prereq_no||' – '||
         course_rec.prerequisite_rec.prereq_desc);
      DBMS_OUTPUT.PUT_LINE ('Prerequisite Cost: '||
         course_rec.prerequisite_rec.prereq_cost);
      DBMS_OUTPUT.PUT_LINE ('========================================');
   END LOOP;
END;

