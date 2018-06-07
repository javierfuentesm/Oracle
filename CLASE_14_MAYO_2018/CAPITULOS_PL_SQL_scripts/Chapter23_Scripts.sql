-- *** Chapter Exercises *** --
-- For Example ch23_1a.sql
CREATE OR REPLACE TYPE zipcode_obj_type AS OBJECT
   (zip           VARCHAR2(5)
   ,city          VARCHAR2(25)
   ,state         VARCHAR2(2)
   ,created_by    VARCHAR2(30)
   ,created_date  DATE
   ,modified_by   VARCHAR2(30)
   ,modified_date DATE);
   
-- For Example ch23_2a.sql
DECLARE
   zip_obj zipcode_obj_type;
BEGIN
   SELECT zipcode_obj_type(zip, city, state, null, null, null, null)
     INTO zip_obj
     FROM zipcode
    WHERE zip = '06883';
   
   DBMS_OUTPUT.PUT_LINE ('Zip:   '||zip_obj.zip);
   DBMS_OUTPUT.PUT_LINE ('City:  '||zip_obj.city);
   DBMS_OUTPUT.PUT_LINE ('State: '||zip_obj.state);
END;

-- For Example ch23_3a.sql
DECLARE
   zip_obj zipcode_obj_type;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Object instance has not been initialized');

   IF zip_obj IS NULL 
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj instance is null');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('zip_obj instance is not null'); 
   END IF;

   IF zip_obj.zip IS NULL
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj.zip is null');
   END IF;

   -- Initialize zip_obj_instance
   zip_obj := zipcode_obj_type(null, null, null, null, null, null, null);
   
   DBMS_OUTPUT.PUT_LINE ('Object instance has been initialized');
   
   IF zip_obj IS NULL 
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj instance is null');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('zip_obj instance is not null'); 
   END IF;

   IF zip_obj.zip IS NULL
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj.zip is null');
   END IF;
END;

-- For Example ch23_4a.sql
DECLARE
   TYPE zip_type IS TABLE OF zipcode_obj_type INDEX BY PLS_INTEGER;
   zip_tab zip_type;
BEGIN
   SELECT zipcode_obj_type(zip, city, state, null, null, null, null)
     BULK COLLECT INTO zip_tab
     FROM zipcode
    WHERE rownum <= 5;
   
   IF zip_tab.COUNT > 0
   THEN
      FOR i in 1..zip_tab.count
      LOOP
         DBMS_OUTPUT.PUT_LINE ('Zip:   '||zip_tab(i).zip);
         DBMS_OUTPUT.PUT_LINE ('City:  '||zip_tab(i).city);
         DBMS_OUTPUT.PUT_LINE ('State: '||zip_tab(i).state);
         DBMS_OUTPUT.PUT_LINE ('-----------------------');
      END LOOP;
   ELSE
      DBMS_OUTPUT.PUT_LINE ('Collection of objects is empty');
   END IF;      
END; 

-- For Example ch23_5a.sql
CREATE OR REPLACE TYPE zip_tab_type AS TABLE OF zipcode_obj_type;
/
DECLARE
   zip_tab zip_tab_type := zip_tab_type();
   v_zip   VARCHAR2(5);
   v_city  VARCHAR2(20);
   v_state VARCHAR2(2);
BEGIN
   SELECT zipcode_obj_type(zip, city, state, null, null, null, null)
     BULK COLLECT INTO zip_tab
     FROM zipcode
    WHERE rownum <= 5;
   
   SELECT zip, city, state
     INTO v_zip, v_city, v_state
     FROM TABLE(zip_tab) 
    where rownum < 2;

   DBMS_OUTPUT.PUT_LINE ('Zip:   '||v_zip);
   DBMS_OUTPUT.PUT_LINE ('City:  '||v_city);
   DBMS_OUTPUT.PUT_LINE ('State: '||v_state);
END; 

-- For Example ch23_6a.sql
CREATE OR REPLACE TYPE city_tab_type AS TABLE OF VARCHAR2(25);
/
CREATE OR REPLACE TYPE zip_tab_type AS TABLE OF VARCHAR2(5);
/
CREATE OR REPLACE TYPE state_obj_type AS OBJECT
   (state VARCHAR2(2)
   ,city  city_tab_type 
   ,zip   zip_tab_type);
/

-- For Example ch23_7a.sql
DECLARE
   city_tab  city_tab_type;
   zip_tab   zip_tab_type;

   state_obj state_obj_type := state_obj_type(null, city_tab_type(), zip_tab_type());
   
BEGIN
   SELECT city, zip
     BULK COLLECT INTO city_tab, zip_tab
     FROM zipcode
    WHERE state = 'NY'
      AND rownum <= 5;
    
   state_obj := state_obj_type ('NY', city_tab, zip_tab);
   
   DBMS_OUTPUT.PUT_LINE ('State: '||state_obj.state);
   DBMS_OUTPUT.PUT_LINE ('------------------------');
   
   IF state_obj.city.COUNT > 0
   THEN
      FOR i in state_obj.city.FIRST..state_obj.city.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE ('City:  '||state_obj.city(i));
         DBMS_OUTPUT.PUT_LINE ('Zip:   '||state_obj.zip(i));
      END LOOP;
   END IF;      
END;

-- For Example ch23_8a.sql
CREATE OR REPLACE TYPE zipcode_obj_type AS OBJECT
   (zip           VARCHAR2(5)
   ,city          VARCHAR2(25)
   ,state         VARCHAR2(2)
   ,created_by    VARCHAR2(30)
   ,created_date  DATE
   ,modified_by   VARCHAR2(30)
   ,modified_date DATE

   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                          ,zip  VARCHAR2)
    RETURN SELF AS RESULT
    
   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                          ,zip   VARCHAR2
                                          ,city  VARCHAR2
                                          ,state VARCHAR2)
    RETURN SELF AS RESULT);
/

CREATE OR REPLACE TYPE BODY zipcode_obj_type AS
    
   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                         ,zip  VARCHAR2) 
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip := zip;

      SELECT city, state
        INTO SELF.city, SELF.state
        FROM zipcode
       WHERE zip = SELF.zip;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN;
   END;

   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                         ,zip   VARCHAR2
                                         ,city  VARCHAR2
                                         ,state VARCHAR2)
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip   := zip;
      SELF.city  := city;
      SELF.state := state;

      RETURN;
   END;
END;
/

