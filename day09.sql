-- day09 : 
-- 2. 복수행 함수(그룹 함수)

-- 1) COUNT(*) : FROM 절에 나열된
--               특정 테이블의 행의 개수(데이터 개수)를 세어주는 함수
--               NULL 값을 처리하는 "유일"한 그룹함수

--    COUNT(expr) : expr 으로 등장한 값을 NULL 제외하고 세어주는 함수

--문제) dept, salgrade 테이블의 전체 데이터 개수 조회
-- 1. dept 테이블 조회
SELECT d.*
  FROM dept d
;  
/* 단일행 함수의 실행 과정 :
-------------------------------
10	ACCOUNTING	NEW YORK ====> SUBSTR(dname, 1, 5) ====> ACCOU
20	RESEARCH	DALLAS   ====> SUBSTR(dname, 1, 5) ====> RESEA
30	SALES	    CHICAGO  ====> SUBSTR(dname, 1, 5) ====> SALES
40	OPERATIONS	BOSTON   ====> SUBSTR(dname, 1, 5) ====> OPERA
*/

/* 그룹함수(COUNT(*))의 실행 과정:
----------------------------------
10	ACCOUNTING	NEW YORK ====>
20	RESEARCH	DALLAS   ====> COUNT(*) ====> 4
30	SALES	    CHICAGO  ====>
40	OPERATIONS	BOSTON   ====>
*/
-- 2. dept 테이블의 데이터 개수 조회 : COUNT(*) 사용
SELECT COUNT(*) "부서 개수"
  FROM dept d
;  
/*
부서 개수
---------
        4
*/

-- salgrade(급여등급) 테이블의 급여 등급 개수를 조회
SELECT COUNT(*) "급여 등급 개수"
  FROM salgrade
;  
/*
급여 등급 개수
--------------
            5
*/
SELECT s.*
  FROM salgrade s
;  
/*
1	700	    1200   =====>
2	1201	1400   =====>
3	1401	2000   =====> COUNT(*) =====> 5
4	2001	3000   =====>
5	3001	9999   =====>
*/

-- COUNT(expr) 이 NULL 데이터를 처리하지 못하는 것 확인을 위한 데이터 추가
INSERT INTO "SCOTT"."EMP" (EMPNO, ENAME) VALUES ('7777', 'JJ');
COMMIT;

-- emp 테이블에서 job 컬럼의 데이터 개수를 카운트
SELECT COUNT(e.job) "직무가 배정된 직원의 수"
  FROM emp e
;  
/*
직무가 배정된 직원의 수
-----------------------
                    14

*/
/*
7777	JJ	    (null)      ====>
7369	SMITH	CLERK       ====>
7499	ALLEN	SALESMAN    ====>
7521	WARD	SALESMAN    ====>
7566	JONES	MANAGER     ====>
7654	MARTIN	SALESMAN    ====> 개수를 세는 기준 컬럼인 job 에
7698	BLAKE	MANAGER     ====> null 인 한 행은 처리를 하지 않는다.
7782	CLARK	MANAGER     ====> 
7839	KING	PRESIDENT   ====> COUNT(e.job)  ====> 14
7844	TURNER	SALESMAN    ====>
7900	JAMES	CLERK       ====>
7902	FORD	ANALYST     ====>
7934	MILLER	CLERK       ====>
9999	J_JAMES	CLERK       ====>
8888	J%JAMES	CLERK	    ====>	
*/

-- 문제) 회사에 매니저가 배정된 직원이 몇명인가
--       별칭 : 상사가 있는 직원의 수
SELECT COUNT(e.mgr) "상사가 있는 직원의 수"
  FROM emp e
;  
/*
상사가 있는 직원의 수
---------------------
                   11
*/

-- 문제) 매니저 직을 맡고 있는 직원이 몇명인가?
-- 1. emp 테이블의 mgr 컬럼의 데이터 형태를 파악
-- 2. mrg 컬럼의 중복 데이터를 제거
SELECT DISTINCT e.mgr
  FROM emp e
