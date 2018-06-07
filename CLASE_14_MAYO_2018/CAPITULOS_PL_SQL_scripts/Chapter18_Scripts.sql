-- *** Chapter Exercises *** --
-- For Example ch18_1a.sql
CREATE TABLE test 
   (row_num  NUMBER
   ,row_text VARCHAR2(10));

DECLARE
   -- Define collection types and variables
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;

   row_num_tab  row_num_type;
   row_text_tab row_text_type;

   v_rows NUMBER;

BEGIN
   -- Populate collections
   FOR i IN 1..10 
   LOOP
      row_num_tab(i)  := i;
      row_text_tab(i) := 'row '||i;
   END LOOP;

   -- Populate TEST table 
   FORALL i IN 1..10 
      INSERT INTO test (row_num, row_text)
      VALUES (row_num_tab(i), row_text_tab(i));
   
   COMMIT;

   -- Check how many rows where inserted in the TEST table
   -- display it on the screen
   SELECT COUNT(*) 
     INTO v_rows
     FROM TEST;

   DBMS_OUTPUT.PUT_LINE ('There are '||v_rows||' rows in the TEST table');
END;

For Example ch18_2a.sql
TRUNCATE TABLE test;

DECLARE
   -- Define collection types and variables
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;

   row_num_tab  row_num_type;
   row_text_tab row_text_type;

   v_start_time INTEGER;
   v_end_time   INTEGER;

BEGIN
   -- Populate collections
   FOR i IN 1..100 
   LOOP
      row_num_tab(i)  := i;
      row_text_tab(i) := 'row '||i;
   END LOOP;

   -- Record start time
   v_start_time := DBMS_UTILITY.GET_TIME;

   -- Insert first 100 rows
   FOR i IN 1..100 
   LOOP
      INSERT INTO test (row_num, row_text)
      VALUES (row_num_tab(i), row_text_tab(i));
   END LOOP;

   -- Record end time
   v_end_time := DBMS_UTILITY.GET_TIME; 
 
   -- Calculate and display elapsed time
   DBMS_OUTPUT.PUT_LINE ('Duration of the FOR LOOP: '||
      (v_end_time - v_start_time));

   -- Record start time
   v_start_time := DBMS_UTILITY.GET_TIME;

   -- Insert second 100 rows
   FORALL i IN 1..100 
      INSERT INTO test (row_num, row_text)
      VALUES (row_num_tab(i), row_text_tab(i));

   -- Record end time
   v_end_time := DBMS_UTILITY.GET_TIME; 
 
   -- Calculate and display elapsed time
   DBMS_OUTPUT.PUT_LINE ('Duration of the FORALL statement: '||
      (v_end_time – v_start_time));

   COMMIT;
END;

-- For Example ch18_3a.sql
TRUNCATE TABLE TEST;

DECLARE
   -- Define collection types and variables
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(11) INDEX BY PLS_INTEGER;

   row_num_tab  row_num_type;
   row_text_tab row_text_type;

   -- Define user-defined exception and associated Oracle 
   -- error number with it
   errors EXCEPTION;
   PRAGMA EXCEPTION_INIT(errors, -24381);

   v_rows NUMBER;
BEGIN
   -- Populate collections
   FOR i IN 1..10 
   LOOP
      row_num_tab(i)  := i;
      row_text_tab(i) := 'row '||i;
   END LOOP;

   -- Modify 1, 5, and 7 elements of the V_ROW_TEXT collection
   -- These rows will cause exception in the FORALL statement
   row_text_tab(1) := RPAD(row_text_tab(1), 11, ' ');
   row_text_tab(5) := RPAD(row_text_tab(5), 11, ' ');
   row_text_tab(7) := RPAD(row_text_tab(7), 11, ' ');


   -- Populate TEST table
   FORALL i IN 1..10 SAVE EXCEPTIONS
      INSERT INTO test (row_num, row_text)
      VALUES (row_num_tab(i), row_text_tab(i));
   COMMIT;

EXCEPTION
   WHEN errors 
   THEN
      -- Display total number of records inserted in the TEST table
      SELECT count(*)
        INTO v_rows
        FROM test;

      DBMS_OUTPUT.PUT_LINE ('There are '||v_rows||' records in the TEST table');

      -- Display total number of exceptions encountered
      DBMS_OUTPUT.PUT_LINE ('There were '||SQL%BULK_EXCEPTIONS.COUNT||' exceptions');

      -- Display detailed exception information 
      FOR i in 1.. SQL%BULK_EXCEPTIONS.COUNT LOOP 
         DBMS_OUTPUT.PUT_LINE ('Record '||
            SQL%BULK_EXCEPTIONS(i).error_index||' caused error '||i||': '||
            SQL%BULK_EXCEPTIONS(i).error_code||' '||
            SQLERRM(-SQL%BULK_EXCEPTIONS(i).error_code));
      END LOOP;
END;

-- For Example ch18_4a.sql
TRUNCATE TABLE TEST;

DECLARE
   -- Define collection types and variables
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;

   row_num_tab  row_num_type;
   row_text_tab row_text_type;

   v_rows NUMBER;
BEGIN
   -- Populate collections
   FOR i IN 1..10 
   LOOP
      row_num_tab(i)  := i;
      row_text_tab(i) := 'row '||i;
   END LOOP;

   -- Delete 1, 5, and 7 elements of collections
   row_num_tab.DELETE(1); row_text_tab.DELETE(1);
   row_num_tab.DELETE(5); row_text_tab.DELETE(5);
   row_num_tab.DELETE(7); row_text_tab.DELETE(7);

   -- Populate TEST table
   FORALL i IN INDICES OF row_num_tab
      INSERT INTO test (row_num, row_text)
      VALUES (row_num_tab(i), row_text_tab(i));
   COMMIT;

   SELECT COUNT(*)
     INTO v_rows
     FROM test;

   DBMS_OUTPUT.PUT_LINE ('There are '||v_rows||' rows in the TEST table');
END;

-- For Example ch18_5a.sql
CREATE TABLE TEST_EXC
   (row_num  NUMBER
   ,row_text VARCHAR2(50));

TRUNCATE TABLE TEST;

DECLARE
   -- Define collection types and variables
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(11) INDEX BY PLS_INTEGER;
   TYPE exc_ind_type  IS TABLE OF PLS_INTEGER  INDEX BY PLS_INTEGER;

   row_num_tab  row_num_type;
   row_text_tab row_text_type;
   exc_ind_tab  exc_ind_type;

   -- Define user-defined exception and associated Oracle 
   -- error number with it
   errors EXCEPTION;
   PRAGMA EXCEPTION_INIT(errors, -24381);

