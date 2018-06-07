-- *** Chapter Exercises *** --
-- For Example ch17_1.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
   sql_stmt VARCHAR2(200);
   v_student_id NUMBER := &sv_student_id;
   v_first_name VARCHAR2(25);
   v_last_name VARCHAR2(25);
BEGIN
   sql_stmt := 'SELECT first_name, last_name'||
               '  FROM student'              ||
               ' WHERE student_id = :1';
   EXECUTE IMMEDIATE sql_stmt 
   INTO v_first_name, v_last_name
   USING v_student_id;
   
   DBMS_OUTPUT.PUT_LINE ('First Name: '||v_first_name);
   DBMS_OUTPUT.PUT_LINE ('Last Name:  '||v_last_name);
END;

-- For Example ch17_1.sql, version 2.0
SET SERVEROUTPUT ON
DECLARE
   sql_stmt VARCHAR2(200);
   v_student_id NUMBER := &sv_student_id;
   v_first_name VARCHAR2(25);
   v_last_name VARCHAR2(25);
   v_street VARCHAR2(50); 
   v_city VARCHAR2(25); 
   v_state VARCHAR2(2); 
   v_zip VARCHAR2(5); 
BEGIN
   sql_stmt := 'SELECT a.first_name, a.last_name, a.street_address'||
               '      ,b.city, b.state, b.zip'                     ||
               '  FROM student a, zipcode b'                       ||
               ' WHERE a.zip = b.zip'                              ||
               '   AND student_id = :1'; 
   EXECUTE IMMEDIATE sql_stmt 
   INTO v_first_name, v_last_name, v_street, v_city, v_state, v_zip
   USING v_student_id; 
   
   DBMS_OUTPUT.PUT_LINE ('First Name: '||v_first_name); 

   DBMS_OUTPUT.PUT_LINE ('Last Name:  '||v_last_name); 
   DBMS_OUTPUT.PUT_LINE ('Street:     '||v_street); 
   DBMS_OUTPUT.PUT_LINE ('City:       '||v_city); 
   DBMS_OUTPUT.PUT_LINE ('State:      '||v_state); 
   DBMS_OUTPUT.PUT_LINE ('Zip Code:   '||v_zip); 
END; 

-- For Example ch17_1.sql, version 3.0
SET SERVEROUTPUT ON
DECLARE
   sql_stmt VARCHAR2(200); 
   v_student_id NUMBER := &sv_student_id; 
   v_first_name VARCHAR2(25); 
   v_last_name VARCHAR2(25); 
   v_street VARCHAR2(50); 
   v_city VARCHAR2(25); 
   v_state VARCHAR2(2); 
   v_zip VARCHAR2(5); 
BEGIN
   sql_stmt := 'SELECT a.first_name, a.last_name, a.street_address'||
               '      ,b.city, b.state, b.zip'                     ||
               '  FROM student a, zipcode b'                       ||
               ' WHERE a.zip = b.zip'                              ||
               '   AND student_id = :1'; 
   EXECUTE IMMEDIATE sql_stmt 
   -- variables v_state and v_zip are misplaced
   INTO v_first_name, v_last_name, v_street, v_city, v_zip, v_state
   USING v_student_id; 
   
   DBMS_OUTPUT.PUT_LINE ('First Name: '||v_first_name); 
   DBMS_OUTPUT.PUT_LINE ('Last Name:  '||v_last_name); 
   DBMS_OUTPUT.PUT_LINE ('Street:     '||v_street); 
   DBMS_OUTPUT.PUT_LINE ('City:       '||v_city); 
   DBMS_OUTPUT.PUT_LINE ('State:      '||v_state); 
   DBMS_OUTPUT.PUT_LINE ('Zip Code:   '||v_zip); 
END;


-- For Example ch17_1.sql, version 4.0
SET SERVEROUTPUT ON
DECLARE
   sql_stmt VARCHAR2(200); 
   v_table_name VARCHAR2(20) := '&sv_table_name'; 
   v_id NUMBER := &sv_id; 
   v_first_name VARCHAR2(25); 
   v_last_name VARCHAR2(25); 
   v_street VARCHAR2(50); 
   v_city VARCHAR2(25); 
   v_state VARCHAR2(2); 
   v_zip VARCHAR2(5); 
BEGIN
   sql_stmt := 'SELECT a.first_name, a.last_name, a.street_address'||
               '      ,b.city, b.state, b.zip'                     ||
               '  FROM '||v_table_name||' a, zipcode b'            ||
               ' WHERE a.zip = b.zip'                              ||
               '   AND '||v_table_name||'_id = :1'; 
   EXECUTE IMMEDIATE sql_stmt 
   INTO v_first_name, v_last_name, v_street, v_city, v_state, v_zip
   USING v_id; 
   
   DBMS_OUTPUT.PUT_LINE ('First Name: '||v_first_name); 
   DBMS_OUTPUT.PUT_LINE ('Last Name:  '||v_last_name); 
   DBMS_OUTPUT.PUT_LINE ('Street:     '||v_street); 
   DBMS_OUTPUT.PUT_LINE ('City:       '||v_city); 
   DBMS_OUTPUT.PUT_LINE ('State:      '||v_state); 
   DBMS_OUTPUT.PUT_LINE ('Zip Code:   '||v_zip); 
