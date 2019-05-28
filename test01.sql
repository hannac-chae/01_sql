-- 청해진 대학 IT 과정 중간 테스트 1차 : SQL
-- 파일명 : 이름(한글로)test01.sql 
/*
전공 :                         
이름 :
학년 :
*/

/* 
  문제의 모든 조건을 정확히 구현 해야만 인정합니다.
  부분 점수는 없습니다.
  
  컬럼의 순서, 별칭(연산이 들어가는 컬럼은 필수, 테이블 별칭)
  세로 줄맞춤, 띄어쓰기, 대소문자,
  연산자 앞뒤 공백, 콤마 앞뒤 공백 등을 정확히 지키지 않은 것에 대하여
  감점이 있습니다.
*/

-- emp테이블에서
--1.	모든 직원의 사번, 이름, 직무, 급여를 조회하시오. (5점)
SELECT e.empno
     , e.ename
     , e.job
     , e.sal
  FROM emp e
;  

--2.	매니저가 있는 직원의 사번, 이름, 매니저 사번을 조회하시오.(10점)
SELECT e.empno
     , e.ename
     , e.mgr
  FROM emp e
 WHERE e.mgr IS NOT NULL
;  


--3.	모든 직원에 대하여, 사번, 이름, 급여, 연 급여를 조회하시오.(10점)
SELECT e.empno
     , e.ename
     , e.sal
     , e.sal * 12 as "연 급여"
  FROM emp e
;  


--4.	30번 부서 소속인 직원의 사번, 이름, 부서번호를 조회하시오.(10점)
SELECT e.empno
     , e.ename
     , e.deptno
  FROM emp e
 WHERE e.deptno = 30  
;  


--5.	급여가 2000 ~ 4000 사이인 직원의 사번, 이름, 급여를 조회하시오.(10점)
SELECT e.empno
     , e.ename
     , e.sal
  FROM emp e
 WHERE e.sal BETWEEN 2000 AND 4000  
;  


--6.	수당을 받는 직원의 사번, 이름, 수당을 조회하시오.(10점)
SELECT e.empno
     , e.ename
     , e.comm
  FROM emp e
 WHERE e.comm IS NOT NULL
;  


--7.	전직원의 급여가 10% 인상된 상황을 가정하고, 
--      현재 급여로부터 10% 인상된 급여를 구하여 
--      사번, 이름, 원급여, 총인상급여 네 가지를 조회하시오.(10점)
SELECT e.empno
     , e.ename
     , e.sal "원급여"
     , e.sal * 1.10 "총인상급여"
  FROM emp e
;  



--8.	10번 부서 소속인 직원에 대하여 급여가 15% 인상된 상황을 가정하고, 
--      현재 급여로부터 15%인상된 급여를 구하여 
--      사번, 이름, 원급여, 인상분, 총인상급여, 부서번호 를 조회하시오.(15점)
SELECT e.empno
     , e.ename
     , e.sal "원급여"
     , e.sal * 0.15 "인상분"
     , e.sal * 1.15 "총인상급여"
     , e.deptno
  FROM emp e
 WHERE e.deptno = 10  
;  



--9.	모든 직원에 대하여 원급여는 2500 이하이고
--      15% 인상된 급여는 2800이 넘는 직원의 
--      사번, 이름, 원급여, 총인상급여, 부서번호를 조회하시오.(20점)
SELECT e.empno
     , e.ename
     , e.sal "원급여"
     , e.sal * 1.15 "총인상급여"
     , e.deptno
  FROM emp e
 WHERE e.sal <= 2500
   AND e.sal * 1.15 > 2800
;  



--10.	이름에 E가 들어가는 직원의 사번, 이름을 조회하시오.(10점)
SELECT e.empno
     , e.ename
  FROM emp e
 WHERE e.ename LIKE '%E%'
;  



--dept 테이블에서
--1.	BOSTON 에 위치한 부서의 모든 정보를 조회하시오.(10점)
SELECT d.deptno
     , d.dname
     , d.loc
  FROM dept d
 WHERE d.loc = 'BOSTON'  
;  


--2.	DALLAS, NEW YORK 에 위치한 부서의 모든 정보를 조회하시오.(15점)
SELECT d.deptno
     , d.dname
     , d.loc
  FROM dept d
 WHERE d.loc IN ('DALLAS', 'NEW YORK')
;  