BEGIN
   -- Populate collections
   FOR i IN 1..10 
   LOOP
      row_num_tab(i)  := i;
      row_text_tab(i) := 'row '||i;
   END LOOP;

   -- Modify 1, 5, and 7 elements of the ROW_TEXT_TAB collection
   -- These rows will cause exception in the FORALL statement
   row_text_tab(1) := RPAD(row_text_tab(1), 11, ' ');
   row_text_tab(5) := RPAD(row_text_tab(5), 11, ' ');
   row_text_tab(7) := RPAD(row_text_tab(7), 11, ' ');

   -- Populate TEST table
   FORALL i IN 1..10 SAVE EXCEPTIONS
      INSERT INTO test (row_num, row_text)
      VALUES (row_num_tab(i), row_text_tab(i));
   COMMIT;

EXCEPTION
   WHEN errors 
   THEN
      -- Populate EXC_IND_TAB collection to be used in the VALUES OF 
      -- clause
      FOR i in 1..SQL%BULK_EXCEPTIONS.COUNT 
      LOOP 
         exc_ind_tab(i) := SQL%BULK_EXCEPTIONS(i).error_index;
      END LOOP;

      -- Insert records that caused exceptions in the TEST_EXC table
      FORALL i in VALUES OF exc_ind_tab
         INSERT INTO test_exc (row_num, row_text)
         VALUES (row_num_tab(i), row_text_tab(i));
   COMMIT;
END;

-- For Example ch18_6a.sql
DECLARE
   CURSOR student_cur IS
      SELECT student_id, first_name, last_name
        FROM student;
BEGIN
   FOR rec IN student_cur 
   LOOP
      DBMS_OUTPUT.PUT_LINE ('student_id: '||rec.student_id);
      DBMS_OUTPUT.PUT_LINE ('first_name: '||rec.first_name);
      DBMS_OUTPUT.PUT_LINE ('last_name:  '||rec.last_name);
   END LOOP;
END;

-- For Example ch18_6b.sql
DECLARE
   -- Define collection type and variables to be used by the
   -- BULK COLLECT clause
   TYPE student_id_type IS TABLE OF student.student_id%TYPE;
   TYPE first_name_type IS TABLE OF student.first_name%TYPE;
   TYPE last_name_type  IS TABLE OF student.last_name%TYPE;

   student_id_tab student_id_type;
   first_name_tab first_name_type;
   last_name_tab  last_name_type;

BEGIN
   -- Fetch all student data at once via BULK COLLECT clause
   SELECT student_id, first_name, last_name
     BULK COLLECT INTO student_id_tab, first_name_tab, last_name_tab
     FROM student;

   FOR i IN student_id_tab.FIRST..student_id_tab.LAST
   LOOP
      DBMS_OUTPUT.PUT_LINE ('student_id: '||student_id_tab(i));
      DBMS_OUTPUT.PUT_LINE ('first_name: '||first_name_tab(i));
      DBMS_OUTPUT.PUT_LINE ('last_name:  '||last_name_tab(i));
   END LOOP;
END;

-- For Example ch18_6c.sql
DECLARE
   CURSOR student_cur IS
      SELECT student_id, first_name, last_name
        FROM student;

   -- Define collection type and variables to be used by the
   -- BULK COLLECT clause
   TYPE student_id_type IS TABLE OF student.student_id%TYPE;
   TYPE first_name_type IS TABLE OF student.first_name%TYPE;
   TYPE last_name_type  IS TABLE OF student.last_name%TYPE;

   student_id_tab student_id_type;
   first_name_tab first_name_type;
   last_name_tab  last_name_type;

   -- Define variable to be used by the LIMIT clause
   v_limit PLS_INTEGER := 50;
 
BEGIN
   OPEN student_cur;
   LOOP
      -- Fetch 50 rows at once
      FETCH student_cur 
       BULK COLLECT INTO student_id_tab, first_name_tab, last_name_tab 
      LIMIT v_limit;
    
      EXIT WHEN student_id_tab.COUNT = 0;

      FOR i IN student_id_tab.FIRST..student_id_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE ('student_id: '||student_id_tab(i));
         DBMS_OUTPUT.PUT_LINE ('first_name: '||first_name_tab(i));
         DBMS_OUTPUT.PUT_LINE ('last_name:  '||last_name_tab(i));
      END LOOP;
   END LOOP;
   CLOSE student_cur;
END;

-- For Example ch18_6d.sql
DECLARE
   CURSOR student_cur IS
      SELECT student_id, first_name, last_name
        FROM student;

   -- Define record type
   TYPE student_rec IS RECORD
      (student_id student.student_id%TYPE,
       first_name student.first_name%TYPE,
       last_name  student.last_name%TYPE);

   -- Define collection type 
   TYPE student_type IS TABLE OF student_rec;

   -- Define collection variable
   student_tab student_type;

   -- Define variable to be used by the LIMIT clause
   v_limit PLS_INTEGER := 50;
 
BEGIN
   OPEN student_cur;
   LOOP
      -- Fetch 50 rows at once
      FETCH student_cur BULK COLLECT INTO student_tab LIMIT v_limit;
    
      EXIT WHEN student_tab.COUNT = 0;

      FOR i IN student_tab.FIRST..student_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE ('student_id: '||student_tab(i).student_id);
         DBMS_OUTPUT.PUT_LINE ('first_name: '||student_tab(i).first_name);
         DBMS_OUTPUT.PUT_LINE ('last_name:  '||student_tab(i).last_name);
      END LOOP;
   END LOOP;
   CLOSE student_cur;
END;

-- For Example ch18_7a.sql
DECLARE
   -- Define collection types and variables
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;

   row_num_tab  row_num_type;
   row_text_tab row_text_type;

BEGIN
   DELETE FROM test
   RETURNING row_num, row_text 
   BULK COLLECT INTO row_num_tab, row_text_tab;

   DBMS_OUTPUT.PUT_LINE ('Deleted '||SQL%ROWCOUNT||' rows:');
   
   FOR i IN row_num_tab.FIRST..row_num_tab.LAST
   LOOP
      DBMS_OUTPUT.PUT_LINE 
         ('row_num = '||row_num_tab(i)||' row_text = ' ||row_text_tab(i));
   END LOOP;

   COMMIT;
END;