;  
/*
MGR
-----
7782
7698
7902
7566
(null)
7839
*/
-- 3. 중복 데이터가 제거된 결과를 카운트
SELECT COUNT(DISTINCT e.mgr) "매니저 수"
  FROM emp e
;  
/*
매니저 수
---------
        5
*/

-- 문제) 부서가 배정된 직원이 몇명이나 있는가?
SELECT COUNT(e.deptno) "부서 배정 인원"
  FROM emp e
;  
/*
부서 배정 인원
--------------
            12
*/

-- COUNT(*) 가 아닌 COUNT(e.deptno)을 사용한 경우에는
SELECT e.deptno
  FROM emp e
 WHERE e.deptno IS NOT NULL  
;  
-- 을 수행한 결과를 카운트 한 것으로 생각할 수 있음.

-- 문제) 전체인원, 부서 배정 인원, 부서 미배정 인원을 구하시오
SELECT COUNT(*) 전체인원
     , COUNT(e.deptno) "부서 배정 인원"
     , COUNT(*) - COUNT(e.deptno) "부서 미배정 인원"
  FROM emp e;
;  

-- SUM(expr) : NULL 항목 제외하고
--             합산 가능한 행을 모두 더한 결과를 출력

-- SALESMAN 들의 수당 총합을 구해보자.
SELECT SUM(e.comm) "수당 총합"
  FROM emp e
;  
/*
COMM
------
(null)  
(null)  
    300 =====>
    500 =====>
(null)  
   1400 =====>
(null)           SUM(e.comm) =====> 2200 : 자동으로 NULL 컬럼 제외
(null)  
(null)  
      0 =====>
(null) 
(null)  
(null)  
(null)  
(null)  
*/

SELECT SUM(e.comm) "수당 총합"
  FROM emp e
 WHERE e.job = 'SALESMAN'  
; 
/*
  COMM
------
   300 =====>
   500 =====>
  1400 =====> SUM(e.comm) =====> 2200 
     0 =====>
*/

-- 수당 총합 결과에 숫자 출력 패턴을 적용 $, 세자리 끊어 읽기 적용
SELECT TO_CHAR(SUM(e.comm), '$9,999') "수당 총합"
  FROM emp e
 WHERE e.job = 'SALESMAN'  
; 
/*
 수당 총합
----------
    $2,200
*/

-- 3) AVG(expr) : NULL 값 제외하고 연산 가능한 항목의 산술 평균을 구함

-- SALESMAN 의 수당 평균을 구해보자.
SELECT AVG(e.comm) "수당 평균"
  FROM emp e
;
SELECT AVG(e.comm) "수당 평균"
  FROM emp e
 WHERE e.job = 'SALESMAN'  
;
-- 수당 평균 결과에 숫자 출력 패턴 $, 세자리 끊어 읽기 적용
SELECT TO_CHAR(AVG(e.comm), '$9,999') "수당 평균"
  FROM emp e
 WHERE e.job = 'SALESMAN'  
; 

-- 4) MAX(expr) : expr에 등장한 값 중 최댓값을 구함
--                expr이 문자인 경우는 알파벳순 뒷쪽에 위치한 글자를 
--                최댓값으로 계산

-- 이름이 가장 나중인 직원
SELECT MAX(e.ename) "이름이 가장 나중인 직원"
  FROM emp e
;
/*
이름이 가장 나중인 직원
------------------------
WARD
*/

-- 5) MIN(expr) : expr에 등장한 값 중 최솟값을 구함
--                expr이 문자인 경우는 알파벳순 앞쪽에 위치한 글자를 
-- 
SELECT MIN(e.ename) "이름이 가장 앞인 직원"
  FROM emp e
;
/*
이름이 가장 앞인 직원
---------------------
ALLEN
*/

---- 3. GROUP BY 절의 사용
-- 문제) 각 부서별로 급여의 총합, 평균, 최대, 최소를 조회