END;


-- For Example ch17_2.sql, version 1.0
SET SERVEROUTPUT ON
DECLARE
   TYPE zip_cur_type IS REF CURSOR;
   zip_cur zip_cur_type;
   sql_stmt VARCHAR2(500);
   v_zip VARCHAR2(5);
   v_total NUMBER;
   v_count NUMBER;
BEGIN
   sql_stmt := 'SELECT zip, COUNT(*) total'||
               '  FROM student '           ||
               'GROUP BY zip';

   v_count := 0;
   OPEN zip_cur FOR sql_stmt; 
   LOOP
      FETCH zip_cur INTO v_zip, v_total;
      EXIT WHEN zip_cur%NOTFOUND;

      -- Limit the number of lines printed on the
      -- screen to 10
      v_count := v_count + 1;
      IF v_count <= 10 THEN
         DBMS_OUTPUT.PUT_LINE ('Zip code: '||v_zip||
                               ' Total: '||v_total);
      END IF;
   END LOOP;
   CLOSE zip_cur;

EXCEPTION
   WHEN OTHERS THEN
      IF zip_cur%ISOPEN THEN
         CLOSE zip_cur;
      END IF;

      DBMS_OUTPUT.PUT_LINE ('ERROR: '||   SUBSTR(SQLERRM, 1, 200));
END;


-- For Example ch17_2.sql, version 2.0
SET SERVEROUTPUT ON
DECLARE
   TYPE zip_cur_type IS REF CURSOR; 
   zip_cur zip_cur_type; 


   v_table_name VARCHAR2(20) := '&sv_table_name'; 
   sql_stmt VARCHAR2(500); 
   v_zip VARCHAR2(5); 
   v_total NUMBER; 

   v_count NUMBER; 
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Totals from '||v_table_name||
                         ' table'); 

   sql_stmt := 'SELECT zip, COUNT(*) total'||
               '  FROM '||v_table_name||' '||
               'GROUP BY zip'; 

   v_count := 0; 
   OPEN zip_cur FOR sql_stmt; 
   LOOP
      FETCH zip_cur INTO v_zip, v_total; 
      EXIT WHEN zip_cur%NOTFOUND; 

      -- Limit the number of lines printed on the
      -- screen to 10
      v_count := v_count + 1; 
      IF v_count <= 10 THEN
         DBMS_OUTPUT.PUT_LINE ('Zip code: '||v_zip||
                               ' Total: '||v_total); 
      END IF; 
   END LOOP; 
   CLOSE zip_cur; 

EXCEPTION
   WHEN OTHERS THEN
      IF zip_cur%ISOPEN THEN
         CLOSE zip_cur; 
      END IF; 

      DBMS_OUTPUT.PUT_LINE ('ERROR: '||   SUBSTR(SQLERRM, 1, 200)); 
END;


-- For Example ch17_2.sql, version 3.0
SET SERVEROUTPUT ON
DECLARE
   TYPE zip_cur_type IS REF CURSOR; 
   zip_cur zip_cur_type; 

   TYPE zip_rec_type IS RECORD
      (zip VARCHAR2(5), 
       total NUMBER); 
   zip_rec zip_rec_type; 

   v_table_name VARCHAR2(20) := '&sv_table_name'; 
   sql_stmt VARCHAR2(500); 
   v_count NUMBER; 
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Totals from '||v_table_name||
                         ' table'); 
   sql_stmt := 'SELECT zip, COUNT(*) total'||
               '  FROM '||v_table_name||' '||
               'GROUP BY zip'; 
   v_count := 0; 
   OPEN zip_cur FOR sql_stmt; 
   LOOP
      FETCH zip_cur INTO zip_rec; 
      EXIT WHEN zip_cur%NOTFOUND; 

      -- Limit the number of lines printed on the
      -- screen to 10
      v_count := v_count + 1; 
      IF v_count <= 10 THEN
         DBMS_OUTPUT.PUT_LINE ('Zip code: '||zip_rec.zip||
                               ' Total: '||zip_rec.total); 
      END IF; 
   END LOOP; 
   CLOSE zip_cur; 

EXCEPTION
   WHEN OTHERS THEN
      IF zip_cur%ISOPEN THEN
         CLOSE zip_cur; 
      END IF; 

      DBMS_OUTPUT.PUT_LINE ('ERROR: '||   SUBSTR(SQLERRM, 1, 200)); 
END;
  