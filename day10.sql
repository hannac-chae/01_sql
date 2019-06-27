-- day 10
---- 7. 조인과 서브쿼리
-- (1) 조인 : JOIN
--    하나 이상의 테이블을 논리적으로 묶어서 하나의 테이블인 것 처럼 다루는 기술
--    조인을 발생시키려면 FROM 절에 조인에 사용할 테이블을 나열

-- 문제) 직원의 소속 부서 번호가 아닌 부서 명을 같이 조회하고 싶다.
-- a) FROM 절에 테이블을 나열
--    emp, dept 두 테이블을 나열 ==> 조인이 발생 ==> 두 테이블의 모든 조합
/* 7777, 8888, 9999 직원정보 삭제

DELETE FROM "SCOTT"."EMP" WHERE EMPNO = 7777
DELETE FROM "SCOTT"."EMP" WHERE EMPNO = 8888
DELETE FROM "SCOTT"."EMP" WHERE EMPNO = 9999

COMMIT;
*/
-- a) FROM 절에 테이블 나열로 조인 발생
SELECT e.empno
     , e.ename
     , e.deptno
     , '|' "구분자"
     , d.deptno
     , d.dname
  FROM emp e
     , dept d
;     
-- ==> (emp)12 x (dept)4 = 48 건의 데이터가 조인으로 생성

-- b) 조인 조건이 추가되어야 직원의 소속부서만 정확히 연결할 수 있다.
SELECT e.empno
     , e.ename
     , e.deptno
     , '|' "구분자"
     , d.deptno
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno = d.deptno -- 오라클의 전통적인 조인 조건 작성 방법
 ORDER BY d.deptno
;

-- 사번, 이름, 부서명 만 남기면
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno = d.deptno -- 오라클의 전통적인 조인 조건 작성 방법
 ORDER BY d.deptno
;

-- 조인 연산자를 사용하여 조인(다른 DBMS 에서 주로 사용)
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e JOIN dept d ON (e.deptno = d.deptno)
 ORDER BY d.deptno
;

-- 위의 결과에서 ACCOUNTING 부서 직원만 알고 싶다.
-- 10부서 직원을 조회하여라
SELECT e.empno
     , e.ename
  FROM emp e
 WHERE e.deptno = 10  
;  

SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno = d.deptno    -- 조인 조건
   AND d.dname = 'ACCOUNTING' -- 일반 조건
;

-- ACCOUNTING 부서 소속인 직원 조회를
-- 조인 연산자를 사용한 쿼리로 변경해보세요.
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e JOIN dept d ON (e.deptno = d.deptno)
 WHERE d.dname = 'ACCOUNTING' -- 일반 조건
;

-- 2) 카티션 곱(카티션 조인)
--           조인 대상 테이블의 데이터를 가능한 모든 조합으로 엮는 것
--           WHERE 절에 조인 조건 누락시 발생
--           CROSS JOIN 연산자로 발생시킴(오라클 9i 버전 이후로 사용가능)

-- emp, dept, salgrade 세 개의 테이블로 카티션 곱 발생
SELECT e.ename
     , d.dname
     , s.grade
  FROM emp e
     , dept d
     , salgrade s
;
-- ==> 12 x 4 x 5 = 240 행의 결과 발생

-- CROSS JOIN 연산자를 사용하면
SELECT e.ename
     , d.dname
     , s.grade
  FROM emp e CROSS JOIN dept d
             CROSS JOIN salgrade s
;             

-- 3) EQUI JOIN : 조인의 가장 기본 형태
--                조인 대상 테이블 사이의 공통 컬럼을 '='로 연결
--                공통 컬럼을 (join-attribute)라고 부름

-- a) 오라클 전통기법으로 WHERE 절 첫번째 줄에 조인 조건을 주는 방법
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno = d.deptno -- 오라클의 전통적인 조인 조건 작성 방법 
;

-- b) JOIN ~ ON 
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e JOIN dept d ON (e.deptno = d.deptno)
;

-- c) NATURAL JOIN 키워드로 자동 조인
--    : ON 절이 없음
--      join-attribute 를 오라클 DBMS 가 자동으로 판단
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e NATURAL JOIN dept d -- 조인 공통 컬럼 명시가 없음.
;  

-- d) JOIN ~ USING 
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e JOIN dept d USING(deptno) 
  -- USING 뒤에 공통 컬럼을 별칭 없이 명시
;

