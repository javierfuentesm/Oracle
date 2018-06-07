-- *** Chapter Exercises *** --
-- For Example ch06_1a.sql
DECLARE
   v_counter BINARY_INTEGER := 0; 
BEGIN
   LOOP
      -- increment loop counter by one
      v_counter := v_counter + 1;
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter); 

      -- if exit condition yields TRUE exit the loop
      IF v_counter = 5 
      THEN 
         EXIT;
      END IF; 
   END LOOP;
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;

-- For Example ch06_1b.sql
DECLARE
   v_counter BINARY_INTEGER := 0; 
BEGIN
   LOOP
      -- increment loop counter by one
      v_counter := v_counter + 1;

      -- if exit condition yields TRUE exit the loop
      IF v_counter = 5 
      THEN 
         EXIT;
      END IF;

      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter); 
   END LOOP;
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;

-- For Example ch06_1c.sql
DECLARE
   v_counter BINARY_INTEGER := 0; 
BEGIN
   LOOP
      -- increment loop counter by one
      v_counter := v_counter + 1;
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter); 

      -- if exit condition yields TRUE exit the loop
      EXIT WHEN v_counter = 5;
   END LOOP;
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;

-- For Example ch06_2a.sql
DECLARE
   v_counter NUMBER := 5;
BEGIN
   WHILE v_counter < 5 
   LOOP
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
      
      -- decrement the value of v_counter by one
      v_counter := v_counter - 1;
   END LOOP;
END;

-- For Example ch06_2b.sql
DECLARE
   v_counter NUMBER := 1;
BEGIN
   WHILE v_counter < 5 
   LOOP
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
      
      -- decrement the value of v_counter by one
      v_counter := v_counter - 1;
  END LOOP;
END;

-- For Example ch06_2c.sql
DECLARE
   v_counter NUMBER := 1;
BEGIN
   WHILE v_counter < 5 
   LOOP
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
      
      -- increment the value of v_counter by one
      v_counter := v_counter + 1;
  END LOOP;
END;

-- For Example ch06_3a.sql
DECLARE
   v_counter NUMBER := 1;
BEGIN
   WHILE v_counter <= 5 
   LOOP
       DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);

      IF v_counter = 2 
      THEN
         EXIT;
      END IF;

      v_counter := v_counter + 1;
   END LOOP;
END;

-- For Example ch06_3b.sql
DECLARE
   v_counter NUMBER := 1;
BEGIN
   WHILE v_counter <= 2 
   LOOP
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
      v_counter := v_counter + 1;
  
      IF v_counter = 5 
      THEN
         EXIT;
      END IF;
   END LOOP;
END;

-- For Example ch06_4a.sql
BEGIN
   FOR v_counter IN 1..5 
   LOOP
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
   END LOOP;
END;

-- For Example ch06_4b.sql
BEGIN
   FOR v_counter IN 1..5 
   LOOP
      v_counter := v_counter + 1;
      DBMS_OUTPUT.PUT_LINE ('v_counter = '|| v_counter);
   END LOOP;
END;

-- For Example ch06_5a.sql
BEGIN
   FOR v_counter IN REVERSE 1..5 
   LOOP
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
   END LOOP;
END;

-- For Example ch06_6a.sql
BEGIN
   FOR v_counter IN 1..5 
   LOOP
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
      EXIT WHEN v_counter = 3;
   END LOOP;
END;

-- *** Web Chapter Exercises *** -- 
-- For Example ch06_7a.sql
DECLARE
   v_counter BINARY_INTEGER := 5; 
BEGIN
   LOOP
      -- decrement loop counter by one
      v_counter := v_counter - 1;
      DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter); 

      -- if EXIT condition yields TRUE exit the loop
      IF v_counter = 0 THEN 
         EXIT;
      END IF; 

   END LOOP;
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;

-- For Example ch06_7b.sql
DECLARE
   v_counter BINARY_INTEGER := 5; 
BEGIN
   WHILE v_counter > 0 
   LOOP
 -- decrement loop counter by one
 v_counter := v_counter - 1;
 DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter); 
   END LOOP;
   
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE('Done…');
END;


-- For Example ch06_8a.sql
DECLARE
   v_counter BINARY_INTEGER := 0; 
