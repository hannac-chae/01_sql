-- HR ���� Ȱ��ȭ(oracleXE 18������ �ش�)
-- sys ���� �۾�
ALTER SESSION 
  SET "_ORACLE_SCRIPT"=true
;

--1. ������ �ý��ۿ� ORACLE_HOME ȯ�溯�� ����

--2. ������ ��ũ��Ʈ ����(F5�� ����)
--   ��ũ��Ʈ ��δ� PC ȯ�渶�� ���ݾ� �ٸ� �� ����.
--   ����Ŭ ��ġ ��ġ(dbhomeXE) ���� \demo\schema\human_resources �Ʒ��� �ִ�
--   hr_main.sql ��ũ��Ʈ�� ������.
@C:\app\304\product\18.0.0\dbhomeXE\demo\schema\human_resources\hr_main.sql;

-- 1�� �Է� : HR
-- 2�� �Է� : HR
-- 3�� �Է� : HR
-- 4�� �Է� : $ORACLE_HOME/demo/schema/log/
-- 1 ~ 4 �Է� �� HR ������ ���̺��� ������.

-- HR �� ���� �� �۾�

-- ���ݱ��� ������ DQL �������� 3������ ������ ����� ���� �ۼ��Ͽ� ���� �ذ�
-- 2. DISTINCT
-- 3. ORDER BY
-- 4. WHERE
-- ...
-- JOIN, sub-query ����
  







