-- 20210225
CREATE TABLE ZIPCODE(
ZIPCODE NVARCHAR2(10),
SIDO NVARCHAR2(10),
GUGUN NVARCHAR2(30),
DONG NVARCHAR2(100),
BUNJI NVARCHAR2(30),
SEQ VARCHAR2(5));

SELECT * FROM ZIPCODE;

CREATE TABLE LOADMEMBER(
NO NUMBER(5) CONSTRAINT LOADMEMBER_NO_PK PRIMARY KEY,
MSG VARCHAR2(20));

SELECT * FROM LOADMEMBER;

CREATE TABLE SSANGYONG(
NO NUMBER(5) CONSTRAINT SSANGYONG_NO_PK PRIMARY KEY,
NAME VARCHAR2(20));

SELECT * FROM SSANGYONG;

SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO, PL.SQL!');
END;
/

DROP TABLE SSANGYONG;