-- 각 부서별로 급여의 총합을 조회하려면
--    총합 : SUM() 을 사용
--    그룹화 기준을 부서번호(deptno)를 사용
--    GROUP BY 절이 등장해야 함

-- a) 먼저 emp 테이블에서 급여 총합을 구하는 구문 작성
SELECT SUM(e.sal)
  FROM emp e
;  

-- b) 부서 번호를 기준으로 그룹화 진행

--    SUM()은 그룹함수다.
--    GROUP BY 절을 조합하면 그룹화 가능하다.
--    그룹화를 하려면 기준컬럼이 GROUP BY 절에 등장해야 함.

SELECT e.deptno 부서번호 -- 그룹화 기준컬럼으로 SELECT 절에 등장
     , SUM(e.sal) "부서 급여 총함" -- 그룹함수가 사용된 컬럼
  FROM emp e
 GROUP BY e.deptno -- 그룹화 기준컬럼으로 GROUP BY 절에 등장
 ORDER BY e.deptno -- 부서번호 정렬 
;  

-- GROUP BY 절에 그룹화 기준 컬럼으로 등장한 컬럼이 아닌 것이
-- SELECT 절에 등장하면 오류, 실행불가

SELECT e.deptno 부서번호 -- 그룹화 기준컬럼으로 SELECT 절에 등장
     , e.job   -- 그룹화 기준컬럼이 아닌데 SELECT 절에 등장 -> 오류의 원인
     , SUM(e.sal) "부서 급여 총함" -- 그룹함수가 사용된 컬럼
  FROM emp e
 GROUP BY e.deptno -- 그룹화 기준컬럼으로 GROUP BY 절에 등장
 ORDER BY e.deptno -- 부서번호 정렬 
; 
/*
ORA-00979: GROUP BY 표현식이 아닙니다.
00979. 00000 -  "not a GROUP BY expression"
*/

-- 문제) 부서별 급여의 총합, 평균, 최대, 최소

SELECT e.deptno 부서번호 
     , SUM(e.sal) "부서 급여 총합" 
     , AVG(e.sal) "부서 급여 평균"
     , MAX(e.sal) "부서 급여 최대"
     , MIN(e.sal) "부서 급여 최소"
  FROM emp e
 GROUP BY e.deptno 
 ORDER BY e.deptno 
; 

-- 숫자 패턴 적용
SELECT e.deptno 부서번호 
     , TO_CHAR(SUM(e.sal), '$9,999') "부서 급여 총합" 
     , TO_CHAR(AVG(e.sal), '$9,999.99') "부서 급여 평균"
     , TO_CHAR(MAX(e.sal), '$9,999') "부서 급여 최대"
     , TO_CHAR(MIN(e.sal), '$9,999') "부서 급여 최소"
  FROM emp e
 GROUP BY e.deptno 
 ORDER BY e.deptno 
; 
/*\
부서번호, 급여 총합, 급여 평균, 급여 최대, 급여 최소
----------------------------------------------------
    10	     $8,750	 $2,916.67	    $5,000	 $1,300
    20	     $6,775	 $2,258.33	    $3,000	   $800
    30	     $9,400	 $1,566.67	    $2,850	   $950
				
*/
-- 부서번호를 삭제한 쿼리
SELECT TO_CHAR(SUM(e.sal), '$9,999') "부서 급여 총합" 
     , TO_CHAR(AVG(e.sal), '$9,999.99') "부서 급여 평균"
     , TO_CHAR(MAX(e.sal), '$9,999') "부서 급여 최대"
     , TO_CHAR(MIN(e.sal), '$9,999') "부서 급여 최소"
  FROM emp e
 GROUP BY e.deptno 
 ORDER BY e.deptno 
; 

/*
위의 쿼리는 수행되지만 정확하게 어느 부서의 결과인지 알 수 없다는 단점이 존재

그래서, GROUP BY 절에 등장하는 기준컬럼은 SELECT 절에 똑같이 등장하는 편이
결과 해석에 편리하다.

SELECT 절에 나열된 컬럼중에서 그룹함수가 사용되지 않는 컬럼이 없기때문에
위의 쿼리는 수행되는 것이다.
*/

