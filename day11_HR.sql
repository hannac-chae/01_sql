-- HR 계정 활성화(oracleXE 18버전에 해당)
-- sys 에서 작업
ALTER SESSION 
  SET "_ORACLE_SCRIPT"=true
;

--1. 윈도우 시스템에 ORACLE_HOME 환경변수 설정

--2. 다음의 스크립트 실행(F5로 실행)
--   스크립트 경로는 PC 환경마다 조금씩 다를 수 있음.
--   오라클 설치 위치(dbhomeXE) 이하 \demo\schema\human_resources 아래에 있는
--   hr_main.sql 스크립트를 실행함.
@C:\app\304\product\18.0.0\dbhomeXE\demo\schema\human_resources\hr_main.sql;

-- 1번 입력 : HR
-- 2번 입력 : HR
-- 3번 입력 : HR
-- 4번 입력 : $ORACLE_HOME/demo/schema/log/
-- 1 ~ 4 입력 후 HR 계정과 테이블이 생성됨.

-- HR 로 접속 후 작업

-- 지금까지 진행한 DQL 주제별로 3문제씩 스스로 만들고 쿼리 작성하여 문제 해결
-- 2. DISTINCT
-- 3. ORDER BY
-- 4. WHERE
-- ...
-- JOIN, sub-query 까지
  







