-- *** Chapter Exercises *** --
-- ***-- *** Chapter Exercises *** --


-- For Example ch24_1.sql 
CREATE OR REPLACE PACKAGE BODY school_api AS
CREATE OR REPLACE PROCEDURE LOG_USER_COUNT 
   (PI_DIRECTORY  IN VARCHAR2,
    PI_FILE_NAME  IN VARCHAR2)
AS
   V_File_handle  UTL_FILE.FILE_TYPE; 
   V_user_count   number;
BEGIN
   SELECT count(*)
   INTO   V_user_count   
   FROM   v$session 
   WHERE  username is not null;

   V_File_handle  :=
      UTL_FILE.FOPEN(PI_DIRECTORY, PI_FILE_NAME, 'A');
   UTL_FILE.NEW_LINE(V_File_handle);    
   UTL_FILE.PUT_LINE(V_File_handle  , '---- User log -----');  
   UTL_FILE.NEW_LINE(V_File_handle);    
   UTL_FILE.PUT_LINE(V_File_handle  , 'on '||
         TO_CHAR(SYSDATE, 'MM/DD/YY HH24:MI')); 
   UTL_FILE.PUT_LINE(V_File_handle  , 
         'Number of users logged on: '|| V_user_count);
   UTL_FILE.PUT_LINE(V_File_handle  , '---- End log -----');
   UTL_FILE.NEW_LINE(V_File_handle);    
   UTL_FILE.FCLOSE(V_File_handle); 

EXCEPTION  
   WHEN UTL_FILE.INVALID_FILENAME THEN
      DBMS_OUTPUT.PUT_LINE('File is invalid');
   WHEN UTL_FILE.WRITE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE('Oracle is not able to write to file');
END; 


-- For Example ch24_2.sql 
CREATE OR REPLACE PROCEDURE READ_FILE
   (PI_DIRECTORY  IN VARCHAR2,
    PI_FILE_NAME  IN VARCHAR2)
AS
   V_File_handle  UTL_FILE.FILE_TYPE; 
   V_FILE_Line    VARCHAR2(1024);
BEGIN 
   V_File_handle  :=
      UTL_FILE.FOPEN(PI_DIRECTORY, PI_FILE_NAME, 'R');
    LOOP
          UTL_FILE.GET_LINE( V_File_handle , v_file_line);
          DBMS_OUTPUT.PUT_LINE(v_file_line);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND
          THEN UTL_FILE.FCLOSE(  V_File_handle );
END;  


-- For Example ch24_3.sql 
DECLARE
   V_JOB_NO NUMBER; 
BEGIN
  DBMS_JOB.SUBMIT( JOB       => v_job_no,
                   WHAT      => 'LOG_USER_COUNT
                            (''C:\WORKING\'', ''USER.LOG'');',
                   NEXT_DATE => SYSDATE,
                   INTERVAL  => 'SYSDATE + 1/4 ');
  Commit;
  DBMS_OUTPUT.PUT_LINE(v_job_no);
 END; 


-- For Example?ch24_4.sql 
CREATE or REPLACE procedure DELETE_ENROLL
AS
  CURSOR C_NO_GRADES is
SELECT st.student_id, se.section_id
  FROM  student st,
        enrollment e,
        section se
 WHERE  st.student_id = e.student_id
 AND    e.section_id  = se.section_id
 AND    se.start_date_time < ADD_MONTHS(SYSDATE, -1)
 AND   NOT EXISTS (SELECT g.student_id, g.section_id
                    FROM  grade g
                   WHERE  g.student_id = st.student_id
                     AND  g.section_id = se.section_id);
BEGIN
   FOR R in C_NO_GRADES LOOP
      DELETE  enrollment
      WHERE   section_id = r.section_id
      AND     student_id = r.student_id;
   END LOOP;
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;   


---  For Example ch24_5.sql 
EXPLAIN PLAN FOR 
  SELECT c.course_no    course_no, 
         c.description  description,
         b.section_no   section_no,
         s.section_id   section_id,
         i.first_name   first_name,
         i.last_name    last_name
  FROM   course     c,
         instructor i,
         section    s,
        (SELECT
               a.course_no       course_no,
               MIN(a.section_no) section_no
         FROM (SELECT  count(*)        enrolled,
                       se.CAPACITY     capacity,
                       se.course_no    course_no,
                       se.section_no   section_no,
                       e.section_id    section_id
                  FROM section se,
                       enrollment e
                 WHERE se.section_id = e.section_id
                   AND e.student_id <> 214
              GROUP BY
                       se.CAPACITY,
                       se.course_no,
                       e.section_id,
                       se.section_no
                HAVING count(*) < se.CAPACITY) a
        GROUP BY
                a.course_no) b
  WHERE c.course_no     = b.course_no
  AND   b.course_no     = s.course_no
  AND   s.section_no    = b.section_no
  AND   s.instructor_id = i.instructor_id; 