-- 4) 네 가지 EQUI-JOIN 구문 작성 법
-- a) 오라클 전통 조인 구조
SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1, 테이블2 별칭2 [, ...]
 WHERE 별칭1.공통컬럼1 = 별칭2.공통컬럼1 -- 조인조건 WHERE 나열
  [AND 별칭1.공통컬럼2 = 별칭n.공통컬럼2] -- 조인 대상 테이블이 여러개일 경우
  [AND ... ]                              -- WHERE 절에 나열되는 조인조건도 늘어남
  [AND ... 추가 가능한 일반 조건들]
;

-- b) JOIN ~ ON : 표준 SQL 구문
SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1 JOIN 테이블2 별칭2 ON (별칭1.공통컬럼1 = 별칭2.공통컬럼1)
                    [JOIN 테이블3 별칭3 ON (별칭1.공통컬럼2 = 별칭3.공통컬럼2)]
                    [JOIN 테이블n 별칭n ON (별칭n-1.공통컬럼n-1 = 별칭n.공통컬럼n)]
[WHERE 일반조건]
  [AND 일반조건]
;                    

-- c) NATURAL JOIN
SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1 NATURAL JOIN 테이블2 별칭2
                    [NATURAL JOIN 테이블n 별칭n]
;
-- d) JOIN ~ USING
SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1 JOIN 테이블2 별칭2 USING (공통컬럼)
                    [JOIN 테이블n 별칭n USING (공통컬럼)] --별칭 사용없음
;

--------------------------------------------------
-- 5) NON-EQUI JOIN : WHERE 조건절에 join-attribute 사용하는 대신
--                   다른 비교 연산자를 사용하여 여러 테이블을 엮는 기법

-- 문제) emp, salgrade 테이블을 사용해서 직원의 급여에 따른 등급을 함께 조회
SELECT e.empno
     , e.ename
     , e.sal
     , s.grade
  FROM emp e
     , salgrade s
 WHERE e.sal BETWEEN s.losal AND s.hisal
;
-- emp 테이블에는 salgrade 테이블과 동일비교 해서
-- 연결할 수 있는 값이 없음. 따라서 EQUI-JOIN 불가능

-- JOIN ~ ON 으로 변경
SELECT e.empno
     , e.ename
     , e.sal
     , s.grade
  FROM emp e JOIN salgrade s ON (e.sal BETWEEN s.losal AND s.hisal)
;

-- OUTER JOIN 예를 만들기 위해 부서번호가 NULL 인 데이터 생성
/* 
INSERT INTO "SCOTT"."EMP" (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL) VALUES ('7777', 'JJ', 'CLERK', '7902', TO_DATE('2019-06-27 13:09:07', 'YYYY-MM-DD HH24:MI:SS'), '900')
INSERT INTO "SCOTT"."EMP" (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM) VALUES ('8888', 'J_JAMES', 'SALESMAN', '7698', TO_DATE('2019-06-07 13:10:37', 'YYYY-MM-DD HH24:MI:SS'), '1250', '200')

COMMIT;
*/

-- 6) OUTER JOIN : 조인 대상 테이블에서 공통 컬럼에 NULL 값인 데이터도
--                 출력을 원할 때 사용하는 조인 기법

--    연산자 : (+), LEFT OUTER JOIN, RIGHT OUTER JOIN

----- 1. (+) : 오라클에서만 사용하는 OUTER JOIN 연산자
--             EQUI-JOIN 조건에 NULL 값 출력을 원하는 쪽에 붙여서 사용

-- 직원의 정보를 부서명과 함께 조회(일반 EQUI-JOIN)
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno = d.deptno
;

-- JJ, J_JAMES 의 e.deptno 는 NULL 이므로 dept 테이블에 일치하는 값이 없으므로
-- 조인 결과로 두 직원이 조회되지 않는다.

-- 부서 배치가 되지 않은 직원도 모두 출력은 하고 싶다.
-- 그러려면 dept 테이블쪽의 데이터가 NULL 이어도 추가 출력이 필요.
-- 추가 출력을 원하는 쪽에 (+) 연산자를 붙인다.
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno = d.deptno(+)
; 
/*
EMPNO,  ENAME,  DNAME
------------------------------
7782	CLARK	ACCOUNTING
7839	KING	ACCOUNTING
7934	MILLER	ACCOUNTING
7369	SMITH	RESEARCH
7566	JONES	RESEARCH
7902	FORD	RESEARCH
7499	ALLEN	SALES
7521	WARD	SALES
7654	MARTIN	SALES
7698	BLAKE	SALES
7844	TURNER	SALES
7900	JAMES	SALES
7777	JJ	
8888	J_JAMES	
*/
-- (+) 연산자는 오른쪽에 붙이 이는 NULL 상태로 출력될 테이블을 결정짓는다.
-- 전체 데이터 기준삼는 테이블이 왼쪽이기 때문에 
-- LEFT OUTER JOIN 이 발생함.


