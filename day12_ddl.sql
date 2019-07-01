-- day 12 : DDL (Data Definition Language)
--          데이터 정의어

-- 1. 테이블을 생성하는 명령어 => 테이블은 DBMS의 OBJECT중 하나
-- 2. DBMS 가 OBJECT(객체) 로 관리/인식 하는 대상을 
--    생성, 수정, 삭제 하는 명령어

-- 생성 : CREATE
-- 수정 : ALTER
-- 삭제 : DROP

-- vs. DML (Data Manipulation Language) 데이터 조작어
-- 생성 : INSERT
-- 수정 : UPDATE
-- 삭제 : DELETE


------------------------------------------------------
/*  DDL 구문의 시작

    CREATE | ALTER | DROP {관리할 객체의 타입명}
    
    DBMS의 OBJECT(객체)의 종류
    SHEMA, DOMAIN, TABLE, VIEW, INDEX, SEQUENCE, USER, DATABASE
*/

-- CREATE TABLE 구문 구조
CREATE TABLE 테이블이름
(  컬럼1이름 데이터타입[(길이)] [DEFAULT 기본값] [컬럼의 제약사항]
 [,컬럼2이름 데이터타입[(길이)] [DEFAULT 기본값] [컬럼의 제약사항]]
 .....
 [,컬럼n이름 데이터타입[(길이)] [DEFAULT 기본값] [컬럼의 제약사항]]
);

/* -----------------------
   컬럼의 제약사항
   -----------------------
   1. PRIMARY KEY : 이 컬럼에 입력되는 값은 중복되지 않고
                    한 행을 식별할 수 있는 값으로 설정해야 하며
                    NULL 데이터 입력은 불가능한 값이어야 한다.
                    
   2. FOREIGN KEY : 주로 JOIN에 사용되는 제약조건으로
                    다른 테이블의 PRIMARY KEY 로 사용되었던 값이
                    등장해야만 한다.
   
   3. UNIQUE      : 이 컬럼에 입력되는 값은 중복되지 않음을 보장해야 한다.
                    NULL 데이터 입력은 가능하다.
                    ==> 데이터가 NULL(없거나) 이거나
                        NULL이 아니면 반드시 유일한 값이어야 함.
   
   4. NOT NULL    : 이 컬럼에 입력되는 값은 중복은 상관없으나
                    NULL 상태는 되지 않도록 보장한다.
                    
   ==> PK : UNIQUE + NOT NULL 조합된 형태라는 것을 알 수 있다.   
*/

-- 예) 청해진 대학 구성인원 정보를 저장할 테이블을 정의
/*
   테이블이름 : member
   1. 멤버아이디       : member_id    : 문자 : VARCHAR2 : PK
   2. 멤버 이름        : member_name  : 문자 : VARCHAR2 : NOT NULL
   3. 전화번호 뒷자리  : phone        : 문자 : VARCHAR2 
   4. 시스템등록일     : reg_date     : 날짜 : DATE 
   5. 사는 곳(동이름)  : address      : 문자 : VARCHAR2
   6. 좋아하는 숫자    : like_number  : 숫자 : NUMBER 
   7. 전공             : major        : 문자 : VARCHAR2
*/

-- 1. 테이블 생성 구문 : member
;
DROP TABLE member;
CREATE TABLE member
(  member_id    VARCHAR2(4)     PRIMARY KEY
 , member_name  VARCHAR2(15)    NOT NULL
 , phone        VARCHAR2(4)     -- NULL 허용하려면 제약조건을 안쓰면 된다.
 , reg_date     DATE            DEFAULT sysdate
 , address      VARCHAR2(30) 
 , like_number  NUMBER
 , major        VARCHAR2(50)
);
-- Table MEMBER이(가) 생성되었습니다.

-- 2. 테이블 삭제 구문
DROP TABLE 테이블이름;

DROP TABLE member;
-- Table MEMBER이(가) 삭제되었습니다.

-- 3. 테이블 수정 구문
/* -----------------------------
   수정의 종류
   -----------------------------
   1. 컬럼을 추가 : ADD
   2. 컬럼을 수정 : MODIFY
   3. 컬럼을 삭제 : DROP COLUMN
   -----------------------------
*/
ALTER TABLE 테이블이름 {ADD | MODIFY | DROP COLUMN} .... ;

-- 1) ADD
-- 예) 생성한 member 테이블에 컬럼 2개를 추가