-- For Example ch23_8b.sql
CREATE OR REPLACE TYPE zipcode_obj_type AS OBJECT
   (zip           VARCHAR2(5)
   ,city          VARCHAR2(25)
   ,state         VARCHAR2(2)
   ,created_by    VARCHAR2(30)
   ,created_date  DATE
   ,modified_by   VARCHAR2(30)
   ,modified_date DATE

   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                          ,zip  VARCHAR2)
    RETURN SELF AS RESULT
    
   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                          ,zip   VARCHAR2
                                          ,city  VARCHAR2
                                          ,state VARCHAR2)
    RETURN SELF AS RESULT

   ,MEMBER PROCEDURE get_zipcode_info (out_zip   OUT VARCHAR2
                                      ,out_city  OUT VARCHAR2
                                      ,out_state OUT VARCHAR2));
/

CREATE OR REPLACE TYPE BODY zipcode_obj_type AS
    
   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                         ,zip  VARCHAR2) 
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip := zip;

      SELECT city, state
        INTO SELF.city, SELF.state
        FROM zipcode
       WHERE zip = SELF.zip;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN;
   END;

   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                         ,zip   VARCHAR2
                                         ,city  VARCHAR2
                                         ,state VARCHAR2)
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip   := zip;
      SELF.city  := city;
      SELF.state := state;

      RETURN;
   END;

   MEMBER PROCEDURE get_zipcode_info (out_zip   OUT VARCHAR2
                                     ,out_city  OUT VARCHAR2
                                     ,out_state OUT VARCHAR2) 
   IS
   BEGIN
      out_zip   := SELF.zip;
      out_city  := SELF.city;
      out_state := SELF.state;
   END;
END;
/

-- For Example ch23_8c.sql
CREATE OR REPLACE TYPE zipcode_obj_type AS OBJECT
   (zip           VARCHAR2(5)
   ,city          VARCHAR2(25)
   ,state         VARCHAR2(2)
   ,created_by    VARCHAR2(30)
   ,created_date  DATE
   ,modified_by   VARCHAR2(30)
   ,modified_date DATE

   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                          ,zip  VARCHAR2)
    RETURN SELF AS RESULT
    
   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                          ,zip   VARCHAR2
                                          ,city  VARCHAR2
                                          ,state VARCHAR2)
    RETURN SELF AS RESULT

   ,MEMBER PROCEDURE get_zipcode_info (out_zip   OUT VARCHAR2
                                      ,out_city  OUT VARCHAR2
                                      ,out_state OUT VARCHAR2)

   ,STATIC PROCEDURE display_zipcode_info (in_zip_obj IN zipcode_obj_type));
/

CREATE OR REPLACE TYPE BODY zipcode_obj_type AS
    
   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                         ,zip  VARCHAR2) 
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip := zip;

      SELECT city, state
        INTO SELF.city, SELF.state
        FROM zipcode
       WHERE zip = SELF.zip;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN;
   END;

   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                         ,zip   VARCHAR2
                                         ,city  VARCHAR2
                                         ,state VARCHAR2)
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip   := zip;
      SELF.city  := city;
      SELF.state := state;

      RETURN;
   END;

   MEMBER PROCEDURE get_zipcode_info (out_zip   OUT VARCHAR2
                                     ,out_city  OUT VARCHAR2
                                     ,out_state OUT VARCHAR2) 
   IS
   BEGIN
      out_zip   := SELF.zip;
      out_city  := SELF.city;
      out_state := SELF.state;
   END;

   STATIC PROCEDURE display_zipcode_info (in_zip_obj IN zipcode_obj_type) 
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('Zip: '  ||in_zip_obj.zip);
      DBMS_OUTPUT.PUT_LINE ('City: ' ||in_zip_obj.city);
      DBMS_OUTPUT.PUT_LINE ('State: '||in_zip_obj.state);
   END;
END;
/

-- For Example ch23_8d.sql
CREATE OR REPLACE TYPE zipcode_obj_type AS OBJECT
   (zip           VARCHAR2(5)
   ,city          VARCHAR2(25)
   ,state         VARCHAR2(2)
   ,created_by    VARCHAR2(30)
   ,created_date  DATE
   ,modified_by   VARCHAR2(30)
   ,modified_date DATE

   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                          ,zip  VARCHAR2)
    RETURN SELF AS RESULT
    
   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                          ,zip   VARCHAR2
                                          ,city  VARCHAR2
                                          ,state VARCHAR2)
    RETURN SELF AS RESULT

   ,MEMBER PROCEDURE get_zipcode_info (out_zip   OUT VARCHAR2
                                      ,out_city  OUT VARCHAR2
                                      ,out_state OUT VARCHAR2)

   ,STATIC PROCEDURE display_zipcode_info (in_zip_obj IN zipcode_obj_type)

   ,MAP MEMBER FUNCTION zipcode RETURN VARCHAR2);
/

CREATE OR REPLACE TYPE BODY zipcode_obj_type AS
    
   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                         ,zip  VARCHAR2) 
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip := zip;

      SELECT city, state
        INTO SELF.city, SELF.state
        FROM zipcode
       WHERE zip = SELF.zip;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN;
   END;

   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                         ,zip   VARCHAR2
                                         ,city  VARCHAR2
                                         ,state VARCHAR2)
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip   := zip;
      SELF.city  := city;
      SELF.state := state;

      RETURN;
   END;

   MEMBER PROCEDURE get_zipcode_info (out_zip   OUT VARCHAR2
                                     ,out_city  OUT VARCHAR2
                                     ,out_state OUT VARCHAR2) 
   IS
   BEGIN
      out_zip   := SELF.zip;
      out_city  := SELF.city;
      out_state := SELF.state;
   END;

   STATIC PROCEDURE display_zipcode_info (in_zip_obj IN zipcode_obj_type) 
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('Zip: '  ||in_zip_obj.zip);
      DBMS_OUTPUT.PUT_LINE ('City: ' ||in_zip_obj.city);
      DBMS_OUTPUT.PUT_LINE ('State: '||in_zip_obj.state);
   END;

   MAP MEMBER FUNCTION zipcode RETURN VARCHAR2
   IS
   BEGIN
      RETURN (zip);
   END;
END;
/

-- For Example ch23_9a.sql
DECLARE
   zip_obj1 zipcode_obj_type;
   zip_obj2 zipcode_obj_type;
BEGIN
   -- Initialize object instances with user-defined constructor methods
   zip_obj1 := zipcode_obj_type (zip   => '12345'
                                ,city  => 'Some City'
                                ,state => 'AB');

   zip_obj2 := zipcode_obj_type (zip => '48104');

   -- Compare object instances via map methods
   IF zip_obj1 > zip_obj2
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj1 is greater than zip_obj2');
   ELSE
      DBMS_OUTPUT.PUT_LINE 
         ('zip_obj1 is not greater than zip_obj2');
   END IF;
