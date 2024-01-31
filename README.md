# 증명서 발급 시스템 DB 설계

## 🔸 About Project

- 주어진 요구사항과 주민 관계 데이터를 참고하여 **주민 관리 시스템의 데이터를 모델링**하는 프로젝트
- **가족관계증명서, 주민등록등본, 출생신고서, 사망신고서** 4종류의 주민관리 문서 예시에 작성된 데이터를 입력 후, '남기준'의 식별 값을 기준으로 출력하는 SQL을 작성
- 데이터 모델링을 수행 후 DBMS에 **ER-Diagram 설계 및 DDL 스크립트 작성**
- 설계한 데이터베이스를 바탕으로 증명서 발급 시 필요한 데이터를 CRUD하는 **DML 스크립트 및 SQL Query 작성**
<br>

## 🔸 요구사항
### 예시 데이터 가계도 (명의: 남기준)
<div align="center"> <img width="600" alt="스크린샷 2024-01-31 오후 4 59 49" src="https://github.com/ghsyn/resident-management-system-database/assets/94375740/40f5f270-24c9-4287-9c08-f1518f0fe32e"> </div>

### 증명서 1. 가족관계증명서
- 가족관계증명서는 본인을 기준으로 가족관계가 있는 '본인, 배우자, 부모, 자녀'가 기재됩니다.
- 가족이라고 하더라도 기준이 되는 사람에 따라서 기재사항이 다르고, 형제자매는 기재되지 않습니다.
<div align="center"> <img width="350" alt="스크린샷 2024-01-31 오후 4 57 16" src="https://github.com/ghsyn/resident-management-system-database/assets/94375740/a0a7b5ca-b45c-4082-8e32-67a23aab7e35"> </div>

### 증명서 2. 주민등록등본
- 주민등록등본은 주민등록 주소지를 같이하는 세대의 세대주와 세대원이 기재됩니다.
- 가족관계라도 동일 세대에 포함되지 않으면 주민등록등본에 나오지 않고, 타인이라도 동일 세대에 포함되면 주민등록등본에 나오게 됩니다.
- 주민등록등본은 세대주 기준으로 출력되므로, 세대주와 세대원의 출력결과가 동일합니다.
<div align="center"> <img width="350" alt="스크린샷 2024-01-31 오후 4 57 57" src="https://github.com/ghsyn/resident-management-system-database/assets/94375740/0110b345-96e9-4db4-89cd-228f086220bb"> </div>

### 증명서 3. 출생신고서
- 출생신고서는 신생아의 출생을 신고하기 위해 작성하는 가족관계등록 문서입니다.
- 출생신고는 일생에 한번만 작성합니다.
<div align="center"> <img width="350" alt="스크린샷 2024-01-31 오후 4 58 12" src="https://github.com/ghsyn/resident-management-system-database/assets/94375740/f768a468-0d32-4787-9d7d-eaa34c20287f"> </div>

### 증명서 4. 사망신고서
- 사람의 사망 사실을 행정 기관에 알리기 위한 문서입니다.
- 사망신고는 일생에 한번만 작성할 수 있습니다.
<div align="center"> <img width="350" alt="스크린샷 2024-01-31 오후 4 58 29" src="https://github.com/ghsyn/resident-management-system-database/assets/94375740/37dae145-1796-4d2d-82ea-31d47a8ba5b9"> </div>

### 기타 요구사항
- 주민등록번호 : 주민등록번호는 13자리이나, 데이터 입력 시 암호화 솔루션에 의해 변환된 300자리로 저장해야 합니다.
- 가족관계 및 세대구성 : 가족관계와 세대구성은 관리하는 목적이 다르므로 분리하여 관리해야 합니다.
- 세대주 : 한 사람이 동시에 여러 세대의 세대주가 될 수 없으며 세대주는 배우자에 한해 변경이 가능하고 이때, 세대주관계에 입력된 '본인'과 '배우자'가 바뀝니다.
- 세대 구성원 : 출생 신고 시 가족관계 및 세대 구성원에 자동으로 등록되며, 세대 구성원의 변동사유를 '출생등록'으로 입력합니다.
- 증명서 확인번호 : 증명서 확인 번호는 발급된 가족관계증명서, 주민등록등본 문서를 식별하는 문서로,16자리의 번호로 구성되어 있습니다.
- 증명서 발급 : 가족관계증명서, 주민등록등본 발급 시 신청한 주민과 증명서 확인번호, 증명서 발급일자만 관리하고, 각 증명서의 스냅 샷 정보는 관리하지 않습니다.
- 신고인 : 출생신고서와 사망신고서의 신고인은 필요 시 확인을 위해 반드시 관리해야 합니다.
<br>

## 🔸 사용 기술
- **데이터베이스 설계 및 DDL 스크립트 작성 |** MySQL, MySQL Workbench
- **DML 스크립트 및 쿼리 작성 |** MySQL Workbench, DataGrip
<br>

## 🔸 ER-Diagram
<div align="center"> <img width="1392" alt="주민_관리_시스템_전체ERD" src="https://github.com/ghsyn/Resident-Management-System-Database/assets/94375740/c76b4949-fa17-45b5-8f8a-bef53640bea3"> </div>