-- 문제) 부서별, 직무별 급여의 총합, 평균, 최대, 최소를 구해보자.
SELECT e.deptno 부서번호 
     , e.job 직무
     , SUM(e.sal) "부서 급여 총합" 
     , AVG(e.sal) "부서 급여 평균"
     , MAX(e.sal) "부서 급여 최대"
     , MIN(e.sal) "부서 급여 최소"
  FROM emp e
 GROUP BY e.deptno, e.job
 ORDER BY e.deptno 
; 
/*
부서번호, 직무, 급여 총합, 급여 평균, 급여 최대, 급여 최소
    10	CLERK	    1300	    1300	    1300	1300
    10	MANAGER	    2450	    2450	    2450	2450
    10	PRESIDENT	5000	    5000	    5000	5000
    20	ANALYST	    3000	    3000	    3000	3000
    20	CLERK	    800	        800	        800	     800
    20	MANAGER	    2975	    2975	    2975	2975
    30	CLERK	    950	        950	        950	     950
    30	MANAGER	    2850	    2850	    2850	2850
    30	SALESMAN	5600	    1400	    1600	1250
        CLERK				
                        
*/


-- 오류상황
-- a) GROUP BY 절에 그룹화 기준이 누락된 경우
SELECT e.deptno 부서번호 
     , e.job 직무                -- SELECT 에는 등장
     , SUM(e.sal) "부서 급여 총합" 
     , AVG(e.sal) "부서 급여 평균"
     , MAX(e.sal) "부서 급여 최대"
     , MIN(e.sal) "부서 급여 최소"
  FROM emp e
 GROUP BY e.deptno               -- GROUP BY 에는 누락된 job 컬럼
 ORDER BY e.deptno 
;
/*
ORA-00979: GROUP BY 표현식이 아닙니다.
00979. 00000 -  "not a GROUP BY expression"
*/

-- b) SELECT 절에 그룹함수와 일반 컬럼이 섞여 등장
--    GROUP BY 절 전체가 누락된 경우
SELECT e.deptno 부서번호 
     , e.job 직무                
     , SUM(e.sal) "부서 급여 총합" 
     , AVG(e.sal) "부서 급여 평균"
     , MAX(e.sal) "부서 급여 최대"
     , MIN(e.sal) "부서 급여 최소"
  FROM emp e
-- GROUP BY e.deptno, e.job             
 ORDER BY e.deptno 
;
/*
ORA-00937: 단일 그룹의 그룹 함수가 아닙니다
00937. 00000 -  "not a single-group group function"
*/

-- 문제) 직무(job) 별 급여의 총합, 평균, 최대, 최소 를 구해보자
--      별칭 : 직무, 급여총합, 급여평균, 최대급여, 최소급여
SELECT e.job 직무                
     , SUM(e.sal) "급여총합" 
     , AVG(e.sal) "급여평균"
     , MAX(e.sal) "최대급여"
     , MIN(e.sal) "최소급여"
  FROM emp e
 GROUP BY e.job
 ORDER BY e.job
;
-- 직무가 null인 사람들은 직무명 대신 '직무 미배정'으로 출력
SELECT NVL(e.job, '직무 미배정') 직무                
     , SUM(e.sal) "급여총합" 
     , AVG(e.sal) "급여평균"
     , MAX(e.sal) "최대급여"
     , MIN(e.sal) "최소급여"
  FROM emp e
 GROUP BY e.job
 ORDER BY e.job
;

-- 부서별 총합, 평균, 최대, 최소 
-- 부서번호가 null 인경우 '부서 미배정' 으로 분류되도록 조회
SELECT NVL(e.deptno, '부서 미배정') 부서번호 
     , TO_CHAR(SUM(e.sal), '$9,999') "부서 급여 총합" 
     , TO_CHAR(AVG(e.sal), '$9,999.99') "부서 급여 평균"
     , TO_CHAR(MAX(e.sal), '$9,999') "부서 급여 최대"
     , TO_CHAR(MIN(e.sal), '$9,999') "부서 급여 최소"
  FROM emp e
 GROUP BY e.deptno 
 ORDER BY e.deptno 