-- For Example ch24.6.sql 
CREATE OR REPLACE PACKAGE Student_Instructor AS    
PROCEDURE show_population
        (i_zip IN zipcode.zip%TYPE);
END Student_Instructor;
/

CREATE or REPLACE PACKAGE BODY Student_Instructor   
AS
PROCEDURE show_population
       (i_zip IN zipcode.zip%TYPE)
AS
  student_list    SYS_REFCURSOR;
  instructor_list SYS_REFCURSOR;
BEGIN
  OPEN student_list FOR
             SELECT 'Student' type, First_Name, Last_Name
               FROM  student
              WHERE  zip = i_zip;
        DBMS_SQL.RETURN_RESULT(student_list);
  OPEN instructor_list FOR
                SELECT 'Instructor' type, First_Name, Last_Name
                  FROM  instructor
                 WHERE  zip = i_zip;
         DBMS_SQL.RETURN_RESULT(instructor_list);
END show_population;
END Student_Instructor;
/


-- For Example  ch24_7.sql 
CREATE OR REPLACE PROCEDURE first 
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.FORMAT_CALL_STACK);
END first;
/   

CREATE OR REPLACE PROCEDURE second
IS
BEGIN
   first;
END second;
/

CREATE OR REPLACE PROCEDURE third
IS
BEGIN
   second;
END third;
/

BEGIN
   third;
END;
  
  
  
-- For Example ch24_8.sql 
CREATE OR REPLACE PROCEDURE first 
IS
   v_name VARCHAR2(30); 
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure FIRST');
   
   SELECT RTRIM(first_name)||' '||RTRIM(last_name)
     INTO v_name
     FROM student
    WHERE student_id = 1000;
END first;
/   

CREATE OR REPLACE PROCEDURE second
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure SECOND'); 
   first;
END second;
/

CREATE OR REPLACE PROCEDURE third
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure THIRD');
   second;
END third;
/

BEGIN
   third;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;


-- For Example ch24_9.sql 
CREATE OR REPLACE PROCEDURE first 
IS
   v_name VARCHAR2(30); 
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure FIRST');
   
   SELECT RTRIM(first_name)||' '||RTRIM(last_name)
     INTO v_name
     FROM student
    WHERE student_id = 1000;
END first;
/   

CREATE OR REPLACE PROCEDURE second
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure SECOND'); 
   first;
END second;
/

CREATE OR REPLACE PROCEDURE third
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure THIRD');
   second;
END third;
/

BEGIN
   third;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE ('Error Backtrace:');
      DBMS_OUTPUT.PUT_LINE ('----------------');
      DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      
      DBMS_OUTPUT.PUT_LINE ('Error Stack:');
      DBMS_OUTPUT.PUT_LINE ('----------------');
      DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.FORMAT_ERROR_STACK);
END;

-- For Example? ch24_10.sql 
CREATE OR REPLACE PROCEDURE first 
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure FIRST');
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
END first;
/   

CREATE OR REPLACE PROCEDURE second
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure SECOND'); 
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   first;
END second;
/

CREATE OR REPLACE PROCEDURE third
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure THIRD');
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   second;
END third;
/

BEGIN
   DBMS_OUTPUT.PUT_LINE ('anonymous block');
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   third;
END;
 
-- For Example ch24_11.sql 
CREATE OR REPLACE PROCEDURE first 
IS
   v_string VARCHAR2(3); 
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure FIRST');
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   v_string := 'ABCDEF'; 
END first;
/   

CREATE OR REPLACE PROCEDURE second
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure SECOND'); 
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   first;
END second;
/

CREATE OR REPLACE PROCEDURE third
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure THIRD');
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   second;
END third;
/

BEGIN
   DBMS_OUTPUT.PUT_LINE ('anonymous block');
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   third;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (CHR(10)||'Backtrace Stack: '||CHR(10)||RPAD('-', 15, '-'));
      DBMS_OUTPUT.PUT_LINE ('Backtrace Depth: '||TO_CHAR(UTL_CALL_STACK.BACKTRACE_DEPTH));
      DBMS_OUTPUT.PUT_LINE ('Backtrace Line: ' ||
         TO_CHAR(UTL_CALL_STACK.BACKTRACE_LINE(UTL_CALL_STACK.BACKTRACE_DEPTH)));
      DBMS_OUTPUT.PUT_LINE ('Backtrace Unit: ' ||
         UTL_CALL_STACK.BACKTRACE_UNIT(UTL_CALL_STACK.BACKTRACE_DEPTH));










































END;
  Note how the value returned by the BACKTRACE_DEPTH function is used as an input parameter to the BACKTRACE_LINE and BACKTRACE_UNIT functions. When run, this script produces output as shown:
