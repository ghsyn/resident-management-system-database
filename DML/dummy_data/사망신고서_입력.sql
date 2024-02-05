USE `CERTIFICATE`;

# 원활한 테스트를 위한 사전 더미 데이터 삭제
START TRANSACTION;

DELETE
FROM DEATH_INFO DI
WHERE PERSON_ID = (SELECT ID
                   FROM PERSON
                   WHERE NAME = '남길동'
                     AND RESIDENT_REGISTRATION_NUMBER = '130914-*******');

DELETE
FROM NOTIFY_INFO NI
WHERE NI.PERSON_ID = (SELECT ID
                      FROM PERSON
                      WHERE NAME = '남석환'
                        AND RESIDENT_REGISTRATION_NUMBER = '540514-*******')
  AND NI.NOTIFY_CODE = (SELECT CODE
                        FROM NOTIFY_CODE
                        WHERE NAME = '사망신고');

COMMIT;


## 주소 테이블에 사망지 추가
START TRANSACTION;

INSERT INTO `CERTIFICATE`.`ADDRESS` (`ZIP_CODE`, `ADDRESS`)
SELECT '67890'
     , '강원도 고성군 금강산로 290번길'
FROM dual
WHERE NOT EXISTS(SELECT *
                 FROM ADDRESS A
                 WHERE ADDRESS = '강원도 고성군 금강산로 290번길');

## 사망자 정보 입력
INSERT INTO `CERTIFICATE`.`DEATH_INFO` (`PERSON_ID`, `ADDRESS_ID`, `DEATH_PLACE_CODE`, `DEATH_DATETIME`)
VALUES ( (SELECT ID
          FROM PERSON
          WHERE NAME = '남길동'
            AND RESIDENT_REGISTRATION_NUMBER = '130914-*******')
       , (SELECT ID
          FROM ADDRESS
          WHERE ADDRESS = '강원도 고성군 금강산로 290번길')
       , (SELECT CODE
          FROM DEATH_PLACE_CODE
          WHERE NAME = '주택')
       , '2021-04-29 09:03:00');

## 사망 신고자 정보 입력
INSERT INTO `CERTIFICATE`.`NOTIFY_INFO` ( `PERSON_ID`, `NOTIFY_CODE`, `TARGET_PERSON_ID`, `QUALIFICATION_CODE_ID`
                                             , `EMAIL`, `PHONE_NUMBER`, `CREATE_DATETIME`)
VALUES ((SELECT ID
         FROM PERSON
         WHERE NAME = '남석환'
           AND RESIDENT_REGISTRATION_NUMBER = '540514-*******')
       , (SELECT CODE
          FROM NOTIFY_CODE
          WHERE NAME = '사망신고')
       , (SELECT ID
          FROM PERSON
          WHERE NAME = '남길동'
            AND RESIDENT_REGISTRATION_NUMBER = '130914-*******')
       , (SELECT ID
          FROM QUALIFICATION_CODE
          WHERE NAME = '비동거친족'
            AND NOTIFY_CODE_CODE = 2), NULL, '010-2345-6789', '2020-05-02 00:00:00');

COMMIT;
