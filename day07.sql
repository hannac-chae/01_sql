-- day07
------ (4) 데이터 타입 변환 함수
/*
 가장 기본적인 타입
 1. 문자 : 반드시 ''(따옴표)로 감싸서 사용
 2. 숫자 : 산술 연산이 되는 값
 3. 날짜 : 세기, 년도, 달, 일, 시, 분, 초 까지 값이 있는 타입

 -----------------------------
 TO_CHAR() : 다른 타입에서 문자 타입으로 변환 해주는 함수
             숫자, 날짜 ==> 문자
             
 TO_DATE() : 다른 타입에서 날짜 타입으로 변환 해주는 함수             
             날짜 형식의 문자(날짜 패턴에 맞는 문자) ==> 날짜

 TO_NUMBER() : 다른 타입에서 숫자 타입으로 변환 해주는 함수
               숫자로만 구성된 문자데이터 ==> 숫자  
*/

---- 1. to_char() : 숫자패턴 적용
SELECT to_char(12345, '9999') -- 12345
  FROM dual
;
SELECT to_char(12345, '99999') as "12345" -- 12345
  FROM dual
;
SELECT 12345
  FROM dual
;
-- 숫자가 문자화되어 출력되면 왼쪽 정렬로 바뀐다.
SELECT to_char(e.sal) "급여(문자화)"
     , e.sal "급여(숫자)"     
  FROM emp e
;
--문자화 된 급여는 왼쪽으로 정렬되어 있고
--숫자 자체인 급여는 오른쪽으로 정렬되어 있음을 확인한다.

-- 숫자를 문자화 하되 총 8칸을 채우도록 만든다.
SELECT to_char(12345, '99999999') as 데이터
  FROM dual
;
-- 앞에 빈 공간을 0으로 채우기
SELECT to_char(12345, '09999999') as 데이터
  FROM dual
;
-- 소수점 이하 표현
SELECT to_char(12345, '09999999') as 데이터
  FROM dual
;
-- 숫자 패턴에서 3자리씩 끊어 읽기 + 소수점 표현
SELECT to_char(12345, '9,999,999.99') as 데이터
  FROM dual
;


---- 2. to_date() : 날짜 패턴에 맞는 문자 값을 
--                  날짜 연산이 가능한 날짜 타입으로 변경
SELECT to_date('2019-05-28', 'YYYY-MM-DD') "today(날짜)"
     , '2019-05-28' "today(문자)"
  FROM dual
;
/*
today(날짜), today(문자)
------------------------
19/05/28	2019-05-28
*/
SELECT to_date('2019-5월-28', 'YYYY-MON-DD') "today(날짜)"
     , '2019-5월-28' "today(문자)"
  FROM dual
;

-- 10일 후의 날짜 연산
SELECT to_date('2019-5월-28', 'YYYY-MON-DD') + 10 "today + 10일"     
  FROM dual
;
-- today + 10일
-- 19/06/07

-- 날짜처럼 생긴 문자와는 날짜 연산이 안됨을 확인해보자.
SELECT '2019-5월-28' + 10 "today + 10일"     
  FROM dual
;
/*
ORA-01722: 수치가 부적합합니다
01722. 00000 -  "invalid number"
*/

---- 3. to_number() : 오라클이 자동 형변환을 해주므로 
--                    자주 사용되지 않음.
SELECT '1000' + 10 계산결과
  FROM dual
;
SELECT to_number('1000') + 10 계산결과
  FROM dual
;

/*
계산결과
-------
1010
*/

----- (5) DECODE(expr, search, result [, search, result] ... [, default])
/*
 만약 default 가 설정되어 있지 않고
 expr 과 일치하는 search 도 없는 경우
 DECODE 문의 결과는 NULL 이 된다.
*/
--            expr  search1 result1
SELECT DECODE('YES', 'YES', '입력값이 YES 입니다.'
                   , 'NO' , '입력값이 NO 입니다.') AS 입력결과
--                  search2 result2                   
  FROM dual
;  