anonymous block
dynamic depth: 1
procedure THIRD
dynamic depth: 2
procedure SECOND
dynamic depth: 3
procedure FIRST
dynamic depth: 4

Backtrace Stack: 
---------------
Backtrace Depth: 4
Backtrace Line: 7
Backtrace Unit: STUDENT.FIRST
  The backtrace stack reports that an exception was encountered in the backtrace depth 4, on line number 7 in the subroutine called FIRST in the STUDENT schema. This is very detailed backtrace output for such a simple example, yet it is still missing the exception itself. The set of error functions described below cover exception reporting gap in this example.
Error Depth, Message, and Number Functions 
The set of error functions return error depth, message, and number of an error in a current stack and have syntax as shown in Listing 24.6.
Listing 24.6 ?Error Functions
UTL_CALL_STACK.ERROR_DEPTH
RETURN PLS_INTEGER;

UTL_CALL_STACK.ERROR_MSG (error_depth IN PLS_INTEGER)
RETURN VARCHAR2;

UTL_CALL_STACK.ERROR_NUMBER (error_depth IN PLS_INTEGER)
RETURN VARCHAR2;
  Next consider how these functions may be utilized for error reporting. In this version of the script, the exception-handling section includes calls to these functions. All changes are shown in bold.










































For Example? ch24_12.sql 
CREATE OR REPLACE PROCEDURE first 
IS
   v_string VARCHAR2(3); 
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure FIRST');
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   v_string := 'ABCDEF'; 
END first;
/   

CREATE OR REPLACE PROCEDURE second
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure SECOND'); 
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   first;
END second;
/

CREATE OR REPLACE PROCEDURE third
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE ('procedure THIRD');
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   second;
END third;
/

BEGIN
   DBMS_OUTPUT.PUT_LINE ('anonymous block');
   DBMS_OUTPUT.PUT_LINE ('dynamic depth: '||TO_CHAR(UTL_CALL_STACK.DYNAMIC_DEPTH));
   third;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (CHR(10)||'Backtrace Stack: '||CHR(10)||RPAD('-', 15, '-'));
      DBMS_OUTPUT.PUT_LINE ('Backtrace Depth: '||TO_CHAR(UTL_CALL_STACK.BACKTRACE_DEPTH));
      DBMS_OUTPUT.PUT_LINE ('Backtrace Line: ' ||
         TO_CHAR(UTL_CALL_STACK.BACKTRACE_LINE(UTL_CALL_STACK.BACKTRACE_DEPTH)));
      DBMS_OUTPUT.PUT_LINE ('Backtrace Unit: ' ||
         UTL_CALL_STACK.BACKTRACE_UNIT(UTL_CALL_STACK.BACKTRACE_DEPTH));
      DBMS_OUTPUT.PUT_LINE (CHR(10)||'Error Info: '||CHR(10)||RPAD('-', 15, '-'));
      DBMS_OUTPUT.PUT_LINE ('Error Depth: '  ||TO_CHAR(UTL_CALL_STACK.ERROR_DEPTH));
      DBMS_OUTPUT.PUT_LINE ('Error Number: ' ||
         TO_CHAR(UTL_CALL_STACK.ERROR_NUMBER (UTL_CALL_STACK.ERROR_DEPTH)));
      DBMS_OUTPUT.PUT_LINE ('Error Message: '||
         UTL_CALL_STACK.ERROR_MSG(UTL_CALL_STACK.ERROR_DEPTH));
END;
  When run this example produces output as follows:
anonymous block
dynamic depth: 1
procedure THIRD
dynamic depth: 2
procedure SECOND
dynamic depth: 3
procedure FIRST
dynamic depth: 4

Backtrace Stack: 
---------------
Backtrace Depth: 4
Backtrace Line: 7
Backtrace Unit: STUDENT.FIRST

Error Info: 
---------------
Error Depth: 1
Error Number: 6502
Error Message: PL/SQL: numeric or value error: character string buffer too small
  Note how the output now contains error depth, number, and message. In a more complex environment, this type of trace date provides invaluable insight to PL/SQL developers that is essential in diagnosing and resolving problems in PL/SQL code efficiently. As stated previously, this Lab covered only some of the functions of the UTL_CALL_STACK package. For additional information on how to utilize this package fully, refer to the Oracle Database PL/SQL Packages and Types Reference available on-line.
Summary
  In this chapter you learned various Oracle supplied packages that can be used to extend functionality.  The method to access files on the operating system within a stored procedure by making use of UTL_FILE was reviewed. Then how to analyze SQL by making use of the explain plan generated by DBMS_XPLAN.  How to generate Implicit Statement Results with DBMS_SQL are also reviewed.  Finally the chapter concludes with how to use DBMS_UTILITY and UTL_CALL_STACK for error reporting. 