----- 2. LEFT OUTER JOIN ~ ON
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e LEFT OUTER JOIN dept d ON (e.deptno = d.deptno)
;
-- ON 절에 쓰는 조인 조건은 EQUI-JOIN 과 동일하지만
-- LEFT OUTER JOIN 연산자에 의해
-- 이 연산자 왼쪽에 위치한 테이블의 모든 데이터는 출력을 보장받는다.
-- 결과는 (+) 연산자를 오른쪽에 붙인 결과와 동일



---- 3. RIGHT OUTER JOIN 

-- 문제) 직원이 아직 아무도 배치되지 않은 부서가 있어도 
--       모든 부서가 출력되길 바라면

-- (+) 연산자로 해결 : '=' 연산자 오른쪽에 쓴다
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno(+) = d.deptno
; 
/*
7839	KING	ACCOUNTING
7782	CLARK	ACCOUNTING
7934	MILLER	ACCOUNTING
7902	FORD	RESEARCH
7369	SMITH	RESEARCH
7566	JONES	RESEARCH
7900	JAMES	SALES
7844	TURNER	SALES
7654	MARTIN	SALES
7521	WARD	SALES
7499	ALLEN	SALES
7698	BLAKE	SALES
		        OPERATIONS
*/

-- RIGHT OUTER JOIN ~ ON
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e RIGHT OUTER JOIN dept d ON (e.deptno = d.deptno)
; 
-- ON 절에는 EQUI-JOIN 과 동일한 조인 조건을 쓰고
-- RIGHT OUTER JOIN 연산자에 의해 오른쪽 테이블인 dept 테이블의
-- 데이터는 모두 출력을 보장받는다.


----- 4. FULL OUTER JOIN :

-- 문제) 부서 배치가 안된 직원도 조회하고 싶고
--       직원이 아무도 없는 부서도 조회하고 싶을 때
--       즉, 조인 대상 양쪽 테이블에 존재하는 NULL 값들을 
--       모두 한번에 조회하려면?

-- (+) 연산자로는 불가능
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno(+) = d.deptno(+)
; 
/*
ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다
01468. 00000 -  "a predicate may reference only one outer-joined table"
*/

-- FULL OUTER JOIN ~ ON 연산자로 지원
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e FULL OUTER JOIN dept d ON e.deptno = d.deptno
; 
/*
EMPNO,  ENAME,  DNAME
---------------------------
7777	JJ	
8888	J_JAMES	
7369	SMITH	RESEARCH
7499	ALLEN	SALES
7521	WARD	SALES
7566	JONES	RESEARCH
7654	MARTIN	SALES
7698	BLAKE	SALES
7782	CLARK	ACCOUNTING
7839	KING	ACCOUNTING
7844	TURNER	SALES
7900	JAMES	SALES
7902	FORD	RESEARCH
7934	MILLER	ACCOUNTING
		        OPERATIONS
*/

-- 문제) 직원이 아무도 없는 부서를 모두 조회하고 싶다.
--       dept 테이블을 왼쪽에 배치해서 조인을 거는 경우
--       LEFT OUTER JOIN 으로 해결하면 된다.
SELECT d.dname
     , e.ename
  FROM dept d
     , emp e
 WHERE d.deptno = e.deptno(+)     
;     

----- 5. SELF JOIN
--       : 한 테이블 내에서 자기 자신의 컬럼끼리 연결하여 
--         논리적인 새 행을 만드는 기법

-- 문제) emp 테이블에 직원 정보를 조회할 때
--       그 직원의 상사(매니저) 이름을 같이 조회하고 싶다.

SELECT e.empno  "사번"
     , e.ename  "이름"
     , e.mgr    "상사 사번"
     , e1.ename "상사 이름"
  FROM emp e
     , emp e1
 WHERE e.mgr = e1.empno    
