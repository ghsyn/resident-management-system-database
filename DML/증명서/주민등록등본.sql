USE CERTIFICATE;

## 주민등록등본

# 발급일 지정. (실제로는 의미있는 값 or 랜덤 일련번호 등 설정이 필요하다.)
SET @PRE_ID = '98765432';
SET @SUB_ID = '10987654';

# 원활한 테스트를 위한 DELETE
DELETE
FROM CERTIFICATE_ISSUE_LOG CIL
WHERE PRE_ID = @PRE_ID
  AND SUB_ID = @SUB_ID;

# 증명서 발급 로그 INSERT
INSERT INTO CERTIFICATE_ISSUE_LOG
    (PRE_ID, SUB_ID, PERSON_ID, CERTIFICATE_CODE, DATETIME)
VALUES ( @PRE_ID, @SUB_ID
       , (SELECT P.ID FROM PERSON P WHERE P.NAME = '남기석') # 실제로는 신청시 주민등록번호 등 기타 정보를 더 받아 해당 정보를 토대로 ID 가져오기
       , (SELECT CODE FROM CERTIFICATE_CODE CC WHERE NAME = '주민등록등본'), NOW());

# 주민등록등본 상단
SELECT DATE_FORMAT(CIL.DATETIME, '%Y-%m-%d') AS '발급일'
     , CONCAT(@PRE_ID, '-', @SUB_ID) AS '증명서확인번호'
     , P.NAME AS '세대주 성명'
     , CRC.NAME AS '세대구성 사유'
     , DATE_FORMAT(R.CREATE_DATETIME, '%Y-%m-%d') AS '세대구성 일자'
FROM CERTIFICATE_ISSUE_LOG CIL
         JOIN HOUSEHOLD H
              ON CIL.PERSON_ID = H.PERSON_ID
         JOIN PERSON P
              ON H.HOUSEHOLDER_ID = P.ID
         JOIN RESIDENCE R
              ON P.ID = R.PERSON_ID
         JOIN CHANGE_REASON_CODE CRC
              ON CRC.ID = R.CHANGE_REASON_CODE_ID
WHERE CIL.PRE_ID = @PRE_ID
  AND CIL.SUB_ID = @SUB_ID
ORDER BY R.CREATE_DATETIME DESC
LIMIT 1;

# 주민등록 주소 및 신고일
SELECT A.ADDRESS AS '주소'
     , DATE_FORMAT(R.CREATE_DATETIME, '%Y-%m-%d') AS '신고일'
FROM RESIDENCE R
         JOIN ADDRESS A
              ON A.ID = R.ADDRESS_ID
WHERE R.PERSON_ID = (SELECT H2.HOUSEHOLDER_ID
                     FROM CERTIFICATE_ISSUE_LOG CIL
                              JOIN HOUSEHOLD H2
                                   ON CIL.PERSON_ID = H2.PERSON_ID
                     WHERE CIL.PRE_ID = @PRE_ID
                       AND CIL.SUB_ID = @SUB_ID)
ORDER BY R.CREATE_DATETIME DESC;

# 등록 세대원
SELECT HRC.NAME AS '세대주 관계'
     , P.NAME AS '성명'
     , P.RESIDENT_REGISTRATION_NUMBER AS '주민등록번호'
     , R.CREATE_DATETIME AS '신고일'
     , CRC.NAME AS '변동사유'
FROM PERSON P
         JOIN HOUSEHOLD H
              ON P.ID = H.PERSON_ID
         JOIN HOUSEHOLD_RELATION_CODE HRC
              ON HRC.CODE = H.RELATION_CODE
         JOIN RESIDENCE R
              ON P.ID = R.PERSON_ID
         JOIN CHANGE_REASON_CODE CRC
              ON CRC.ID = R.CHANGE_REASON_CODE_ID
WHERE H.HOUSEHOLDER_ID = (SELECT H2.HOUSEHOLDER_ID
                          FROM CERTIFICATE_ISSUE_LOG CIL
                                   JOIN HOUSEHOLD H2
                                        ON CIL.PERSON_ID = H2.PERSON_ID
                          WHERE CIL.PRE_ID = @PRE_ID
                            AND CIL.SUB_ID = @SUB_ID)
  AND R.CREATE_DATETIME = (SELECT MAX(R2.CREATE_DATETIME)
                           FROM RESIDENCE R2
                           WHERE P.ID = R2.PERSON_ID
                           GROUP BY R2.PERSON_ID);