-- 출생 월 : birth_month : NUMBER
-- 성별    : gender      : VARCHAR2(1) : F, M 두 글자 중 하나만 입력가능하도록

-- member 테이블 생성 후 아래 구문 실행
ALTER TABLE member ADD 
(  birth_month NUMBER 
 , gender      VARCHAR2(1)  CHECK (gender IN ('F', 'M'))
);
-- Table MEMBER이(가) 변경되었습니다.

-- 2) MODIFY
-- 예) 출생 월 컬럼을 숫자2 자리까지만 제한하도록 수정
ALTER TABLE 테이블이름 MODIFY 컬럼이름 데이터타입(크기);
ALTER TABLE member MODIFY birth_month NUMBER(2);
-- Table MEMBER이(가) 변경되었습니다.

-- 3) DROP COLUMN
-- 예) 수정한 테이블 member에서 like_number 컬럼을 삭제
ALTER TABLE 테이블이름 DROP COLUMN 컬럼이름;
ALTER TABLE member DROP COLUMN like_number;
-- Table MEMBER이(가) 변경되었습니다.

----------------------------------------------
-- 예로 사용할 member 테이블의 최종형태

CREATE TABLE member
(  member_id    VARCHAR2(4)     PRIMARY KEY
 , member_name  VARCHAR2(15)    NOT NULL
 , phone        VARCHAR2(4)     -- NULL 허용하려면 제약조건을 안쓰면 된다.
 , reg_date     DATE            DEFAULT sysdate
 , address      VARCHAR2(30) 
 , major        VARCHAR2(50)
 , birth_month  NUMBER(2)
 , gender       VARCHAR2(1)     CHECK (gender IN ('F', 'M'))
);

-- 가장 단순화된 테이블 정의 구문
-- 제약조건을 각 컬럼 뒤에 바로 제약조건 이름 없이 생성

-- 제약조건에 이름을 부여해서 생성 :
-- 컬럼의 정의가 끝난 뒤 제약조건 정의를 몰아서 작성


-- 테이블 삭제
DROP TABLE member;
-- Table MEMBER이(가) 삭제되었습니다.

-- 제약조건 이름을 주어 member 테이블 생성
CREATE TABLE member
(  member_id    VARCHAR2(4)  
 , member_name  VARCHAR2(15)    NOT NULL
 , phone        VARCHAR2(4)     -- NULL 허용하려면 제약조건을 안쓰면 된다.
 , reg_date     DATE            DEFAULT sysdate
 , address      VARCHAR2(30) 
 , major        VARCHAR2(50)
 , birth_month  NUMBER(2)
 , gender       VARCHAR2(1)     
-- , CONSTRAINT  제약조건이름 제약조건타입 (제약조건 적용대상 컬럼)
 , CONSTRAINT pk_member         PRIMARY KEY (member_id)
 , CONSTRAINT ck_member_gender  CHECK       (gender IN ('M', 'F'))
);
-- Table MEMBER이(가) 생성되었습니다.

-- 테이블 생성시 DDL 로 정의한 내용은 시스템 카탈로그에 저장됨.
-- user_tables, user_constraints 
-- 두 개의 시스템 카탈로그 테이블을 조회

-- 1) 두 테이블의 형태(컬럼 이름) 조회
DESC user_tables;
/*
이름                        널?       유형             
------------------------- -------- -------------- 
TABLE_NAME                NOT NULL VARCHAR2(128)  
*/
-- 현재 유저(SCOTT)가 가지고 있는 테이블 목록을 조회
SELECT t.table_name
  FROM user_tables t
;  
/* 
TABLE_NAME
-----------
DEPT
EMP
BONUS
SALGRADE
MEMBER
*/

-- DROP TABLE member;

DESC user_constraints ;
/*
이름                  널? 유형             
------------------- -- -------------- 
OWNER                  VARCHAR2(128)  
CONSTRAINT_NAME        VARCHAR2(128)  
CONSTRAINT_TYPE        VARCHAR2(1)    
TABLE_NAME             VARCHAR2(128)  
*/
-- 현재 유저(SCOTT)이 가지고 있는 제약조건 조회
SELECT c.constraint_name
     , c.constraint_type
     , c.table_name
  FROM user_constraints c