; 
/* deptno 는 숫자, '부서 미배정' 은 문자 데이터이므로 타입 불일치로
   NVL() 이 작동하지 못한다.
   
ORA-01722: 수치가 부적합합니다
01722. 00000 -  "invalid number"
*/

-- 해결방법 : deptno 의 값을 문자화 TO_CHAR() 사용
SELECT NVL(TO_CHAR(e.deptno), '부서 미배정') 부서번호 
     , TO_CHAR(SUM(e.sal), '$9,999') "부서 급여 총합" 
     , TO_CHAR(AVG(e.sal), '$9,999.99') "부서 급여 평균"
     , TO_CHAR(MAX(e.sal), '$9,999') "부서 급여 최대"
     , TO_CHAR(MIN(e.sal), '$9,999') "부서 급여 최소"
  FROM emp e
 GROUP BY e.deptno 
 ORDER BY e.deptno 
; 
-- 숫자를 문자로 변경 : 결합연산자(||) 를 사용
SELECT NVL(e.deptno || '', '부서 미배정') 부서번호 
     , TO_CHAR(SUM(e.sal), '$9,999') "부서 급여 총합" 
     , TO_CHAR(AVG(e.sal), '$9,999.99') "부서 급여 평균"
     , TO_CHAR(MAX(e.sal), '$9,999') "부서 급여 최대"
     , TO_CHAR(MIN(e.sal), '$9,999') "부서 급여 최소"
  FROM emp e
 GROUP BY e.deptno 
 ORDER BY e.deptno 
; 
-- NVL, DECODE, TO_CHAR 조합으로 해결
SELECT DECODE(NVL(e.deptno, 0), e.deptno, TO_CHAR(e.deptno)
                              , 0       , '부서 미배정') "부서번호"
     , TO_CHAR(SUM(e.sal), '$9,999') "급여 총합" 
     , TO_CHAR(AVG(e.sal), '$9,999.99') "급여 평균"
     , TO_CHAR(MAX(e.sal), '$9,999') "최대 급여"
     , TO_CHAR(MIN(e.sal), '$9,999') "최소 급여"
  FROM emp e
 GROUP BY e.deptno 
 ORDER BY e.deptno 
;

------ 4. HAVING 절의 사용

-- GROUP BY 결과에 조건을 걸어서
-- 그 결과를 제한할 목적으로 사용되는 절.

-- HAVING 절은 WHERE 절과 비슷하지만 
-- SELECT 구문의 실행 순서때문에
-- GROUP BY 절 보다 먼저 실행되는 WHERE 절로는
-- GROUP BY 결과를 제한할 수 없다.

-- 따라서 GROUP BY 다음 수행순서를 가지는 
-- HAVING 에서 제한한다.

-- 문제) 부서별 급여 평균이 2000 이상인 부서를 조회하여라.

-- a) 우선 부서별 급여 평균을 구한다.
SELECT e.deptno "부서번호"
     , AVG(e.sal) "급여평균"
  FROM emp e
 GROUP BY e.deptno
;  

-- b) a의 결과에서 급여평균이 2000이상인 값만 남긴다.
--    HAVING 으로 결과 제한
SELECT e.deptno "부서번호"
     , AVG(e.sal) "급여평균"
  FROM emp e
 GROUP BY e.deptno
HAVING AVG(e.sal) >= 2000
;  
-- 결과에 숫자 패턴
SELECT e.deptno "부서번호"
     , TO_CHAR(AVG(e.sal), '$9,999.99') "급여평균"
  FROM emp e
 GROUP BY e.deptno
HAVING AVG(e.sal) >= 2000
;  

