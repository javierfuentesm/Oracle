-- *** Chapter Exercises *** --
-- For Example ch04_1a.sql
DECLARE
   v_num1 NUMBER := 5;
   v_num2 NUMBER := 3;
   v_temp NUMBER;
BEGIN
   -- if v_num1 is greater than v_num2 rearrange their values
   IF v_num1 > v_num2 
   THEN
      v_temp := v_num1;
      v_num1 := v_num2;
      v_num2 := v_temp;
   END IF;
   
   -- display the values of v_num1 and v_num2
   DBMS_OUTPUT.PUT_LINE ('v_num1 = '||v_num1);
   DBMS_OUTPUT.PUT_LINE ('v_num2 = '||v_num2);
END;

-- For Example ch04_2a.sql
DECLARE
   v_num1 NUMBER := 0;
   v_num2 NUMBER;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Before IF statement�');
   IF v_num1 = v_num2 
   THEN
      DBMS_OUTPUT.PUT_LINE ('v_num1 = v_num2');
   END IF;
   DBMS_OUTPUT.PUT_LINE ('After IF statement�');
END;

-- For Example ch04_2b.sql
DECLARE
   v_num1 NUMBER := 0;
   v_num2 NUMBER;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Before IF statement�');
   IF v_num1 = v_num2 
   THEN
      DBMS_OUTPUT.PUT_LINE ('v_num1 = v_num2');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('v_num1 != v_num2');
   END IF;
   DBMS_OUTPUT.PUT_LINE ('After IF statement�');
END;

-- For Example ch04_3a.sql
DECLARE
   v_num NUMBER := &sv_num;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Before IF statement�');
   IF v_num < 0 
   THEN
      DBMS_OUTPUT.PUT_LINE (v_num||' is a negative number');
   ELSIF v_num = 0 
   THEN
      DBMS_OUTPUT.PUT_LINE (v_num||' is equal to zero');
   ELSE
      DBMS_OUTPUT.PUT_LINE (v_num||' is a positive number');
  END IF;
  DBMS_OUTPUT.PUT_LINE ('After IF statement�');
END;

-- For Example ch04_3b.sql
DECLARE
   v_num NUMBER := &sv_num;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Before IF statement�');
   IF v_num < 0 
   THEN
      DBMS_OUTPUT.PUT_LINE (v_num||' is a negative number');
   ELSIF v_num > 0 
   THEN
      DBMS_OUTPUT.PUT_LINE (v_num||' is a positive number');
   END IF;
   DBMS_OUTPUT.PUT_LINE ('After IF statement�');
END;

-- For Example ch04_4a.sql
DECLARE
   v_num1  NUMBER := &sv_num1;
   v_num2  NUMBER := &sv_num2;
   v_total NUMBER;
BEGIN
   IF v_num1 > v_num2 
   THEN
      DBMS_OUTPUT.PUT_LINE ('IF part of the outer IF');
      v_total := v_num1 - v_num2;
   ELSE
      DBMS_OUTPUT.PUT_LINE ('ELSE part of the outer IF');
      v_total := v_num1 + v_num2;
      
      IF v_total < 0 
      THEN
         DBMS_OUTPUT.PUT_LINE ('Inner IF');
         v_total := v_total * (-1);
      END IF;
   END IF;
   DBMS_OUTPUT.PUT_LINE ('v_total = '||v_total);
END;

-- For Example ch04_5a.sql
DECLARE
   v_letter CHAR(1) := '&sv_letter';
BEGIN
   IF (v_letter >= 'A' AND v_letter <= 'Z') OR 
      (v_letter >= 'a' AND v_letter <= 'z') 
   THEN 
      DBMS_OUTPUT.PUT_LINE ('This is a letter');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('This is not a letter');
      
      IF v_letter BETWEEN '0' and '9' 
      THEN
         DBMS_OUTPUT.PUT_LINE ('This is a number');
      ELSE
         DBMS_OUTPUT.PUT_LINE ('This is not a number');
      END IF;
   END IF;
END;

-- *** Web Chapter Exercises *** --
-- For Example ch04_6a.sql
DECLARE
   v_date DATE := TO_DATE('&sv_user_date', 'DD-MON-YYYY');
   v_day  VARCHAR2(15); 
BEGIN
   v_day := RTRIM(TO_CHAR(v_date, 'DAY'));
   
   IF v_day IN ('SATURDAY', 'SUNDAY') 
   THEN
      DBMS_OUTPUT.PUT_LINE (v_date||' falls on weekend'); 
   END IF; 
   DBMS_OUTPUT.PUT_LINE ('After IF statement�');