-- For Example ch18_8a.sql
DECLARE
   -- Define collection types and variables
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;

   row_num_tab  row_num_type;
   row_text_tab row_text_type;

BEGIN
   SELECT row_num, row_text 
     BULK COLLECT INTO row_num_tab, row_text_tab
     FROM test;

   FOR i IN row_num_tab.FIRST..row_num_tab.LAST
   LOOP
      DBMS_OUTPUT.PUT_LINE 
         ('row_num = '||row_num_tab(i)||' row_text = ' ||row_text_tab(i));
   END LOOP;
END;

-- For Example ch18_8b.sql
DECLARE
   -- Define collection types and variables
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;

   row_num_tab  row_num_type;
   row_text_tab row_text_type;

BEGIN
   SELECT row_num, row_text 
     BULK COLLECT INTO row_num_tab, row_text_tab
     FROM test;

   IF row_num_tab.COUNT != 0
   THEN
      FOR i IN row_num_tab.FIRST..row_num_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE 
            ('row_num = '||row_num_tab(i)||' row_text = ' ||row_text_tab(i));
      END LOOP;
   ELSE
      DBMS_OUTPUT.PUT_LINE ('row_num_tab.COUNT  = '||row_num_tab.COUNT);
      DBMS_OUTPUT.PUT_LINE ('row_text_tab.COUNT = '||row_text_tab.COUNT);
   END IF;
END;

-- For Example ch18_9a.sql
CREATE TABLE my_zipcode AS
SELECT * 
  FROM zipcode
 WHERE 1 = 2; 

DECLARE
   -- Declare collection types 
   TYPE string_type IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
   TYPE date_type   IS TABLE OF DATE          INDEX BY PLS_INTEGER;

   -- Declare collection variables to be used by the FORALL statement
   zip_tab      string_type;
   city_tab     string_type;
   state_tab    string_type;
   cr_by_tab    string_type;
   cr_date_tab  date_type;
   mod_by_tab   string_type;
   mod_date_tab date_type;

   v_rows INTEGER := 0;

BEGIN
   -- Populate individual collections 
   SELECT *
     BULK COLLECT INTO zip_tab, city_tab, state_tab, cr_by_tab,
        cr_date_tab, mod_by_tab, mod_date_tab
     FROM zipcode
    WHERE state = 'CT';

   -- Populate MY_ZIPCODE table
   FORALL i in 1..zip_tab.COUNT
      INSERT INTO my_zipcode 
         (zip, city, state, created_by, created_date, modified_by,
          modified_date)
      VALUES
         (zip_tab(i), city_tab(i), state_tab(i), cr_by_tab(i), 
          cr_date_tab(i), mod_by_tab(i), mod_date_tab(i));
   COMMIT;

   -- Check how many records were added to MY_ZIPCODE table
   SELECT COUNT(*)
     INTO v_rows
     FROM my_zipcode;

   DBMS_OUTPUT.PUT_LINE (v_rows||' records were added to MY_ZIPCODE table'); 
END;

-- For Example ch18_10a.sql
DECLARE
   -- Declare collection types 
   TYPE string_type IS TABLE OF VARCHAR2(100);

   -- Declare collection variables to be used by the FORALL statement
   -- and BULK COLLECT clause
   zip_codes string_type := string_type ('06401', '06455', '06483', '06520', '06605');
   zip_tab   string_type;
   city_tab  string_type;

   v_rows INTEGER := 0;

BEGIN
   -- Delete some records from MY_ZIPCODE table
   FORALL i in zip_codes.FIRST..zip_codes.LAST
      DELETE FROM my_zipcode
       WHERE zip = zip_codes(i)
      RETURNING zip, city
      BULK COLLECT INTO zip_tab, city_tab;
   COMMIT;

   DBMS_OUTPUT.PUT_LINE ('The following records were deleted from MY_ZIPCODE table:');
   FOR i in zip_tab.FIRST..zip_tab.LAST
   LOOP
      DBMS_OUTPUT.PUT_LINE ('Zip code '||zip_tab(i)||', city '||city_tab(i));
   END LOOP;
END;

-- Listing 18.3 TEST_ADM_PKG Package with Collection Types
CREATE OR REPLACE PACKAGE test_adm_pkg 
AS
   -- Define collection types 
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;

   -- Define procedures
   PROCEDURE populate_test (row_num_tab  ROW_NUM_TYPE
                           ,row_num_type ROW_TEXT_TYPE);
                           
   PROCEDURE update_test (row_num_tab  ROW_NUM_TYPE
                         ,row_num_type ROW_TEXT_TYPE);                         
                         
   PROCEDURE delete_test (row_num_tab ROW_NUM_TYPE);                      
END test_adm_pkg;
/

CREATE OR REPLACE PACKAGE BODY test_adm_pkg 
AS
   PROCEDURE populate_test (row_num_tab  ROW_NUM_TYPE
                           ,row_num_type ROW_TEXT_TYPE)                           
   IS                        
   BEGIN
      FORALL i IN 1..10
         INSERT INTO test (row_num, row_text) 
         VALUES (row_num_tab(i), row_num_type(i));
   END populate_test;

   PROCEDURE update_test (row_num_tab  ROW_NUM_TYPE
                         ,row_num_type ROW_TEXT_TYPE)                           
   IS                        
   BEGIN
      FORALL i IN 1..10
         UPDATE test 
            SET row_text = row_num_type(i) 
          WHERE row_num = row_num_tab(i);
   END update_test;

   PROCEDURE delete_test (row_num_tab ROW_NUM_TYPE)                           
   IS                        
   BEGIN
      FORALL i IN 1..10
         DELETE from test 
          WHERE row_num = row_num_tab(i);
   END delete_test;

END test_adm_pkg;
/

-- For Example ch18_11a.sql
DECLARE
   row_num_tab  test_adm_pkg.row_num_type;
   row_text_tab test_adm_pkg.row_text_type;

   v_rows NUMBER;

BEGIN
   -- Populate collections
   FOR i IN 1..10 
   LOOP
      row_num_tab(i)  := i;
      row_text_tab(i) := 'row '||i;
   END LOOP;

   -- Delete previously added data from the TEST table
   test_adm_pkg.delete_test (row_num_tab);

   -- Populate TEST table 
   test_adm_pkg.populate_test (row_num_tab, row_text_tab); 
   COMMIT;

   -- Check how many rows where inserted in the TEST table
   -- display it on the screen
   SELECT COUNT(*) 
     INTO v_rows
     FROM TEST;

   DBMS_OUTPUT.PUT_LINE ('There are '||v_rows||' rows in the TEST table');
