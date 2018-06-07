-- *** Chapter Exercises *** --
-- For Example ch14_1a.sql
CREATE OR REPLACE TRIGGER section_biu
BEFORE INSERT OR UPDATE ON section
FOR EACH ROW
DECLARE
   v_total NUMBER;
   v_name  VARCHAR2(30);
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM section  -- SECTION is MUTATING
    WHERE instructor_id = :NEW.instructor_id;

   -- check if the current instructor is overbooked   
   IF v_total >= 10 
   THEN
      SELECT first_name||' '||last_name
        INTO v_name
        FROM instructor
       WHERE instructor_id = :NEW.instructor_id;
      
      RAISE_APPLICATION_ERROR (-20000, 'Instructor, '||v_name||', is overbooked');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RAISE_APPLICATION_ERROR (-20001, 'This is not a valid instructor');
END;

-- Listing 14.1 INSTRUCTOR_ADM Package Specification 
CREATE OR REPLACE PACKAGE instructor_adm 
AS
   g_instructor_id   instructor.instructor_id%TYPE;
   g_instructor_name varchar2(50);
END;

-- For Example ch14_1b.sql
CREATE OR REPLACE TRIGGER section_biu
BEFORE INSERT OR UPDATE ON section
FOR EACH ROW
BEGIN
   IF :NEW.instructor_id IS NOT NULL 
   THEN
      BEGIN
         -- Assign new instructor ID to the global variable
         instructor_adm.g_instructor_id := :NEW.INSTRUCTOR_ID;
         
         SELECT first_name||' '||last_name
           INTO instructor_adm.g_instructor_name
           FROM instructor
          WHERE instructor_id = instructor_adm.g_instructor_id;
      
      EXCEPTION
         WHEN NO_DATA_FOUND 
         THEN
            RAISE_APPLICATION_ERROR (-20001, 'This is not a valid instructor');
      END;
   END IF;
END;

-- For Example ch14_2a.sql
CREATE OR REPLACE TRIGGER section_aiu
AFTER INSERT OR UPDATE ON section
DECLARE
   v_total INTEGER;
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM section
    WHERE instructor_id = instructor_adm.g_instructor_id;
   
   -- check if the current instructor is overbooked
   IF v_total >= 10 
   THEN
      RAISE_APPLICATION_ERROR   
         (-20000, 'Instructor, '||instructor_adm.g_instructor_name||', is overbooked');
   END IF;
END;

-- For Example ch14_3a.sql
CREATE OR REPLACE TRIGGER student_compound
FOR INSERT ON STUDENT
COMPOUND TRIGGER

   -- Declaration section
   v_day  VARCHAR2(10);

BEFORE STATEMENT IS
BEGIN
   v_day := RTRIM(TO_CHAR(SYSDATE, 'DAY'));
   
   IF v_day LIKE ('S%') 
   THEN
      RAISE_APPLICATION_ERROR 
         (-20000, 'A table cannot be modified during off hours');  
   END IF;
END BEFORE STATEMENT;

BEFORE EACH ROW IS
BEGIN
   :NEW.student_id    := STUDENT_ID_SEQ.NEXTVAL;
   :NEW.created_by    := USER;
   :NEW.created_date  := SYSDATE;
   :NEW.modified_by   := USER;
   :NEW.modified_date := SYSDATE;
END BEFORE EACH ROW;

END;

-- Listing 14.3 Preventing Mutating Table Issue Prior to Oracle 11g 
Trigger on the SECTION table that causes mutating table error 
CREATE OR REPLACE TRIGGER section_biu
BEFORE INSERT OR UPDATE ON section
FOR EACH ROW
DECLARE
   v_total NUMBER;
   v_name VARCHAR2(30);
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM section  -- SECTION is MUTATING
    WHERE instructor_id = :NEW.instructor_id;

   -- check if the current instructor is overbooked   
   IF v_total >= 10 
   THEN
      SELECT first_name||' '||last_name
        INTO v_name
        FROM instructor
       WHERE instructor_id = :NEW.instructor_id;
      
      RAISE_APPLICATION_ERROR (-20000, 'Instructor, '||v_name||', is overbooked');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RAISE_APPLICATION_ERROR 
          (-20001, 'This is not a valid instructor');
END;

-- In order to correct this problem, you took the following steps:
-- You created a package where you declared two global variables. 
CREATE OR REPLACE PACKAGE instructor_adm AS
   g_instructor_id   instructor.instructor_id%TYPE;
   g_instructor_name varchar2(50);
END;

-- You modified the existing trigger to record the instructor’s ID and name. 
CREATE OR REPLACE TRIGGER section_biu
BEFORE INSERT OR UPDATE ON section
FOR EACH ROW
BEGIN
   IF :NEW.instructor_id IS NOT NULL 
   THEN
      BEGIN
         instructor_adm.g_instructor_id := :NEW.INSTRUCTOR_ID;
         
         SELECT first_name||' '||last_name
           INTO instructor_adm.g_instructor_name
           FROM instructor
          WHERE instructor_id = instructor_adm.g_instructor_id;
      
      EXCEPTION
         WHEN NO_DATA_FOUND 
         THEN
            RAISE_APPLICATION_ERROR (-20001, 'This is not a valid instructor');
      END;
   END IF;