;  
/*
FK_DEPTNO	        R	EMP
PK_DEPT	            P	DEPT
PK_EMP	            P	EMP
CK_MEMBER_GENDER	C	MEMBER
PK_MEMBER	        P	MEMBER
SYS_C007594	        C	MEMBER
*/
-- MEMBER 테이블의 제약조건만 확인
SELECT c.constraint_name
     , c.constraint_type
     , c.table_name
  FROM user_constraints c
 WHERE c.table_name = 'MEMBER'
; 

-- user_objects : 현재 사용자가 가지고 있는 object들의 정보가 저장되는
--                시스템 카탈로그 테이블
DESC user_objects;
/*
이름                널? 유형            
----------------- -- ------------- 
OBJECT_NAME          VARCHAR2(128) 
SUBOBJECT_NAME       VARCHAR2(128) 
OBJECT_ID            NUMBER        
DATA_OBJECT_ID       NUMBER        
OBJECT_TYPE          VARCHAR2(23)
*/
SELECT o.object_name
     , o.object_id
     , o.object_type
  FROM user_objects o
;  
/*
DEPT	    73559	TABLE
PK_DEPT	    73560	INDEX
PK_EMP	    73566	INDEX
EMP	        73565	TABLE
BONUS	    73567	TABLE
SALGRADE	73568	TABLE
PK_MEMBER	74882	INDEX
MEMBER	    74881	TABLE
*/

-- 테이블 생성 기법중 이미 존재하는 테이블로부터 복사 생성
-- 테이블 구조 복사 생성 구문
CREATE TABLE 테이블이름
AS
SELECT 컬럼이름...
  FROM 복사대상테이블
 WHERE 항상 거짓이 되는 조건
;

-- 예) 앞서 생성한 member 테이블에서 복사 : new_member
CREATE TABLE new_member
AS
SELECT m.*
  FROM member m
 WHERE 1 = 2 -- 항상 거짓이 되는 조건
;  
-- PK 설정은 복사되지 않고 테이블 구조(조회된 컬럼만) 복사됨

-- Table NEW_MEMBER이(가) 생성되었습니다.
-- new_member 테이블의 구조를 조회
DESC new_member;
/*

이름          널?       유형           
----------- -------- ------------ 
MEMBER_ID            VARCHAR2(4)  
MEMBER_NAME NOT NULL VARCHAR2(15) 
PHONE                VARCHAR2(4)  
REG_DATE             DATE         
ADDRESS              VARCHAR2(30) 
MAJOR                VARCHAR2(50) 
BIRTH_MONTH          NUMBER(2)    
GENDER               VARCHAR2(1) 
*/


/*
-- member 테이블에 데이터 추가
*/
INSERT INTO "SCOTT"."MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, MAJOR, BIRTH_MONTH, GENDER) VALUES ('M001', '박성협', '9155', '수원시', '행정', '3', 'M');
INSERT INTO "SCOTT"."MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, MAJOR, BIRTH_MONTH, GENDER) VALUES ('M002', '오진오', '1418', '군포시', '일어', '1', 'M');
INSERT INTO "SCOTT"."MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, MAJOR, BIRTH_MONTH, GENDER) VALUES ('M003', '이병현', '0186', '천안시', '컴공', '3', 'M');
INSERT INTO "SCOTT"."MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, MAJOR, BIRTH_MONTH, GENDER) VALUES ('M004', '김문정', '1392', '청주시', '일어', '3', 'F');
INSERT INTO "SCOTT"."MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, MAJOR, BIRTH_MONTH, GENDER) VALUES ('M005', '송지환', '0322', '안양시', '제약', '3', 'F');
COMMIT;

-- 3월생의 정보만 복사해서 새 테이블을 생성
CREATE TABLE march_member
AS
SELECT m.*
  FROM member m
 WHERE m.birth_month = 3  
;  
-- Table MARCH_MEMBER이(가) 생성되었습니다.

-- 복사하여 테이블 생성시 참이 될 수 있는 조건을 주면
-- 해당 조건을 만족하는 행의 데이터까지 복사되면서 테이블 생성

-- 항상 참이 되는 조건을 주면 모든 데이터를 복사하면서 테이블 생성
CREATE TABLE full_member
AS
SELECT m.*
  FROM member m
 WHERE 1 = 1
;
-- Table FULL_MEMBER이(가) 생성되었습니다.
-- full_member 삭제
DROP TABLE full_member;
CREATE TABLE full_member
AS
SELECT m.*
  FROM member m
  -- WHERE 조건절을 생략하면
  -- 항상 참인 결과와 동일하므로 모든 데이터가 복사되며 새 테이블 생성