;     
/*
사번,   이름,   상사 사번, 상사 이름
-----------------------------------
7902	FORD	7566	JONES
8888	J_JAMES	7698	BLAKE
7654	MARTIN	7698	BLAKE
7900	JAMES	7698	BLAKE
7844	TURNER	7698	BLAKE
7521	WARD	7698	BLAKE
7499	ALLEN	7698	BLAKE
7934	MILLER	7782	CLARK
7698	BLAKE	7839	KING
7566	JONES	7839	KING
7782	CLARK	7839	KING
7777	JJ	    7902	FORD
7369	SMITH	7902	FORD
*/
-- 위의 결과는 SELF-JOIN  이면서 EQUI-JOIN 이기때문에
-- 상사가 없는 직원은 조회되지 않는다.
-- KING 은 조회되지 않음.

-- 상사가 없는 직원도 조회하고 싶으면
-- a) e테이블 기준으로 모든 데이터가 조회되어야 함
-- b) (+) 기호를 오른쪽에 붙이거나
SELECT e.empno  "사번"
     , e.ename  "이름"
     , e.mgr    "상사 사번"
     , e1.ename "상사 이름"
  FROM emp e
     , emp e1
 WHERE e.mgr = e1.empno(+)
;     
-- c) LEFT OUTER JOIN ~ ON 을 사용
SELECT e.empno  "사번"
     , e.ename  "이름"
     , e.mgr    "상사 사번"
     , e1.ename "상사 이름"
  FROM emp e LEFT OUTER JOIN emp e1 ON e.mgr = e1.empno
;  
/*
사번,   이름,   상사 사번, 상사 이름
------------------------------
7902	FORD	7566	JONES
8888	J_JAMES	7698	BLAKE
7499	ALLEN	7698	BLAKE
7521	WARD	7698	BLAKE
7654	MARTIN	7698	BLAKE
7844	TURNER	7698	BLAKE
7900	JAMES	7698	BLAKE
7934	MILLER	7782	CLARK
7566	JONES	7839	KING
7698	BLAKE	7839	KING
7782	CLARK	7839	KING
7777	JJ	    7902	FORD
7369	SMITH	7902	FORD
7839	KING		         
*/

-- 부하 직원이 없는 직원들 조회
SELECT e.empno  "사번"
     , e.ename  "이름"
     , e.mgr    "상사 사번"
     , e1.ename "상사 이름"
  FROM emp e
     , emp e1
 WHERE e.mgr(+) = e1.empno
 ORDER BY "사번" DESC 
;
/*
사번, 이름, 상사 사번, 상사 이름
----------------------------------
                        SMITH
                        J_JAMES
                        WARD
                        ALLEN
                        MILLER
                        JAMES
                        TURNER
                        JJ
                        MARTIN
8888	J_JAMES	7698	BLAKE
7934	MILLER	7782	CLARK
7902	FORD	7566	JONES
7900	JAMES	7698	BLAKE
7844	TURNER	7698	BLAKE
7782	CLARK	7839	KING
7777	JJ	7902	FORD
7698	BLAKE	7839	KING
7654	MARTIN	7698	BLAKE
*/
-- RIGHT OUTER JOIN ~ ON 으로 변경
SELECT e.empno  "사번"
     , e.ename  "이름"
     , e.mgr    "상사 사번"
     , e1.ename "상사 이름"
  FROM emp e RIGHT OUTER JOIN emp e1 ON (e.mgr = e1.empno)
 ORDER BY "사번" DESC 
;

-- 수업중 실습 문제)
-- 1. 사번, 이름, 직무, 상사이름, 부서명, 부서위치 를 조회하시오.
--    emp e, emp e1, dept d
SELECT e.empno  사번
     , e.ename  이름
     , e.job    직무
     , e1.ename 상사이름
     , d.dname  부서명
     , d.loc    부서위치
  FROM emp e
     , emp e1
     , dept d
 WHERE e.mgr = e1.empno
   AND e.deptno = d.deptno
 ORDER BY d.deptno   
;     
-- 위의 구문을 JOIN ~ ON 으로 변경
SELECT e.empno  사번
     , e.ename  이름
     , e.job    직무
     , e1.ename 상사이름
     , d.dname  부서명
     , d.loc    부서위치
  FROM emp e JOIN emp e1 ON (e.mgr = e1.empno)
             JOIN dept d ON (e.deptno = d.deptno)
 ORDER BY d.deptno   
