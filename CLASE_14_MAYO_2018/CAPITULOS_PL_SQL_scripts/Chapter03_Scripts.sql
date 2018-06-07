-- *** Chapter Exercises *** --
-- For Example  ch03_1a.sql
SET SERVEROUTPUT ON
DECLARE
   v_average_cost VARCHAR2(10);
BEGIN
   SELECT TO_CHAR(AVG(cost), '$9,999.99')
     INTO v_average_cost
     FROM course;
   DBMS_OUTPUT.PUT_LINE('The average cost of a '||
      'course in the CTA program is '||
      v_average_cost);
END; 

-- For Example  ch03_1a.sql
SET SERVEROUTPUT ON
DECLARE
   v_average_cost VARCHAR2(10);
BEGIN
   DBMS_OUTPUT.PUT_LINE('The average cost of a '||
      'course in the CTA program is '||
      v_average_cost);
   SELECT TO_CHAR(AVG(cost), '$9,999.99')
     INTO v_average_cost
     FROM course;
END; 


-- For Example  ch03_2a.sql
SET SERVEROUTPUT ON
DECLARE
   v_city zipcode.city%TYPE;
BEGIN
   SELECT 'COLUMBUS'
     INTO v_city
     FROM dual;
   UPDATE zipcode
      SET city = v_city
    WHERE ZIP = 43224;
END; 

-- For Example  ch03_3a.sql
DECLARE
   v_zip zipcode.zip%TYPE;
   v_user zipcode.created_by%TYPE;
   v_date zipcode.created_date%TYPE;
BEGIN
   SELECT 43438, USER, SYSDATE
     INTO v_zip, v_user, v_date
     FROM dual;
   INSERT INTO zipcode
      (ZIP, CREATED_BY ,CREATED_DATE, MODIFIED_BY,
       MODIFIED_DATE
      )
       VALUES(v_zip, v_user, v_date, v_user, v_date);
END; 

-- For Example  ch03_4a.sql
BEGIN
   SELECT MAX(student_id)
     INTO v_max_id
     FROM student;
   INSERT into student
      (student_id, last_name, zip,
       created_by, created_date,
       modified_by, modified_date,
       registration_date
      )
     VALUES (v_max_id + 1, 'Rosenzweig',
             11238, 'BROSENZ ', '01-JAN-2014',
             'BROSENZ', '10-JAN-2014', '15-FEB-2014'
            );
END; 


-- For Example  ch03_5a.sql
CREATE TABLE test01 (col1 number); 
CREATE SEQUENCE test_seq
   INCREMENT BY 5;
BEGIN
   INSERT INTO test01
      VALUES (test_seq.NEXTVAL);
END;
/
Select * FROM test01;.3 Make Use of a Sequence in a PL/SQL Block



-- For Example  ch03_6a.sql
DECLARE
   v_user student.created_by%TYPE;
   v_date student.created_date%TYPE;
BEGIN
   SELECT USER, sysdate
     INTO  v_user, v_date
     FROM dual;
  INSERT INTO student
     (student_id, last_name, zip,
      created_by, created_date, modified_by, 
      modified_date, registration_date
     )
     VALUES (student_id_seq.nextval, 'Smith',
             11238, v_user, v_date, v_user, v_date,
             v_date
            );
END;

-- For Example  ch03_7a.sql
BEGIN
-- STEP 1
   UPDATE course
      SET cost = cost  - (cost * 0.10)
    WHERE prerequisite IS NULL;
-- STEP 2
   UPDATE course
      SET cost = cost  + (cost * 0.10) 
    WHERE prerequisite IS NOT NULL; 
END;
ch03_8a.sql
BEGIN
INSERT INTO student
   (student_id, last_name, zip, registration_date,
    created_by, created_date, modified_by,
    modified_date
   )
   VALUES (student_id_seq.nextval, 'Tashi', 10015,
           '01-JAN-99', 'STUDENTA', '01-JAN-99',
           'STUDENTA', '01-JAN-99'
          );
END;


-- For Example  ch03_9a.sql
BEGIN
   INSERT INTO student
      ( student_id, Last_name, zip, registration_date,
        created_by, created_date, modified_by,
        modified_date
      )
      VALUES ( student_id_seq.nextval, 'Tashi', 10015, 
               '01-JAN-99', 'STUDENTA', '01-JAN-99',
               'STUDENTA','01-JAN-99'
             );
   SAVEPOINT A;
   INSERT INTO student
      ( student_id, Last_name, zip, registration_date,
        created_by, created_date, modified_by, 
        modified_date
      )
      VALUES (student_id_seq.nextval, 'Sonam', 10015,
              '01-JAN-99', 'STUDENTB','01-JAN-99', 
              'STUDENTB', '01-JAN-99'
             );
   SAVEPOINT B;
   INSERT INTO student
     ( student_id, Last_name, zip, registration_date,
       created_by, created_date, modified_by, 
       modified_date
     )
      VALUES (student_id_seq.nextval, 'Norbu', 10015,
              '01-JAN-99', 'STUDENTB', '01-JAN-99',
              'STUDENTB', '01-JAN-99'
             );
   SAVEPOINT C;
   ROLLBACK TO B; 
END;

-- For Example  ch03_10a.sql
DECLAE
     v_Counter NUMBER;
   BEGIN
     v_counter := 0;
     FOR i IN 1..100 
     LOOP
        v_counter := v_counter + 1;
        IF v_counter = 10
        THEN
           COMMIT;
           v_counter := 0;
        END IF;
     END LOOP;
END;