END;

-- You created a new statement trigger that fires after the INSERT or UPDATE statement has been issued. 
CREATE OR REPLACE TRIGGER section_aiu
AFTER INSERT OR UPDATE ON section
DECLARE
   v_total INTEGER;
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM section
    WHERE instructor_id = instructor_adm.v_instructor_id;
   
   -- check if the current instructor is overbooked
   IF v_total >= 10 THEN
      RAISE_APPLICATION_ERROR 
         (-20000, 'Instructor, '||instructor_adm.v_instructor_name||
          ', is overbooked');
   END IF;
END;

-- For Example ch14_4a.sql
CREATE OR REPLACE TRIGGER section_compound
FOR INSERT OR UPDATE ON SECTION
COMPOUND TRIGGER

   -- Declaration Section
   v_instructor_id   INSTRUCTOR.INSTRUCTOR_ID%TYPE;
   v_instructor_name VARCHAR2(50);
   v_total           INTEGER;

BEFORE EACH ROW IS
BEGIN
   IF :NEW.instructor_id IS NOT NULL 
   THEN
      BEGIN
         v_instructor_id := :NEW.instructor_id;
         
         SELECT first_name||' '||last_name
           INTO v_instructor_name
           FROM instructor
          WHERE instructor_id = v_instructor_id;
      
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR 
               (-20001, 'This is not a valid instructor');
      END;
   END IF;
END BEFORE EACH ROW;

AFTER STATEMENT IS
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM section
    WHERE instructor_id = v_instructor_id;
   
   -- check if the current instructor is overbooked
   IF v_total >= 10 
   THEN
      RAISE_APPLICATION_ERROR 
         (-20000, 'Instructor, '||v_instructor_name||', is overbooked');
   END IF;
END AFTER STATEMENT;

END;

-- *** Web Chapter Exercises *** --
-- For Example ch14_5a.sql
CREATE OR REPLACE TRIGGER enrollment_biu
BEFORE INSERT OR UPDATE ON enrollment
FOR EACH ROW
DECLARE
   v_total NUMBER;
   v_name  VARCHAR2(30);
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM enrollment
    WHERE student_id = :NEW.student_id;

   -- check if the current student is enrolled into too 
   -- many courses
   IF v_total >= 3 
   THEN
      SELECT first_name||' '||last_name
        INTO v_name
        FROM student
       WHERE student_id = :NEW.STUDENT_ID;
      
      RAISE_APPLICATION_ERROR 
         (-20000, 'Student, '||v_name||', is registered for 3 courses already');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RAISE_APPLICATION_ERROR (-20001, 'This is not a valid student');
END;

-- STUDENT_PKG Package Specification
CREATE OR REPLACE PACKAGE student_pkg 
AS
   g_student_id   student.student_id%TYPE;
   g_student_name varchar2(50);
END;

-- For Example ch14_5b.sql
CREATE OR REPLACE TRIGGER enrollment_biu
BEFORE INSERT OR UPDATE ON enrollment
FOR EACH ROW
BEGIN
   IF :NEW.student_id IS NOT NULL 
   THEN
      BEGIN
     student_pkg.g_student_id := :NEW.student_id;
   
         SELECT first_name||' '||last_name
           INTO student_pkg.g_student_name
           FROM student
          WHERE student_id = student_pkg.g_student_id;
      EXCEPTION
         WHEN NO_DATA_FOUND 
         THEN
            RAISE_APPLICATION_ERROR (-20001, 'This is not a valid student');
      END;
   END IF;
END;

-- For Example ch14_6a.sql
CREATE OR REPLACE TRIGGER enrollment_aiu
AFTER INSERT OR UPDATE ON enrollment
DECLARE
   v_total INTEGER;
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM enrollment
    WHERE student_id = student_pkg.g_student_id;

   -- check if the current student is enrolled into too 
   -- many courses
    IF v_total >= 3 
   THEN
       RAISE_APPLICATION_ERROR 
         (-20000, 'Student, '||student_pkg.g_student_name||
          ', is registered for 3 courses already ');
    END IF;
END;

-- For Example ch14_7a.sql
CREATE OR REPLACE TRIGGER enrollment_compound
FOR INSERT OR UPDATE ON enrollment
COMPOUND TRIGGER
   v_student_id   STUDENT.STUDENT_ID%TYPE;
   v_student_name VARCHAR2(50);
   v_total        INTEGER;

BEFORE EACH ROW IS
BEGIN
    IF :NEW.student_id IS NOT NULL 
   THEN
       BEGIN
          v_student_id := :NEW.student_id;
   
          SELECT first_name||' '||last_name
            INTO v_student_name
            FROM student
           WHERE student_id = v_student_id;
       EXCEPTION
          WHEN NO_DATA_FOUND 
         THEN
             RAISE_APPLICATION_ERROR (-20001, 'This is not a valid student');
       END;
    END IF;