;  


----------------------------------
-- 테이블 수정(ALTER) 주의사항

-- 1) 컬럼에 데이터가 없을 때
--  : 모든 변경에 자유로움 
--    데이터 타입변경, 데이터 크기변경에 모두 자유로움

-- 2) 컬럼에 데이터가 있을 때
--  : 데이터가 소실되면 안되므로 변경에 제약이 있음
--    타입 변경은 같은 타입내에서만 가능
--    문자 타입간에 CHAR -> VARCHAR2 변경 가능

--    크기 변경은 동일 혹은 커지는 방향으로만 가능
--    숫자 타입의 크기변경은 정밀도가 커지는 방향으로만 가능

-- 예) MARCH_MEMBER 테이블에서 BIRTH_MONTH 컬럼의
--     데이터 타입의 크기를 NUMBER(1) 로 줄이면
ALTER TABLE MARCH_MEMBER MODIFY (BIRTH_MONTH NUMBER(1));
/*
ORA-01440: 정도 또는 자리수를 축소할 열은 비어 있어야 합니다
01440. 00000 -  "column to be modified must be empty to decrease precision or scale"
*/
--     숫자 데이터의 정밀도가 증가하는 값으로 변경하면
--     2 -> 10자리, 그중 소수점 2자리
ALTER TABLE MARCH_MEMBER MODIFY (BIRTH_MONTH NUMBER(10, 2));
-- Table MARCH_MEMBER이(가) 변경되었습니다.

-- 숫자 데이터인 BIRTH_MONTH 컬럼을 문자 데이터로 변경
ALTER TABLE MARCH_MEMBER MODIFY (BIRTH_MONTH VARCHAR2(1) );
/*
ORA-01439: 데이터 유형을 변경할 열은 비어 있어야 합니다
01439. 00000 -  "column to be modified must be empty to change datatype"
*/

-- MARCH_MEMBER 테이블의 모든 행에 대해서
-- BIRTH_MONTH 컬럼의 값을 NULL 데이터로 변경하는 명령
UPDATE "SCOTT"."MARCH_MEMBER" 
  SET BIRTH_MONTH = '' 
;
COMMIT;
/*
6개 행 이(가) 업데이트되었습니다.

커밋 완료.
*/
-- 데이터가 없는 컬럼으로 변경 후 
-- VARCHAR2(2) 문자컬럼으로 변경
ALTER TABLE MARCH_MEMBER 
MODIFY (BIRTH_MONTH VARCHAR2(2) )
;
-- Table MARCH_MEMBER이(가) 변경되었습니다.

-- NUMBER(1) 숫자1자리 컬럼으로 변경
ALTER TABLE MARCH_MEMBER
MODIFY (BIRTH_MONTH NUMBER(1) )
;
-- Table MARCH_MEMBER이(가) 변경되었습니다.

----------------------------------------------------------------
-- 3) 기본 값(DEFAULT) 설정은 수정 이후 값부터 적용 됨.

-- 예) 3월 생인 멤버만 복사한 MARCH_MEMBER 테이블을 생각해보자.
--   : BIRTH_MONTH 컬럼의 값이 항상 3 으로 고정되어도 될 것 같다.

-- a)
-- MARCH_MEMBER 테이블에 
-- BIRTH_MONTH 컬럼의 값이 없는 멤버 정보 1줄 추가
INSERT INTO "SCOTT"."MARCH_MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, MAJOR, GENDER) 
VALUES ('M006', '함예은', '0437', '수원시', '컴공', 'F');
COMMIT;

-- b) a의 멤버 정보 추가 후 DEFAULT 설정 추가
ALTER TABLE march_member 
MODIFY (BIRTH_MONTH DEFAULT 3);
-- Table MARCH_MEMBER이(가) 변경되었습니다.

-- c) MARCH_MEMBER 테이블에 DEFAULT 설정 추가 후
--    새 멤버를 추가
INSERT INTO "SCOTT"."MARCH_MEMBER" (MEMBER_ID, MEMBER_NAME, ADDRESS, MAJOR, GENDER) 
VALUES ('M007', '홍길동', '율도국', '도술', 'M');
COMMIT;

----------------------------------------------------
-- 테이블 무결성 제약 조건 처리방법 4가지

