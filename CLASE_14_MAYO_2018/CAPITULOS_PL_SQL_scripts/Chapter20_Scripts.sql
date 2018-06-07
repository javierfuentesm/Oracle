-- *** Chapter Exercises *** --
-- ***
-- For Example ch20_2.sql 
CREATE OR REPLACE FUNCTION id_is_good
  (i_student_id IN NUMBER)
  RETURN BOOLEAN
AS
  v_id_cnt NUMBER;
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


-- For Example ch20_3.sql 
SET SERVEROUTPUT ON
DECLARE
  v_description VARCHAR2(50);
BEGIN
  v_description := show_description(&sv_cnumber);
  DBMS_OUTPUT.PUT_LINE(v_description);
END;


-- For Example ch20_4.sql 
DECLARE
   V_id number;
BEGIN
   V_id := &id; 
   IF id_is_good(v_id)
   THEN
      DBMS_OUTPUT.PUT_LINE
         ('Student ID: '||v_id||' is a valid.');
   ELSE
      DBMS_OUTPUT.PUT_LINE
         ('Student ID: '||v_id||' is not valid.');
   END IF;
END;


-- For Example ch20_5.sql 
CREATE OR REPLACE FUNCTION new_instructor_id
   RETURN instructor.instructor_id%TYPE
AS
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
         v_sqlerrm VARCHAR2(250) 
            := SUBSTR(SQLERRM,1,250);
      BEGIN
         RAISE_APPLICATION_ERROR(-20003,
              'Error in     instructor_id: '||v_sqlerrm);
    END;
END new_instructor_id; 


-- For Example ch20_6.sql
WITH
  FUNCTION show_descript
  (i_course_no course.course_no%TYPE)
RETURN varchar2
AS
  v_description varchar2(50);
BEGIN
  SELECT description
    INTO v_description
    FROM course
   WHERE course_no = i_course_no;
  RETURN v_description;
END;

SELECT course_no, show_descript(course_no), cost
FROM   COURSE


-- For Example?ch20_7.sql
CREATE OR REPLACE FUNCTION show_description
  (i_course_no course.course_no%TYPE)
RETURN varchar2
AS
  pragma UDF;
  v_description varchar2(50);
BEGIN
  SELECT description
    INTO v_description
    FROM course
   WHERE course_no = i_course_no;
  RETURN v_description;
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
    RETURN('The Course is not in the database');
  WHEN OTHERS
  THEN
    RETURN('Error in running show_description');
END;
