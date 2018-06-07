-- *** Chapter Exercises *** --
-- ***


-- For Example ch21_1.sql 
  1  CREATE OR REPLACE PACKAGE manage_students
  2  AS
  3    PROCEDURE find_sname
  4      (i_student_id IN student.student_id%TYPE,
  5       o_first_name OUT student.first_name%TYPE,
  6       o_last_name OUT student.last_name%TYPE
  7      );
  8    FUNCTION id_is_good
  9      (i_student_id IN student.student_id%TYPE)
 10      RETURN BOOLEAN;
 11  END manage_students;

-- For Example ch21_2.sql 
SET SERVEROUTPUT ON
DECLARE
   v_first_name student.first_name%TYPE;
   v_last_name student.last_name%TYPE;
BEGIN
   manage_students.find_sname
      (125, v_first_name, v_last_name);
   DBMS_OUTPUT.PUT_LINE(v_first_name||' '||v_last_name);
END;


-- For Example ch21_4.sql 
 1  CREATE OR REPLACE PACKAGE BODY manage_students
 2  AS
 3    PROCEDURE find_sname
 4      (i_student_id IN student.student_id%TYPE,
 5       o_first_name OUT student.first_name%TYPE,
 6       o_last_name OUT student.last_name%TYPE
 7       )
 8    IS
 9     v_student_id  student.student_id%TYPE;
10     BEGIN
11        SELECT first_name, last_name
12          INTO o_first_name, o_last_name
13          FROM student
14         WHERE student_id = i_student_id;
15      EXCEPTION
16        WHEN OTHERS
17        THEN
18          DBMS_OUTPUT.PUT_LINE
19      ('Error in finding student_id: '||v_student_id);
20      END find_sname;
21      FUNCTION id_is_good
22        (i_student_id IN student.student_id%TYPE)
23        RETURN BOOLEAN
24      IS
25        v_id_cnt number;
26      BEGIN
27        SELECT COUNT(*)
28          INTO v_id_cnt
29          FROM student
30         WHERE student_id = i_student_id;
31        RETURN 1 = v_id_cnt;
32      EXCEPTION
33      WHEN OTHERS
34      THEN
35        RETURN FALSE;
36      END id_is_good;
37    END manage_students;


-- For Example ch21_5.sql 
 1 CREATE OR REPLACE PACKAGE BODY school_api AS
 2    PROCEDURE discount_cost
 3    IS
 4       CURSOR c_group_discount
 5       IS
 6       SELECT distinct s.course_no, c.description
 7         FROM section s, enrollment e, course c
 8        WHERE s.section_id = e.section_id
 9       GROUP BY s.course_no, c.description,
