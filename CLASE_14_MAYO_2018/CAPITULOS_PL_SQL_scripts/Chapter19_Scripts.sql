-- *** Chapter Exercises *** --
-- 
-- For Example  ch19_1.sql
CREATE OR REPLACE PROCEDURE Discount 
AS
  CURSOR c_group_discount
  IS
    SELECT distinct s.course_no, c.description
      FROM section s, enrollment e, course c
     WHERE s.section_id = e.section_id
       AND c.course_no = s.course_no
     GROUP BY s.course_no, c.description, 
              e.section_id, s.section_id
     HAVING COUNT(*) >=8;
BEGIN
   FOR r_group_discount IN c_group_discount
   LOOP
      UPDATE course
         SET cost = cost * .95
       WHERE course_no = r_group_discount.course_no;
      DBMS_OUTPUT.PUT_LINE
        ('A 5% discount has been given to '||
         r_group_discount.course_no||' '|| 
         r_group_discount.description
        );
   END LOOP; 
END; 

-- For Example  ch19_2.sql
CREATE OR REPLACE PROCEDURE find_sname
  (i_student_id IN NUMBER,
   o_first_name OUT VARCHAR2,
   o_last_name OUT VARCHAR2
   )
AS
BEGIN
  SELECT first_name, last_name
    INTO o_first_name, o_last_name
    FROM student
   WHERE student_id = i_student_id;
EXCEPTION
  WHEN OTHERS
  THEN
    DBMS_OUTPUT.PUT_LINE('Error in finding student_id: 
      '||i_student_id); 
END find_sname; 
  The procedure takes in a student_id via the parameter named i_student_id. It passes out the parameters o_first_name and o_last_name. The procedure is a simple select statement retrieving the first_name and last_name from the Student table where the student_id matches the value of the i_student_id, which is the only in parameter that exists in the procedure. To call the procedure, a value must be passed in for the i_student_id parameter.
For Example?ch19_3.sql
DECLARE
  v_local_first_name student.first_name%TYPE;
  v_local_last_name student.last_name%TYPE;
BEGIN
  find_sname
    (145, v_local_first_name, v_local_last_name);
  DBMS_OUTPUT.PUT_LINE
    ('Student 145 is: '||v_local_first_name||
     ' '|| v_local_last_name||'.'
    );
END; 
 