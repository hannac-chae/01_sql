-- û���� ���� IT ���� �߰� �׽�Ʈ 1�� : SQL
-- ���ϸ� : �̸�(�ѱ۷�)test01.sql 
/*
���� :                         
�̸� :
�г� :
*/

/* 
  ������ ��� ������ ��Ȯ�� ���� �ؾ߸� �����մϴ�.
  �κ� ������ �����ϴ�.
  
  �÷��� ����, ��Ī(������ ���� �÷��� �ʼ�, ���̺� ��Ī)
  ���� �ٸ���, ����, ��ҹ���,
  ������ �յ� ����, �޸� �յ� ���� ���� ��Ȯ�� ��Ű�� ���� �Ϳ� ���Ͽ�
  ������ �ֽ��ϴ�.
*/

-- emp���̺���
--1.	��� ������ ���, �̸�, ����, �޿��� ��ȸ�Ͻÿ�. (5��)
SELECT e.empno
     , e.ename
     , e.job
     , e.sal
  FROM emp e
;  

--2.	�Ŵ����� �ִ� ������ ���, �̸�, �Ŵ��� ����� ��ȸ�Ͻÿ�.(10��)
SELECT e.empno
     , e.ename
     , e.mgr
  FROM emp e
 WHERE e.mgr IS NOT NULL
;  


--3.	��� ������ ���Ͽ�, ���, �̸�, �޿�, �� �޿��� ��ȸ�Ͻÿ�.(10��)
SELECT e.empno
     , e.ename
     , e.sal
     , e.sal * 12 as "�� �޿�"
  FROM emp e
;  


--4.	30�� �μ� �Ҽ��� ������ ���, �̸�, �μ���ȣ�� ��ȸ�Ͻÿ�.(10��)
SELECT e.empno
     , e.ename
     , e.deptno
  FROM emp e
 WHERE e.deptno = 30  
;  


--5.	�޿��� 2000 ~ 4000 ������ ������ ���, �̸�, �޿��� ��ȸ�Ͻÿ�.(10��)
SELECT e.empno
     , e.ename
     , e.sal
  FROM emp e
 WHERE e.sal BETWEEN 2000 AND 4000  
;  


--6.	������ �޴� ������ ���, �̸�, ������ ��ȸ�Ͻÿ�.(10��)
SELECT e.empno
     , e.ename
     , e.comm
  FROM emp e
 WHERE e.comm IS NOT NULL
;  


--7.	�������� �޿��� 10% �λ�� ��Ȳ�� �����ϰ�, 
--      ���� �޿��κ��� 10% �λ�� �޿��� ���Ͽ� 
--      ���, �̸�, ���޿�, ���λ�޿� �� ������ ��ȸ�Ͻÿ�.(10��)
SELECT e.empno
     , e.ename
     , e.sal "���޿�"
     , e.sal * 1.10 "���λ�޿�"
  FROM emp e
;  



--8.	10�� �μ� �Ҽ��� ������ ���Ͽ� �޿��� 15% �λ�� ��Ȳ�� �����ϰ�, 
--      ���� �޿��κ��� 15%�λ�� �޿��� ���Ͽ� 
--      ���, �̸�, ���޿�, �λ��, ���λ�޿�, �μ���ȣ �� ��ȸ�Ͻÿ�.(15��)
SELECT e.empno
     , e.ename
     , e.sal "���޿�"
     , e.sal * 0.15 "�λ��"
     , e.sal * 1.15 "���λ�޿�"
     , e.deptno
  FROM emp e
 WHERE e.deptno = 10  
;  



--9.	��� ������ ���Ͽ� ���޿��� 2500 �����̰�
--      15% �λ�� �޿��� 2800�� �Ѵ� ������ 
--      ���, �̸�, ���޿�, ���λ�޿�, �μ���ȣ�� ��ȸ�Ͻÿ�.(20��)
SELECT e.empno
     , e.ename
     , e.sal "���޿�"
     , e.sal * 1.15 "���λ�޿�"
     , e.deptno
  FROM emp e
 WHERE e.sal <= 2500
   AND e.sal * 1.15 > 2800
;  



--10.	�̸��� E�� ���� ������ ���, �̸��� ��ȸ�Ͻÿ�.(10��)
SELECT e.empno
     , e.ename
  FROM emp e
 WHERE e.ename LIKE '%E%'
;  



--dept ���̺���
--1.	BOSTON �� ��ġ�� �μ��� ��� ������ ��ȸ�Ͻÿ�.(10��)
SELECT d.deptno
     , d.dname
     , d.loc
  FROM dept d
 WHERE d.loc = 'BOSTON'  
;  


--2.	DALLAS, NEW YORK �� ��ġ�� �μ��� ��� ������ ��ȸ�Ͻÿ�.(15��)
SELECT d.deptno
     , d.dname
     , d.loc
  FROM dept d
 WHERE d.loc IN ('DALLAS', 'NEW YORK')
;  