END;

-- For Example ch23_8e.sql
CREATE OR REPLACE TYPE zipcode_obj_type AS OBJECT
   (zip           VARCHAR2(5)
   ,city          VARCHAR2(25)
   ,state         VARCHAR2(2)
   ,created_by    VARCHAR2(30)
   ,created_date  DATE
   ,modified_by   VARCHAR2(30)
   ,modified_date DATE

   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                          ,zip  VARCHAR2)
    RETURN SELF AS RESULT
    
   ,CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                          ,zip   VARCHAR2
                                          ,city  VARCHAR2
                                          ,state VARCHAR2)
    RETURN SELF AS RESULT

   ,MEMBER PROCEDURE get_zipcode_info (out_zip   OUT VARCHAR2
                                      ,out_city  OUT VARCHAR2
                                      ,out_state OUT VARCHAR2)

   ,STATIC PROCEDURE display_zipcode_info (in_zip_obj IN zipcode_obj_type)

   ,ORDER MEMBER FUNCTION zipcode (zip_obj zipcode_obj_type) RETURN INTEGER);
/

CREATE OR REPLACE TYPE BODY zipcode_obj_type AS
    
   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF IN OUT NOCOPY zipcode_obj_type
                                         ,zip  VARCHAR2) 
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip := zip;

      SELECT city, state
        INTO SELF.city, SELF.state
        FROM zipcode
       WHERE zip = SELF.zip;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN;
   END;

   CONSTRUCTOR FUNCTION zipcode_obj_type (SELF  IN OUT NOCOPY zipcode_obj_type
                                         ,zip   VARCHAR2
                                         ,city  VARCHAR2
                                         ,state VARCHAR2)
   RETURN SELF AS RESULT 
   IS
   BEGIN
      SELF.zip   := zip;
      SELF.city  := city;
      SELF.state := state;

      RETURN;
   END;

   MEMBER PROCEDURE get_zipcode_info (out_zip   OUT VARCHAR2
                                     ,out_city  OUT VARCHAR2
                                     ,out_state OUT VARCHAR2) 
   IS
   BEGIN
      out_zip   := SELF.zip;
      out_city  := SELF.city;
      out_state := SELF.state;
   END;

   STATIC PROCEDURE display_zipcode_info (in_zip_obj IN zipcode_obj_type) 
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('Zip: '  ||in_zip_obj.zip);
      DBMS_OUTPUT.PUT_LINE ('City: ' ||in_zip_obj.city);
      DBMS_OUTPUT.PUT_LINE ('State: '||in_zip_obj.state);
   END;

   ORDER MEMBER FUNCTION zipcode (zip_obj zipcode_obj_type) RETURN INTEGER
   IS
   BEGIN
      IF    zip < zip_obj.zip THEN RETURN -1;
      ELSIF zip = zip_obj.zip THEN RETURN  0;
      ELSIF zip > zip_obj.zip THEN RETURN  1;
      END IF;
   END;
END;
/

-- For Example ch23_10a.sql
DECLARE
   zip_obj1 zipcode_obj_type;
   zip_obj2 zipcode_obj_type;

   v_result   INTEGER;
BEGIN
   -- Initialize object instances with user-defined constructor methods
   zip_obj1 := zipcode_obj_type ('12345', 'Some City', 'AB');
   zip_obj2 := zipcode_obj_type ('48104');

   -- Compare objects instances via ORDER method
   v_result := zip_obj1.zipcode(zip_obj2);
   DBMS_OUTPUT.PUT_LINE ('The result of comparison is '||v_result);
   
   IF v_result = 1
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj1 is greater than zip_obj2');
   
   ELSIF v_result = 0
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj1 is equal to zip_obj2');
   
   ELSIF v_result = -1
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj1 is less than zip_obj2');
   END IF;
END;

-- For Example ch23_10b.sql
DECLARE
   zip_obj1 zipcode_obj_type;
   zip_obj2 zipcode_obj_type;

   v_result   INTEGER;
BEGIN
   -- Initialize object instances with user-defined constructor methods
   zip_obj1 := zipcode_obj_type ('12345', 'Some City', 'AB');
   zip_obj2 := zipcode_obj_type ('48104');

   -- Compare objects instances via ORDER method
   v_result := zip_obj2.zipcode(zip_obj1);
   DBMS_OUTPUT.PUT_LINE ('The result of comparison is '||v_result);
   
   IF v_result = 1
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj2 is greater than zip_obj1');
   
   ELSIF v_result = 0
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj2 is equal to zip_obj1');
   
   ELSIF v_result = -1
   THEN
      DBMS_OUTPUT.PUT_LINE ('zip_obj2 is less than zip_obj1');
   END IF;
END;

-- *** Web Chapter Exercises *** --
-- For Example ch23_11a.sql
CREATE OR REPLACE TYPE ENROLLMENT_OBJ_TYPE AS OBJECT
   (student_id   NUMBER(8)
   ,first_name   VARCHAR2(25)
   ,last_name    VARCHAR2(25)
   ,course_no    NUMBER(8)
   ,section_no   NUMBER(3)
   ,enroll_date  DATE
   ,final_grade  NUMBER(3));

-- For Example ch23_12a.sql
DECLARE
   v_enrollment_obj enrollment_obj_type;

BEGIN
   v_enrollment_obj.student_id := 102;
   v_enrollment_obj.first_name := 'Fred';
   v_enrollment_obj.last_name  := 'Crocitto';
   v_enrollment_obj.course_no  := 25;
END;

-- For Example ch23_12b.sql
DECLARE
   v_enrollment_obj enrollment_obj_type;

BEGIN
   v_enrollment_obj := 
      enrollment_obj_type(102, 'Fred', 'Crocitto', 25, null, null, null);
END;

-- For Example ch23_12c.sql
DECLARE
   v_enrollment_obj enrollment_obj_type;

BEGIN
   SELECT 
      enrollment_obj_type(st.student_id, st.first_name, st.last_name, c.course_no
                         ,se.section_no, e.enroll_date, e.final_grade)
     INTO v_enrollment_obj
     FROM student st, course c, section se, enrollment e
    WHERE st.student_id = e.student_id
      AND c.course_no   = se.course_no
      AND se.section_id = e.section_id
      AND st.student_id = 102
      AND c.course_no   = 25
      AND se.section_no = 2;
END;