-- 주의 : HAVING 에는 별칭을 사용할 수 없다.
SELECT e.deptno "부서번호"
     , AVG(e.sal) "급여평균"
  FROM emp e
 GROUP BY e.deptno
HAVING "급여평균" >= 2000 --  HAVING에 별칭은 사용할 수 없음
; 
/*
ORA-00904: "급여평균": 부적합한 식별자
00904. 00000 -  "%s: invalid identifier"
*/

-- HAVING 절이 존재하는 경우 SELECT 구문의 실행 순서 정리
/*
 1. FROM        절의 테이블 각 행 모두를 대상으로
 2. WHERE       절의 조건에 맞는 행만 선택하고
 3. GROUP BY    절에 나온 컬럼, 식(함수 식) 으로 그룹화 진행
 4. HVAING      절의 조건을 만족시키는 그룹행만 선택
 5.             4까지 선택된 그룹 정보를 가진 행에 대해서
 6. SELECT      절에 명시된 컬럼, 식(함수 식)만 출력
 7. ORDER BY    가 있다면 정렬 조건에 맞추어 최종 정렬하여 결과 출력
*/

----------------------------------------------------------------------
-- 수업중 실습

-- 1. 매니저별, 부하직원의 수를 구하고, 많은 순으로 정렬
--   : mgr 컬럼이 그룹화 기준 컬럼
SELECT e.MGR     as "매니저 사번"
     , COUNT(*)  as "부하직원 수"
  FROM emp e
 WHERE e.MGR IS NOT NULL
 GROUP BY e.MGR 
;

-- 2. 부서별 인원을 구하고, 인원수 많은 순으로 정렬
--    : deptno 컬럼이 그룹화 기준 컬럼
SELECT e.DEPTNO  as "부서 번호"
     , COUNT(*)  as "인원(명)"
  FROM emp e
 WHERE e.DEPTNO IS NOT NULL
 GROUP BY e.DEPTNO
 ORDER BY "인원(명)" DESC
;
-- 2.2 deptno 가 null 인 데이터는 '부서 미배정' 으로 출력되도록 처리
SELECT nvl(e.DEPTNO || '', '미배정') as "부서 번호"
     , COUNT(*)  as "인원(명)"
  FROM emp e
 GROUP BY e.DEPTNO
 ORDER BY "인원(명)" DESC
;

-- 3. 직무별 급여 평균 구하고, 급여평균 높은 순으로 정렬
--   : job 이 그룹화 기준 컬럼
SELECT e.JOB      as "직무"
     , AVG(e.SAL) as "급여 평균"
  FROM emp e
 GROUP BY e.JOB
 ORDER BY "급여 평균" DESC
;

-- 3.2 job 이 null 인 데이터는 '직무 미배정' 으로 출력되도록 처리
SELECT nvl(e.JOB, '직무 미배정') as "직무"
     , AVG(e.SAL)                as "급여 평균"
  FROM emp e
 GROUP BY e.JOB
 ORDER BY "급여 평균" DESC
;

-- 4. 직무별 급여 총합 구하고, 총합 높은 순으로 정렬
--   : job 이 그룹화 기준 컬럼
SELECT e.JOB      as "직무"
     , SUM(e.SAL) as "급여 총합"
  FROM emp e
 GROUP BY e.JOB
 ORDER BY "급여 총합" DESC
;  

-- 5. 급여의 앞단위가 1000미만, 1000, 2000, 3000, 5000 별로 인원수를 구하시오
--    급여 단위 오름차순으로 정렬
-- a) 급여 단위를 어떻게 구할 것인가? TRUNC() 활용
SELECT e.EMPNO
     , e.ENAME
     , TRUNC(e.SAL, -3) as "급여 단위"
  FROM emp e
;