/*
입력결과
---------------------
입력값이 YES 입니다.
*/
--            expr  search1 result1
SELECT DECODE('NO', 'YES', '입력값이 YES 입니다.'
                  , 'NO' , '입력값이 NO 입니다.') AS 입력결과
--                  search2 result2                   
  FROM dual
; 
/*
입력결과
---------------------
입력값이 NO 입니다.
*/
--            expr  search1 result1
SELECT DECODE('예', 'YES', '입력값이 YES 입니다.'
                  , 'NO' , '입력값이 NO 입니다.') AS 입력결과
--                  search2 result2                   
  FROM dual
;
/*
입력결과
-----------
(null)
*/
--            expr  search1 result1
SELECT DECODE('예', 'YES', '입력값이 YES 입니다.'
                  , 'NO' , '입력값이 NO 입니다.'
--                  search2 result2                     
                  , '입력값이 YES/NO 중 어느 것도 아닙니다.') AS 입력결과
--                  default                   
  FROM dual
;
/*
입력결과
-----------
입력값이 YES/NO 중 어느 것도 아닙니다.
*/

-- emp 테이블에서 job(직무) 별로 
-- 경조사비를 급여대비 일정 비율로 지급하기로 했다.
-- 지급비율이 다음과 같다고 할 때, 
-- 각 직원들의 경조사비 지원금을 구해보자.
-- 사번, 이름, 직무 와 함께 구해보자
/*
  CLERK     : 5%
  SALESMAN  : 4%
  MANAGER   : 3.7%
  ANALYST   : 3%
  PRESIDENT : 1.5%
*/
SELECT e.empno
     , e.ename
     , e.job
     , DECODE(e.job, 'CLERK'    , e.sal * 0.05
                   , 'SALESMAN' , e.sal * 0.04
                   , 'MANAGER'  , e.sal * 0.037
                   , 'ANALYST'  , e.sal * 0.03
                   , 'PRESIDENT', e.sal * 0.015) "경조사 지원금"
  FROM emp e
;  
/*
EMPNO,  ENAME,  JOB,        경조사 지원금
-----------------------------------------b
7369	SMITH	CLERK	    40
7499	ALLEN	SALESMAN	64
7521	WARD	SALESMAN	50
7566	JONES	MANAGER	    110.075
7654	MARTIN	SALESMAN	50
7698	BLAKE	MANAGER	    105.45
7782	CLARK	MANAGER	    90.65
7839	KING	PRESIDENT	75
7844	TURNER	SALESMAN	60
7900	JAMES	CLERK	    47.5
7902	FORD	ANALYST 	90
7934	MILLER	CLERK	    65
9999	J_JAMES	CLERK	
8888	J%JAMES	CLERK	
*/

-- 경조사 지원비 결과에 숫자 패턴($999.99) 입히기
SELECT e.empno
     , e.ename
     , e.job
     , to_char(DECODE(e.job, 'CLERK'    , e.sal * 0.05
                           , 'SALESMAN' , e.sal * 0.04
                           , 'MANAGER'  , e.sal * 0.037
                           , 'ANALYST'  , e.sal * 0.03
                           , 'PRESIDENT', e.sal * 0.015
                           , e.sal * 0.010), '$999.99') "경조사 지원금"
  FROM emp e
;  

/*
EMPNO,  ENAME,  JOB,          경조사 지원금
-------------------------------------
7369	SMITH	CLERK	      $40.00
7499	ALLEN	SALESMAN	  $64.00
7521	WARD	SALESMAN	  $50.00
7566	JONES	MANAGER	     $110.08
7654	MARTIN	SALESMAN	  $50.00
7698	BLAKE	MANAGER	     $105.45
7782	CLARK	MANAGER	      $90.65
7839	KING	PRESIDENT	  $75.00
7844	TURNER	SALESMAN	  $60.00
7900	JAMES	CLERK	      $47.50
7902	FORD	ANALYST	      $90.00
7934	MILLER	CLERK	      $65.00
9999	J_JAMES	CLERK	
8888	J%JAMES	CLERK	
*/








