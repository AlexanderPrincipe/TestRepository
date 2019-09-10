
------------------------MERGE--------------------------------
-------------------SMA_ADSL_2019.SQL-----------------

-- APPEND FROM ADSL0719 = SUBIR ARCHIVO ADSL0719 A LA TABLA SMA_ADSL, LA TABLA SMA_ADSL ES UN ACUMULATIVO DONDE SE SUBEN TODOS LOS -->
-- ADSL DE TODOS LOS MESES

-- LUEGO DE A�ADIR ESTAS FILAS A LA TABLA SMA_ADSL, SE ACTUALIZA

-- SE CREA EL ATRIBUTO CSEG PARA PODER HACER LAS VALIDACIONES SIN AFECTAR LA INFORMACION DE LA TABLA INICIAL
SELECT * INTO SMA_ADSL FROM ADSL
ALTER TABLE SMA_ADSL ADD CSEG VARCHAR(250)
UPDATE SMA_ADSL
SET CSEG = CODSEG


UPDATE SMA_ADSL
SET CSEG = 'E'
WHERE CSEG IN ('0','1','2','3','4','5','6','7')
AND MM_LIQ = 7

SELECT CSEG FROM SMA_ADSL
----------------------------------------------------------------------
SELECT CODLIQ FROM SMA_ADSL WHERE CSEG = 'E'
SELECT * FROM INDICA_ADSL_PAIS
SELECT CSEG, COUNT(*) FROM SMA_ADSL GROUP BY CSEG ORDER BY 1 DESC
SELECT CODSEG FROM SMA_ADSL
SELECT CODSEG, COUNT(*) FROM SMA_ADSL GROUP BY CODSEG ORDER BY 2 DESC
-----------------------------------------------------------------------
SELECT * FROM SMA_ADSL A JOIN CODLIQ_ADSL_2017 B ON A.CODLIQ = B.COD_LIQ
SELECT * FROM SMA_ADSL A JOIN RUTEMPP B ON A.MDF = B.MDF
SELECT * FROM SMA_ADSL A JOIN MDF_INSOURCING2015 B ON A.MDF = B.MDF
SELECT * FROM SMA_ADSL A JOIN MODARM B ON A.MDF = B.MDF

-- ALTER TABLE CODLIQ_ADSL_2017 ALTER COLUMN COD_LIQ NVARCHAR(500)


---------------------------------------------------------------
ALTER TABLE SMA_ADSL ADD TELEFONO NVARCHAR(255)

SELECT TELEFONO FROM SMA_ADSL

UPDATE SMA_ADSL
SET TELEFONO = 0
WHERE TELEFONO IS NULL

---------------------UPDATE JOIN--------------------------
UPDATE A
SET A.TELEFONO = B.CLASIF_NUEVA
FROM SMA_ADSL A JOIN CODLIQ_ADSL_2017 B ON A.CODLIQ = B.COD_LIQ
WHERE A.MM_LIQ = 7

SELECT CODLIQ FROM SMA_ADSL
SELECT CODLIQ, COUNT(*) FROM SMA_ADSL GROUP BY CODLIQ HAVING COUNT(*) > 1

-----------------------------------------------------------------
ALTER TABLE SMA_ADSL ADD MODRUT INT
SELECT LEN(TRIM(MDF)) FROM SMA_ADSL

UPDATE SMA_ADSL
SET MODRUT = 0
WHERE MODRUT IS NULL

UPDATE A
SET A.MODRUT = 1
FROM SMA_ADSL A JOIN RUTEMPP B ON A.MDF = B.MDF
WHERE LEN(A.MDF) = 4
	AND (A.CSEG) = 'E'
	AND A.MM_LIQ = 7 
	AND A.AA_LIQ = 2019

---------------------------------------------------------------------
ALTER TABLE SMA_ADSL ADD INSMDF INT
SELECT DISTINCT SWITCH FROM MDF_INSOURCING2015

UPDATE SMA_ADSL
SET INSMDF = 0
WHERE INSMDF IS NULL

create function TRIM(@data varchar(20)) returns varchar(255)
as
begin
  declare @str varchar(255)
  set @str = rtrim(ltrim(@data))
  return @str
end


SELECT CODLIQ FROM SMA_ADSL

UPDATE A
SET INSMDF = 1
FROM SMA_ADSL A JOIN MDF_INSOURCING2015 B ON A.MDF = B.MDF
WHERE DBO.TRIM(A.CODLIQ) IN ('31','32','33','34')
	--AND B.SWITCH = '.T.'
	AND A.MM_LIQ = 7
	AND A.AA_LIQ = 2019
-------------------------------------------------------------------
ALTER TABLE SMA_ADSL ADD MODARM INT

UPDATE SMA_ADSL
SET MODARM = 0
WHERE MODARM IS NULL

UPDATE A
SET MODARM = 1
FROM SMA_ADSL A JOIN MODARM B ON (A.MDF = B.MDF)
WHERE DBO.TRIM(A.CODLIQ) IN ('15','24')
	AND A.MM_LIQ = 7
	AND A.AA_LIQ = 2019 

---------------------------------------------------------------------------------------------------------------------
-- CODIGO GLORIA
SELECT * FROM 'd:\calc_averias\ACUM\2019\SMA_ADSL' GROUP BY AVERIA INTO TABLE 'd:\calc_averias\ACUM\2019\SMA_ADSL2'


DROP VIEW SMA_ADSL2_VW

SELECT * FROM SMA_ADSL2_VW

CREATE VIEW SMA_ADSL2_VW AS (
SELECT * FROM SMA_ADSL 
)

-------------------------------------------------------------------------------------------------------------------
CREATE VIEW ADSL_07 AS (
SELECT * FROM SMA_ADSL A WHERE DBO.TRIM(ESTALIQ) in ('ZEI','STAR','RTNC','PEX','PAGE','VOIP') AND MODRUT=0
AND MODARM=0 AND INSMDF=0 AND TELEFONO='EFECTIVA' AND MM_LIQ = 7
)

SELECT * FROM ADSL_07
---------------------------------------------------------------------------------------------------------------------