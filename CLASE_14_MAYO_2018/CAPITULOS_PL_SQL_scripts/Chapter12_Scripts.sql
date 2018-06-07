-- *** Chapter Exercises *** --
-- For Example ch12_2.sql
SET SERVEROUTPUT ON
  1    DECLARE
  2       CURSOR c_student IS
  3          SELECT first_name, last_name, student_id
  4            FROM student
  5           WHERE last_name LIKE 'J%';
  6       CURSOR c_course
  7         (i_student_id IN student.student_id%TYPE)
  8       IS
  9          SELECT c.description, s.section_id sec_id
 10            FROM course c, section s, enrollment e
 11           WHERE e.student_id = i_student_id
 12             AND c.course_no = s.course_no
 13             AND s.section_id = e.section_id;
 14       CURSOR c_grade(i_section_id IN section.section_id%TYPE,
 15                      i_student_id IN student.student_id%TYPE)
 16            IS
 17            SELECT gt.description grd_desc,
 18               TO_CHAR
 19                  (AVG(g.numeric_grade), '999.99') num_grd
 20              FROM enrollment e,
 21                   grade g, grade_type gt
 22             WHERE e.section_id = i_section_id
 23               AND e.student_id = g.student_id
 24               AND e.student_id = i_student_id
 25               AND e.section_id = g.section_id
 26               AND g.grade_type_code = gt.grade_type_code
 27             GROUP BY gt.description ;
 28    BEGIN
 29       FOR r_student IN c_student
 30       LOOP
 31         DBMS_OUTPUT.PUT_LINE(CHR(10));
 32         DBMS_OUTPUT.PUT_LINE(r_student.first_name||
 33            '  '||r_student.last_name);
 34         FOR r_course IN c_course(r_student.student_id)
 35         LOOP
 36            DBMS_OUTPUT.PUT_LINE ('Grades for course :'||
 37               r_course.description);
 38            FOR r_grade IN c_grade(r_course.sec_id,
 39                              r_student.student_id)
 40            LOOP
 41               DBMS_OUTPUT.PUT_LINE(r_grade.num_grd||
 42                  '  '||r_grade.grd_desc);
 43            END LOOP;
 44         END LOOP;
 45       END LOOP; 
 46   END; 

--- For Example ch12_3.sql
DECLARE
  CURSOR c_course IS
     SELECT course_no, cost
       FROM course FOR UPDATE;
BEGIN
   FOR r_course IN c_course
   LOOP
      IF r_course.cost < 2500
      THEN
         UPDATE course
            SET cost = r_course.cost + 10
          WHERE course_no = r_course.course_no;
      END IF;
   END LOOP;
END; 

-- For Example?ch12_4.sql
DECLARE
  CURSOR c_grade(
      i_student_id IN enrollment.student_id%TYPE,
      i_section_id IN enrollment.section_id%TYPE)
   IS
      SELECT final_grade
        FROM enrollment
       WHERE student_id = i_student_id
         AND section_id = i_section_id
       FOR UPDATE;
   CURSOR c_enrollment IS
      SELECT e.student_id, e.section_id
        FROM enrollment e, section s
       WHERE s.course_no = 135
         AND e.section_id = s.section_id;
BEGIN
   FOR r_enroll IN c_enrollment
   LOOP
      FOR r_grade IN c_grade(r_enroll.student_id,
                             r_enroll.section_id)
      LOOP
         UPDATE enrollment
            SET final_grade  = 90
          WHERE student_id = r_enroll.student_id
            AND section_id = r_enroll.section_id;
      END LOOP;
   END LOOP;
END; 
  
-- For Example?ch12_5.sql
DECLARE
  CURSOR c_stud_zip IS 
      SELECT s.student_id, z.city
        FROM student s, zipcode z
       WHERE z.city = 'Brooklyn'
         AND s.zip = z.zip
       FOR UPDATE OF phone;
BEGIN
  FOR r_stud_zip IN c_stud_zip
  LOOP
     UPDATE student
        SET phone = '718'||SUBSTR(phone,4)
      WHERE student_id = r_stud_zip.student_id;
  END LOOP;
END; 


-- For Example?ch12_6.sql
DECLARE
  CURSOR c_stud_zip IS 
      SELECT s.student_id, z.city
        FROM student s, zipcode z
       WHERE z.city = 'Brooklyn'
         AND s.zip = z.zip
       FOR UPDATE OF phone;
BEGIN
   FOR r_stud_zip IN c_stud_zip
   LOOP
      DBMS_OUTPUT.PUT_LINE(r_stud_zip.student_id);
      UPDATE student
         SET phone = '718'||SUBSTR(phone,4)
       WHERE CURRENT OF c_stud_zip;
   END LOOP;
END; 
 