/*
  MAIN_TABLE
  ---------------------------------------------
  ID        VARCHAR2(10)    PRIMARY KEY
  NICKNAME  VARCHAR2(30)    UNIQUE
  REG_DATE  DATE            DEFAULT SYSDATE
  GENDER    VARCHAR2(1)     CHECK (GENDER IN ('M', 'F'))
  MESSAGE   VARCHAR2(300)   
  ---------------------------------------------
  
  SUB_TABLE
  ---------------------------------------------
  ID         VARCHAR2(10)    REFERENCES MAIN_TABLE(ID)  
                            (FK FROM MAIN_TABLE.ID )
  HOBBY      VARCHAR2(200)   
  BIRTH_YEAR NUMBER(4)
  ---------------------------------------------
*/
---- 1. 컬럼 정의할 때, 제약 조건 이름 없이 바로 선언
;
DROP TABLE MAIN_TABLE1;
CREATE TABLE MAIN_TABLE1
(  ID        VARCHAR2(10)    PRIMARY KEY
 , NICKNAME  VARCHAR2(30)    UNIQUE
 , REG_DATE  DATE            DEFAULT SYSDATE
 , GENDER    VARCHAR2(1)     CHECK (GENDER IN ('M', 'F'))
 , MESSAGE   VARCHAR2(300)
);
-- Table MAIN_TABLE1이(가) 생성되었습니다.

DROP TABLE SUB_TABLE1;
CREATE TABLE SUB_TABLE1
(  ID         VARCHAR2(10)   REFERENCES MAIN_TABLE1(ID)
 , HOBBY      VARCHAR2(200)
 , BIRTH_YEAR NUMBER(4)
);
-- Table SUB_TABLE1이(가) 생성되었습니다.

---- 2. 컬럼 정의할 때, 제약 조건 이름을 주며 선언
DROP TABLE MAIN_TABLE2;
CREATE TABLE MAIN_TABLE2
(  ID        VARCHAR2(10)    CONSTRAINT PK_MAIN     PRIMARY KEY
 , NICKNAME  VARCHAR2(30)    CONSTRAINT UQ_NICKNAME UNIQUE
 , REG_DATE  DATE            DEFAULT SYSDATE
 , GENDER    VARCHAR2(1)     CONSTRAINT CK_GENDER   CHECK (GENDER IN ('M', 'F'))
 , MESSAGE   VARCHAR2(300)
);
-- Table MAIN_TABLE2이(가) 생성되었습니다.

DROP TABLE SUB_TABLE2;
CREATE TABLE SUB_TABLE2
(  ID         VARCHAR2(10)   CONSTRAINT FK_SUB REFERENCES MAIN_TABLE2(ID)
 , HOBBY      VARCHAR2(200)
 , BIRTH_YEAR NUMBER(4)
);
-- Table SUB_TABLE2이(가) 생성되었습니다.

-- MAIN_TABLE1, MAIN_TABLE2 의 제약조건을 비교

-- 3. 컬럼 정의 후 제약 조건 따로 선언
DROP TABLE MAIN_TABLE3;
CREATE TABLE MAIN_TABLE3
(  ID        VARCHAR2(10)    
 , NICKNAME  VARCHAR2(30)    
 , REG_DATE  DATE            DEFAULT SYSDATE
 , GENDER    VARCHAR2(1)     
 , MESSAGE   VARCHAR2(300)
 , CONSTRAINT PK_MAIN3     PRIMARY KEY (ID)
 , CONSTRAINT UQ_NICKNAME3 UNIQUE (NICKNAME)
 , CONSTRAINT CK_GENDER3   CHECK  (GENDER IN ('M', 'F'))
);
-- Table MAIN_TABLE3이(가) 생성되었습니다.

DROP TABLE SUB_TABLE3;
CREATE TABLE SUB_TABLE3
(  ID         VARCHAR2(10)    
 , HOBBY      VARCHAR2(200)
 , BIRTH_YEAR NUMBER(4)
 , CONSTRAINT FK_SUB3 FOREIGN KEY(ID) REFERENCES MAIN_TABLE3(ID)
 -- SUB_TABLE3 의 경우 PRIMARY KEY 를 ID, BIRTH_YEAR 의 복합키로 생성
 -- 복합키로 PK를 삼으려는 경우는 반드시 제약조건 추가로만 생성가능
 , CONSTRAINT PK_SUB3 PRIMARY KEY (ID, BIRTH_YEAR)
);
-- Table SUB_TABLE3이(가) 생성되었습니다.











