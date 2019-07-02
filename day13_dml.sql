-- day 13

---------------------------------------------------
-- 오라클의 특별한 컬럼 2가지
-- : 사용자가 만든 적 없어도 자동으로 제공되는 컬럼

-- 1. ROWID : 물리적으로 디스크에 저장된 위치를 가리키는 값
--            물리적 위치이므로 한 행당 반드시 유일한 값일 수 밖에 없음
--            ORDER BY 절에 의해 변경되지 않는 값

-- 2. ROWNUM : 조회된 결과의 첫번째 행부터 1로 증가하는 값
---------------------------------------------------

-- 예) emp 테이블의 'SMITH' 를 조회
SELECT e.empno
     , e.ename
  FROM emp e
 WHERE e.ename = 'SMITH'  
;  

-- ROWID 를 같이 조회
SELECT e.rowid
     , e.empno
     , e.ename
  FROM emp e
 WHERE e.ename = 'SMITH'  
;  
/*
ROWID,              EMPNO,   ENAME
------------------------------------
AAAR9dAAHAAAACuAAA	7369	 SMITH
*/
-- ROWNUM 을 같이 조회
SELECT rownum
     , e.empno
     , e.ename
  FROM emp e
 WHERE e.ename = 'SMITH'  
;
--ROWNUM, EMPNO, ENAME
-------------------------
--     1   7369	 SMITH

----------------------------------------------
-- ORDER BY 절에 의해 ROWNUM 이 변경되는 결과 확인
-- (1) ORDER BY 가 없을 때의 ROWNUM
SELECT rownum
     , e.empno
     , e.ename
  FROM emp e
;  
/*
1	7777	JJ
2	8888	J_JAMES
3	7369	SMITH
4	7499	ALLEN
5	7521	WARD
6	7566	JONES
7	7654	MARTIN
8	7698	BLAKE
9	7782	CLARK
10	7839	KING
11	7844	TURNER
12	7900	JAMES
13	7902	FORD
14	7934	MILLER
*/

-- (2) ename 순으로 오름차순 정렬 후 ROWNUM 값 확인
SELECT rownum
     , e.empno
     , e.ename
  FROM emp e
 ORDER BY e.ename  
; 
/*
4	7499	ALLEN
8	7698	BLAKE
9	7782	CLARK
13	7902	FORD
12	7900	JAMES
1	7777	JJ
6	7566	JONES
2	8888	J_JAMES
10	7839	KING
7	7654	MARTIN
14	7934	MILLER
3	7369	SMITH
11	7844	TURNER
5	7521	WARD
*/
-- ==> ROWNUM 이 ORDER BY 결과에 영향을 받지 않는 것처럼 보일 수 있음.
--     SUB-QUERY 로 사용할 때 영향을 받음.

-- (3) SUB-QUERY 를 썼을 때 ROWNUM 의 값 확인
SELECT rownum
     , a.empno
     , a.ename
     , a.numrow
  FROM (SELECT rownum as numrow
             , e.empno
             , e.ename
          FROM emp e
         ORDER BY e.ename) a
;         
/*
1	7499	ALLEN	4
2	7698	BLAKE	8
3	7782	CLARK	9
4	7902	FORD	13
5	7900	JAMES	12
6	7777	JJ	    1
7	7566	JONES	6
8	8888	J_JAMES	2
9	7839	KING	10
10	7654	MARTIN	7
11	7934	MILLER	14
12	7369	SMITH	3
13	7844	TURNER	11
14	7521	WARD	5
*/

-- 이름에 A 가 들어가는 사람들을 조회 (ORDER BY 없이)
SELECT ROWNUM
     , e.ename
  FROM emp e
 WHERE e.ename LIKE '%A%'  
;  
/*
1	J_JAMES
2	ALLEN
3	WARD
4	MARTIN
5	BLAKE
6	CLARK
7	JAMES
*/

-- 이름에 A가 들어가는 사람을 이름순으로 정렬하여 조회
SELECT ROWNUM
     , e.ename
  FROM emp e
 WHERE e.ename LIKE '%A%'  
 ORDER BY e.ename
;
/*
2	ALLEN
5	BLAKE
6	CLARK
7	JAMES
1	J_JAMES
4	MARTIN
3	WARD
*/

-- 이름에 S 가 들어가는 사람들을 조회
-- 이때, ROWNUM, ROWID 를 확인
SELECT ROWNUM
     , e.rowid
     , e.ename
  FROM emp e
 WHERE e.ename LIKE '%S%'  
 ORDER BY e.ename
;
/*
4	AAAR9dAAHAAAACuAAJ	JAMES
3	AAAR9dAAHAAAACuAAD	JONES
1	AAAR9dAAHAAAACsAAC	J_JAMES
2	AAAR9dAAHAAAACuAAA	SMITH
*/
-- 이름에 S가 들어가는 사람들의 조회 결과를
-- SUB-QUERY 로 감쌌을 때의 ROWNUM, ROWID 확인
SELECT ROWNUM
     , a.rowid
     , a.ename
  FROM (SELECT e.rowid
             , e.ename
          FROM emp e
         WHERE e.ename LIKE '%S%'  
         ORDER BY e.ename) a
;         
/*
1	AAAR9dAAHAAAACuAAJ	JAMES
2	AAAR9dAAHAAAACuAAD	JONES
3	AAAR9dAAHAAAACsAAC	J_JAMES
4	AAAR9dAAHAAAACuAAA	SMITH
*/

-- ROWNUM 으로 할 수 있는 쿼리
-- emp 에서 급여를 많이 받는 상위 5명을 조회하시오.