END;

-- For Example ch18_11b.sql
DECLARE
   row_num_tab  test_adm_pkg.row_num_type;
   row_text_tab test_adm_pkg.row_text_type;

   v_dyn_sql VARCHAR2(1000);
   v_rows NUMBER;

BEGIN
   -- Populate collections
   FOR i IN 1..10 
   LOOP
      row_num_tab(i)  := i;
      row_text_tab(i) := 'row '||i;
   END LOOP;

   -- Delete previously added data from the TEST table
   v_dyn_sql := 'begin test_adm_pkg.delete_test (:row_num_tab); end;';
   EXECUTE IMMEDIATE v_dyn_sql USING row_num_tab;

   -- Populate TEST table 
   v_dyn_sql := 'begin test_adm_pkg.populate_test (:row_num_tab, :row_text_tab); end;';
   EXECUTE IMMEDIATE v_dyn_sql USING row_num_tab, row_text_tab;
   COMMIT;

   -- Check how many rows where inserted in the TEST table
   -- display it on the screen
   SELECT COUNT(*) 
     INTO v_rows
     FROM TEST;

   DBMS_OUTPUT.PUT_LINE ('There are '||v_rows||' rows in the TEST table');
END;

-- For Example ch18_11c.sql
DECLARE
   row_num_tab  test_adm_pkg.row_num_type;
   row_text_tab test_adm_pkg.row_text_type;

   v_dyn_sql VARCHAR2(1000);
   v_rows NUMBER;

BEGIN
   -- Populate collections
   FOR i IN 1..10 
   LOOP
      row_num_tab(i)  := i;
      row_text_tab(i) := 'row '||i;
   END LOOP;

   -- Delete previously added data from the TEST table
   v_dyn_sql := 'test_adm_pkg.delete_test (:row_num_tab);';
   EXECUTE IMMEDIATE v_dyn_sql USING row_num_tab;

   -- Populate TEST table 
   v_dyn_sql := 'test_adm_pkg.populate_test (:row_num_tab, :row_text_tab);';
   EXECUTE IMMEDIATE v_dyn_sql USING row_num_tab, row_text_tab;
   COMMIT;

   -- Check how many rows where inserted in the TEST table
   -- display it on the screen
   SELECT COUNT(*) 
     INTO v_rows
     FROM TEST;

   DBMS_OUTPUT.PUT_LINE ('There are '||v_rows||' rows in the TEST table');
END;

-- Listing 18.4 TEST_ADM_PKG Package with Record Type
CREATE OR REPLACE PACKAGE test_adm_pkg 
AS
   -- Define collection types 
   TYPE row_num_type  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
   TYPE row_text_type IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;

   -- Define record type
   TYPE rec_type IS RECORD
      (row_num  NUMBER
      ,row_text VARCHAR2(10));

   -- Define procedures
   PROCEDURE populate_test (row_num_tab  ROW_NUM_TYPE
                           ,row_num_type ROW_TEXT_TYPE);
                           
   PROCEDURE update_test (row_num_tab  ROW_NUM_TYPE
                         ,row_num_type ROW_TEXT_TYPE);                         
                         
   PROCEDURE delete_test (row_num_tab ROW_NUM_TYPE); 

   PROCEDURE populate_test_rec (row_num_val IN NUMBER
                               ,test_rec   OUT REC_TYPE);                     
END test_adm_pkg;
/

CREATE OR REPLACE PACKAGE BODY test_adm_pkg 
AS
   PROCEDURE populate_test (row_num_tab  ROW_NUM_TYPE
                           ,row_num_type ROW_TEXT_TYPE)                           
   IS                        
   BEGIN
      FORALL i IN 1..10
         INSERT INTO test (row_num, row_text) 
         VALUES (row_num_tab(i), row_num_type(i));
   END populate_test;

   PROCEDURE update_test (row_num_tab  ROW_NUM_TYPE
                         ,row_num_type ROW_TEXT_TYPE)                           
   IS                        
   BEGIN
      FORALL i IN 1..10
         UPDATE test 
            SET row_text = row_num_type(i) 
          WHERE row_num = row_num_tab(i);
   END update_test;

   PROCEDURE delete_test (row_num_tab ROW_NUM_TYPE)                           
   IS                        
   BEGIN
      FORALL i IN 1..10
         DELETE from test 
          WHERE row_num = row_num_tab(i);
   END delete_test;

   PROCEDURE populate_test_rec (row_num_val IN NUMBER
                               ,test_rec   OUT REC_TYPE)
   IS
   BEGIN
      SELECT *
        INTO test_rec
        FROM test
       WHERE row_num = row_num_val;
   END populate_test_rec;

END test_adm_pkg;
/

-- For Example ch18_12a.sql
DECLARE
   test_rec test_adm_pkg.rec_type;
   
   v_dyn_sql VARCHAR2(1000);

BEGIN
   -- Select record from the TEST table 
   v_dyn_sql := 'begin test_adm_pkg.populate_test_rec (:val, :rec); end;';
   EXECUTE IMMEDIATE v_dyn_sql USING IN 10, OUT test_rec;
   COMMIT;

   -- Display newly selected record
   DBMS_OUTPUT.PUT_LINE ('test_rec.row_num  = '||test_rec.row_num);
   DBMS_OUTPUT.PUT_LINE ('test_rec.row_text = '||test_rec.row_text);
END;

-- For Example ch18_13a.sql
DECLARE
   TYPE student_cur_typ IS REF CURSOR;

   student_cur student_cur_typ; 
   student_rec student%ROWTYPE;
   
   v_zip_code student.zip%TYPE := '06820';

BEGIN
   OPEN student_cur 
    FOR 'SELECT * FROM student WHERE zip = :my_zip' USING v_zip_code;

   LOOP
      FETCH student_cur INTO student_rec;
      EXIT WHEN student_cur%NOTFOUND;

      -- Display student ID, first and last names
      DBMS_OUTPUT.PUT_LINE ('student_rec.student_id = '||student_rec.student_id);
      DBMS_OUTPUT.PUT_LINE ('student_rec.first_name = '||student_rec.first_name);
      DBMS_OUTPUT.PUT_LINE ('student_rec.last_name  = '||student_rec.last_name);
   END LOOP;
   CLOSE student_cur;
END;

