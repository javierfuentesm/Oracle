-- *** Chapter Exercises *** --
-- ***


-- For Example ch22_1.sql 
SELECT OBJECT_TYPE, OBJECT_NAME, STATUS
FROM   USER_OBJECTS
WHERE  OBJECT_TYPE IN
       ('FUNCTION', 'PROCEDURE', 'PACKAGE',
        'PACKAGE_BODY')
ORDER BY OBJECT_TYPE; 


-- For Example ch22_2.sql 
CREATE OR REPLACE FUNCTION scode_at_line
    (i_name_in IN VARCHAR2,
     i_line_in IN INTEGER := 1,
     i_type_in IN VARCHAR2 := NULL)
RETURN VARCHAR2
IS
   CURSOR scode_cur IS
      SELECT text
        FROM user_source
       WHERE name = UPPER (i_name_in)
         AND (type = UPPER (i_type_in) 
          OR i_type_in IS NULL)
         AND line = i_line_in;
   scode_rec scode_cur%ROWTYPE;
BEGIN
   OPEN scode_cur;
   FETCH scode_cur INTO scode_rec;
   IF scode_cur%NOTFOUND
      THEN
         CLOSE scode_cur;
         RETURN NULL;
   ELSE
      CLOSE scode_cur;
      RETURN scode_rec.text;
   END IF;
END; 
 

-- For Example ch22_3.sql 
CREATE OR REPLACE PACKAGE  school_api as
   v_current_date DATE; 
   PROCEDURE Discount_Cost;
   FUNCTION new_instructor_id
   RETURN instructor.instructor_id%TYPE;
        FUNCTION total_cost_for_student
          (i_student_id IN student.student_id%TYPE)
      RETURN course.cost%TYPE;
       PRAGMA RESTRICT_REFERENCES
           (total_cost_for_student, WNDS, WNPS, RNPS);      
  PROCEDURE get_student_info
      (i_student_id   IN  student.student_id%TYPE,
       o_last_name    OUT student.last_name%TYPE,
      o_first_name   OUT student.first_name%TYPE,
      o_zip          OUT student.zip%TYPE,
      o_return_code  OUT NUMBER);
  PROCEDURE get_student_info
     (i_last_name   IN student.last_name%TYPE,
      i_first_name  IN student.first_name%TYPE,
      o_student_id  OUT student.student_id%TYPE,
      o_zip         OUT student.zip%TYPE,
      o_return_code OUT NUMBER);
 END school_api; 


-- For Example ch22_4.sql 
CREATE OR REPLACE PACKAGE BODY school_api AS
   PROCEDURE discount_cost
   IS
      CURSOR c_group_discount
      IS
      SELECT distinct s.course_no, c.description
        FROM section s, enrollment e, course c
       WHERE s.section_id = e.section_id
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
          ('A 5% discount has been given to'
          ||r_group_discount.course_no||'  
         '||r_group_discount.description);
      END LOOP;
     END discount_cost;
    FUNCTION new_instructor_id
       RETURN instructor.instructor_id%TYPE
    IS
       v_new_instid instructor.instructor_id%TYPE;
    BEGIN
       SELECT INSTRUCTOR_ID_SEQ.NEXTVAL 
         INTO v_new_instid
         FROM dual;
       RETURN v_new_instid;
    EXCEPTION
       WHEN OTHERS
        THEN
         DECLARE
            v_sqlerrm VARCHAR2(250) :=   
                SUBSTR(SQLERRM,1,250);
         BEGIN
           RAISE_APPLICATION_ERROR(-20003,
           'Error in    instructor_id: '||v_sqlerrm);
         END;
    END new_instructor_id;
  FUNCTION total_cost_for_student
     (i_student_id IN student.student_id%TYPE)
      RETURN course.cost%TYPE
  IS
     v_cost course.cost%TYPE;
  BEGIN
     SELECT sum(cost)
       INTO v_cost
       FROM course c, section s, enrollment e
      WHERE c.course_no = s.course_no
        AND e.section_id = s.section_id
        AND e.student_id = i_student_id;
     RETURN v_cost;
  EXCEPTION
     WHEN OTHERS THEN
        RETURN NULL;
  END total_cost_for_student;

 PROCEDURE get_student_info
   (i_student_id   IN  student.student_id%TYPE,
    o_last_name    OUT student.last_name%TYPE,
    o_first_name   OUT student.first_name%TYPE,
    o_zip          OUT student.zip%TYPE,
    o_return_code  OUT NUMBER)
  IS
  BEGIN
    SELECT last_name, first_name, zip
      INTO o_last_name, o_first_name, o_zip
      FROM student
     WHERE student.student_id = i_student_id;
    o_return_code := 0;
  EXCEPTION
     WHEN NO_DATA_FOUND
     THEN
        DBMS_OUTPUT.PUT_LINE 
           ('Student ID is not valid.');
        o_return_code := -100;
        o_last_name := NULL;
        o_first_name := NULL;
        o_zip   := NULL;
    WHEN OTHERS
      THEN
        DBMS_OUTPUT.PUT_LINE
             ('Error in procedure get_student_info');
  END get_student_info;
  PROCEDURE get_student_info
    (i_last_name   IN student.last_name%TYPE,
     i_first_name  IN student.first_name%TYPE,
     o_student_id  OUT student.student_id%TYPE,
     o_zip         OUT student.zip%TYPE,
     o_return_code OUT NUMBER)
  IS
  BEGIN
    SELECT student_id, zip
      INTO o_student_id, o_zip
      FROM student
      WHERE UPPER(last_name)  = UPPER(i_last_name)
      AND UPPER(first_name) = UPPER(i_first_name);
    o_return_code := 0;
  EXCEPTION
    WHEN NO_DATA_FOUND
      THEN
        DBMS_OUTPUT.PUT_LINE 
           ('Student name is not valid.');
        o_return_code := -100;
        o_student_id := NULL;
        o_zip   := NULL;
    WHEN OTHERS
      THEN
        DBMS_OUTPUT.PUT_LINE
             ('Error in procedure get_student_info');
  END get_student_info;
   BEGIN
     SELECT TRUNC(sysdate, 'DD')
       INTO v_current_date
       FROM dual;
END school_api; 


--  The following PL/SQL block shows how this overloaded function can be used
DECLARE
   v_student_ID  student.student_id%TYPE;
   v_last_name   student.last_name%TYPE;
   v_first_name  student.first_name%TYPE;
   v_zip         student.zip%TYPE;
   v_return_code NUMBER;
BEGIN
   school_api.get_student_info
      (&&p_id, v_last_name, v_first_name,
       v_zip,v_return_code);
   IF v_return_code = 0
   THEN
     DBMS_OUTPUT.PUT_LINE
         ('Student with ID '||&&p_id||' is '||v_first_name
        ||' '||v_last_name
        );
   ELSE
   DBMS_OUTPUT.PUT_LINE
      ('The ID '||&&p_id||'is not in the database'
       );
   END IF;  
   school_api.get_student_info
      (&&p_last_name , &&p_first_name, v_student_id,
       v_zip , v_return_code);
   IF v_return_code = 0
   THEN
      DBMS_OUTPUT.PUT_LINE
        (&&p_first_name||' '|| &&p_last_name||
         ' has an ID of '||v_student_id        );
   ELSE
   DBMS_OUTPUT.PUT_LINE
     (&&p_first_name||' '|| &&p_last_name||
      'is not in the database'
      );
   END IF;  