-- For Example ch23_12d.sql
DECLARE
   v_enrollment_obj enrollment_obj_type;

BEGIN
   FOR REC IN (SELECT st.student_id, st.first_name, st.last_name, c.course_no
                     ,se.section_no, e.enroll_date, e.final_grade
                 FROM student st, course c, section se, enrollment e
                WHERE st.student_id = e.student_id
                  AND c.course_no   = se.course_no
                  AND se.section_id = e.section_id
                  AND st.student_id = 102
                  AND c.course_no   = 25)
   LOOP
      v_enrollment_obj :=
         enrollment_obj_type(rec.student_id, rec.first_name, rec.last_name
                            ,rec.course_no, rec.section_no, rec.enroll_date
                            ,rec.final_grade);
   END LOOP;
END;

-- For Example ch23_12e.sql
DECLARE
   v_enrollment_obj enrollment_obj_type;

BEGIN
   FOR REC IN (SELECT st.student_id, st.first_name, st.last_name, c.course_no
                     ,se.section_no, e.enroll_date, e.final_grade
                 FROM student st, course c, section se, enrollment e
                WHERE st.student_id = e.student_id
                  AND c.course_no   = se.course_no
                  AND se.section_id = e.section_id
                  AND st.student_id = 102
                  AND c.course_no   = 25)
   LOOP
      v_enrollment_obj :=
         enrollment_obj_type(rec.student_id, rec.first_name, rec.last_name
                            ,rec.course_no, rec.section_no, rec.enroll_date
                            ,rec.final_grade);

      DBMS_OUTPUT.PUT_LINE ('student_id:  '||v_enrollment_obj.student_id);
      DBMS_OUTPUT.PUT_LINE ('first_name:  '||v_enrollment_obj.first_name);
      DBMS_OUTPUT.PUT_LINE ('last_name:   '||v_enrollment_obj.last_name);
      DBMS_OUTPUT.PUT_LINE ('course_no:   '||v_enrollment_obj.course_no);
      DBMS_OUTPUT.PUT_LINE ('section_no:  '||v_enrollment_obj.section_no);
      DBMS_OUTPUT.PUT_LINE ('enroll_date: '||v_enrollment_obj.enroll_date);
      DBMS_OUTPUT.PUT_LINE ('final_grade: '||v_enrollment_obj.final_grade);
   END LOOP;
END;

-- For Example ch23_13a.sql
DECLARE
   TYPE enroll_tab_type IS TABLE OF enrollment_obj_type INDEX BY PLS_INTEGER;

   v_enrollment_tab enroll_tab_type;

   v_counter integer := 0;
   
BEGIN
   FOR REC IN (SELECT st.student_id, st.first_name, st.last_name, c.course_no
                     ,se.section_no, e.enroll_date, e.final_grade
                 FROM student st, course c, section se, enrollment e
                WHERE st.student_id = e.student_id
                  AND c.course_no   = se.course_no
                  AND se.section_id = e.section_id
                  AND st.student_id in (102, 103, 104))
   LOOP
      v_counter := v_counter + 1;
      v_enrollment_tab(v_counter) := 
         enrollment_obj_type(rec.student_id, rec.first_name, rec.last_name
                            ,rec.course_no, rec.section_no, rec.enroll_date
                            ,rec.final_grade);

      DBMS_OUTPUT.PUT_LINE ('student_id:  '||   
         v_enrollment_tab(v_counter).student_id);
      DBMS_OUTPUT.PUT_LINE ('first_name:  '||
         v_enrollment_tab(v_counter).first_name);
      DBMS_OUTPUT.PUT_LINE ('last_name:   '||
         v_enrollment_tab(v_counter).last_name);
      DBMS_OUTPUT.PUT_LINE ('course_no:   '||
         v_enrollment_tab(v_counter).course_no);
      DBMS_OUTPUT.PUT_LINE ('section_no:  '||
         v_enrollment_tab(v_counter).section_no);
      DBMS_OUTPUT.PUT_LINE ('enroll_date: '||
         v_enrollment_tab(v_counter).enroll_date);
      DBMS_OUTPUT.PUT_LINE ('final_grade: '|| 
         v_enrollment_tab(v_counter).final_grade);
      DBMS_OUTPUT.PUT_LINE ('------------------');
   END LOOP;
END;

-- For Example ch23_13b.sql
DECLARE
   TYPE enroll_tab_type IS TABLE OF enrollment_obj_type INDEX BY PLS_INTEGER;

   v_enrollment_tab enroll_tab_type;

BEGIN
   SELECT 
      enrollment_obj_type(st.student_id, st.first_name, st.last_name, c.course_no
                         ,se.section_no, e.enroll_date, e.final_grade)
     BULK COLLECT INTO v_enrollment_tab
     FROM student st, course c, section se, enrollment e
    WHERE st.student_id = e.student_id
      AND c.course_no   = se.course_no
      AND se.section_id = e.section_id
      AND st.student_id in (102, 103, 104);

   FOR i IN 1..v_enrollment_tab.COUNT
   LOOP
      DBMS_OUTPUT.PUT_LINE ('student_id:  '||v_enrollment_tab(i).student_id);
      DBMS_OUTPUT.PUT_LINE ('first_name:  '||v_enrollment_tab(i).first_name);
      DBMS_OUTPUT.PUT_LINE ('last_name:   '||v_enrollment_tab(i).last_name);
      DBMS_OUTPUT.PUT_LINE ('course_no:   '||v_enrollment_tab(i).course_no);
      DBMS_OUTPUT.PUT_LINE ('section_no:  '||v_enrollment_tab(i).section_no);
      DBMS_OUTPUT.PUT_LINE ('enroll_date: '||v_enrollment_tab(i).enroll_date);
      DBMS_OUTPUT.PUT_LINE ('final_grade: '||v_enrollment_tab(i).final_grade);
      DBMS_OUTPUT.PUT_LINE ('------------------');
   END LOOP;
END;

-- For Example ch23_13c.sql
DECLARE
   v_enrollment_tab enroll_tab_type;