END BEFORE EACH ROW;

AFTER STATEMENT IS
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM enrollment
    WHERE student_id = v_student_id;

   -- check if the current student is enrolled into too 
   -- many courses
    IF v_total >= 3 
   THEN
       RAISE_APPLICATION_ERROR 
         (-20000, 'Student, '||v_student_name||
          ', is registered for 3 courses already ');
    END IF;
END AFTER STATEMENT;

END enrollment_compound;

-- For Example ch14_7b.sql
CREATE OR REPLACE TRIGGER enrollment_compound
FOR INSERT OR UPDATE ON enrollment
COMPOUND TRIGGER
   v_student_id   STUDENT.STUDENT_ID%TYPE;
   v_student_name VARCHAR2(50);
   v_total        INTEGER;
   v_date         DATE;
   v_user         STUDENT.CREATED_BY%TYPE;       

BEFORE STATEMENT IS
BEGIN
   v_date := SYSDATE;
   v_user := USER;
END BEFORE STATEMENT;

BEFORE EACH ROW IS
BEGIN
   IF INSERTING 
   THEN
      :NEW.created_date := v_date;
      :NEW.created_by   := v_user;
   ELSIF UPDATING 
   THEN
      :NEW.created_date := :OLD.created_date;
      :NEW.created_by   := :OLD.created_by;
   END IF;
   :NEW.MODIFIED_DATE := v_date;
   :NEW.MODIFIED_BY   := v_user;

   IF :NEW.STUDENT_ID IS NOT NULL 
   THEN
      BEGIN
          v_student_id := :NEW.STUDENT_ID;
   
          SELECT first_name||' '||last_name
            INTO v_student_name
            FROM student
           WHERE student_id = v_student_id;
       EXCEPTION
          WHEN NO_DATA_FOUND 
          THEN
             RAISE_APPLICATION_ERROR (-20001, 'This is not a valid student');
       END;
    END IF;
END BEFORE EACH ROW;

AFTER STATEMENT IS
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM enrollment
    WHERE student_id = v_student_id;

   -- check if the current student is enrolled into too 
   -- many courses
   IF v_total >= 3 THEN
       RAISE_APPLICATION_ERROR 
         (-20000, 'Student, '||v_student_name||
          ', is registered for 3 courses already ');
    END IF;
END AFTER STATEMENT;

END enrollment_compound;

-- For Example ch14_8a.sql
CREATE OR REPLACE TRIGGER instructor_compound
FOR INSERT OR UPDATE ON instructor
COMPOUND TRIGGER

   v_date DATE;
   v_user VARCHAR2(30);
   
BEFORE STATEMENT IS
BEGIN
   IF RTRIM(TO_CHAR(SYSDATE, 'DAY')) NOT LIKE 'S%' AND
      RTRIM(TO_CHAR(SYSDATE, 'HH24:MI')) BETWEEN '09:00' AND '17:00' 
   THEN
      v_date := SYSDATE;
      v_user := USER;
   ELSE   
      RAISE_APPLICATION_ERROR 
         (-20000, 'A table cannot be modified during off hours');  
   END IF;

END BEFORE STATEMENT;

BEFORE EACH ROW IS
BEGIN
   IF INSERTING 
   THEN
      :NEW.instructor_id := INSTRUCTOR_ID_SEQ.NEXTVAL;
      :NEW.created_by    := v_user;
      :NEW.created_date  := v_date;

   ELSIF UPDATING 
   THEN
      :NEW.created_by    := :OLD.created_by;
      :NEW.created_date  := :OLD.created_date;
   END IF;
   
   :NEW.modified_by   := v_user;
   :NEW.modified_date := v_date;

END BEFORE EACH ROW;

END instructor_compound;

-- For Example ch14_9a.sql
CREATE OR REPLACE TRIGGER zipcode_compound
FOR INSERT OR UPDATE ON zipcode
COMPOUND TRIGGER

   v_date DATE;
   v_user VARCHAR2(30);
   v_type VARCHAR2(10);
   
BEFORE STATEMENT IS
BEGIN
   v_date := SYSDATE;
   v_user := USER;
END BEFORE STATEMENT;

BEFORE EACH ROW IS
BEGIN
   IF INSERTING 
   THEN
      :NEW.created_by   := v_user;
      :NEW.created_date := v_date;
   
   ELSIF UPDATING 
   THEN
      :NEW.created_by   := :OLD.created_by;
      :NEW.created_date := :OLD.created_date;
   END IF;
   
   :NEW.modified_by   := v_user;
   :NEW.modified_date := v_date;

END BEFORE EACH ROW;

AFTER STATEMENT IS
BEGIN
   IF INSERTING 
   THEN
      v_type := 'INSERT';

   ELSIF UPDATING 
   THEN 
      v_type := 'UPDATE';
   END IF;
   
   INSERT INTO statistics 
      (table_name, transaction_name, transaction_user, transaction_date)
   VALUES ('ZIPCODE', v_type, v_user, v_date);
                         
END AFTER STATEMENT;

END zipcode_compound;





