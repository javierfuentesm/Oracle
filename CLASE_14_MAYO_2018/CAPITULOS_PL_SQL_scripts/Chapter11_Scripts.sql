-- *** Chapter Exercises *** --
For Example?ch11_1a.sql
SET SERVEROUTPUT ON; 
DECLARE
   v_first_name VARCHAR2(35);
   v_last_name VARCHAR2(35);
BEGIN
   SELECT first_name, last_name
     INTO v_first_name, v_last_name
     FROM student
    WHERE student_id = 123;
   DBMS_OUTPUT.PUT_LINE ('Student name: '||
      v_first_name||' '||v_last_name);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE 
      ('There is no student with student ID 123');
END; 
For Example?ch11_1b.sql
DECLARE 
   CURSOR C_MyCursor IS
      SELECT *
        FROM zipcode
       WHERE state = 'NY';
... 
    <code would continue here with Opening, Fetching
      and closing of the cursor>
For Example?ch11_1c.sql
SET SERVEROUTPUT ON
DECLARE
   vr_student student%ROWTYPE;
BEGIN
   SELECT *
     INTO vr_student
     FROM student
    WHERE student_id = 156;
   DBMS_OUTPUT.PUT_LINE (vr_student.first_name||' '
      ||vr_student.last_name||' has an ID of 156');
EXCEPTION
   WHEN no_data_found
      THEN
           RAISE_APPLICATION_ERROR(-2001,'The Student '||
            'is not in the database');
END; 

-- For Example  ch11_2a.sql
SET SERVEROUTPUT ON;
DECLARE
   CURSOR c_student_name IS
      SELECT first_name, last_name
        FROM student
       WHERE rownum <= 5;
   vr_student_name c_student_name%ROWTYPE;
BEGIN
   OPEN c_student_name;
   LOOP
      FETCH c_student_name INTO vr_student_name;
      EXIT WHEN c_student_name%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('Student name: '||
         vr_student_name.first_name
         ||'  '||vr_student_name.last_name);
   END LOOP;
   CLOSE c_student_name;
END;

-- For Example ch11_2b.sql
SET SERVEROUTPUT ON;
DECLARE
   CURSOR c_student_name IS
      SELECT first_name, last_name
        FROM student
       WHERE rownum <= 5;
   vr_student_name c_student_name%ROWTYPE;
BEGIN
   OPEN c_student_name;
   LOOP
      FETCH c_student_name INTO vr_student_name;
      EXIT WHEN c_student_name%NOTFOUND;
   END LOOP;
   CLOSE c_student_name;
   DBMS_OUTPUT.PUT_LINE('Student name: '||
      vr_student_name.first_name||' ' 
      ||vr_student_name.last_name);
END;

-- For Example  ch11_2c.sql
SET SERVEROUTPUT ON;
DECLARE
   TYPE instructor_info IS RECORD
      (first_name instructor.first_name%TYPE,
       last_name instructor.last_name%TYPE,
       sections NUMBER);
   rv_instructor instructor_info;
BEGIN
   SELECT RTRIM(i.first_name), 
          RTRIM(i.last_name), COUNT(*)
     INTO rv_instructor
     FROM instructor i, section s
    WHERE i.instructor_id = s.instructor_id
      AND i.instructor_id = 102
   GROUP BY i.first_name, i.last_name;
   DBMS_OUTPUT.PUT_LINE('Instructor, '||
      rv_instructor.first_name|| 
    ' '||rv_instructor.last_name||
      ', teaches '||rv_instructor.sections|| 
        ' section(s)');
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE
           ('There is no such instructor');
END;

-- For Example ch11_3a.sql
SET SERVEROUTPUT ON;
DECLARE
   v_city zipcode.city%type; 
BEGIN
   SELECT city
     Into v_city
     from zipcode
    Where zip = 07002;
   if SQL%ROWCOUNT = 1
   then
     Dbms_output.put_line(v_city ||' has a '||
        'zipcode of 07002');
   ELSif SQL%ROWCOUNT = 0
   then
      Dbms_output.put_line('The zipcode 07002 is '||
         ' not in the database');
   ELSE
      Dbms_output.put_line('Stop harassing me');
   END IF;
END;

-- For Example ch11_4.sql
1> DECLARE
2>    v_sid      student.student_id%TYPE; 
3>    CURSOR c_student IS
4>       SELECT student_id
5>         FROM student
6>        WHERE student_id < 110;
7> BEGIN
8>    OPEN c_student;
9>    LOOP
10>      FETCH c_student INTO v_sid;
11>      EXIT WHEN c_student%NOTFOUND;
12>        DBMS_OUTPUT.PUT_LINE('STUDENT ID : '||v_sid);
13>   END LOOP;
14>   CLOSE c_student;
15> EXCEPTION
16>   WHEN OTHERS
17>   THEN
18>      IF c_student%ISOPEN
19>      THEN
20>         CLOSE c_student;
21>      END IF;
22> END;

-- For Example ch11_5.sql
SET SERVEROUTPUT ON
DECLARE
    v_sid      student.student_id%TYPE;
    CURSOR c_student IS
       SELECT student_id
         FROM student
        WHERE student_id < 110;
 BEGIN
    OPEN c_student;
    LOOP
      FETCH c_student INTO v_sid;
      IF c_student%FOUND THEN
      DBMS_OUTPUT.PUT_LINE
        ('Just FETCHED row '   
          ||TO_CHAR(c_student%ROWCOUNT)||
          ' Student ID: '||v_sid);
      ELSE 
        EXIT;
      END IF;
   END LOOP;
   CLOSE c_student;
 EXCEPTION
   WHEN OTHERS
   THEN
      IF c_student%ISOPEN
      THEN
         CLOSE c_student;
      END IF;