BEGIN
   SELECT 
      enrollment_obj_type(st.student_id, st.first_name, st.last_name, c.course_no
                         ,se.section_no, e.enroll_date, e.final_grade)
     BULK COLLECT INTO v_enrollment_tab
     FROM student st, course c, section se, enrollment e
    WHERE st.student_id = e.student_id
      AND c.course_no   = se.course_no
      AND se.section_id = e.section_id
      AND st.student_id in (102, 103, 104);

   FOR rec IN (SELECT *
                 FROM TABLE(CAST(v_enrollment_tab AS enroll_tab_type)))
   LOOP
      DBMS_OUTPUT.PUT_LINE ('student_id:  '||rec.student_id);
      DBMS_OUTPUT.PUT_LINE ('first_name:  '||rec.first_name);
      DBMS_OUTPUT.PUT_LINE ('last_name:   '||rec.last_name);
      DBMS_OUTPUT.PUT_LINE ('course_no:   '||rec.course_no);
      DBMS_OUTPUT.PUT_LINE ('section_no:  '||rec.section_no);
      DBMS_OUTPUT.PUT_LINE ('enroll_date: '||rec.enroll_date);
      DBMS_OUTPUT.PUT_LINE ('final_grade: '||rec.final_grade);
      DBMS_OUTPUT.PUT_LINE ('------------------');
   END LOOP;
END;

-- For Example ch23_14a.sql
CREATE OR REPLACE TYPE enrollment_obj_type AS OBJECT
   (student_id  NUMBER(8),
    first_name  VARCHAR2(25),
    last_name   VARCHAR2(25),
    course_no   NUMBER(8),
    section_no  NUMBER(3),
    enroll_date DATE,
    final_grade NUMBER(3),
    
   CONSTRUCTOR FUNCTION enrollment_obj_type (SELF IN OUT NOCOPY enrollment_obj_type
                                            ,in_student_id NUMBER
                                            ,in_course_no  NUMBER
                                            ,in_section_no NUMBER)
   RETURN SELF AS RESULT);
/

CREATE OR REPLACE TYPE BODY enrollment_obj_type AS

CONSTRUCTOR FUNCTION enrollment_obj_type (SELF IN OUT NOCOPY enrollment_obj_type
                                         ,in_student_id NUMBER
                                         ,in_course_no  NUMBER
                                         ,in_section_no NUMBER)
RETURN SELF AS RESULT
IS
BEGIN
   SELECT st.student_id, st.first_name, st.last_name, c.course_no,
          se.section_no, e.enroll_date, e.final_grade
     INTO SELF.student_id, SELF.first_name, SELF.last_name,
          SELF.course_no, SELF.section_no, SELF.enroll_date, 
          SELF.final_grade
     FROM student st, course c, section se, enrollment e
    WHERE st.student_id = e.student_id
      AND c.course_no   = se.course_no
      AND se.section_id = e.section_id
      AND st.student_id = in_student_id
      AND c.course_no   = in_course_no
      AND se.section_no = in_section_no;

   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RETURN;
END;
END;
/

-- For Example ch23_15a.sql
DECLARE
   v_enrollment_obj enrollment_obj_type;
BEGIN
   v_enrollment_obj := enrollment_obj_type(102, 25, 2);
   
   DBMS_OUTPUT.PUT_LINE ('student_id:  '||v_enrollment_obj.student_id);
   DBMS_OUTPUT.PUT_LINE ('first_name:  '||v_enrollment_obj.first_name);
   DBMS_OUTPUT.PUT_LINE ('last_name:   '||v_enrollment_obj.last_name);
   DBMS_OUTPUT.PUT_LINE ('course_no:   '||v_enrollment_obj.course_no);
   DBMS_OUTPUT.PUT_LINE ('section_no:  '||v_enrollment_obj.section_no);
   DBMS_OUTPUT.PUT_LINE ('enroll_date: '||v_enrollment_obj.enroll_date);
   DBMS_OUTPUT.PUT_LINE ('final_grade: '||v_enrollment_obj.final_grade);
END;

-- For Example ch23_14b.sql
CREATE OR REPLACE TYPE enrollment_obj_type AS OBJECT
   (student_id  NUMBER(8),
    first_name  VARCHAR2(25),
    last_name   VARCHAR2(25),
    course_no   NUMBER(8),
    section_no  NUMBER(3),
    enroll_date DATE,
    final_grade NUMBER(3),
    
   CONSTRUCTOR FUNCTION enrollment_obj_type (SELF IN OUT NOCOPY enrollment_obj_type
                                            ,in_student_id NUMBER
                                            ,in_course_no  NUMBER
                                            ,in_section_no NUMBER)
   RETURN SELF AS RESULT,

   MEMBER PROCEDURE get_enrollment_info (out_student_id  OUT NUMBER
                                        ,out_first_name  OUT VARCHAR2
                                        ,out_last_name   OUT VARCHAR2
                                        ,out_course_no   OUT NUMBER
                                        ,out_section_no  OUT NUMBER
                                        ,out_enroll_date OUT DATE
                                        ,out_final_grade OUT NUMBER));
/

CREATE OR REPLACE TYPE BODY enrollment_obj_type AS

CONSTRUCTOR FUNCTION enrollment_obj_type (SELF IN OUT NOCOPY enrollment_obj_type
                                         ,in_student_id NUMBER
                                         ,in_course_no  NUMBER
                                         ,in_section_no NUMBER)
RETURN SELF AS RESULT
IS
BEGIN
   SELECT st.student_id, st.first_name, st.last_name, c.course_no,
          se.section_no, e.enroll_date, e.final_grade
     INTO SELF.student_id, SELF.first_name, SELF.last_name,
          SELF.course_no, SELF.section_no, SELF.enroll_date, 
          SELF.final_grade
     FROM student st, course c, section se, enrollment e
    WHERE st.student_id = e.student_id
      AND c.course_no   = se.course_no
      AND se.section_id = e.section_id
      AND st.student_id = in_student_id
      AND c.course_no   = in_course_no
      AND se.section_no = in_section_no;

   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RETURN;
END;

MEMBER PROCEDURE get_enrollment_info (out_student_id  OUT NUMBER
                                     ,out_first_name  OUT VARCHAR2
                                     ,out_last_name   OUT VARCHAR2
                                     ,out_course_no   OUT NUMBER
                                     ,out_section_no  OUT NUMBER
                                     ,out_enroll_date OUT DATE
                                     ,out_final_grade OUT NUMBER)
IS
BEGIN
   out_student_id  := student_id;
   out_first_name  := first_name;
   out_last_name   := last_name;
   out_course_no   := course_no;
   out_section_no  := section_no;
   out_enroll_date := enroll_date;
   out_final_grade := final_grade;
END;

END;
/

