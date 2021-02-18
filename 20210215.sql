--2021-02-15

SELECT DEPTNO,MAX(SAL),MIN(SAL),COUNT(SAL),SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO);


SELECT DEPTNO,MAX(SAL),MIN(SAL),COUNT(SAL),SUM(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO);




SELECT DEPTNO,JOB,MAX(SAL),MIN(SAL),COUNT(SAL),SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO,JOB);

SELECT DEPTNO,JOB,MAX(SAL),MIN(SAL),COUNT(SAL),SUM(SAL)
FROM EMP
GROUP BY ROLLUP(JOB,DEPTNO);


SELECT DEPTNO,MAX(SAL),MIN(SAL),COUNT(SAL),SUM(SAL)
FROM EMP
GROUP BY DEPTNO;



SELECT DEPTNO,JOB,MAX(SAL),MIN(SAL),COUNT(SAL),SUM(SAL)
FROM EMP
GROUP BY CUBE(JOB,DEPTNO);



SELECT TO_CHAR(HIREDATE,'YYYY'),COUNT(SAL)
FROM EMP
GROUP BY TO_CHAR(HIREDATE,'YYYY');

SELECT * FROM STUDENT;

SELECT GRADE,DEPTNO,SUBSTR(birthdate,1,2), COUNT(*) FROM STUDENT
GROUP BY GRADE,DEPTNO,SUBSTR(birthdate,1,2);--GROUP BY

SELECT SUBSTR(birthdate,1,2),DEPTNO,MAX(HEIGHT),MIN(HEIGHT),COUNT(HEIGHT)
FROM STUDENT
GROUP BY CUBE(SUBSTR(birthdate,1,2),DEPTNO);


SELECT GRADE,DEPTNO,COUNT(*) FROM STUDENT
GROUP BY ROLLUP(GRADE,DEPTNO);--

SELECT GRADE,DEPTNO,COUNT(*) FROM STUDENT
GROUP BY CUBE(GRADE,DEPTNO);--

SELECT * FROM PROFESSOR;

SELECT DEPTNO,POSITION,TO_CHAR(HIREDATE,'YYYY'), MAX(SAL),MIN(SAL),COUNT(SAL)
FROM PROFESSOR
GROUP BY DEPTNO,POSITION,TO_CHAR(HIREDATE,'YYYY');


SELECT DEPTNO,JOB,TO_CHAR(HIREDATE,'YYYY'), MAX(SAL),MIN(SAL)
FROM EMP
GROUP BY DEPTNO,JOB,TO_CHAR(HIREDATE,'YYYY');


SELECT DEPTNO,JOB,TO_CHAR(HIREDATE,'YYYY'), MAX(SAL),MIN(SAL)
FROM EMP
GROUP BY GROUPING SETS(CUBE(DEPTNO,JOB),TO_CHAR(HIREDATE,'YYYY'));



SELECT DEPTNO,JOB,TO_CHAR(HIREDATE,'YYYY'), MAX(SAL),MIN(SAL)
FROM EMP
GROUP BY GROUPING SETS(ROLLUP(DEPTNO),CUBE(JOB,TO_CHAR(HIREDATE,'YYYY')));

-- GROUPING으로 사용한것은 0, 사용하지 않은것은 1로 표시
SELECT DEPTNO,JOB,COUNT(SAL),GROUPING(DEPTNO)GD,GROUPING(JOB)GJ
FROM EMP
GROUP BY ROLLUP(JOB,DEPTNO);

SELECT DEPTNO,GRADE,MAX(HEIGHT),MIN(HEIGHT),COUNT(HEIGHT),GROUPING(DEPTNO)GD,GROUPING(GRADE)GG
FROM STUDENT
GROUP BY ROLLUP(GRADE, DEPTNO);

SELECT GRADE,COUNT(*)
FROM STUDENT
WHERE HEIGHT>=150
GROUP BY GRADE
HAVING COUNT(*)>5;

SELECT JOB,MAX(SAL)MS,MIN(SAL),COUNT(JOB)
FROM EMP
GROUP BY JOB
HAVING MAX(SAL)>=2000;


-- 상황에 따른 RANK
SELECT STUDNO,NAME,GRADE,HEIGHT,BIRTHDATE,RK1,RK2,RK3
FROM(
SELECT STUDNO,NAME,GRADE,HEIGHT,BIRTHDATE,RANK()OVER(ORDER BY HEIGHT DESC)RK1,
DENSE_RANK()OVER(ORDER BY HEIGHT DESC)RK2,
ROW_NUMBER()OVER(ORDER BY HEIGHT DESC)RK3
FROM STUDENT)
WHERE RK1 BETWEEN 1 AND 10;

SELECT STUDNO,NAME,WEIGHT,GRADE,RANK()OVER(ORDER BY WEIGHT ASC)RK
FROM STUDENT;

-- PARTITION BY로 학년별로 등수 관리.
SELECT STUDNO,NAME,WEIGHT,GRADE,RANK()OVER(PARTITION BY GRADE ORDER BY WEIGHT DESC)RK
FROM STUDENT;

SELECT EMPNO,ENAME,SAL,DEPTNO,DENSE_RANK()OVER(PARTITION BY DEPTNO ORDER BY SAL)RK
FROM EMP;

SELECT EMPNO, ENAME, SAL, SUM(SAL) OVER()SS,MAX(SAL) OVER()MXS,MIN(SAL) OVER()MNS,COUNT(SAL) OVER()CS
FROM EMP;