END;

-- For Example ch04_6b.sql
DECLARE
   v_date DATE := TO_DATE('&sv_user_date', 'DD-MON-YYYY');
   v_day  VARCHAR2(15); 
BEGIN
   v_day := TO_CHAR(v_date, 'DAY');
   
   IF v_day IN ('SATURDAY', 'SUNDAY') 
   THEN
      DBMS_OUTPUT.PUT_LINE (v_date||' falls on weekend'); 
   END IF; 
   DBMS_OUTPUT.PUT_LINE ('After IF statement�');
END;

-- For Example ch04_6c.sql
DECLARE
   v_date DATE := TO_DATE('&sv_user_date', 'DD-MON-YYYY');
   v_day  VARCHAR2(15); 
BEGIN
   v_day := TO_CHAR(v_date, 'DAY');
   
   IF v_day LIKE 'S%' 
   THEN
      DBMS_OUTPUT.PUT_LINE (v_date||' falls on weekend'); 
   END IF; 
   DBMS_OUTPUT.PUT_LINE ('After IF statement�');
END;

-- For Example ch04_7a.sql
DECLARE
   v_total NUMBER;
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM enrollment e
     JOIN section s USING (section_id)
    WHERE s.course_no = 25
      AND s.section_no = 1;
   
   -- check if section 1 of course 25 is full   
   IF v_total >= 15 
   THEN
      DBMS_OUTPUT.PUT_LINE ('Section 1 of course 25 is full');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('Section 1 of course 25 is not full');
   END IF;
   -- control resumes here
END;

-- For Example ch04_7b.sql
DECLARE
   v_total    NUMBER;
   v_students NUMBER;
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM enrollment e
     JOIN section s USING (section_id)
    WHERE s.course_no = 25
      AND s.section_no = 1;

   -- check if section 1 of course 25 is full   
   IF v_total >= 15 
   HEN 
      DBMS_OUTPUT.PUT_LINE ('Section 1 of course 25 is full');
   ELSE
      v_students := 15 - v_total; 
      DBMS_OUTPUT.PUT_LINE (v_students||
         ' students can still enroll into section 1 of course 25');
   END IF;
   -- control resumes here
END;

-- For Example ch04_8a.sql
DECLARE
   v_student_id   NUMBER := 102;
   v_section_id   NUMBER := 89;
   v_final_grade  NUMBER;
   v_letter_grade CHAR(1); 
BEGIN
   SELECT final_grade
     INTO v_final_grade
     FROM enrollment
    WHERE student_id = v_student_id
      AND section_id = v_section_id;
   
   IF v_final_grade BETWEEN 90 AND 100 
   THEN
      v_letter_grade := 'A';
   ELSIF v_final_grade BETWEEN 80 AND 89 
   THEN
      v_letter_grade := 'B';
   ELSIF v_final_grade BETWEEN 70 AND 79 
   THEN
      v_letter_grade := 'C';
   ELSIF v_final_grade BETWEEN 60 AND 69 
   THEN
      v_letter_grade := 'D';
   ELSE
      v_letter_grade := 'F';
   END IF;

   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Letter grade is: '||v_letter_grade);

EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      DBMS_OUTPUT.PUT_LINE ('There is no such student or section');
END;

-- For Example ch04_8b.sql
DECLARE
   v_student_id   NUMBER := 102;
   v_section_id   NUMBER := 89;
   v_final_grade  NUMBER;
   v_letter_grade CHAR(1); 
BEGIN
   SELECT final_grade
     INTO v_final_grade
     FROM enrollment
    WHERE student_id = v_student_id
      AND section_id = v_section_id;
   
   IF v_final_grade IS NULL 
   THEN
      DBMS_OUTPUT.PUT_LINE ('v_final_grade is null');
   ELSIF v_final_grade BETWEEN 90 AND 100 
   THEN
      v_letter_grade := 'A';
   ELSIF v_final_grade BETWEEN 80 AND 89 
   THEN
      v_letter_grade := 'B';
   ELSIF v_final_grade BETWEEN 70 AND 79 
   THEN
      v_letter_grade := 'C';
   ELSIF v_final_grade BETWEEN 60 AND 69 
   THEN
      v_letter_grade := 'D';
   ELSE
      v_letter_grade := 'F';
   END IF;
   
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Letter grade is: '||v_letter_grade);

EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      DBMS_OUTPUT.PUT_LINE ('There is no such student or section');
END;