BEGIN
   LOOP
      -- increment loop counter by one
      v_counter := v_counter + 1;

      -- determine whether v_counter is even or odd
      CASE
         WHEN MOD(v_counter, 2) = 0
         THEN
            DBMS_OUTPUT.PUT_LINE (v_counter||' is even');
         ELSE
            DBMS_OUTPUT.PUT_LINE (v_counter||' is odd');
         END CASE;

      -- if EXIT WHEN condition yields TRUE exit the loop
      EXIT WHEN v_counter = 10;
   END LOOP;
   
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;

-- For Example ch06_8b.sql
DECLARE
   v_counter BINARY_INTEGER := 0; 
BEGIN
   LOOP
      -- increment loop counter by two
      v_counter := v_counter + 2;

      -- determine whether v_counter is even or odd
      CASE
         WHEN MOD(v_counter, 2) = 0
         THEN
            DBMS_OUTPUT.PUT_LINE (v_counter||' is even');
         ELSE
            DBMS_OUTPUT.PUT_LINE (v_counter||' is odd');
         END CASE;

      -- if EXIT WHEN condition yields TRUE exit the loop
      EXIT WHEN v_counter = 10;
   END LOOP;
   
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;

-- For Example ch06_8c.sql
DECLARE
   v_counter BINARY_INTEGER := 0; 
BEGIN
   LOOP
      -- determine whether v_counter is even or odd
      CASE
         WHEN MOD(v_counter, 2) = 0
         THEN
            DBMS_OUTPUT.PUT_LINE (v_counter||' is even');
         ELSE
            DBMS_OUTPUT.PUT_LINE (v_counter||' is odd');
         END CASE;

      -- if EXIT WHEN condition yields TRUE exit the loop
      EXIT WHEN v_counter = 10;

      -- increment loop counter by 1
      v_counter := v_counter + 1;
   END LOOP;
   
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;

-- For Example ch06_9a.sql
DECLARE
   v_counter BINARY_INTEGER := 1;
   v_sum     BINARY_INTEGER := 0; 
BEGIN
   WHILE v_counter <= 10 
   LOOP
      v_sum := v_sum + v_counter;
      DBMS_OUTPUT.PUT_LINE ('Current sum is: '||v_sum);
      
      -- increment loop counter by one
      v_counter := v_counter + 1;
   END LOOP;

   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('The sum of integers between 1 and 10 is: '||v_sum);
END;

-- For Example ch06_9b.sql
DECLARE
   v_sum BINARY_INTEGER := 0; 
BEGIN
   FOR v_counter in 1..10 
   LOOP
      v_sum := v_sum + v_counter;
      DBMS_OUTPUT.PUT_LINE ('Current sum is: '||v_sum);
   END LOOP;

   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('The sum of integers between 1 and 10 is: '||v_sum);
END;


-- For Example ch06_10a.sql
DECLARE
   v_factorial NUMBER := 1;
BEGIN
   FOR v_counter IN 1..10 
   LOOP
      v_factorial := v_factorial * v_counter;
   END LOOP;
   
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Factorial of ten is: ¬'||v_factorial);
END;

-- For Example ch06_10b.sql
DECLARE
   v_counter   NUMBER := 1;
   v_factorial NUMBER := 1;
BEGIN
   LOOP
      v_factorial := v_factorial * v_counter;

      v_counter := v_counter + 1;
      EXIT WHEN v_counter = 10;
   END LOOP;
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Factorial of ten is: ¬'||v_factorial);
END;

-- For Example ch06_11a.sql
BEGIN
   FOR v_counter IN REVERSE 0..10 
   LOOP
      -- if v_counter is even, display its value on the screen
      IF MOD(v_counter, 2) = 0 
      THEN
         DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
      END IF;
   END LOOP;
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;

-- For Example ch06_11b.sql
BEGIN
   FOR v_counter IN 0..10 
   LOOP
      -- if v_counter is even, display its value on the screen
      IF MOD(v_counter, 2) = 0 
      THEN
         DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
      END IF;
   END LOOP;
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;

-- For Example ch06_11c.sql
BEGIN
   FOR v_counter IN REVERSE 0..10 
   LOOP
      -- if v_counter is odd, display its value on the screen
      IF MOD(v_counter, 2) != 0 
      THEN
         DBMS_OUTPUT.PUT_LINE ('v_counter = '||v_counter);
      END IF;
   END LOOP;
   -- control resumes here
   DBMS_OUTPUT.PUT_LINE ('Done…');
END;


