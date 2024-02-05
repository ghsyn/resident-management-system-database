USE CERTIFICATE;

## 사망신고서

## 사망신고서 상단
SELECT NC.NAME AS '신고서 이름'
     , NI.CREATE_DATETIME AS '신고일'
FROM NOTIFY_CODE NC
         JOIN NOTIFY_INFO NI
              ON NC.CODE = NI.NOTIFY_CODE
WHERE PERSON_ID = (SELECT ID
                   FROM PERSON
                   WHERE NAME = '남석환'
                     AND RESIDENT_REGISTRATION_NUMBER = '540514-*******')
  AND NOTIFY_CODE = (SELECT CODE
                     FROM NOTIFY_CODE
                     WHERE NAME = '사망신고')
  AND TARGET_PERSON_ID = (SELECT ID
                          FROM PERSON
                          WHERE NAME = '남길동'
                            AND RESIDENT_REGISTRATION_NUMBER = '130914-*******');

## 사망신고서 사망자
SELECT P.NAME AS '성명'
     , P.RESIDENT_REGISTRATION_NUMBER AS '주민등록번호'
     , DI.DEATH_DATETIME AS '사망일시'
     , DPC.NAME AS '사망장소 구분'
     , A.ADDRESS AS '사망장소 주소'
FROM DEATH_INFO DI
         JOIN PERSON P
              ON DI.PERSON_ID = P.ID
         JOIN DEATH_PLACE_CODE DPC
              ON DI.DEATH_PLACE_CODE = DPC.CODE
         JOIN ADDRESS A
              ON DI.ADDRESS_ID = A.ID
WHERE PERSON_ID = (SELECT ID
                   FROM PERSON
                   WHERE NAME = '남길동'
                     AND RESIDENT_REGISTRATION_NUMBER = '130914-*******');

## 사망신고서 신고인
SELECT P.NAME
     , P.RESIDENT_REGISTRATION_NUMBER
     , QC.NAME
     , NI.EMAIL
     , NI.PHONE_NUMBER
FROM PERSON AS P
         JOIN NOTIFY_INFO NI
              ON P.ID = NI.PERSON_ID
         JOIN QUALIFICATION_CODE QC
              ON NI.QUALIFICATION_CODE_ID = QC.ID
WHERE TARGET_PERSON_ID = (SELECT ID
                          FROM PERSON
                          WHERE NAME = '남길동'
                            AND RESIDENT_REGISTRATION_NUMBER = '130914-*******')
  AND NOTIFY_CODE = (SELECT CODE
                     FROM NOTIFY_CODE
                     WHERE NAME = '사망신고');
