CREATE OR REPLACE FUNCTION get_matching_days (p_input_date DATE)
RETURN SYS_REFCURSOR
AS
  matching_days SYS_REFCURSOR;
BEGIN
  OPEN matching_days FOR
    SELECT to_char(date_column, 'YYYY-MM-DD') as matching_date
    FROM your_table_name
    WHERE extract(year from date_column) = extract(year from p_input_date)
    AND extract(month from date_column) = extract(month from p_input_date)
    AND to_char(date_column, 'DY') = to_char(p_input_date, 'DY');
  RETURN matching_days;
END;
CREATE OR REPLACE FUNCTION get_matching_days (p_input_date DATE)
RETURN SYS_REFCURSOR
AS
  matching_days SYS_REFCURSOR;
BEGIN
  OPEN matching_days FOR
    SELECT to_char(date_column, 'YYYY-MM-DD') as matching_date
    FROM your_table_name
    WHERE extract(year from date_column) = extract(year from p_input_date)
    AND extract(month from date_column) = extract(month from p_input_date)
    AND to_char(date_column, 'DY') = to_char(p_input_date, 'DY');
  RETURN matching_days;
END;

CREATE OR REPLACE FUNCTION split_text_by_words(p_text CLOB, p_max_length NUMBER)
RETURN SYS_REFCURSOR
AS
  split_text SYS_REFCURSOR;
BEGIN
  OPEN split_text FOR
    WITH words AS (
      SELECT TRIM(REGEXP_SUBSTR(p_text, '[^ ]+', 1, LEVEL)) as word
      FROM DUAL
      CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(p_text, '[^ ]+')) + 1
    ),
    chunks AS (
      SELECT word,
             ROW_NUMBER() OVER(ORDER BY LEVEL) - 1 as chunk_id
      FROM words
    )
    SELECT chunk_id,
           LISTAGG(word, ' ') WITHIN GROUP (ORDER BY word) as chunk_text
    FROM chunks
    GROUP BY chunk_id
    HAVING SUM(LENGTH(word)) + COUNT(word) <= p_max_length;
  RETURN split_text;
END;	

WITH
  t0 AS ( SELECT 10 AS nnn FROM DUAL )
, t1 AS 
( 
    SELECT 
        ROWNUM   AS rn , 1 AS val 
    FROM t0 
    CONNECT BY LEVEL < (CASE 
                        WHEN t0.nnn > 1000000 THEN 1000000 
                        ELSE t0.nnn 
                      END) * 10
)
, t2 AS 
(   SELECT 
        ROWNUM+2 AS rn , 
        2 AS val , 
        ROUND (DBMS_RANDOM.VALUE(1,10) ) AS val2   
    FROM t0 
    CONNECT BY LEVEL < (CASE 
                        WHEN t0.nnn > 1000000 THEN 1000000 
                        ELSE t0.nnn 
                      END) * 100
)
, t3 AS 
( 
    SELECT 
        ROUND (DBMS_RANDOM.VALUE(1,100) ) AS rn , 
        ROUND (DBMS_RANDOM.VALUE(1,1000) ) AS val 
    FROM t0 
    CONNECT BY LEVEL < (CASE 
                        WHEN t0.nnn > 1000000 THEN 1000000 
                        ELSE t0.nnn 
                      END) * 1000
)
SELECT
     t1.rn , t2.val2
FROM t1, t2, t3
WHERE  t1.rn = t2.rn AND t2.rn = t3.rn
GROUP BY t1.rn , t2.val2
HAVING SUM( t2.val ) > 205  AND COUNT( t3.rn ) < 105 	