SELECT EMPNO,SAL,SUM(SAL)OVER(PARTITION BY EMPNO ORDER BY SAL DESC) TOTAL
FROM EMP;


-- 함수,조인,SubQuery
SELECT EMPNO,ENAME,SAL,COMM,EMP.DEPTNO,DNAME,LOC
FROM EMP,DEPT
WHERE EMP.DEPTNO=DEPT.DEPTNO;

-- 위와 같은 식
SELECT EMPNO,ENAME,SAL,COMM,EMP.DEPTNO,DNAME,LOC
FROM EMP INNER JOIN DEPT
ON EMP.DEPTNO=DEPT.DEPTNO;

-- CROSS조인
SELECT EMPNO,ENAME,SAL,COMM,EMP.DEPTNO,DNAME,LOC
FROM EMP CROSS JOIN DEPT;

SELECT * FROM EMP;
INSERT INTO EMP(EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO)
VALUES(7212,'CSS','MANAGER',7370,'99/11/25',8000,900,40);

ALTER TABLE DEPT ADD CONSTRAINT DEPT_DEPTNO_PK PRIMARY KEY(DEPTNO);
SELECT * FROM DEPT;

-- FOREIGN KEY 제약 조건
ALTER TABLE EMP ADD CONSTRAINT EMP_DEPTNO_FK FOREIGN KEY(DEPTNO) REFERENCES DEPT(DEPTNO);
ALTER TABLE DEPT DROP PRIMARY KEY CASCADE;

DELETE FROM DEPT WHERE DEPTNO=40;


-- 제약 조건 확인
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('DEPT','EMP');

CREATE TABLE DEPTJOIN(
DEPTNO NUMBER(7) CONSTRAINT DEPTJOIN_DEPTNO_PK PRIMARY KEY,
DNAME VARCHAR2(20),
LOC VARCHAR2(20));

CREATE TABLE EMPJOIN(
EMPNO NUMBER(7) CONSTRAINT EMPJOIN_MEPNO_PK PRIMARY KEY,
ENAME VARCHAR2(20),
SAL NUMBER(7),
DEPTNO NUMBER(7));

ALTER TABLE EMPJOIN ADD
    CONSTRAINT EMPJOIN_DEPTNO_FK 
    FOREIGN KEY(DEPTNO) REFERENCES DEPTJOIN(DEPTNO) ON DELETE CASCADE;
ALTER TABLE EMPJOIN DROP CONSTRAINT EMPJOIN_DEPTNO_FK;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('EMPJOIN','DEPTJOIN');

SELECT * FROM DEPTJOIN;
INSERT INTO DEPTJOIN VALUES(40,'회계부','울산');
SELECT * FROM EMPJOIN;
INSERT INTO EMPJOIN(EMPNO,ENAME,SAL,DEPTNO) VALUES(7786,'CCC',6000,40);

SELECT * FROM DEPTJOIN;
DELETE FROM DEPTJOIN WHERE DEPTNO=10;
SELECT * FROM EMPJOIN;


CREATE TABLE JSTUDENT(
SID_ID CHAR(6) CONSTRAINT JSTUDENT_SID_PK PRIMARY KEY
               CONSTRAINT JSTUDENT_SID_CK CHECK(LENGTH(TRIM(' 'FROM SID_ID))=6),
SNAME VARCHAR2(15) CONSTRAINT JSTUDENT_SNAME_NN NOT NULL,
GRADE CHAR(1),
ADDR VARCHAR2(30));


SELECT * FROM JSUBJECT;
CREATE TABLE JSUBJECT(
SUB_ID CHAR(6) CONSTRAINT JSUBJECT_SUB_ID_PK PRIMARY KEY,
SUB_NAME VARCHAR2(30),
SINCE NUMBER(10));

CREATE TABLE SCORE(
SID_ID CHAR(6),
SUB_ID CHAR(6),
SCORE NUMBER(5) CONSTRAINT SCORE_CK CHECK(SCORE BETWEEN 0 AND 100),
CONSTRAINT SCORE_S_PK PRIMARY KEY(SID_ID,SUB_ID),
CONSTRAINT SCORE_FK FOREIGN KEY(SID_ID) REFERENCES JSTUDENT(SID_ID) ON DELETE CASCADE,
CONSTRAINT SCORE_FK2 FOREIGN KEY(SUB_ID) REFERENCES JSUBJECT(SUB_ID));


SELECT * FROM JSTUDENT; -- 학생
SELECT * FROM JSUBJECT; -- 과목

INSERT INTO JSUBJECT(SUB_ID,SUB_NAME,SINCE)
VALUES('562312','자료구조',1980);

INSERT INTO JSUBJECT(SUB_ID,SUB_NAME,SINCE)
VALUES('562313','소프트웨어공학',1970);

INSERT INTO JSUBJECT(SUB_ID,SUB_NAME,SINCE)
VALUES('562314','유닉스',1990);

INSERT INTO JSUBJECT(SUB_ID,SUB_NAME,SINCE)
VALUES('562315','오라클',1980);

SELECT * FROM SCORE; -- 점수

INSERT INTO JSTUDENT(SID_ID,SNAME,GRADE,ADDR)
VALUES('121211','김준철','1','경기도');

INSERT INTO JSTUDENT(SID_ID,SNAME,GRADE,ADDR)
VALUES('121212','김윤하','4','경기도');

INSERT INTO JSTUDENT(SID_ID,SNAME,GRADE,ADDR)
VALUES('121213','최수정','3','서울');

INSERT INTO SCORE(SID_ID,SUB_ID,SCORE)
VALUES('121211','562318',80);