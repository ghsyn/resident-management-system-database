USE CERTIFICATE;

## 출생신고서
## 남기석이 나이가 들고 본인의 출생 신고서가 궁금하여 조회를 하는 컨셉

# 출생신고서 상단
    SELECT NC.NAME AS '신고서 이름'
        , ni.CREATE_DATETIME AS '신고일'
        FROM NOTIFY_CODE NC
        JOIN NOTIFY_INFO NI
            ON NC.CODE = NI.NOTIFY_CODE
    WHERE PERSON_ID = (SELECT ID
                       FROM PERSON
                       WHERE NAME = '남기준'
                         AND RESIDENT_REGISTRATION_NUMBER = '790510-*******')
      AND NOTIFY_CODE = (SELECT CODE
                         FROM NOTIFY_CODE
                         WHERE NAME = '출생신고')
      AND TARGET_PERSON_ID = (SELECT ID
                              FROM PERSON
                              WHERE NAME = '남기석'
                                AND RESIDENT_REGISTRATION_NUMBER = '120315-*******')

# 출생신고서 출생자
SELECT P.NAME AS '성명'
     , GC.NAME AS '성별'
     , BI.BIRTH_DATETIME AS '출생일시'
     , BPC.NAME AS '출생장소'
     , A.ADDRESS AS '등록기준지(본적)'
FROM BIRTH_INFO BI
         JOIN GENDER_CODE GC
              ON GC.CODE = BI.GENDER_CODE
         JOIN BIRTH_PLACE_CODE BPC
              ON BPC.CODE = BI.BIRTH_PLACE_CODE
         JOIN ADDRESS A
              ON A.ID = BI.ADDRESS_ID
         JOIN PERSON P
              ON P.ID = BI.PERSON_ID
WHERE BI.PERSON_ID = (SELECT ID
                      FROM PERSON P
                      WHERE P.NAME = '남기석'
                        AND P.RESIDENT_REGISTRATION_NUMBER = '120315-*******');

# 출생신고서 부모
SELECT FRC.NAME AS '부모 구분'
     , P2.NAME AS '성명'
     , P2.RESIDENT_REGISTRATION_NUMBER AS '주민등록번호'
FROM PERSON P
         JOIN FAMILY F
              ON P.ID = F.TARGET_PERSON_ID
         JOIN FAMILY_RELATION_CODE FRC
              ON FRC.CODE = F.FAMILY_RELATION_CODE
         JOIN PERSON P2
              ON P2.ID = F.PERSON_ID
WHERE P.NAME = '남기석'
  AND P.RESIDENT_REGISTRATION_NUMBER = '120315-*******'
  AND (FRC.NAME = '부' OR FRC.NAME = '모');

# 출생신고서 신고인
SELECT P.NAME AS '성명'
     , P.RESIDENT_REGISTRATION_NUMBER AS '주민등록번호'
     , QC.NAME AS '자격'
     , NI.EMAIL AS '이메일'
     , NI.PHONE_NUMBER AS '전화번호'
FROM NOTIFY_INFO NI
         JOIN NOTIFY_CODE NC
              ON NC.CODE = NI.NOTIFY_CODE
         JOIN QUALIFICATION_CODE QC
              ON QC.ID = NI.QUALIFICATION_CODE_ID
         JOIN PERSON P
              ON P.ID = NI.PERSON_ID
WHERE NI.TARGET_PERSON_ID = (SELECT ID
                             FROM PERSON P
                             WHERE P.NAME = '남기석'
                               AND P.RESIDENT_REGISTRATION_NUMBER = '120315-*******');