END;
For Example?ch11_6.sql
SET SERVEROUTPUT ON
DECLARE
   CURSOR c_student_enroll IS
      SELECT s.student_id, first_name, last_name,
             COUNT(*) enroll,
             (CASE  
                  WHEN count(*) = 1 Then ' class.'
                  WHEN count(*) is null then 
                               ' no classes.'
                  ELSE ' classes.'
              END) class                     
        FROM student s, enrollment e
       WHERE s.student_id = e.student_id
         AND s.student_id <110
       GROUP BY s.student_id, first_name, last_name;
   r_student_enroll    c_student_enroll%ROWTYPE;
BEGIN
   OPEN c_student_enroll;
   LOOP
      FETCH c_student_enroll INTO r_student_enroll;
      EXIT WHEN c_student_enroll%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('Student INFO: ID '||
         r_student_enroll.student_id||' is '||
         r_student_enroll.first_name|| ' ' ||
         r_student_enroll.last_name||
         ' is enrolled in '||r_student_enroll.enroll||
         r_student_enroll.class);
   END LOOP;
   CLOSE c_student_enroll;
EXCEPTION
   WHEN OTHERS
   THEN
    IF c_student_enroll %ISOPEN
      THEN
    CLOSE c_student_enroll;
    END IF;
END;
For Example?ch11_7.sql
DECLARE
   CURSOR c_student IS
      SELECT student_id, last_name, first_name
        FROM student
       WHERE student_id < 110;
BEGIN
   FOR r_student IN c_student
   LOOP
      INSERT INTO table_log
         VALUES(r_student.last_name);
   END LOOP;
END;
SELECT * from table_log;
2.2 PROCESS NESTED CURSORS
For Example?ch11_8.sql
DECLARE
   CURSOR c_group_discount IS
      SELECT DISTINCT s.course_no 
        FROM section s, enrollment e
       WHERE s.section_id = e.section_id
        GROUP BY s.course_no, e.section_id, s.section_id
       HAVING COUNT(*)>=8;
BEGIN
   FOR r_group_discount IN c_group_discount   LOOP
      UPDATE course
         SET cost = cost * .95
       WHERE course_no = r_group_discount.course_no;
   END LOOP;
   COMMIT;
END; 

-- For Example ch11_9.sql
SET SERVEROUTPUT ON
 1    DECLARE
 2       v_zip zipcode.zip%TYPE;
 3       v_student_flag CHAR;
 4       CURSOR c_zip IS
 5          SELECT zip, city, state
 6            FROM zipcode
 7           WHERE state = 'CT';
 8       CURSOR c_student IS
 9          SELECT first_name, last_name
10            FROM student
11           WHERE zip = v_zip;
12    BEGIN
13       FOR r_zip IN c_zip
14       LOOP
15          v_student_flag := 'N';
16          v_zip := r_zip.zip;
17          DBMS_OUTPUT.PUT_LINE(CHR(10));
18          DBMS_OUTPUT.PUT_LINE('Students living in '||
19             r_zip.city);
20          FOR r_student in c_student
21          LOOP
22             DBMS_OUTPUT.PUT_LINE(
23                r_student.first_name||
24                ' '||r_student.last_name);
25             v_student_flag := 'Y';
26          END LOOP;
27          IF v_student_flag = 'N'
28             THEN
29             DBMS_OUTPUT.PUT_LINE
                  ('No Students for this zipcode');
30          END IF;
31       END LOOP;
32  END; 

-- For Example ch11_10.sql
SET SERVEROUTPUT ON
DECLARE
   v_sid student.student_id%TYPE;
   CURSOR c_student IS
      SELECT student_id, first_name, last_name
        FROM student
       WHERE student_id < 110;
   CURSOR c_course IS
      SELECT c.course_no, c.description
        FROM course c, section s, enrollment e
       WHERE c.course_no = s.course_no
         AND s.section_id = e.section_id
         AND e.student_id = v_sid;
BEGIN
   FOR r_student IN c_student 
   LOOP
      v_sid := r_student.student_id;
      DBMS_OUTPUT.PUT_LINE(chr(10));
      DBMS_OUTPUT.PUT_LINE(' The Student '||
         r_student.student_id||' '||
         r_student.first_name||' '||
         r_student.last_name);
      DBMS_OUTPUT.PUT_LINE(' is enrolled in the '||
         'following courses: ');
      FOR r_course IN c_course
      LOOP
         DBMS_OUTPUT.PUT_LINE(r_course.course_no||
            '   '||r_course.description);
      END LOOP;
   END LOOP;
END; 

-- For Example ch11_11.sql
SET SERVEROUTPUT ON
DECLARE
   v_amount course.cost%TYPE;
   v_instructor_id  instructor.instructor_id%TYPE;
   CURSOR c_inst IS
      SELECT first_name, last_name, instructor_id
        FROM instructor;
   CURSOR c_cost IS
      SELECT c.cost
        FROM course c, section s, enrollment e
       WHERE s.instructor_id = v_instructor_id
         AND c.course_no = s.course_no
         AND s.section_id = e.section_id;
BEGIN
   FOR r_inst IN c_inst
   LOOP
       v_instructor_id := r_inst.instructor_id;
       v_amount := 0;
       DBMS_OUTPUT.PUT_LINE(
          'Amount generated by instructor '||
          r_inst.first_name||' '||r_inst.last_name
          ||' is');
       FOR r_cost IN c_cost
       LOOP
          v_amount := v_amount + NVL(r_cost.cost, 0);
       END LOOP;
       DBMS_OUTPUT.PUT_LINE
       ('     '||TO_CHAR(v_amount,'$999,999'));
   END LOOP;
END;