-- Listing 18.5 STUDENT_ADM_PKG Package with Record and Collection Types
CREATE OR REPLACE PACKAGE student_adm_pkg
AS
   -- Define collection type
   TYPE student_tab_type IS TABLE OF student%ROWTYPE INDEX BY PLS_INTEGER;

   -- Define procedures
   PROCEDURE populate_student_tab (zip_code     IN VARCHAR2
                                  ,student_tab OUT student_tab_type);
                                  
   PROCEDURE display_student_info (student_rec student%ROWTYPE);                                  

END student_adm_pkg;
/

CREATE OR REPLACE PACKAGE BODY student_adm_pkg 
AS
   PROCEDURE populate_student_tab (zip_code     IN VARCHAR2
                                  ,student_tab OUT student_tab_type)

   IS                        
   BEGIN
      SELECT *
        BULK COLLECT INTO student_tab
        FROM student
       WHERE zip = zip_code;
   END populate_student_tab;
   
   PROCEDURE display_student_info (student_rec student%ROWTYPE)
   IS                        
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('student_rec.zip =        '||student_rec.zip);
      DBMS_OUTPUT.PUT_LINE ('student_rec.student_id = '||student_rec.student_id);
      DBMS_OUTPUT.PUT_LINE ('student_rec.first_name = '||student_rec.first_name);
      DBMS_OUTPUT.PUT_LINE ('student_rec.last_name  = '||student_rec.last_name);
   END display_student_info;

END student_adm_pkg;
/

-- For Example ch18_13b.sql
DECLARE
   TYPE student_cur_typ IS REF CURSOR;
   student_cur student_cur_typ; 

   -- Collection and record variables
   student_tab student_adm_pkg.student_tab_type;
   student_rec student%ROWTYPE;
   
BEGIN
   -- Populate collection of records
   student_adm_pkg.populate_student_tab ('06820', student_tab);
      
   OPEN student_cur 
    FOR 'SELECT * FROM TABLE(:my_table)' USING student_tab;
  
   LOOP
      FETCH student_cur INTO student_rec;
      EXIT WHEN student_cur%NOTFOUND;
      
      student_adm_pkg.display_student_info (student_rec);
   END LOOP;   
   CLOSE student_cur;
END;

-- *** Web Chapter Exercises *** --
-- For Example ch18_9b.sql
DECLARE
   -- Declare collection types 
   TYPE string_type IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
   TYPE date_type   IS TABLE OF DATE          INDEX BY PLS_INTEGER;

   -- Declare collection variables to be used by the FORALL statement
   zip_tab      string_type;
   city_tab     string_type;
   state_tab    string_type;
   cr_by_tab    string_type;
   cr_date_tab  date_type;
   mod_by_tab   string_type;
   mod_date_tab date_type;

   v_counter PLS_INTEGER := 0;
   v_total   INTEGER := 0;

   -- Define user-defined exception and associated Oracle error number with it
   errors EXCEPTION;
   PRAGMA EXCEPTION_INIT(errors, -24381);

BEGIN
   -- Populate individual collections 
   SELECT *
     BULK COLLECT INTO zip_tab, city_tab, state_tab, cr_by_tab,
        cr_date_tab, mod_by_tab, mod_date_tab
     FROM zipcode
    WHERE state = 'MA';

   -- Modify individual collection records to produce various exceptions
   zip_tab(1)     := NULL;
   city_tab(2)    := RPAD(city_tab(2), 26, ' ');
   state_tab(3)   := SYSDATE;
   cr_by_tab(4)   := RPAD(cr_by_tab(4), 31, ' ');
   cr_date_tab(5) := NULL;   

   -- Populate MY_ZIPCODE table
   FORALL i in 1..zip_tab.COUNT SAVE EXCEPTIONS
      INSERT INTO my_zipcode 
         (zip, city, state, created_by, created_date, modified_by, modified_date)
      VALUES
         (zip_tab(i), city_tab(i), state_tab(i), cr_by_tab(i), cr_date_tab(i)
         ,mod_by_tab(i), mod_date_tab(i));
   COMMIT;

   -- Check how many records were added to MY_ZIPCODE table
   SELECT COUNT(*)
     INTO v_total
     FROM my_zipcode
    WHERE state = 'MA';

   DBMS_OUTPUT.PUT_LINE (v_total||' records were added to MY_ZIPCODE table'); 