-- b) TRUNC 로 얻어낸 급여단위를 COUNT 하면 인원수를 구할 수 있겠다.
--    TRUNC(e.SAL, -3) 로 잘라낸 값이 그룹화 기준값으로 사용됨
SELECT TRUNC(e.SAL, -3)       as "급여 단위"
     , COUNT(TRUNC(e.SAL, -3))
  FROM emp e
 GROUP BY TRUNC(e.SAL, -3)
 ORDER BY "급여 단위" 
;

-- c) 급여 단위가 1000 미만인 경우 0으로 출력되는 것을 변경
--   : 범위 연산이 필요해 보임 ===> CASE 구문 선택
SELECT CASE WHEN TRUNC(e.SAL, -3) < 1000 THEN '1000 미만'
            ELSE TRUNC(e.SAL, -3) || ''            
        END as "급여 단위"
     , COUNT(TRUNC(e.SAL, -3)) "인원(명)"
  FROM emp e
 GROUP BY TRUNC(e.SAL, -3)
 ORDER BY TRUNC(e.SAL, -3)
;

-------------------------------------------------------------------------------
--- 5번을 다른 함수로 풀이
-- a) sal 컬럼에 왼쪽으로 패딩을 붙여서 0을 채움
SELECT e.EMPNO
     , e.ENAME
     , LPAD(e.SAL, 4, '0')
  FROM emp e
;
-- b) 맨 앞의 글자를 잘라낸다. ==> 단위를 구함
SELECT e.EMPNO
     , e.ENAME
     , SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1)
  FROM emp e
;

-- c) 단위로 처리 + COUNT + 그룹화
SELECT SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1) "급여 단위"
     , COUNT(*) "인원(명)"
  FROM emp e
 GROUP BY SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1)
;  
  
-- d) 1000 단위로 출력 형태 변경
SELECT CASE WHEN SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1) = 0 THEN '1000 미만'
            ELSE TO_CHAR(SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1) * 1000)
        END  "급여 단위"
     , COUNT(*) "인원(명)"
  FROM emp e
 GROUP BY SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1)
 ORDER BY SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1)
;



--------------------------------------------------------------------------------
-- 6. 직무별 급여 합의 단위를 구하고, 급여 합의 단위가 큰 순으로 정렬
-- a) job 별로 급여의 합을 구함 ==>  그룹화 기준 컬럼으로 job 을 사용
SELECT e.JOB
     , SUM(e.SAL)
  FROM emp e
 GROUP BY e.JOB
;

-- b) job 별 급여의 합에서 단위을 구함
SELECT e.JOB
     , TRUNC(SUM(e.SAL), -3) "급여 단위"
  FROM emp e
 GROUP BY e.JOB
;

-- c) 정렬, NULL 처리
SELECT NVL(e.JOB, '미배정')  "직무"
     , TRUNC(SUM(e.SAL), -3) "급여 단위"
  FROM emp e
 GROUP BY e.JOB
 ORDER BY "급여 단위" DESC
;

-- 7. 직무별 급여 평균이 2000이하인 경우를 구하고 평균이 높은 순으로 정렬
-- a) 직무별로 급여 평균을 구하자 : 그룹화 기준 컬럼 : job
SELECT e.JOB
     , AVG(e.SAL) "급여 평균"
  FROM emp e
 GROUP BY e.JOB
;

-- b) a에서 구해진 결과를 2000 이하 값으로 제한
SELECT e.JOB
     , AVG(e.SAL) "급여 평균"
  FROM emp e
 GROUP BY e.JOB
HAVING AVG(e.SAL) <= 2000
 ORDER BY "급여 평균" DESC
;


-- 8. 년도별 입사 인원을 구하시오
--   : hiredate 를 활용 ==> 년도만 추출하여 그룹화 기준으로 사용
-- a) hiredate 에서 년도 추출 : TO_CHAR(hiredate, 'YYYY')
-- b) 기준값으로 그룹화 작성
SELECT TO_CHAR(e.hiredate, 'YYYY') "입사 년도"
     , COUNT(*) "인원(명)"
  FROM emp e
 GROUP BY TO_CHAR(e.hiredate, 'YYYY')
 ORDER BY "입사 년도"
;