-- For Example ch04_8c.sql
DECLARE
   v_student_id   NUMBER := 102;
   v_section_id   NUMBER := 89;
   v_final_grade  NUMBER;
   v_letter_grade CHAR(1); 
BEGIN
   SELECT final_grade
     INTO v_final_grade
     FROM enrollment
    WHERE student_id = v_student_id
      AND section_id = v_section_id;
   
   IF v_final_grade >= 90 
   THEN
      v_letter_grade := 'A';
   ELSIF v_final_grade >= 80 
   THEN
      v_letter_grade := 'B';
   ELSIF v_final_grade >= 70 
   THEN
      v_letter_grade := 'C';
   ELSIF v_final_grade >= 60 
   THEN
      v_letter_grade := 'D';
   ELSE
      v_letter_grade := 'F';
   END IF;
   
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Letter grade is: '||v_letter_grade);

EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      DBMS_OUTPUT.PUT_LINE ('There is no such student or section');
END;

-- For Example ch04_9a.sql
DECLARE
   v_temp_in   NUMBER := &sv_temp_in;
   v_scale_in  CHAR   := '&sv_scale_in';
   v_temp_out  NUMBER;
   v_scale_out CHAR;
BEGIN
   IF v_scale_in != 'C' AND v_scale_in != 'F' 
   THEN
      DBMS_OUTPUT.PUT_LINE ('This is not a valid scale');
   ELSE
      IF v_scale_in = 'C' 
      THEN
         v_temp_out  := ( (9 * v_temp_in) / 5 ) + 32;
         v_scale_out := 'F';
      ELSE
         v_temp_out  := ( (v_temp_in - 32) * 5 ) / 9;
         v_scale_out := 'C';
      END IF;
      DBMS_OUTPUT.PUT_LINE ('New scale is: '||v_scale_out);
      DBMS_OUTPUT.PUT_LINE ('New temperature is: '||v_temp_out);
   END IF;
END;

-- For Example ch04_9b.sql
DECLARE
   v_temp_in   NUMBER := &sv_temp_in;
   v_scale_in  CHAR   := '&sv_scale_in';
   v_temp_out  NUMBER;
   v_scale_out CHAR;
BEGIN
   IF v_scale_in != 'C' AND v_scale_in != 'F' 
   THEN
      DBMS_OUTPUT.PUT_LINE ('This is not a valid scale');
      v_temp_out  := 0;
      v_scale_out := 'C';
   ELSE
      IF v_scale_in = 'C' 
      THEN
         v_temp_out  := ( (9 * v_temp_in) / 5 ) + 32;
         v_scale_out := 'F';
      ELSE
         v_temp_out  := ( (v_temp_in - 32) * 5 ) / 9;
         v_scale_out := 'C';
      END IF;
   END IF;
   DBMS_OUTPUT.PUT_LINE ('New scale is: '||v_scale_out);
   DBMS_OUTPUT.PUT_LINE ('New temperature is: '||v_temp_out);
END;

-- For Example ch04_10a.sql
DECLARE
   v_instructor_id NUMBER := &sv_instructor_id;
   v_total NUMBER;
BEGIN
   SELECT COUNT(*)
     INTO v_total
     FROM section
    WHERE instructor_id = v_instructor_id;
   
   -- check if instructor teaches 3 or more sections
   IF v_total >= 3 
   THEN
      DBMS_OUTPUT.PUT_LINE ('This instructor needs a �vacation');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('This instructor teaches '||v_total||' sections');
   END IF;
   -- control resumes here
END;

-- For Example ch04_11a.sql
-- Block 1
DECLARE
   v_num NUMBER := NULL; 
BEGIN
   DBMS_OUTPUT.PUT_LINE ('PL/SQL Block 1');	
   IF v_num > 0 
   THEN
      DBMS_OUTPUT.PUT_LINE ('v_num is greater than 0');
   ELSE
      DBMS_OUTPUT.PUT_LINE ('v_num is not greater than 0');
   END IF;
END;
/

-- Block 2
DECLARE
   v_num NUMBER := NULL; 
BEGIN
   DBMS_OUTPUT.PUT_LINE ('PL/SQL Block 2');
   IF v_num > 0 
   THEN
      DBMS_OUTPUT.PUT_LINE ('v_num is greater than 0');
   END IF;
   IF NOT (v_num > 0) 
   THEN
      DBMS_OUTPUT.PUT_LINE ('v_num is not greater than 0');
   END IF;
END;
/