;
/*
사번,   이름,   직무,     상사이름, 부서명,      부서위치
--------------------------------------------------------
7782	CLARK	MANAGER	    KING	ACCOUNTING	NEW YORK
7934	MILLER	CLERK	    CLARK	ACCOUNTING	NEW YORK
7902	FORD	ANALYST	    JONES	RESEARCH	DALLAS
7566	JONES	MANAGER	    KING	RESEARCH	DALLAS
7369	SMITH	CLERK	    FORD	RESEARCH	DALLAS
7698	BLAKE	MANAGER	    KING	SALES	    CHICAGO
7521	WARD	SALESMAN	BLAKE	SALES	    CHICAGO
7654	MARTIN	SALESMAN	BLAKE	SALES	    CHICAGO
7844	TURNER	SALESMAN	BLAKE	SALES	    CHICAGO
7900	JAMES	CLERK	    BLAKE	SALES	    CHICAGO
7499	ALLEN	SALESMAN	BLAKE	SALES	    CHICAGO
*/
-- 상사가 없거나, 부서가 배정되지 않은 직원도 모두 출력하시오.
-- 1.1) (+) 연산자로 해결

-- 1.2) LEFT OUTER JOIN ~ ON 으로 해결


-- 1.3) 상사가 없거나, 부서가 배정되지 않은 직원도 모두 출력하며
-- 상사가 없을 때 상사이름 대신  '-' 가
-- 부서가 배정되지 않았을 때 부서명, 부서위치 대신 
-- '-' 가 출력되도록 하시오


-- 2. 사번, 이름, 급여, 급여등급, 부서명, 부서위치 를 조회하시오.
--    emp e, dept d, salgrade s
SELECT e.empno  사번
     , e.ename  이름
     , e.sal    급여
     , s.grade  급여등급
     , d.dname  부서명
     , d.loc    부서위치
  FROM emp e
     , dept d
     , salgrade s
 WHERE e.sal BETWEEN s.losal AND s.hisal
   AND e.deptno = d.deptno
;
-- 위의 구문을 JOIN ~ ON 으로 변경
SELECT e.empno  사번
     , e.ename  이름
     , e.sal    급여
     , s.grade  급여등급
     , d.dname  부서명
     , d.loc    부서위치
  FROM emp e JOIN dept d     ON (e.deptno = d.deptno)
             JOIN salgrade s ON (e.sal BETWEEN s.losal AND s.hisal)
;
/*
사번, 이름, 급여, 급여등급, 부서명, 부서위치
-------------------------------------------------
7839	KING	5000	5	ACCOUNTING	NEW YORK
7902	FORD	3000	4	RESEARCH	DALLAS
7566	JONES	2975	4	RESEARCH	DALLAS
7698	BLAKE	2850	4	SALES	CHICAGO
7782	CLARK	2450	4	ACCOUNTING	NEW YORK
7499	ALLEN	1600	3	SALES	CHICAGO
7844	TURNER	1500	3	SALES	CHICAGO
7934	MILLER	1300	2	ACCOUNTING	NEW YORK
7654	MARTIN	1250	2	SALES	CHICAGO
7521	WARD	1250	2	SALES	CHICAGO
7900	JAMES	950	1	SALES	CHICAGO
7369	SMITH	800	1	RESEARCH	DALLAS
*/

-- 부서가 배정되지 않은 직원도 모두 출력하시오
-- 2.1) (+) 연산자로 해결

-- 2.2) LEFT OUTER JOIN ~ ON 으로 해결


-- 2.3) 부서가 배정되지 않은 직원은 
--      부서명, 부서위치 대신 '-' 이 출력되도록 하시오.


-- 2.4) 부서별 소속 인원을 출력하시오.
--      이때 부서 명으로 출력하시오.
--      또한, 직원이 없는 부서도 출력하시오.

/* 실행결과 다음과 같이 나옵니다.

부서 명, 인원(명)
------------------
RESEARCH	3
SALES	    6
ACCOUNTING	3
OPERATIONS	0
*/

-- 2.5) 2.4의 결과에 부서가 미배정된 인원까지 출력하시오.
--      이 때, 부서가 없는 직원은 '부서 미배정'으로 출력하시오.

/* 실행결과 다음과 같이 나옵니다.
부서 명     인원(명)
-----------------
ACCOUNTING	3
OPERATIONS	0
RESEARCH	3
SALES	    6
부서 미배정	2
*/
 
