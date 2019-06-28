-- HR 계정 활성화(oracleXE 18버전에 해당)

ALTER SESSION 
  SET "_ORACLE_SCRIPT"=true
;

@C:\app\304\product\18.0.0\dbhomeXE\demo\schema\human_resources\hr_main.sql;

-- 1번 입력 : HR
-- 2번 입력 : HR
-- 3번 입력 : HR
-- 4번 입력 : $ORACLE_HOME/demo/schema/log/
-- 1 ~ 4 입력 후 HR 계정 테이블 생성됨.