EXCEPTION
   WHEN errors 
   THEN
      -- Display total number of exceptions encountered
      DBMS_OUTPUT.PUT_LINE 
         ('There were '||SQL%BULK_EXCEPTIONS.COUNT||' exceptions');

      -- Display detailed exception information 
      FOR i in 1.. SQL%BULK_EXCEPTIONS.COUNT 
      LOOP 
         DBMS_OUTPUT.PUT_LINE ('Record '||
            SQL%BULK_EXCEPTIONS(i).error_index||' caused error '||i||
            ': '||SQL%BULK_EXCEPTIONS(i).ERROR_CODE||' '||
            SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
      END LOOP;

      -- Commit records if any that were inserted successfully
      COMMIT;
END;

-- For Example ch18_9c.sql
DECLARE
   -- Declare collection types 
   TYPE string_type IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
   TYPE date_type   IS TABLE OF DATE          INDEX BY PLS_INTEGER;

   -- Declare collection variables to be used by the FORALL statement
   zip_tab      string_type;
   city_tab     string_type;
   state_tab    string_type;
   cr_by_tab    string_type;
   cr_date_tab  date_type;
   mod_by_tab   string_type;
   mod_date_tab date_type;

   v_counter PLS_INTEGER := 0;
   v_total   INTEGER := 0;

   -- Define user-defined exception and associated Oracle error number with it
   errors EXCEPTION;
   PRAGMA EXCEPTION_INIT(errors, -24381);

BEGIN
   -- Populate individual collections 
   SELECT *
     BULK COLLECT INTO zip_tab, city_tab, state_tab, cr_by_tab,
        cr_date_tab, mod_by_tab, mod_date_tab
     FROM zipcode
    WHERE state = 'MA';

   -- Delete first 3 records from each collection
   zip_tab.DELETE(1,3); 
   city_tab.DELETE(1,3);
   state_tab.DELETE(1,3);
   cr_by_tab.DELETE(1,3);
   cr_date_tab.DELETE(1,3);
   mod_by_tab.DELETE(1,3);
   mod_date_tab.DELETE(1,3);

   -- Populate MY_ZIPCODE table
   FORALL i IN INDICES OF zip_tab SAVE EXCEPTIONS
      INSERT INTO my_zipcode 
         (zip, city, state, created_by, created_date, modified_by, modified_date)
      VALUES
         (zip_tab(i), city_tab(i), state_tab(i), cr_by_tab(i), cr_date_tab(i)
         ,mod_by_tab(i), mod_date_tab(i));
   COMMIT;

   -- Check how many records were added to MY_ZIPCODE table
   SELECT COUNT(*)
     INTO v_total
     FROM my_zipcode
    WHERE state = 'MA';

   DBMS_OUTPUT.PUT_LINE (v_total||' records were added to MY_ZIPCODE table'); 

EXCEPTION
   WHEN errors 
   THEN
      -- Display total number of exceptions encountered
      DBMS_OUTPUT.PUT_LINE 
         ('There were '||SQL%BULK_EXCEPTIONS.COUNT||' exceptions');

      -- Display detailed exception information 
      FOR i in 1.. SQL%BULK_EXCEPTIONS.COUNT LOOP 
         DBMS_OUTPUT.PUT_LINE ('Record '||
            SQL%BULK_EXCEPTIONS(i).error_index||' caused error '||i||
            ': '||SQL%BULK_EXCEPTIONS(i).ERROR_CODE||' '||
            SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
      END LOOP;

      -- Commit records if any that were inserted successfully
      COMMIT;
END;

-- For Example ch18_9d.sql
DECLARE
   -- Declare collection types 
   TYPE string_type  IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
   TYPE date_type    IS TABLE OF DATE          INDEX BY PLS_INTEGER;
   TYPE exc_ind_type IS TABLE OF PLS_INTEGER   INDEX BY PLS_INTEGER;

   -- Declare collection variables to be used by the FORALL statement
   zip_tab      string_type;
   city_tab     string_type;
   state_tab    string_type;
   cr_by_tab    string_type;
   cr_date_tab  date_type;
   mod_by_tab   string_type;
   mod_date_tab date_type;
   exc_ind_tab  exc_ind_type;

   v_counter PLS_INTEGER := 0;
   v_total   INTEGER := 0;

   -- Define user-defined exception and associated Oracle error number with it
   errors EXCEPTION;
   PRAGMA EXCEPTION_INIT(errors, -24381);

BEGIN
   -- Populate individual collections 
   SELECT *
     BULK COLLECT INTO zip_tab, city_tab, state_tab, cr_by_tab,
        cr_date_tab, mod_by_tab, mod_date_tab
     FROM zipcode
    WHERE state = 'MA';

   -- Modify individual collection records to produce various exceptions
   zip_tab(1)     := NULL;
   city_tab(2)    := RPAD(city_tab(2), 26, ' ');
   state_tab(3)   := SYSDATE;
   cr_by_tab(4)   := RPAD(cr_by_tab(4), 31, ' ');
   cr_date_tab(5) := NULL;   

   -- Populate MY_ZIPCODE table
   FORALL i in 1..zip_tab.COUNT SAVE EXCEPTIONS
      INSERT INTO my_zipcode 
         (zip, city, state, created_by, created_date, modified_by, modified_date)
      VALUES
         (zip_tab(i), city_tab(i), state_tab(i), cr_by_tab(i), cr_date_tab(i)
         ,mod_by_tab(i), mod_date_tab(i));
   COMMIT;

   -- Check how many records were added to MY_ZIPCODE table
   SELECT COUNT(*)
     INTO v_total
     FROM my_zipcode
    WHERE state = 'MA';

   DBMS_OUTPUT.PUT_LINE (v_total||' records were added to MY_ZIPCODE table'); 

EXCEPTION
   WHEN errors 
   THEN
      -- Populate V_EXC_IND_TAB collection to be used in the VALUES OF clause
      FOR i in 1.. SQL%BULK_EXCEPTIONS.COUNT 
      LOOP 
         exc_ind_tab(i) := SQL%BULK_EXCEPTIONS(i).error_index;
      END LOOP;

      -- Insert records that caused exceptions in the MY_ZIPCODE_EXC table
      FORALL i in VALUES OF exc_ind_tab
         INSERT INTO my_zipcode_exc 
            (zip, city, state, created_by, created_date, modified_by, modified_date)
         VALUES
            (zip_tab(i), city_tab(i), state_tab(i), cr_by_tab(i), cr_date_tab(i)
            ,mod_by_tab(i), mod_date_tab(i));

      COMMIT;
END;

-- For Example ch18_14a.sql
DECLARE
   -- Define collection types and variables to be used by the BULK COLLECT clause
   TYPE instructor_id_type IS TABLE OF my_instructor.instructor_id%TYPE;
   TYPE first_name_type    IS TABLE OF my_instructor.first_name%TYPE;
   TYPE last_name_type     IS TABLE OF my_instructor.last_name%TYPE;

   instructor_id_tab instructor_id_type;
   first_name_tab    first_name_type;
   last_name_tab     last_name_type;

BEGIN
   -- Fetch all instructor data at once via BULK COLLECT clause
   SELECT instructor_id, first_name, last_name
     BULK COLLECT INTO instructor_id_tab, first_name_tab, last_name_tab
     FROM my_instructor;

   FOR i IN instructor_id_tab.FIRST..instructor_id_tab.LAST
   LOOP
      DBMS_OUTPUT.PUT_LINE ('instructor_id: '||instructor_id_tab(i));
      DBMS_OUTPUT.PUT_LINE ('first_name:    '||first_name_tab(i));
      DBMS_OUTPUT.PUT_LINE ('last_name:     '||last_name_tab(i));
   END LOOP;
END;

-- For Example ch18_14b.sql
DECLARE
   -- Define collection types and variables to be used by the
   -- BULK COLLECT clause
   TYPE instructor_id_type IS TABLE OF my_instructor.instructor_id%TYPE;
   TYPE first_name_type    IS TABLE OF my_instructor.first_name%TYPE;
   TYPE last_name_type     IS TABLE OF my_instructor.last_name%TYPE;

   instructor_id_tab instructor_id_type;
   first_name_tab    first_name_type;
   last_name_tab     last_name_type;

BEGIN
   -- Fetch all instructor data at once via BULK COLLECT clause
   SELECT instructor_id, first_name, last_name
     BULK COLLECT INTO instructor_id_tab, first_name_tab, last_name_tab
     FROM my_instructor;

   IF instructor_id_tab.COUNT > 0 
   THEN
      FOR i IN instructor_id_tab.FIRST..instructor_id_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE ('instructor_id: '||instructor_id_tab(i));
         DBMS_OUTPUT.PUT_LINE ('first_name:    '||first_name_tab(i));
         DBMS_OUTPUT.PUT_LINE ('last_name:     '||last_name_tab(i));
      END LOOP;
   END IF;
END;

-- For Example ch18_14c.sql
DECLARE
   CURSOR instructor_cur IS
      SELECT instructor_id, first_name, last_name
        FROM my_instructor;

   -- Define collection types and variables to be used by the BULK COLLECT clause
   TYPE instructor_id_type IS TABLE OF my_instructor.instructor_id%TYPE;
   TYPE first_name_type    IS TABLE OF my_instructor.first_name%TYPE;
   TYPE last_name_type     IS TABLE OF my_instructor.last_name%TYPE;

   instructor_id_tab instructor_id_type;
   first_name_tab    first_name_type;
   last_name_tab     last_name_type;

   v_limit PLS_INTEGER := 5;
BEGIN
   OPEN instructor_cur;
   LOOP
      -- Fetch partial instructor data at once via BULK COLLECT clause
      FETCH instructor_cur
       BULK COLLECT INTO instructor_id_tab, first_name_tab, last_name_tab
      LIMIT v_limit;
  
      EXIT WHEN instructor_id_tab.COUNT = 0;

      FOR i IN instructor_id_tab.FIRST..instructor_id_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE ('instructor_id: '||instructor_id_tab(i));
         DBMS_OUTPUT.PUT_LINE ('first_name:    '||first_name_tab(i));
         DBMS_OUTPUT.PUT_LINE ('last_name:     '||last_name_tab(i));
      END LOOP;
   END LOOP;
   CLOSE instructor_cur;
END;

-- For Example ch18_14d.sql
DECLARE
   CURSOR instructor_cur IS
      SELECT instructor_id, first_name, last_name
        FROM my_instructor;

   -- Define record type
   TYPE instructor_rec IS RECORD
      (instructor_id my_instructor.instructor_id%TYPE,
       first_name    my_instructor.first_name%TYPE,
       last_name     my_instructor.last_name%TYPE);

   -- Define collection type and variable to be used by the BULK COLLECT clause
   TYPE instructor_type IS TABLE OF instructor_rec;
   
   instructor_tab instructor_type;

   v_limit PLS_INTEGER := 5;
BEGIN
   OPEN instructor_cur;
   LOOP
      -- Fetch partial instructor data at once via BULK COLLECT clause
      FETCH instructor_cur 
       BULK COLLECT INTO instructor_tab 
      LIMIT v_limit;
  
      EXIT WHEN instructor_tab.COUNT = 0;

      FOR i IN instructor_tab.FIRST..instructor_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE ('instructor_id: '||instructor_tab(i).instructor_id);
         DBMS_OUTPUT.PUT_LINE ('first_name:    '||instructor_tab(i).first_name);
         DBMS_OUTPUT.PUT_LINE ('last_name:     '||instructor_tab(i).last_name);
      END LOOP;
   END LOOP;
   CLOSE instructor_cur;
END;

-- For Example ch18_14e.sql
DECLARE
   CURSOR instructor_cur IS
      SELECT instructor_id, first_name, last_name
        FROM my_instructor;

   -- Define collection type and variable to be used by the BULK COLLECT clause
   TYPE instructor_type IS TABLE OF instructor_cur%ROWTYPE;
   
   instructor_tab instructor_type;

   v_limit PLS_INTEGER := 5;
BEGIN
   OPEN instructor_cur;
   LOOP
      -- Fetch partial instructor data at once via BULK COLLECT clause
      FETCH instructor_cur 
       BULK COLLECT INTO instructor_tab 
      LIMIT v_limit;
  
      EXIT WHEN instructor_tab.COUNT = 0;

      FOR i IN instructor_tab.FIRST..instructor_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE ('instructor_id: '||instructor_tab(i).instructor_id);
         DBMS_OUTPUT.PUT_LINE ('first_name:    '||instructor_tab(i).first_name);
         DBMS_OUTPUT.PUT_LINE ('last_name:     '||instructor_tab(i).last_name);
      END LOOP;
   END LOOP;
   CLOSE instructor_cur;
END;

-- For Example ch18_15a.sql
DECLARE
   -- Define collection types and variables to be used by the BULK COLLECT clause
   TYPE instructor_id_type IS TABLE OF my_instructor.instructor_id%TYPE;
   TYPE first_name_type    IS TABLE OF my_instructor.first_name%TYPE;
   TYPE last_name_type     IS TABLE OF my_instructor.last_name%TYPE;

   instructor_id_tab instructor_id_type;
   first_name_tab    first_name_type;
   last_name_tab     last_name_type;

BEGIN
   DELETE FROM MY_INSTRUCTOR
   RETURNING instructor_id, first_name, last_name
   BULK COLLECT INTO instructor_id_tab, first_name_tab, last_name_tab;

   DBMS_OUTPUT.PUT_LINE ('Deleted '||SQL%ROWCOUNT||' rows ');
   
   IF instructor_id_tab.COUNT > 0 
   THEN
      FOR i IN instructor_id_tab.FIRST..instructor_id_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE ('instructor_id: '||instructor_id_tab(i));
         DBMS_OUTPUT.PUT_LINE ('first_name:    '||first_name_tab(i));
         DBMS_OUTPUT.PUT_LINE ('last_name:     '||last_name_tab(i));
      END LOOP;
   END IF;
   COMMIT;
END;

-- For Example ch18_16a.sql
DECLARE
   -- Declare collection types 
   TYPE number_type IS TABLE of NUMBER        INDEX BY PLS_INTEGER;
   TYPE string_type IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
   TYPE date_type   IS TABLE OF DATE          INDEX BY PLS_INTEGER;

   -- Declare collection variables to be used by the FORALL statement
   section_id_tab      number_type;
   course_no_tab       number_type;
   section_no_tab      number_type;
   start_date_time_tab date_type;
   location_tab        string_type;
   instructor_id_tab   number_type;
   capacity_tab        number_type;
   cr_by_tab           string_type;
   cr_date_tab         date_type;
   mod_by_tab          string_type;
   mod_date_tab        date_type;

   v_counter PLS_INTEGER := 0;
   v_total   INTEGER := 0;

   -- Define user-defined exception and associated Oracle error number with it
   errors EXCEPTION;
   PRAGMA EXCEPTION_INIT(errors, -24381);

BEGIN
   -- Populate individual collections 
   SELECT *
     BULK COLLECT INTO section_id_tab, course_no_tab, section_no_tab
                      ,start_date_time_tab, location_tab, instructor_id_tab   
                      ,capacity_tab, cr_by_tab, cr_date_tab, mod_by_tab           
                      ,mod_date_tab        
     FROM section; 

   -- Populate MY_SECTION table
   FORALL i in 1..section_id_tab.COUNT SAVE EXCEPTIONS
      INSERT INTO my_section 
         (section_id, course_no, section_no, start_date_time,
          location, instructor_id, capacity, created_by, 
          created_date, modified_by, modified_date)
      VALUES
         (section_id_tab(i), course_no_tab(i), section_no_tab(i), 
          start_date_time_tab(i), location_tab(i), 
          instructor_id_tab(i), capacity_tab(i), cr_by_tab(i), 
          cr_date_tab(i), mod_by_tab(i), mod_date_tab(i));
   COMMIT;

   -- Check how many records were added to MY_SECTION table
   SELECT COUNT(*)
     INTO v_total
     FROM my_section;

   DBMS_OUTPUT.PUT_LINE (v_total||' records were added to MY_SECTION table'); 

EXCEPTION
   WHEN errors 
   THEN
      -- Display total number of exceptions encountered
      DBMS_OUTPUT.PUT_LINE 
         ('There were '||SQL%BULK_EXCEPTIONS.COUNT||' exceptions');

      -- Display detailed exception information 
      FOR i in 1.. SQL%BULK_EXCEPTIONS.COUNT 
      LOOP 
         DBMS_OUTPUT.PUT_LINE ('Record '||
            SQL%BULK_EXCEPTIONS(i).error_index||' caused error '||i||
            ': '||SQL%BULK_EXCEPTIONS(i).ERROR_CODE||' '||
            SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
      END LOOP;

      -- Commit records if any that were inserted successfully
      COMMIT;
END;

-- For Example ch18_16b.sql
DECLARE
   -- Declare collection types 
   TYPE number_type IS TABLE of NUMBER        INDEX BY PLS_INTEGER;
   TYPE string_type IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
   TYPE date_type   IS TABLE OF DATE          INDEX BY PLS_INTEGER;

   -- Declare collection variables to be used by the FORALL statement
   section_id_tab      number_type;
   course_no_tab       number_type;
   section_no_tab      number_type;
   start_date_time_tab date_type;
   location_tab        string_type;
   instructor_id_tab   number_type;
   capacity_tab        number_type;
   cr_by_tab           string_type;
   cr_date_tab         date_type;
   mod_by_tab          string_type;
   mod_date_tab        date_type;
   total_recs_tab      number_type;

   v_counter PLS_INTEGER := 0;
   v_total   INTEGER := 0;

   -- Define user-defined exception and associated Oracle error number with it
   errors EXCEPTION;
   PRAGMA EXCEPTION_INIT(errors, -24381);

BEGIN
   -- Populate individual collections 
   SELECT *
     BULK COLLECT INTO section_id_tab, course_no_tab, section_no_tab
                      ,start_date_time_tab, location_tab, instructor_id_tab   
                      ,capacity_tab, cr_by_tab, cr_date_tab, mod_by_tab           
                      ,mod_date_tab        
     FROM section;

   -- Populate MY_SECTION table
   FORALL i in 1..section_id_tab.COUNT SAVE EXCEPTIONS
      INSERT INTO my_section 
         (section_id, course_no, section_no, start_date_time,
          location, instructor_id, capacity, created_by, 
          created_date, modified_by, modified_date)
      VALUES
         (section_id_tab(i), course_no_tab(i), section_no_tab(i), 
          start_date_time_tab(i), location_tab(i), 
          instructor_id_tab(i), capacity_tab(i), cr_by_tab(i), 
          cr_date_tab(i), mod_by_tab(i), mod_date_tab(i));
   COMMIT;

   -- Check how many records were added to MY_SECTION table
   SELECT COUNT(*)
     INTO v_total
     FROM my_section;

   DBMS_OUTPUT.PUT_LINE 
      (v_total||' records were added to MY_SECTION table'); 

   -- Check how many records were inserted for each course
   -- and display this information 
   -- Fetch data from MY_SECTION table via BULK COLLECT clause
   SELECT course_no, COUNT(*)
     BULK COLLECT INTO course_no_tab, total_recs_tab 
     FROM my_section
   GROUP BY course_no;

   IF course_no_tab.COUNT > 0 THEN
      FOR i IN course_no_tab.FIRST..course_no_tab.LAST
      LOOP
         DBMS_OUTPUT.PUT_LINE 
            ('course_no: '||course_no_tab(i)||
             ', total sections: '||total_recs_tab(i));
      END LOOP;
   END IF;

EXCEPTION
   WHEN errors 
   THEN
      -- Display total number of exceptions encountered
      DBMS_OUTPUT.PUT_LINE 
         ('There were '||SQL%BULK_EXCEPTIONS.COUNT||' exceptions');

      -- Display detailed exception information 
      FOR i in 1.. SQL%BULK_EXCEPTIONS.COUNT 
      LOOP 
         DBMS_OUTPUT.PUT_LINE ('Record '||
            SQL%BULK_EXCEPTIONS(i).error_index||' caused error '||i||
            ': '||SQL%BULK_EXCEPTIONS(i).ERROR_CODE||' '||
            SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
      END LOOP;

      -- Commit records if any that were inserted successfully
      COMMIT;
END;

For Example ch18_17a.sql
DECLARE
   -- Define collection types and variables to be used by the BULK COLLECT clause
   TYPE section_id_type IS TABLE OF my_section.section_id%TYPE;

   section_id_tab section_id_type;

BEGIN
   FOR rec IN (SELECT UNIQUE course_no
                 FROM my_section)
   LOOP
      DELETE FROM MY_SECTION
       WHERE course_no = rec.course_no
      RETURNING section_id
      BULK COLLECT INTO section_id_tab;

      DBMS_OUTPUT.PUT_LINE ('Deleted '||SQL%ROWCOUNT||
         ' rows for course '||rec.course_no);
   
      IF section_id_tab.COUNT > 0 
      THEN
         FOR i IN section_id_tab.FIRST..section_id_tab.LAST
         LOOP
            DBMS_OUTPUT.PUT_LINE ('section_id: '||section_id_tab(i));
         END LOOP;
         DBMS_OUTPUT.PUT_LINE ('===============================');
      END IF;
      COMMIT;
   END LOOP;
END;