-- For Example ch23_14c.sql
CREATE OR REPLACE TYPE enrollment_obj_type AS OBJECT
   (student_id  NUMBER(8),
    first_name  VARCHAR2(25),
    last_name   VARCHAR2(25),
    course_no   NUMBER(8),
    section_no  NUMBER(3),
    enroll_date DATE,
    final_grade NUMBER(3),
    
   CONSTRUCTOR FUNCTION enrollment_obj_type (SELF IN OUT NOCOPY enrollment_obj_type
                                            ,in_student_id NUMBER
                                            ,in_course_no  NUMBER
                                            ,in_section_no NUMBER)
   RETURN SELF AS RESULT,

   MEMBER PROCEDURE get_enrollment_info (out_student_id  OUT NUMBER
                                        ,out_first_name  OUT VARCHAR2
                                        ,out_last_name   OUT VARCHAR2
                                        ,out_course_no   OUT NUMBER
                                        ,out_section_no  OUT NUMBER
                                        ,out_enroll_date OUT DATE
                                             ,out_final_grade OUT NUMBER),

 STATIC PROCEDURE display_enrollment_info (enrollment_obj enrollment_obj_type));
/

CREATE OR REPLACE TYPE BODY enrollment_obj_type AS

CONSTRUCTOR FUNCTION enrollment_obj_type (SELF IN OUT NOCOPY enrollment_obj_type
                                         ,in_student_id NUMBER
                                         ,in_course_no  NUMBER
                                         ,in_section_no NUMBER)
RETURN SELF AS RESULT
IS
BEGIN
   SELECT st.student_id, st.first_name, st.last_name, c.course_no,
          se.section_no, e.enroll_date, e.final_grade
     INTO SELF.student_id, SELF.first_name, SELF.last_name,
          SELF.course_no, SELF.section_no, SELF.enroll_date, 
          SELF.final_grade
     FROM student st, course c, section se, enrollment e
    WHERE st.student_id = e.student_id
      AND c.course_no   = se.course_no
      AND se.section_id = e.section_id
      AND st.student_id = in_student_id
      AND c.course_no   = in_course_no
      AND se.section_no = in_section_no;

   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RETURN;
END;

MEMBER PROCEDURE get_enrollment_info (out_student_id  OUT NUMBER
                                     ,out_first_name  OUT VARCHAR2
                                     ,out_last_name   OUT VARCHAR2
                                     ,out_course_no   OUT NUMBER
                                     ,out_section_no  OUT NUMBER
                                     ,out_enroll_date OUT DATE
                                     ,out_final_grade OUT NUMBER)
IS
BEGIN
   out_student_id  := student_id;
   out_first_name  := first_name;
   out_last_name   := last_name;
   out_course_no   := course_no;
   out_section_no  := section_no;
   out_enroll_date := enroll_date;
   out_final_grade := final_grade;
END;

STATIC PROCEDURE display_enrollment_info (enrollment_obj enrollment_obj_type)
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('student_id:  '||enrollment_obj.student_id);
   DBMS_OUTPUT.PUT_LINE ('first_name:  '||enrollment_obj.first_name);
   DBMS_OUTPUT.PUT_LINE ('last_name:   '||enrollment_obj.last_name);
   DBMS_OUTPUT.PUT_LINE ('course_no:   '||enrollment_obj.course_no);
   DBMS_OUTPUT.PUT_LINE ('section_no:  '||enrollment_obj.section_no);
   DBMS_OUTPUT.PUT_LINE ('enroll_date: '||enrollment_obj.enroll_date);
   DBMS_OUTPUT.PUT_LINE ('final_grade: '||enrollment_obj.final_grade);
END;

END;
/

-- For Example ch23_15b.sql
DECLARE
   v_enrollment_obj enrollment_obj_type;
BEGIN
   v_enrollment_obj := enrollment_obj_type(102, 25, 2);
   
   enrollment_obj_type.display¬_enrollment_info (v_enrollment_obj);
END;

-- For Example ch23_14d.sql
CREATE OR REPLACE TYPE enrollment_obj_type AS OBJECT
   (student_id  NUMBER(8),
    first_name  VARCHAR2(25),
    last_name   VARCHAR2(25),
    course_no   NUMBER(8),
    section_no  NUMBER(3),
    enroll_date DATE,
    final_grade NUMBER(3),
    
   CONSTRUCTOR FUNCTION enrollment_obj_type (SELF IN OUT NOCOPY enrollment_obj_type
                                            ,in_student_id NUMBER
                                            ,in_course_no  NUMBER
                                            ,in_section_no NUMBER)
   RETURN SELF AS RESULT,

   MEMBER PROCEDURE get_enrollment_info (out_student_id  OUT NUMBER
                                        ,out_first_name  OUT VARCHAR2
                                        ,out_last_name   OUT VARCHAR2
                                        ,out_course_no   OUT NUMBER
                                        ,out_section_no  OUT NUMBER
                                        ,out_enroll_date OUT DATE
                                             ,out_final_grade OUT NUMBER),

 STATIC PROCEDURE display_enrollment_info (enrollment_obj enrollment_obj_type),

 MAP MEMBER FUNCTION enrollment RETURN NUMBER);
/  

CREATE OR REPLACE TYPE BODY enrollment_obj_type AS

CONSTRUCTOR FUNCTION enrollment_obj_type (SELF IN OUT NOCOPY enrollment_obj_type
                                         ,in_student_id NUMBER
                                         ,in_course_no  NUMBER
                                         ,in_section_no NUMBER)
RETURN SELF AS RESULT
IS
BEGIN
   SELECT st.student_id, st.first_name, st.last_name, c.course_no,
          se.section_no, e.enroll_date, e.final_grade
     INTO SELF.student_id, SELF.first_name, SELF.last_name,
          SELF.course_no, SELF.section_no, SELF.enroll_date, 
          SELF.final_grade
     FROM student st, course c, section se, enrollment e
    WHERE st.student_id = e.student_id
      AND c.course_no   = se.course_no
      AND se.section_id = e.section_id
      AND st.student_id = in_student_id
      AND c.course_no   = in_course_no
      AND se.section_no = in_section_no;

   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RETURN;
END;

MEMBER PROCEDURE get_enrollment_info (out_student_id  OUT NUMBER
                                     ,out_first_name  OUT VARCHAR2
                                     ,out_last_name   OUT VARCHAR2
                                     ,out_course_no   OUT NUMBER
                                     ,out_section_no  OUT NUMBER
                                     ,out_enroll_date OUT DATE
                                     ,out_final_grade OUT NUMBER)
IS
BEGIN
   out_student_id  := student_id;
   out_first_name  := first_name;
   out_last_name   := last_name;
   out_course_no   := course_no;
   out_section_no  := section_no;
   out_enroll_date := enroll_date;
   out_final_grade := final_grade;
END;