10                e.section_id, s.section_id
11       HAVING COUNT(*) >=8;
12    BEGIN
14       FOR r_group_discount IN c_group_discount
14       LOOP
15       UPDATE course
16          SET cost = cost * .95
17         WHERE course_no = r_group_discount.course_no;
18         DBMS_OUTPUT.PUT_LINE
19           ('A 5% discount has been given to'
20           ||r_group_discount.course_no||'  
21          '||r_group_discount.description);
22       END LOOP;
23      END discount_cost;
24     FUNCTION new_instructor_id
25        RETURN instructor.instructor_id%TYPE
26     IS
27        v_new_instid instructor.instructor_id%TYPE;
28     BEGIN
29        SELECT INSTRUCTOR_ID_SEQ.NEXTVAL 
30          INTO v_new_instid
31          FROM dual;
32        RETURN v_new_instid;
33     EXCEPTION
34        WHEN OTHERS
35         THEN
36          DECLARE
37             v_sqlerrm VARCHAR2(250) :=   
                   SUBSTR(SQLERRM,1,250);
38          BEGIN
39            RAISE_APPLICATION_ERROR(-20003,
40            'Error in    instructor_id: '||v_sqlerrm);
41          END;
42     END new_instructor_id;
43   END school_api; 


-- For Example ch21_6.sql 
SET SERVEROUTPUT ON
DECLARE
  v_first_name student.first_name%TYPE;
  v_last_name student.last_name%TYPE;
BEGIN
  IF manage_students.id_is_good(&&v_id)
  THEN
    manage_students.find_sname(&&v_id, v_first_name,
       v_last_name);
  DBMS_OUTPUT.PUT_LINE('Student No. '||&&v_id||' is '
      ||v_last_name||', '||v_first_name);
ELSE
   DBMS_OUTPUT.PUT_LINE
   ('Student ID: '||&&v_id||' is not in the database.');
END IF;
END;
  This is a correct PL/SQL block for running the function and the procedure in the package manage_students. If an existing student_id is entered, then the name of the student is displayed. If the id is not valid, then the error message is displayed. The following example shows the result when 145 is entered for the variable v_id in Oracle SQL Developer. The script output will show the original script and then the script once all variables have been replaced with the number entered (in this case 145), the final one line in bold is the result.
old:DECLARE
  v_first_name student.first_name%TYPE;
  v_last_name student.last_name%TYPE;
BEGIN
  IF manage_students.id_is_good(&&v_id)
  THEN
    manage_students.find_sname(&&v_id, v_first_name,
       v_last_name);
  DBMS_OUTPUT.PUT_LINE('Student No. '||&&v_id||' is '
      ||v_last_name||', '||v_first_name);
ELSE
   DBMS_OUTPUT.PUT_LINE
   ('Student ID: '||&&v_id||' is not in the database.');
END IF;
END;
new:DECLARE
  v_first_name student.first_name%TYPE;
  v_last_name student.last_name%TYPE;
BEGIN
  IF manage_students.id_is_good(145)
  THEN
    manage_students.find_sname(145, v_first_name,
       v_last_name);
  DBMS_OUTPUT.PUT_LINE('Student No. '||145||' is '
      ||v_last_name||', '||v_first_name);
ELSE
   DBMS_OUTPUT.PUT_LINE
   ('Student ID: '||145||' is not in the database.');
END IF;
END;


-- For Example ch21_7.sql 
SET SERVEROUTPUT ON
DECLARE
   V_instructor_id instructor.instructor_id%TYPE;
BEGIN
   School_api.Discount_Cost;
   v_instructor_id := school_api.new_instructor_id;
   DBMS_OUTPUT.PUT_LINE
      ('The new id is: '||v_instructor_id);
END;


-- For Example ch21_8.sql 
CREATE OR REPLACE PACKAGE manage_students
AS
   PROCEDURE find_sname
     (i_student_id IN student.student_id%TYPE,
      o_first_name OUT student.first_name%TYPE,
      o_last_name OUT student.last_name%TYPE
     );
   FUNCTION id_is_good
     (i_student_id IN student.student_id%TYPE)
     RETURN BOOLEAN;
  PROCEDURE display_student_count;
END manage_students;
  The Package body for Manage_Students is now:
For Example?ch21_9.sql 
CREATE OR REPLACE PACKAGE BODY manage_students
AS
  PROCEDURE find_sname
    (i_student_id IN student.student_id%TYPE,
     o_first_name OUT student.first_name%TYPE,
     o_last_name OUT student.last_name%TYPE
     )
  IS
   v_student_id  student.student_id%TYPE;
   BEGIN
      SELECT first_name, last_name
        INTO o_first_name, o_last_name
        FROM student
       WHERE student_id = i_student_id;
    EXCEPTION
      WHEN OTHERS
      THEN
        DBMS_OUTPUT.PUT_LINE
    ('Error in finding student_id: '||v_student_id);
    END find_sname;
    FUNCTION id_is_good
      (i_student_id IN student.student_id%TYPE)
      RETURN BOOLEAN
    IS
      v_id_cnt number;
    BEGIN
      SELECT COUNT(*)
        INTO v_id_cnt
        FROM student
       WHERE student_id = i_student_id;
      RETURN 1 = v_id_cnt;
    EXCEPTION
    WHEN OTHERS
    THEN
      RETURN FALSE;
    END id_is_good;
FUNCTION student_count_priv
  RETURN NUMBER
 IS
  v_count NUMBER;
 BEGIN
  select count(*)
  into v_count
  from student;
  return v_count;
 EXCEPTION
  WHEN OTHERS
    THEN
    return(0);
 END student_count_priv;
 PROCEDURE display_student_count
  is
  v_count NUMBER;
 BEGIN
  v_count := student_count_priv;
  DBMS_OUTPUT.PUT_LINE
     ('There are '||v_count||' students.');
 END display_student_count;
 FUNCTION get_course_descript_private
    (i_course_no  course.course_no%TYPE)
    RETURN course.description%TYPE
  IS
     v_course_descript course.description%TYPE;
  BEGIN
     SELECT description
       INTO v_course_descript
       FROM course
      WHERE course_no = i_course_no;
     RETURN v_course_descript;
  EXCEPTION
     WHEN OTHERS
     THEN
        RETURN NULL;
  END get_course_descript_private;
END manage_students;


-- For Example ch21_10.sql 
CREATE OR REPLACE PACKAGE course_pkg AS
  TYPE course_rec_typ IS RECORD
    (first_name    student.first_name%TYPE,
     last_name     student.last_name%TYPE,
     course_no     course.course_no%TYPE,
     description   course.description%TYPE,
     section_no    section.section_no%TYPE
     );
  TYPE course_cur IS REF CURSOR RETURN course_rec_typ;
  PROCEDURE get_course_list
    (p_student_id    NUMBER ,
     p_instructor_id NUMBER ,
     course_list_cv IN OUT course_cur);
END course_pkg;
/

CREATE OR REPLACE PACKAGE BODY course_pkg AS
  PROCEDURE get_course_list
    (p_student_id    NUMBER ,
     p_instructor_id NUMBER ,
     course_list_cv IN OUT course_cur)
  IS
  BEGIN
    IF p_student_id IS NULL AND p_instructor_id 
      IS NULL THEN 
      OPEN course_list_cv FOR
        SELECT 'Please choose a student-' First_name,
               'instructor combination'   Last_name,
          NULL     course_no,
          NULL     description,
          NULL     section_no
          FROM dual;
    ELSIF p_student_id IS NULL  THEN 
      OPEN course_list_cv FOR
        SELECT s.first_name    first_name,
          s.last_name     last_name,
          c.course_no     course_no,
          c.description   description,
          se.section_no   section_no
   FROM   instructor i, student s, 
          section se, course c, enrollment e
   WHERE  i.instructor_id = p_instructor_id
     AND  i.instructor_id = se.instructor_id
     AND  se.course_no    = c.course_no
     AND  e.student_id    = s.student_id
     AND  e.section_id    = se.section_id
     ORDER BY  c.course_no, se.section_no;
    ELSIF p_instructor_id IS NULL  THEN 
      OPEN course_list_cv FOR
           SELECT i.first_name    first_name,
          i.last_name     last_name,
          c.course_no     course_no,
          c.description   description,
          se.section_no   section_no
   FROM   instructor i, student s, 
          section se, course c, enrollment e
   WHERE  s.student_id = p_student_id
     AND  i.instructor_id = se.instructor_id
     AND  se.course_no    = c.course_no
     AND  e.student_id    = s.student_id
     AND  e.section_id    = se.section_id
        ORDER BY  c.course_no, se.section_no;
        END IF; 
     END get_course_list; 
END course_pkg;
 

-- For Example ch21_11.sql 
CREATE OR REPLACE PACKAGE student_info_pkg AS
  TYPE student_details IS REF CURSOR;
  PROCEDURE get_student_info
    (p_student_id    NUMBER ,
     p_choice        NUMBER ,
     details_cv IN OUT student_details);
END student_info_pkg;
/
CREATE OR REPLACE PACKAGE BODY student_info_pkg AS
  PROCEDURE get_student_info
    (p_student_id    NUMBER ,
     p_choice        NUMBER ,
     details_cv IN OUT student_details)
  IS
  BEGIN
    IF p_choice = 1  THEN 
      OPEN details_cv FOR
        SELECT s.first_name     first_name,
               s.last_name      last_name,
               s.street_address address,
               z.city           city,
               z.state          state,
               z.zip            zip
         FROM  student s, zipcode z 
        WHERE  s.student_id = p_student_id
          AND  z.zip = s.zip;
    ELSIF p_choice = 2 THEN 
      OPEN details_cv  FOR
        SELECT c.course_no     course_no,
               c.description   description,
               se.section_no   section_no,
               s.first_name    first_name,
               s.last_name     last_name
        FROM   student s,  section se, 
               course c, enrollment e
        WHERE  se.course_no    = c.course_no
          AND  e.student_id    = s.student_id
          AND  e.section_id    = se.section_id
          AND  se.section_id in (SELECT e.section_id
                                   FROM student s,
                                        enrollment e
                                  WHERE s.student_id = 
                                        p_student_id
                                    AND  s.student_id = 
                                         e.student_id)
     ORDER BY  c.course_no;
    ELSIF p_choice = 3 THEN 
      OPEN details_cv FOR
        SELECT i.first_name    first_name,
               i.last_name     last_name,
               c.course_no     course_no,
               c.description   description,
               se.section_no   section_no
        FROM   instructor i, student s, 
               section se, course c, enrollment e
        WHERE  s.student_id = p_student_id
          AND  i.instructor_id = se.instructor_id
          AND  se.course_no    = c.course_no
          AND  e.student_id    = s.student_id
          AND  e.section_id    = se.section_id
     ORDER BY  c.course_no, se.section_no;
    END IF; 
  END get_student_info;
    


-- For Example ch21_12.sql 
      SELECT GRADE_TYPE_CODE, 
              NUMBER_PER_SECTION,
              PERCENT_OF_FINAL_GRADE,
              DROP_LOWEST
        FROM  grade_Type_weight
       WHERE  section_id = 106
         AND  section_id IN (SELECT section_id
                              FROM grade 
                             WHERE student_id = 145) 


-- For Example?ch21_13.sql 
CREATE OR REPLACE PACKAGE MANAGE_GRADES AS
--  Cursor to loop through all grade types for a given section
      CURSOR  c_grade_type
              (pc_section_id  section.section_id%TYPE,
               PC_student_ID  student.student_id%TYPE)
              IS
       SELECT GRADE_TYPE_CODE,
              NUMBER_PER_SECTION,
              PERCENT_OF_FINAL_GRADE,
              DROP_LOWEST
        FROM  grade_Type_weight
       WHERE  section_id = pc_section_id
         AND section_id IN (SELECT section_id
                              FROM grade 
                             WHERE student_id = pc_student_id);
END MANAGE_GRADES; 


-- For Example ch21_14.sql 
CREATE OR REPLACE PACKAGE MANAGE_GRADES AS
  -- Cursor to loop through all grade types for a given section.
      CURSOR  c_grade_type
              (pc_section_id  section.section_id%TYPE,
               PC_student_ID  student.student_id%TYPE)
              IS
       SELECT GRADE_TYPE_CODE,
              NUMBER_PER_SECTION,
              PERCENT_OF_FINAL_GRADE,
              DROP_LOWEST
        FROM  grade_Type_weight
       WHERE  section_id = pc_section_id
         AND section_id IN (SELECT section_id
                              FROM grade 
                             WHERE student_id = pc_student_id);
    -- Cursor to loop through all grades for a given student
    -- in a given section.
     CURSOR  c_grades
              (p_grade_type_code
                   grade_Type_weight.grade_type_code%TYPE,
               pc_student_id  student.student_id%TYPE,
               pc_section_id  section.section_id%TYPE) IS
       SELECT grade_type_code,grade_code_occurrence,
              numeric_grade
       FROM   grade
       WHERE  student_id = pc_student_id
       AND    section_id = pc_section_id
       AND    grade_type_code = p_grade_type_code;
END MANAGE_GRADES; 


-- For Example ch21_15.sql 
CREATE OR REPLACE PACKAGE MANAGE_GRADES AS
  -- Cursor to loop through all grade types for a given section.
      CURSOR  c_grade_type
              (pc_section_id  section.section_id%TYPE,
               PC_student_ID  student.student_id%TYPE)
              IS
       SELECT GRADE_TYPE_CODE,
              NUMBER_PER_SECTION,
              PERCENT_OF_FINAL_GRADE,
              DROP_LOWEST
        FROM  grade_Type_weight
       WHERE  section_id = pc_section_id
         AND section_id IN (SELECT section_id
                              FROM grade 
                             WHERE student_id = pc_student_id);
    -- Cursor to loop through all grades for a given student
    -- in a given section.
     CURSOR  c_grades
              (p_grade_type_code
                   grade_Type_weight.grade_type_code%TYPE,
               pc_student_id  student.student_id%TYPE,
               pc_section_id  section.section_id%TYPE) IS
       SELECT grade_type_code,grade_code_occurrence,
              numeric_grade
       FROM   grade
       WHERE  student_id = pc_student_id
       AND    section_id = pc_section_id
       AND    grade_type_code = p_grade_type_code;
  -- Function to calcuation a students final grade
  -- in one section
     Procedure final_grade
       (P_student_id   IN student.student_id%type,
        P_section_id   IN section.section_id%TYPE,
        P_Final_grade  OUT enrollment.final_grade%TYPE,
        P_Exit_Code    OUT CHAR);
END MANAGE_GRADES; 
  

-- For Example ch21_16.sql 
CREATE OR REPLACE PACKAGE BODY MANAGE_GRADES AS
     Procedure final_grade
       (P_student_id   IN student.student_id%type,
        P_section_id   IN section.section_id%TYPE,
        P_Final_grade  OUT enrollment.final_grade%TYPE,
        P_Exit_Code    OUT CHAR)
IS
      v_student_id             student.student_id%TYPE;
      v_section_id             section.section_id%TYPE;
      v_grade_type_code        grade_type_weight.grade_type_code%TYPE;
      v_grade_percent          NUMBER;
      v_final_grade            NUMBER;
      v_grade_count            NUMBER;
      v_lowest_grade           NUMBER;
      v_exit_code              CHAR(1) := 'S';
      v_no_rows1               CHAR(1) := 'N';
      v_no_rows2               CHAR(1) := 'N';
      e_no_grade               EXCEPTION;
BEGIN
      NULL;
END;
END MANAGE_GRADES; 


-- For Example ch21_17.sql 
CREATE OR REPLACE PACKAGE BODY MANAGE_GRADES AS
     Procedure final_grade
       (P_student_id   IN student.student_id%type,
        P_section_id   IN section.section_id%TYPE,
        P_Final_grade  OUT enrollment.final_grade%TYPE,
        P_Exit_Code    OUT CHAR)
IS
      v_student_id             student.student_id%TYPE;
      v_section_id             section.section_id%TYPE;
      v_grade_type_code        grade_type_weight.grade_type_code%TYPE;
      v_grade_percent          NUMBER;
      v_final_grade            NUMBER;
      v_grade_count            NUMBER;
      v_lowest_grade           NUMBER;
      v_exit_code              CHAR(1) := 'S';
      v_no_rows1               CHAR(1) := 'N';
      v_no_rows2               CHAR(1) := 'N';
      e_no_grade               EXCEPTION;
BEGIN
    v_section_id := p_section_id;
    v_student_id := p_student_id;
    -- Start loop of grade types for the section.
       FOR r_grade in c_grade_type(v_section_id, v_student_id)
       LOOP
    -- Since cursor is open it has a result
    -- set, change indicator.
           v_no_rows1 := 'Y';
    -- To hold the number of grades per section,
    -- reset to 0 before detailed cursor loops
           v_grade_count := 0;
           v_grade_type_code := r_grade.GRADE_TYPE_CODE;
    -- Variable to hold the lowest grade.
    -- 500 will not be the lowest grade.
           v_lowest_grade := 500;
    -- Determine what to multiply a grade by to
    -- compute final grade, must take into consideration
    -- if the drop lowest grade indicator is Y
           SELECT (r_grade.percent_of_final_grade /
                   DECODE(r_grade.drop_lowest, 'Y',
                                (r_grade.number_per_section - 1),
                                 r_grade.number_per_section
                         ))* 0.01
            INTO  v_grade_percent
            FROM dual;
    -- Open cursor of detailed grade for a student in a
    -- given section.
           FOR r_detail in c_grades(v_grade_type_code,
                             v_student_id, v_section_id) LOOP
        -- Since cursor is open it has a result
        -- set, change indicator.
               v_no_rows2 := 'Y';
               v_grade_count  := v_grade_count + 1;
        -- Handle the situation where there are more
        -- entries for grades of a given grade type
        -- than there should be for that section.
               If v_grade_count > r_grade.number_per_section THEN
                  v_exit_code := 'T';
                  raise e_no_grade;
               END IF;
        -- If drop lowest flag is Y determine which is lowest
       -- grade to drop
               IF  r_grade.drop_lowest = 'Y' THEN
                    IF nvl(v_lowest_grade, 0) >=
                           r_detail.numeric_grade
                 THEN
                        v_lowest_grade := r_detail.numeric_grade;
                    END IF;
               END IF;
        -- Increment the final grade with percentage of current
        -- grade in the detail loop.
               v_final_grade := nvl(v_final_grade, 0) +
                      (r_detail.numeric_grade * v_grade_percent);
          END LOOP;
       -- Once detailed loop is finished, if the number of grades
       -- for a given student for a given grade type and section
       -- is less than the required amount, raise an exception.
              IF  v_grade_count < r_grade.NUMBER_PER_SECTION THEN
                  v_exit_code := 'I';
                  raise e_no_grade;
              END IF;
       -- If the drop lowest flag was Y then you need to take
       -- the lowest grade out of the final grade, it was not
       -- known when it was added which was the lowest grade
       -- to drop until all grades were examined.
              IF  r_grade.drop_lowest = 'Y' THEN
                  v_final_grade := nvl(v_final_grade, 0) -
                            (v_lowest_grade *  v_grade_percent);
              END IF;
      END LOOP;
   -- If either cursor had no rows then there is an error.
   IF v_no_rows1 = 'N' OR v_no_rows2 = 'N'   THEN
       v_exit_code := 'N';
       raise e_no_grade;
   END IF;
   P_final_grade  := v_final_grade;
   P_exit_code    := v_exit_code;
   EXCEPTION
     WHEN e_no_grade THEN
       P_final_grade := null;
       P_exit_code   := v_exit_code;
     WHEN OTHERS THEN
       P_final_grade := null;
       P_exit_code   := 'E';
 END final_grade;
END MANAGE_GRADES; 


-- For Example ch21_18.sql 
SET SERVEROUTPUT ON

DECLARE 
 v_student_id   student.student_id%TYPE := &sv_student_id;
 v_section_id   section.section_id%TYPE := &sv_section_id;
 v_final_grade  enrollment.final_grade%TYPE;
 v_exit_code    CHAR;
BEGIN
  manage_grades.final_grade(v_student_id, v_section_id,
     v_final_grade, v_exit_code);
  DBMS_OUTPUT.PUT_LINE('The Final Grade is '||v_final_grade);
  DBMS_OUTPUT.PUT_LINE('The Exit Code is '||v_exit_code);
END; 


-- For Example ch21_19.sql 
CREATE OR REPLACE PACKAGE MANAGE_GRADES AS
  -- Cursor to loop through all grade types for a given section.
      CURSOR  c_grade_type
              (pc_section_id  section.section_id%TYPE,
               PC_student_ID  student.student_id%TYPE)
              IS
       SELECT GRADE_TYPE_CODE,
              NUMBER_PER_SECTION,
              PERCENT_OF_FINAL_GRADE,
              DROP_LOWEST
        FROM  grade_Type_weight
       WHERE  section_id = pc_section_id
         AND section_id IN (SELECT section_id
                              FROM grade 
                             WHERE student_id = pc_student_id);
    -- Cursor to loop through all grades for a given student
    -- in a given section.
     CURSOR  c_grades
              (p_grade_type_code
                   grade_Type_weight.grade_type_code%TYPE,
               pc_student_id  student.student_id%TYPE,
               pc_section_id  section.section_id%TYPE) IS
       SELECT grade_type_code,grade_code_occurrence,
              numeric_grade
       FROM   grade
       WHERE  student_id = pc_student_id
       AND    section_id = pc_section_id
       AND    grade_type_code = p_grade_type_code;
  -- Function to calcuation a students final grade
  -- in one section
     Procedure final_grade
       (P_student_id   IN student.student_id%type,
        P_section_id   IN section.section_id%TYPE,
        P_Final_grade  OUT enrollment.final_grade%TYPE,
        P_Exit_Code    OUT CHAR);
    -- ---------------------------------------------------------
    -- Function to calculate the median grade 
      FUNCTION median_grade
         (p_course_number section.course_no%TYPE,
          p_section_number section.section_no%TYPE,
          p_grade_type grade.grade_type_code%TYPE)
        RETURN grade.numeric_grade%TYPE;
    CURSOR c_work_grade 
           (p_course_no  section.course_no%TYPE,
            p_section_no section.section_no%TYPE,
            p_grade_type_code grade.grade_type_code%TYPE
            )IS
      SELECT distinct numeric_grade
        FROM grade
       WHERE section_id = (SELECT section_id
                             FROM section
                            WHERE course_no= p_course_no
                              AND section_no = p_section_no)
         AND grade_type_code = p_grade_type_code
      ORDER BY numeric_grade;      
    TYPE t_grade_type IS TABLE OF c_work_grade%ROWTYPE
      INDEX BY BINARY_INTEGER;
    t_grade t_grade_type;              
END MANAGE_GRADES; 


-- For Example ch21_20.sql 
CREATE OR REPLACE PACKAGE MANAGE_GRADES AS
CREATE OR REPLACE PACKAGE BODY MANAGE_GRADES AS
     Procedure final_grade
       (P_student_id   IN student.student_id%type,
        P_section_id   IN section.section_id%TYPE,
        P_Final_grade  OUT enrollment.final_grade%TYPE,
        P_Exit_Code    OUT CHAR)
IS
      v_student_id             student.student_id%TYPE;
      v_section_id             section.section_id%TYPE;
      v_grade_type_code        grade_type_weight.grade_type_code%TYPE;
      v_grade_percent          NUMBER;
      v_final_grade            NUMBER;
      v_grade_count            NUMBER;
      v_lowest_grade           NUMBER;
      v_exit_code              CHAR(1) := 'S';
    --  Next two variables are used to calculate whether a cursor
    --  has no result set.
      v_no_rows1               CHAR(1) := 'N';
      v_no_rows2               CHAR(1) := 'N';
      e_no_grade               EXCEPTION;
BEGIN
    v_section_id := p_section_id;
    v_student_id := p_student_id;
    -- Start loop of grade types for the section.
       FOR r_grade in c_grade_type(v_section_id, v_student_id)
       LOOP
    -- Since cursor is open it has a result
    -- set, change indicator.
           v_no_rows1 := 'Y';
    -- To hold the number of grades per section,
    -- reset to 0 before detailed cursor loops
           v_grade_count := 0;
           v_grade_type_code := r_grade.GRADE_TYPE_CODE;
    -- Variable to hold the lowest grade.
    -- 500 will not be the lowest grade.
           v_lowest_grade := 500;
    -- Determine what to multiply a grade by to
    -- compute final grade, must take into consideration
    -- if the drop lowest grade indicator is Y
           SELECT (r_grade.percent_of_final_grade /
                   DECODE(r_grade.drop_lowest, 'Y',
                                (r_grade.number_per_section - 1),
                                 r_grade.number_per_section
                         ))* 0.01
            INTO  v_grade_percent
            FROM dual;
    -- Open cursor of detailed grade for a student in a
    -- given section.
           FOR r_detail in c_grades(v_grade_type_code,
                             v_student_id, v_section_id) LOOP
        -- Since cursor is open it has a result
        -- set, change indicator.
               v_no_rows2 := 'Y';
               v_grade_count  := v_grade_count + 1;
        -- Handle the situation where there are more
        -- entries for grades of a given grade type
        -- than there should be for that section.
               If v_grade_count > r_grade.number_per_section THEN
                  v_exit_code := 'T';
                  raise e_no_grade;
               END IF;
        -- If drop lowest flag is Y determine which is lowest
       -- grade to drop
               IF  r_grade.drop_lowest = 'Y' THEN
                    IF nvl(v_lowest_grade, 0) >=
                           r_detail.numeric_grade
                 THEN
                        v_lowest_grade := r_detail.numeric_grade;
                    END IF;
               END IF;
        -- Increment the final grade with percentage of current
        -- grade in the detail loop.
               v_final_grade := nvl(v_final_grade, 0) +
                      (r_detail.numeric_grade * v_grade_percent);
          END LOOP;
       -- Once detailed loop is finished, if the number of grades
       -- for a given student for a given grade type and section
       -- is less than the required amount, raise an exception.
              IF  v_grade_count < r_grade.NUMBER_PER_SECTION THEN
                  v_exit_code := 'I';
                  raise e_no_grade;
              END IF;
       -- If the drop lowest flag was Y then you need to take
       -- the lowest grade out of the final grade, it was not
       -- known when it was added which was the lowest grade
       -- to drop until all grades were examined.
              IF  r_grade.drop_lowest = 'Y' THEN
                  v_final_grade := nvl(v_final_grade, 0) -
                            (v_lowest_grade *  v_grade_percent);
              END IF;
      END LOOP;
   -- If either cursor had no rows then there is an error.
   IF v_no_rows1 = 'N' OR v_no_rows2 = 'N'   THEN
       v_exit_code := 'N';
       raise e_no_grade;
   END IF;
   P_final_grade  := v_final_grade;
   P_exit_code    := v_exit_code;
   EXCEPTION
     WHEN e_no_grade THEN
       P_final_grade := null;
       P_exit_code   := v_exit_code;
     WHEN OTHERS THEN
       P_final_grade := null;
       P_exit_code   := 'E';
 END final_grade;

FUNCTION median_grade
  (p_course_number section.course_no%TYPE,
  p_section_number section.section_no%TYPE,
  p_grade_type grade.grade_type_code%TYPE)
RETURN grade.numeric_grade%TYPE
  IS
  BEGIN
    FOR r_work_grade 
       IN c_work_grade(p_course_number, p_section_number, p_grade_type) 
    LOOP
      t_grade(NVL(t_grade.COUNT,0) + 1).numeric_grade := r_work_grade.numeric_grade;
    END LOOP;
    IF t_grade.COUNT = 0
    THEN
      RETURN NULL;
    ELSE
      IF MOD(t_grade.COUNT, 2) = 0
      THEN
        -- There is an even number of workgrades. Find the middle
        --   two and average them.
        RETURN (t_grade(t_grade.COUNT / 2).numeric_grade +
                t_grade((t_grade.COUNT / 2) + 1).numeric_grade
               ) / 2;
      ELSE
        -- There is an odd number of grades. Return the one in the middle.
        RETURN t_grade(TRUNC(t_grade.COUNT / 2, 0) + 1).numeric_grade;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS
    THEN
      RETURN NULL;
  END median_grade;
END MANAGE_GRADES; 


-- For Example ch21_21.sql 
SELECT COURSE_NO,
       COURSE_NAME,
       SECTION_NO,
       GRADE_TYPE,
       manage_grades.median_grade
               (COURSE_NO,
                SECTION_NO,
                GRADE_TYPE)
            median_grade
FROM
(SELECT DISTINCT 
       C.COURSE_NO        COURSE_NO,
       C.DESCRIPTION      COURSE_NAME,
       S.SECTION_NO       SECTION_NO,
       G.GRADE_TYPE_CODE  GRADE_TYPE
FROM SECTION S, COURSE C, ENROLLMENT E, GRADE G
WHERE C.course_no = s.course_no
AND   s.section_id = e.section_id
AND   e.student_id = g.student_id
AND   c.course_no = 25
AND   s.section_no between 1 and 2
ORDER BY 1, 4, 3) grade_source
 

-- For Example ch21_22.sql 
CREATE OR REPLACE PACKAGE  school_api as
   v_current_date DATE; 
   PROCEDURE Discount_Cost;
   FUNCTION new_instructor_id
      RETURN instructor.instructor_id%TYPE;
END school_api;


-- For Example ch21_23.sql 
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
BEGIN
  SELECT trunc(sysdate, 'DD')
    INTO v_current_date
    FROM dual;
END school_api; 


-- For Example ch21_24.sql 
CREATE OR REPLACE PACKAGE show_date
IS
   PRAGMA SERIALLY_REUSABLE;
   the_date DATE := SYSDATE + 4;
   PROCEDURE display_DATE;
   PROCEDURE set_date;
END show_date;
/
CREATE OR REPLACE PACKAGE BODY show_date
IS
   PRAGMA SERIALLY_REUSABLE;
   PROCEDURE display_DATE IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('The date is  ' || show_date.the_date);
   END;
   -- Initialize package state
   PROCEDURE set_date IS
   BEGIN
      show_date.the_date := sysdate;
   END;
END show_date; 


-- For Example ch21_25.sql 
begin
        -- initialize and print the package variable
        show_date.display_DATE;
        -- change the value of the variable the_date
        show_date.set_date;
        -- Display the new value of variable the_date 
        show_date.display_DATE;
        end;
/
begin
        show_date.display_DATE;
end; 
/
