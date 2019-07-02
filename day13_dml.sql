-- day 13

---------------------------------------------------
-- ����Ŭ�� Ư���� �÷� 2����
-- : ����ڰ� ���� �� ��� �ڵ����� �����Ǵ� �÷�

-- 1. ROWID : ���������� ��ũ�� ����� ��ġ�� ����Ű�� ��
--            ������ ��ġ�̹Ƿ� �� ��� �ݵ�� ������ ���� �� �ۿ� ����
--            ORDER BY ���� ���� ������� �ʴ� ��

-- 2. ROWNUM : ��ȸ�� ����� ù��° ����� 1�� �����ϴ� ��
---------------------------------------------------

-- ��) emp ���̺��� 'SMITH' �� ��ȸ
SELECT e.empno
     , e.ename
  FROM emp e
 WHERE e.ename = 'SMITH'  
;  

-- ROWID �� ���� ��ȸ
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
-- ROWNUM �� ���� ��ȸ
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
-- ORDER BY ���� ���� ROWNUM �� ����Ǵ� ��� Ȯ��
-- (1) ORDER BY �� ���� ���� ROWNUM
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

-- (2) ename ������ �������� ���� �� ROWNUM �� Ȯ��
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
-- ==> ROWNUM �� ORDER BY ����� ������ ���� �ʴ� ��ó�� ���� �� ����.
--     SUB-QUERY �� ����� �� ������ ����.

-- (3) SUB-QUERY �� ���� �� ROWNUM �� �� Ȯ��
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

-- �̸��� A �� ���� ������� ��ȸ (ORDER BY ����)
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

-- �̸��� A�� ���� ����� �̸������� �����Ͽ� ��ȸ
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

-- �̸��� S �� ���� ������� ��ȸ
-- �̶�, ROWNUM, ROWID �� Ȯ��
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
-- �̸��� S�� ���� ������� ��ȸ �����
-- SUB-QUERY �� ������ ���� ROWNUM, ROWID Ȯ��
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

-- ROWNUM ���� �� �� �ִ� ����
-- emp ���� �޿��� ���� �޴� ���� 5���� ��ȸ�Ͻÿ�.

-- 1. �޿��� ���� ���� ����
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

-- 2. 1�� ����� SUB-QUERY �� FROM ���� ����ϰ�
--    ���� �������� ROWNUM �� ���� ��ȸ
SELECT ROWNUM
     , a.*
  FROM (SELECT e.empno
             , e.ename
             , e.sal
          FROM emp e
         ORDER BY e.sal DESC) a
;

-- 3. �� ��, ROWNUM <= 5 ������ �߰�
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
-- DML : ������ ���۾� 
----------------------------------------------
-- 1) INSERT : ���̺� ������ ��(row)�� �߰��ϴ� ���

-- MEMBER ���̺� ������ �߰� ����
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

--- 1. INTO ������ �÷��̸� ������ ������ �߰�
--     : VALUES ���� �ݵ�� ��ü �÷��� �����͸� ������� ��� ����
INSERT INTO MEMBER 
VALUES ('M001', '�ڼ���', '9155', sysdate, '������', '����', 3, 'M')
;
INSERT INTO MEMBER 
VALUES ('M002', '������', '1418', sysdate, '������', NULL, NULL, 'M')
;
/*
INSERT INTO MEMBER 
VALUES ('M002', '������', '1418', sysdate, '������', 'M');
-- ��ó�� VALUES ���� ������ ���� ������ ��ü �÷� ���� ��ġ���� ������
-- �Ʒ��� ���� ������ �߻��ϹǷ�, NULL �Է��� �ؼ��� 
-- ���� ������ ���߾�� �Ѵ�.

SQL ����: ORA-00947: ���� ���� ������� �ʽ��ϴ�
00947. 00000 -  "not enough values"
*/
INSERT INTO MEMBER 
VALUES ('M003', '�̺���', '0186', sysdate, NULL, NULL, 3, 'M')
;
INSERT INTO MEMBER 
VALUES ('M004', '�蹮��', NULL, sysdate, 'û�ֽ�', '�Ͼ�', 3, 'F')
;
INSERT INTO MEMBER 
VALUES ('M005', '����ȯ', '0322', sysdate, '�Ⱦ��', '����', 3, NULL)
;
COMMIT;
/*
1 �� ��(��) ���ԵǾ����ϴ�.
1 �� ��(��) ���ԵǾ����ϴ�.
1 �� ��(��) ���ԵǾ����ϴ�.
1 �� ��(��) ���ԵǾ����ϴ�.
1 �� ��(��) ���ԵǾ����ϴ�.

Ŀ�� �Ϸ�.
*/

-- PK �������ǿ� ����Ǵ� ������ �߰� �õ� : M005 �̹� ����
INSERT INTO MEMBER 
VALUES ('M005', 'ȫ�浿', '0001', sysdate, '������', '����', 3, 'M')
;
-- ORA-00001: ���Ἲ ���� ����(SCOTT.PK_MEMBER)�� ����˴ϴ�

-- GENDER �÷��� CHECK ���������� �����ϴ� ������ �߰� �õ�
-- GENDER �÷���, 'F', 'M', NULL ���� ���� �߰��ϸ� 
INSERT INTO MEMBER 
VALUES ('M006', 'ȫ�浿', '0001', sysdate, '������', '����', 3, 'G')
;
-- ORA-02290: üũ ��������(SCOTT.CK_GENDER)�� ����Ǿ����ϴ�

-- BIRTH_MONHT �÷��� 1 ~ 12 ���� ���ڰ� �Է� �õ�
INSERT INTO MEMBER 
VALUES ('M006', 'ȫ�浿', '0001', sysdate, '������', '����', -1, 'M')
;
-- ORA-02290: üũ ��������(SCOTT.CK_BIRTH)�� ����Ǿ����ϴ�

-- MEMBER_NAME �� NULL �Է� �õ�
INSERT INTO MEMBER 
VALUES ('M006', NULL, '0001', sysdate, '������', '����', 5, 'M')
;
-- ORA-01400: NULL�� ("SCOTT"."MEMBER"."MEMBER_NAME") 
-- �ȿ� ������ �� �����ϴ�

INSERT INTO MEMBER 
VALUES ('M006', 'ȫ�浿', '0001', sysdate, '������', '����', 5, 'M')
;
COMMIT;