STATIC PROCEDURE display_enrollment_info (enrollment_obj enrollment_obj_type)
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('student_id:  '||enrollment_obj.student_id);
   DBMS_OUTPUT.PUT_LINE ('first_name:  '||enrollment_obj.first_name);
   DBMS_OUTPUT.PUT_LINE ('last_name:   '||enrollment_obj.last_name);
   DBMS_OUTPUT.PUT_LINE ('course_no:   '||enrollment_obj.course_no);
   DBMS_OUTPUT.PUT_LINE ('section_no:  '||enrollment_obj.section_no);
   DBMS_OUTPUT.PUT_LINE ('enroll_date: '||enrollment_obj.enroll_date);
   DBMS_OUTPUT.PUT_LINE ('final_grade: '||enrollment_obj.final_grade);
END;

MAP MEMBER FUNCTION enrollment RETURN NUMBER
IS
BEGIN
   RETURN (course_no + section_no + student_id);
END;

END;
/

--  For Example ch23_15c.sql
DECLARE
   v_enrollment_obj1 enrollment_obj_type;
   v_enrollment_obj2 enrollment_obj_type;
BEGIN
   v_enrollment_obj1 := enrollment_obj_type(102, 25, 2);
   v_enrollment_obj2 := enrollment_obj_type(104, 20, 2);
   
   enrollment_obj_type.display¬_enrollment_info (v_enrollment_obj1);
   DBMS_OUTPUT.PUT_LINE ('--------------------');
   enrollment_obj_type.display¬_enrollment_info (v_enrollment_obj2);

   IF v_enrollment_obj1 > v_enrollment_obj2
   THEN
      DBMS_OUTPUT.PUT_LINE ('Instance 1 is greater than instance 2');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('Instance 1 is not greater than instance 2'); 
   END IF;
END;

-- For Example ch23_16a.sql
CREATE OR REPLACE TYPE student_obj_type AS OBJECT
   (student_id        NUMBER(8),
    salutation        VARCHAR2(5),
    first_name        VARCHAR2(25),
    last_name         VARCHAR2(25),
    street_address    VARCHAR2(50),
    zip               VARCHAR2(5),
    phone             VARCHAR2(15),
    employer          VARCHAR2(50),
    registration_date DATE,
    created_by        VARCHAR2(30),
    created_date      DATE,
    modified_by       VARCHAR2(30),
    modified_date     DATE);
/

-- For Example ch23_17a.sql
DECLARE
   v_student_obj student_obj_type;
BEGIN
   -- Use default contructor method to initialize student object
   SELECT 
      student_obj_type(student_id, salutation, first_name, last_name
                      ,street_address, zip, phone, employer, registration_date
                      ,null, null, null, null)
     INTO v_student_obj
     FROM student
    WHERE student_id = 103;
   
   DBMS_OUTPUT.PUT_LINE ('Student ID: '       ||v_student_obj.student_id);
   DBMS_OUTPUT.PUT_LINE ('Salutation: '       ||v_student_obj.salutation);
   DBMS_OUTPUT.PUT_LINE ('First Name: '       ||v_student_obj.first_name);
   DBMS_OUTPUT.PUT_LINE ('Last Name: '        ||v_student_obj.last_name);
   DBMS_OUTPUT.PUT_LINE ('Street Address: '   ||v_student_obj.street_address);
   DBMS_OUTPUT.PUT_LINE ('Zip: '              ||v_student_obj. zip);
   DBMS_OUTPUT.PUT_LINE ('Phone: '            ||v_student_obj.phone);
   DBMS_OUTPUT.PUT_LINE ('Employer: '         ||v_student_obj.employer);
   DBMS_OUTPUT.PUT_LINE ('Registration Date: '||v_student_obj.registration_date);
END;

-- For Example ch23_16b.sql
CREATE OR REPLACE TYPE student_obj_type AS OBJECT
  (student_id        NUMBER(8),
   salutation        VARCHAR2(5),
   first_name        VARCHAR2(25),
   last_name         VARCHAR2(25),
   street_address    VARCHAR2(50),
   zip               VARCHAR2(5),
   phone             VARCHAR2(15),
   employer          VARCHAR2(50),
   registration_date DATE,
   created_by        VARCHAR2(30),
   created_date      DATE,
   modified_by       VARCHAR2(30),
   modified_date     DATE,

   CONSTRUCTOR FUNCTION student_obj_type 
      (SELF IN OUT NOCOPY STUDENT_OBJ_TYPE 
      ,in_student_id  IN NUMBER,   in_salutation IN VARCHAR2
      ,in_first_name  IN VARCHAR2, in_last_name  IN VARCHAR2
      ,in_street_addr IN VARCHAR2, in_zip        IN VARCHAR2
      ,in_phone       IN VARCHAR2, in_employer   IN VARCHAR2
      ,in_reg_date    IN DATE,     in_cr_by      IN VARCHAR2
      ,in_cr_date     IN DATE,     in_mod_by     IN VARCHAR2
      ,in_mod_date    IN DATE)
   RETURN SELF AS RESULT,

   CONSTRUCTOR FUNCTION student_obj_type (SELF IN OUT NOCOPY STUDENT_OBJ_TYPE
                                         ,in_student_id IN NUMBER)
   RETURN SELF AS RESULT,
    
   MEMBER PROCEDURE get_student_info
      (student_id  OUT NUMBER,   salutation OUT VARCHAR2
      ,first_name  OUT VARCHAR2, last_name  OUT VARCHAR2
      ,street_addr OUT VARCHAR2, zip        OUT VARCHAR2
      ,phone       OUT VARCHAR2, employer   OUT VARCHAR2
      ,reg_date    OUT DATE,     cr_by      OUT VARCHAR2
      ,cr_date     OUT DATE,     mod_by     OUT VARCHAR2
      ,mod_date    OUT DATE),

   STATIC PROCEDURE display_student_info (student_obj IN STUDENT_OBJ_TYPE), 

   ORDER MEMBER FUNCTION student (student_obj STUDENT_OBJ_TYPE) 
   RETURN INTEGER);
/

CREATE OR REPLACE TYPE BODY student_obj_type AS
    
CONSTRUCTOR FUNCTION student_obj_type 
   (SELF IN OUT NOCOPY STUDENT_OBJ_TYPE 
   ,in_student_id  IN NUMBER,   in_salutation IN VARCHAR2
   ,in_first_name  IN VARCHAR2, in_last_name  IN VARCHAR2
   ,in_street_addr IN VARCHAR2, in_zip        IN VARCHAR2
   ,in_phone       IN VARCHAR2, in_employer   IN VARCHAR2
   ,in_reg_date    IN DATE,     in_cr_by      IN VARCHAR2
   ,in_cr_date     IN DATE,     in_mod_by     IN VARCHAR2
   ,in_mod_date    IN DATE)
