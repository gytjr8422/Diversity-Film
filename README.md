# 다양성 영화 박스오피스

영화 박스오피스 순위 및 상세정보 제공 앱

## 프로젝트 소개

UIKit과 Firestore를 사용한 iOS 앱

## 개발 기간

- 23.03.07 ~ 

## 주요 기능

### 1. 메인 페이지
 
-  Collection View를 활용한 박스오피스 순위
-  영화 제목, 포스터, 순위, 박스오피스 신규 진입 여부 정보 제공

<img src="https://user-images.githubusercontent.com/74528858/230960890-4960bf24-07d5-40f2-ac3f-c0f7a8d37d9f.PNG"  width="270" height="585">  <img src="https://user-images.githubusercontent.com/74528858/230962051-cef3b903-448f-4dd6-9cc2-269a6111ddeb.PNG"  width="270" height="585">

### 2. 영화 상세정보 페이지

-  장르, 제작 국가, 감독, 배우, 줄거리 정보 제공
-  영화관 현황 페이지로 이동 버튼

<img src="https://user-images.githubusercontent.com/74528858/230962369-8d95e052-516b-4179-b5f3-29bdc897eee7.PNG"  width="270" height="585">

### 3. 상영 영화관 형환 페이지(현재 상영관, 상영 예정관)

-  현재 상영관 및 상영 예정관을 Segmented Control로 구현
-  상영 지역별로 확인 기능

<img src="https://user-images.githubusercontent.com/74528858/230962565-f58c1dfc-45f1-43e7-8409-6c790c73db1d.PNG"  width="270" height="585">  <img src="https://user-images.githubusercontent.com/74528858/230962604-dab6b42b-66c2-4838-87c1-8503921159ab.PNG"  width="270" height="585">  <img src="https://user-images.githubusercontent.com/74528858/230962626-88eaffc0-1739-4d5c-beeb-20aceb74cbac.PNG"  width="270" height="585">  <img src="https://user-images.githubusercontent.com/74528858/230962641-113343e2-66ff-4421-b651-67516fe9561d.PNG"  width="270" height="585">

### 4. 공지사항 화면

-  데이터베이스에 저장된 공지사항 정보 제공

<img src="https://user-images.githubusercontent.com/74528858/231073902-68de0d14-a8d1-4b97-9367-fad7d0fc852d.PNG"  width="270" height="585"> <img src="https://user-images.githubusercontent.com/74528858/231073909-9f1831c3-50cd-407d-8e38-bc374b410ce0.PNG"  width="270" height="585">


### 5. 검색 화면

-  영화 제목으로 검색 기능

<img src="https://user-images.githubusercontent.com/74528858/230963055-219037d2-c579-43ba-ba13-ce738a86014a.PNG"  width="270" height="585">  <img src="https://user-images.githubusercontent.com/74528858/230963074-064e4f11-e3d9-4ab9-b409-1849a4a7001e.PNG"  width="270" height="585">


### 6. Python을 활용한 영화 데이터 저장(API, 크롤링)

a. crawler.py

-  영화진흥위원회 API와 Selenium을 활용한 데이터 크롤링
-  Firestore 데이터베이스에 저장

b. tmdb_api.py

-  TMDB API를 활용한 데이터 가져오기
-  상영관 현황은 제공되지 않기 때문에 크롤링 방법 채택