-- 1. 급여가 많은 역순 정렬
SELECT e.empno
     , e.ename
     , e.sal
  FROM emp e
 ORDER BY e.sal DESC  
;  
/*
7839	KING	5000
7902	FORD	3000
7566	JONES	2975
7698	BLAKE	2850
7782	CLARK	2450
7499	ALLEN	1600
7844	TURNER	1500
7934	MILLER	1300
7521	WARD	1250
8888	J_JAMES	1250
7654	MARTIN	1250
7900	JAMES	950
7777	JJ	    900
7369	SMITH	800
*/

-- 2. 1의 결과를 SUB-QUERY 로 FROM 절에 사용하고
--    메인 쿼리에서 ROWNUM 을 같이 조회
SELECT ROWNUM
     , a.*
  FROM (SELECT e.empno
             , e.ename
             , e.sal
          FROM emp e
         ORDER BY e.sal DESC) a
;

-- 3. 그 때, ROWNUM <= 5 조건을 추가
SELECT ROWNUM
     , a.*
  FROM (SELECT e.empno
             , e.ename
             , e.sal
          FROM emp e
         ORDER BY e.sal DESC) a
 WHERE ROWNUM <= 5
;
/*
1	7839	KING	5000
2	7902	FORD	3000
3	7566	JONES	2975
4	7698	BLAKE	2850
5	7782	CLARK	2450
*/


----------------------------------------------
-- DML : 데이터 조작어 
----------------------------------------------
-- 1) INSERT : 테이블에 데이터 행(row)을 추가하는 명령

-- MEMBER 테이블에 데이터 추가 진행
DROP TABLE member;
CREATE TABLE member
(  member_id    VARCHAR2(4)     
 , member_name  VARCHAR2(15)    NOT NULL
 , phone        VARCHAR2(4)     
 , reg_date     DATE            DEFAULT sysdate
 , address      VARCHAR2(30) 
 , major        VARCHAR2(50)
 , birth_month  NUMBER(2)
 , gender       VARCHAR2(1)     
 , CONSTRAINT PK_MEMBER PRIMARY KEY (member_id)
 , CONSTRAINT CK_GENDER CHECK (gender IN ('F', 'M'))
 , CONSTRAINT CK_BIRTH  CHECK (birth_month BETWEEN 1 AND 12)
);

--- 1. INTO 구문에 컬럼이름 생략시 데이터 추가
--     : VALUES 절에 반드시 전체 컬럼의 데이터를 순서대로 모두 나열
INSERT INTO MEMBER 
VALUES ('M001', '박성협', '9155', sysdate, '수원시', '행정', 3, 'M')
;
INSERT INTO MEMBER 
VALUES ('M002', '오진오', '1418', sysdate, '군포시', NULL, NULL, 'M')
;
/*
INSERT INTO MEMBER 
VALUES ('M002', '오진오', '1418', sysdate, '군포시', 'M');
-- 위처럼 VALUES 절에 나열된 값의 개수가 전체 컬럼 수와 일치하지 않으면
-- 아래와 같은 오류가 발생하므로, NULL 입력을 해서라도 
-- 값의 개수를 맞추어야 한다.

SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다
00947. 00000 -  "not enough values"
*/
INSERT INTO MEMBER 
VALUES ('M003', '이병현', '0186', sysdate, NULL, NULL, 3, 'M')
;
INSERT INTO MEMBER 
VALUES ('M004', '김문정', NULL, sysdate, '청주시', '일어', 3, 'F')
;
INSERT INTO MEMBER 
VALUES ('M005', '송지환', '0322', sysdate, '안양시', '제약', 3, NULL)
;
COMMIT;
/*
1 행 이(가) 삽입되었습니다.
1 행 이(가) 삽입되었습니다.
1 행 이(가) 삽입되었습니다.
1 행 이(가) 삽입되었습니다.
1 행 이(가) 삽입되었습니다.

커밋 완료.
*/

-- PK 제약조건에 위배되는 데이터 추가 시도 : M005 이미 존재
INSERT INTO MEMBER 
VALUES ('M005', '홍길동', '0001', sysdate, '율도국', '도술', 3, 'M')
;
-- ORA-00001: 무결성 제약 조건(SCOTT.PK_MEMBER)에 위배됩니다

-- GENDER 컬럼에 CHECK 제약조건을 위배하는 데이터 추가 시도
-- GENDER 컬럼에, 'F', 'M', NULL 외의 값을 추가하면 
INSERT INTO MEMBER 
VALUES ('M006', '홍길동', '0001', sysdate, '율도국', '도술', 3, 'G')
;
-- ORA-02290: 체크 제약조건(SCOTT.CK_GENDER)이 위배되었습니다

-- BIRTH_MONHT 컬럼에 1 ~ 12 외의 숫자값 입력 시도
INSERT INTO MEMBER 
VALUES ('M006', '홍길동', '0001', sysdate, '율도국', '도술', -1, 'M')
;
-- ORA-02290: 체크 제약조건(SCOTT.CK_BIRTH)이 위배되었습니다

-- MEMBER_NAME 에 NULL 입력 시도
INSERT INTO MEMBER 
VALUES ('M006', NULL, '0001', sysdate, '율도국', '도술', 5, 'M')
;
-- ORA-01400: NULL을 ("SCOTT"."MEMBER"."MEMBER_NAME") 
-- 안에 삽입할 수 없습니다

INSERT INTO MEMBER 
VALUES ('M006', '홍길동', '0001', sysdate, '율도국', '도술', 5, 'M')
;
COMMIT;