RETURN SELF AS RESULT
IS
BEGIN
   -- Validate incoming value of zip
   SELECT zip 
     INTO SELF.zip
     FROM zipcode
    WHERE zip = in_zip;

   -- Check incoming value of student ID
   -- If it is not populated, get it from the sequence
   IF in_student_id IS NULL 
   THEN
      student_id := STUDENT_ID_SEQ.NEXTVAL;
   ELSE
      student_id := in_student_id;
   END IF;

   salutation        := in_salutation;
   first_name        := in_first_name;
   last_name         := in_last_name;
   street_address    := in_street_addr;
   phone             := in_phone;
   employer          := in_employer;
   registration_date := in_reg_date;

   IF in_cr_by IS NULL THEN created_by := USER;
   ELSE                     created_by := in_cr_by;
   END IF;

   IF in_cr_date IS NULL THEN created_date := SYSDATE;
   ELSE                       created_date := in_cr_date;
   END IF;

   IF in_mod_by IS NULL THEN modified_by := USER;
   ELSE                      modified_by := in_mod_by;
   END IF;
   
   IF in_mod_date IS NULL THEN modified_date := SYSDATE;
   ELSE                        modified_date := in_mod_date;
   END IF;

   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RETURN;
END;

CONSTRUCTOR FUNCTION student_obj_type (SELF IN OUT NOCOPY STUDENT_OBJ_TYPE
                                      ,in_student_id IN NUMBER)
RETURN SELF AS RESULT
IS
BEGIN
   SELECT student_id, salutation, first_name, last_name, street_address, zip
         ,phone, employer, registration_date, created_by, created_date
         ,modified_by, modified_date
     INTO SELF.student_id, SELF.salutation, SELF.first_name, 
          SELF.last_name, SELF.street_address, SELF.zip, 
          SELF.phone, SELF.employer, SELF.registration_date, 
          SELF.created_by, SELF.created_date, 
          SELF.modified_by, SELF.modified_date
     FROM student
    WHERE student_id = in_student_id;

   RETURN;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RETURN;
END;

MEMBER PROCEDURE get_student_info
   (student_id  OUT NUMBER,   salutation OUT VARCHAR2
   ,first_name  OUT VARCHAR2, last_name  OUT VARCHAR2
   ,street_addr OUT VARCHAR2, zip        OUT VARCHAR2
   ,phone       OUT VARCHAR2, employer   OUT VARCHAR2
   ,reg_date    OUT DATE,     cr_by      OUT VARCHAR2
   ,cr_date     OUT DATE,     mod_by     OUT VARCHAR2
   ,mod_date    OUT DATE) 
IS
BEGIN
   student_id  := SELF.student_id;
   salutation  := SELF.salutation;
   first_name  := SELF.first_name;
   last_name   := SELF.last_name;
   street_addr := SELF.street_address;
   zip         := SELF.zip;
   phone       := SELF.phone;
   employer    := SELF.employer;
   reg_date    := SELF.registration_date;
   cr_by       := SELF.created_by;
   cr_date     := SELF.created_date;
   mod_by      := SELF.modified_by;
   mod_date    := SELF.modified_date;
END;

STATIC PROCEDURE display_student_info (student_obj IN STUDENT_OBJ_TYPE)
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Student ID: '       ||student_obj.student_id);
   DBMS_OUTPUT.PUT_LINE ('Salutation: '       ||student_obj.salutation);
   DBMS_OUTPUT.PUT_LINE ('First Name: '       ||student_obj.first_name);
   DBMS_OUTPUT.PUT_LINE ('Last Name: '        ||student_obj.last_name);
   DBMS_OUTPUT.PUT_LINE ('Street Address: '   ||student_obj.street_address);
   DBMS_OUTPUT.PUT_LINE ('Zip: '              ||student_obj.zip);
   DBMS_OUTPUT.PUT_LINE ('Phone: '            ||student_obj.phone);
   DBMS_OUTPUT.PUT_LINE ('Employer: '         ||student_obj.employer);
   DBMS_OUTPUT.PUT_LINE ('Registration Date: '||student_obj.registration_date);
END;

ORDER MEMBER FUNCTION student (student_obj STUDENT_OBJ_TYPE) 
RETURN INTEGER
IS
BEGIN
   IF    student_id < student_obj.student_id THEN RETURN -1;
   ELSIF student_id = student_obj.student_id THEN RETURN  0;
   ELSIF student_id > student_obj.student_id THEN RETURN  1;
   END IF;
END;

END;
/

-- For Example ch23_17b.sql
DECLARE
   v_student_obj1 student_obj_type;
   v_student_obj2 student_obj_type;
   
   v_result integer;
BEGIN
   -- Populate student objects via user-defined constructor methods
   v_student_obj1 := student_obj_type (in_student_id  => NULL
                                      ,in_salutation  => 'Mr.'
                                      ,in_first_name  => 'John'
                                      ,in_last_name   => 'Smith'
                                      ,in_street_addr => '123 Main Street'
                                      ,in_zip         => '00914'
                                      ,in_phone       => '555-555-5555'
                                      ,in_employer    => 'ABC Company'
                                      ,in_reg_date    => TRUNC(sysdate)
                                      ,in_cr_by       => NULL
                                      ,in_cr_date     => NULL
                                      ,in_mod_by      => NULL
                                      ,in_mod_date    => NULL);
   v_student_obj2 := student_obj_type(103);
                        
   -- Display student information for both objects  
   student_obj_type.display_student_info (v_student_obj1);
   DBMS_OUTPUT.PUT_LINE ('================================');
   student_obj_type.display_student_info (v_student_obj2);    
   DBMS_OUTPUT.PUT_LINE ('================================');

   -- Compare student objects
   v_result := v_student_obj1.student(v_student_obj2);
   DBMS_OUTPUT.PUT_LINE ('The result of comparison is '||v_result);
   
   IF v_result = 1 
   THEN
      DBMS_OUTPUT.PUT_LINE ('v_student_obj1 is greater than v_student_obj2');
   
   ELSIF v_result = 0 
   THEN
      DBMS_OUTPUT.PUT_LINE ('v_student_obj1 is equal to v_student_obj2');
   
   ELSIF v_result = -1 
   THEN
      DBMS_OUTPUT.PUT_LINE ('v_student_obj1 is less than v_student_obj2');
   END IF;
 
END;

  
