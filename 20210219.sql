
--DBMS---정의어 ,조작어[논리적작업단위]   ROLLBACK<---부분완료 ---->COMMIT 완전완료

--(SELECT      -->CONSOL---->
--                    JDBC, ORACLERESULT-->JAVA  
--                    JDBC, ORACLERESULT-->JAVA---> XML,JSON 
--ORDER BY)

--분석함수
--순위관련함수 [RANK,DENSE_RANK,ROW_NUMBER]
--집계관련함수 [SUM ,MAX,MIN,AVG,COUNT]
--순서관련함수 [FIRST_VALUE,LAST_VALUE,LAG,LEAD ]
--비율관련함수 [NTILE , RATIO_TO_REPORT,PERCENT_RANK]


SELECT STUDNO, NAME, GRADE, TEL, RANK() OVER(ORDER BY WEIGHT DESC) RK1,
RANK() OVER (PARTITION BY DEPTNO ORDER BY WEIGHT DESC) RK2
FROM STUDENT;


SELECT EMPNO, ENAME, MGR, SAL, SUM(SAL) OVER(PARTITION BY MGR)MGR_SUM
FROM EMP;
--SUM(SAL) OVER(PARTITION BY MGR
--MGR을 부분으로 나눠서 부분마다 SUM

SELECT EMPNO, ENAME,MGR, SAL, SUM(SAL) OVER(ORDER BY SAL) SALSUM
FROM EMP;
--SUM(SAL) OVER(ORDER BY SAL)
--SAL을 순서대로 정렬하여 전체 SAL을 순차적으로 SUM

SELECT EMPNO, ENAME, MGR, SAL, JOB, SUM(SAL) OVER(PARTITION BY JOB)JOB_SUM
FROM EMP;

SELECT EMPNO,ENAME,SAL,HIREDATE,JOB,MGR,
SUM(SAL) OVER(PARTITION BY MGR)
FROM EMP;

-- 현재 행의 1행 이전의 합과 1행 이후의 합을 더함.
SELECT EMPNO,ENAME,SAL,HIREDATE,JOB,MGR,
SUM(SAL) OVER(PARTITION BY MGR
ORDER BY HIREDATE ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
FROM EMP;

-- SAL에서 50뺀 값부터 150 더한 값 사이의 범위에 있는 값의 카운트
SELECT PROFNO,NAME,SAL,COUNT(*) OVER(ORDER BY SAL RANGE BETWEEN 50 PRECEDING AND 150 FOLLOWING)
FROM PROFESSOR;

-- JOB을 파티션으로 해서 자기 행을 기준으로 퍼스트와 라스트 ENAME값 출력
SELECT DEPTNO,ENAME,SAL,JOB,FIRST_VALUE(ENAME) OVER(PARTITION BY JOB ORDER BY SAL DESC),
LAST_VALUE(ENAME) OVER(PARTITION BY JOB ORDER BY SAL DESC)
FROM EMP;


SELECT DEPTNO,ENAME,SAL,FIRST_VALUE(ENAME)
OVER(PARTITION BY DEPTNO ORDER BY SAL DESC)
FROM EMP;

-- ENAME DESC ROWS UNBOUNDED PRECEDING : ENAME을 내림차순으로 해서 UNBOUNDED(맨 앞부분부터) 데이터를 가져와라. 
SELECT DEPTNO,ENAME,SAL,FIRST_VALUE(ENAME)
OVER(PARTITION BY DEPTNO ORDER BY SAL, ENAME DESC ROWS UNBOUNDED PRECEDING),
LAST_VALUE(ENAME) OVER(PARTITION BY DEPTNO ORDER BY SAL, ENAME DESC ROWS UNBOUNDED PRECEDING)
FROM EMP;

-- HEIGHT 내림차순 후에 중복 있으면 STUDNO로 오름차순
SELECT STUDNO,NAME,HEIGHT,DEPTNO,
COUNT(*) OVER(PARTITION BY DEPTNO ORDER BY HEIGHT DESC, STUDNO ASC)CO
FROM STUDENT;

-- 이전 1행 이후 2행을 더한 카운트 구하기.
SELECT STUDNO,NAME,HEIGHT,DEPTNO,
COUNT(*) OVER(PARTITION BY DEPTNO ORDER BY HEIGHT DESC ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING)CO
FROM STUDENT;

SELECT STUDNO,NAME,HEIGHT,DEPTNO,
COUNT(*) OVER(PARTITION BY DEPTNO ORDER BY HEIGHT DESC ROWS UNBOUNDED PRECEDING)CO
FROM STUDENT;


SELECT EMPNO,ENAME,SAL,HIREDATE,DEPTNO,
COUNT(*) OVER(PARTITION BY DEPTNO ORDER BY SAL DESC,
ENAME DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)CO
FROM EMP;


-- 분석함수, 그룹함수, 단일함수
-- INDEX, 정규식, 정규화[개념설계,논리설계[1정규화,2,3,4,5]물리설계]
-- PLSQL

-- SAL에 대한 이전 값을 출력해줌.
SELECT ENAME,HIREDATE,SAL,LAG(SAL)OVER(ORDER BY HIREDATE DESC)PRV,
LEAD(SAL)OVER(ORDER BY SAL DESC)NXT
FROM EMP;


SELECT STUDNO,NAME,GRADE,BIRTHDATE,HEIGHT,DEPTNO,
SUM(HEIGHT) OVER(PARTITION BY DEPTNO ORDER BY HEIGHT DESC)SO,
LAG(HEIGHT) OVER(PARTITION BY DEPTNO ORDER BY HEIGHT DESC)PRV,
LEAD(HEIGHT) OVER(PARTITION BY DEPTNO ORDER BY HEIGHT DESC)NXT
FROM STUDENT;

-- 직접 전체합을 나누어서 비율 구함.
SELECT EMPNO,ENAME,SAL,SUM(SAL) OVER()SUM,ROUND(SAL/21375,2)RATIO
FROM EMP;

-- RATIO_TO_REPORT SUM(컬럼) 전체 값에 대한 컬럼값의 백분율을 구하는 함수
SELECT EMPNO,ENAME,SAL,ROUND(RATIO_TO_REPORT(SAL) OVER(),2)
FROM EMP;


SELECT STUDNO,NAME,HEIGHT,ROUND(RATIO_TO_REPORT(HEIGHT)OVER(),3)
FROM STUDENT;

-- 
SELECT EMPNO,ENAME,SAL,PERCENT_RANK() OVER(ORDER BY SAL DESC)
FROM EMP;

SELECT EMPNO,ENAME,DEPTNO,SAL,PERCENT_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC)
FROM EMP;


-- CUM_DIST는 누적분포율을 나타내는 분석함수.
SELECT EMPNO,ENAME,SAL,RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC)RK1,
DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC)RK2,
ROW_NUMBER() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC)RK3,
PERCENT_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC)RK4,
CUME_DIST()OVER(PARTITION BY DEPTNO ORDER BY SAL DESC)RK5
FROM EMP;


-- 사원입사일을 기준으로 2년간 누적 연봉을 출력하라.
-- 기준 행에서 50 빼고 50더한 범위내에 있는 SAL값을 더한 값을 SO로 출력.
SELECT EMPNO,ENAME,SAL,HIREDATE,SUM(SAL) 
OVER(ORDER BY SAL ASC RANGE BETWEEN 50 PRECEDING AND 50 FOLLOWING)SO
FROM EMP;


SELECT EMPNO,ENAME,SAL,HIREDATE,
SUM(SAL) OVER(ORDER BY HIREDATE ASC RANGE BETWEEN INTERVAL '2' YEAR PRECEDING AND INTERVAL '2' YEAR FOLLOWING)SO
FROM EMP;

SELECT TEAMNO,NO,NAME,POSITION,HEIGHT,BIRTHDATE,SCHOOL,
ROUND(AVG(HEIGHT) OVER(ORDER BY HEIGHT ASC RANGE BETWEEN 5 PRECEDING AND 5 FOLLOWING),2)SO,
HEIGHT-5,HEIGHT+5
FROM KGC