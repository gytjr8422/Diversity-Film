from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait 
import requests
import time
from datetime import date, timedelta

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

from api_keys import KOBIS_API_KEY


def film_crawler():
    # try:
    # 현재 상영 및 예정 영화관 가져오는 함수
    def get_theater_dict(divTd):
        if divTd == "divTd1":
            theater_dict = current_theater_dict
        else:
            theater_dict = coming_theater_dict
        time.sleep(2)
        print(divTd)
        # tr = driver.find_elements(By.CLASS_NAME, "divTr")
        Td = driver.find_element(By.CLASS_NAME, divTd)
        info = Td.find_element(By.CSS_SELECTOR, "div.info.info2")
        table = info.find_element(By.CLASS_NAME, "tbl_comm")
        tbody = table.find_element(By.TAG_NAME, "tbody")
        trs = tbody.find_elements(By.TAG_NAME, "tr")
        for tr in trs:
            tds = tr.find_elements(By.TAG_NAME, "td")
            theater = []
            for td in tds:
                theater.append(td.text)
            if len(theater) == 5:
                if theater[0] in theater_dict:
                    theater_dict[theater[0]].append(theater[2])
                else:
                    theater_dict[theater[0]] = [theater[2]]
        return theater_dict

    # Use a service account
    cred = credentials.Certificate('./serviceAccountKey.json')
    firebase_admin.initialize_app(cred)

    db = firestore.client()

    options = webdriver.ChromeOptions()
    options.add_argument('headless') # 화면 출력 안함

    # WebDriver로 크롬 브라우저 열기
    driver = webdriver.Chrome(options=options)

    api_key = KOBIS_API_KEY
    film_url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    film_info_url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?"


    yesterday_date = date.today() - timedelta(days=1)
    yesterday = yesterday_date.strftime("%Y%m%d") # 기준일 전날

    eight_days_ago = date.today() - timedelta(days=30)
    delete_date = eight_days_ago.strftime("%Y%m%d") # 30일 전, 삭제할 데이터

    response = requests.get(film_url + f"key={api_key}&multiMovieYn=Y&targetDt={yesterday}")
    film_result = response.json()

    save_count = 0
    for movie in film_result['boxOfficeResult']['dailyBoxOfficeList']:
        # 페이지 접속
        driver.get('https://kobis.or.kr/kobis/business/mast/mvie/findDiverMovList.do')

        # 영화 정보 api 활용
        response = requests.get(film_info_url + f"key={api_key}&movieCd={movie['movieCd']}")
        film_info_result = response.json()
        movieNm = movie['movieNm'] # 영화 이름 데이터
        rank = movie['rank'] # 랭킹 데이터
        rankOldAndNew = movie['rankOldAndNew'] # 새로 진입 여부 데이터
        prdtYear = film_info_result['movieInfoResult']['movieInfo']['prdtYear']
        director = ""
        director_data = [] # 감독 데이터
        if len(film_info_result['movieInfoResult']['movieInfo']['directors']) != 0:
            director = film_info_result['movieInfoResult']['movieInfo']['directors'][0]['peopleNm']
            for dir in film_info_result['movieInfoResult']['movieInfo']['directors']:
                director_data.append(dir['peopleNm'])
        
        actor_data = [] # 배우 데이터
        if len(film_info_result['movieInfoResult']['movieInfo']['actors']) != 0:
            count = 0
            for actor in film_info_result['movieInfoResult']['movieInfo']['actors']:
                actor_data.append(actor['peopleNm'])
                count += 1
                if count >= 4:
                    break
        
        nations_data = []
        if len(film_info_result['movieInfoResult']['movieInfo']['nations']) != 0:
            for i in range (len(film_info_result['movieInfoResult']['movieInfo']['nations'])):
                nation = film_info_result['movieInfoResult']['movieInfo']['nations'][i]['nationNm']
                nations_data.append(nation)

        genres_data = []
        if len(film_info_result['movieInfoResult']['movieInfo']['genres']) != 0:
            for i in range (len(film_info_result['movieInfoResult']['movieInfo']['genres'])):
                genre = film_info_result['movieInfoResult']['movieInfo']['genres'][i]['genreNm']
                genres_data.append(genre)
        
        print(director_data, actor_data, nations_data, genres_data)

        # 크롤링 시작
        # 검색 필드에 영화 제목 입력
        title_field = driver.find_element(By.NAME, 'sMovieNm')
        title_field.send_keys(movieNm)

        # 감독 입력
        director_field = driver.find_element(By.NAME, 'sDirector')
        director_field.send_keys(director)

        prdtYearS_field = driver.find_element(By.NAME, 'sPrdtYearS')
        prdtYearS_field.send_keys(prdtYear)

        prdtYearE_field = driver.find_element(By.NAME, 'sPrdtYearE')
        prdtYearE_field.send_keys(prdtYear)

        # 조회 버튼 클릭
        search_button = driver.find_element(By.CSS_SELECTOR, "button.btn_blue")
        # search_button.click()
        search_button.send_keys(Keys.RETURN)

        # 검색 결과 중 첫 번째 목록 클릭
        movie_button = driver.find_element(By.CLASS_NAME, "fst")
        movie_button.click()
        # movie_button.send_keys(Keys.RETURN)
        time.sleep(2)

        # 이미지 URL 가져오기
        thumb = driver.find_element(By.CSS_SELECTOR, "a.fl.thumb")
        url = thumb.get_attribute("href") # 이미지 url 데이터
        print(url)

        

        # 시놉시스 가져오기
        # synopsis = driver.find_element(By.CLASS_NAME, 'desc_info').text # 시놉시스 데이터
        synopsis = driver.find_element(By.CSS_SELECTOR, 'p.desc_info').text
        print(synopsis)


        screen_info = driver.find_element(By.XPATH, '//a[text()="상영현황정보"]')
        screen_info.click()
        time.sleep(2)

        # button1을 순서대로 클릭
        buttons = driver.find_elements(By.NAME, "button1")
        current_theater_dict, coming_theater_dict = {}, {}
        for button in buttons:
            print(f'Button: {button}')
            button.send_keys(Keys.ENTER)
            time.sleep(2)

            past_history_text = driver.find_elements(By.XPATH, "//th[contains(text(), '과거 상영내역')]")
            print(f"past_history_text: {past_history_text}")

            # '과거 상영내역'이 있으면 상영이 끝난 것이라서 현재 상영 및 예정 정보가 없다.
            if len(past_history_text) == 0:
                elements_1 = driver.find_elements(By.CLASS_NAME, "divTd1")
                if len(elements_1) > 0:
                    # 현재 상영 영화관 데이터 가져오기
                    current_theater_dict = get_theater_dict("divTd1")
            
                elements_2 = driver.find_elements(By.CLASS_NAME, "divTd2")
                if len(elements_2) > 0:
                    # 상영 예정 영화관 데이터 가져오기
                    coming_theater_dict = get_theater_dict("divTd2")

        print(f'current: {current_theater_dict}')
        print(f'coming: {coming_theater_dict}')


        # Firestore
        data = {
            "boxOfficeResult": [
                {
                    "movieNm": movieNm,
                    "rank": rank,
                    "nations": nations_data,
                    "genres": genres_data,
                    "rankOldAndNew": rankOldAndNew,
                    "directors": director_data,
                    "actors": actor_data,
                    "imgURL": url,
                    "synopsis": synopsis,
                    "current_theater": current_theater_dict,
                    "coming_theater": coming_theater_dict
                }
            ]
        }

        # 데이터 저장하기
        doc_ref = db.collection("films").document(yesterday)

        if save_count >= 1:
            doc_ref.update({f'{"boxOfficeResult"}': firestore.ArrayUnion(data["boxOfficeResult"])})
            save_count += 1
        else:
            doc_ref.set(data)
            save_count += 1

        print("Data added to Firestore")

        # 30일 전 데이터 삭제하기
        eight_days_ref = db.collection("films").document(delete_date)
        if eight_days_ref.get().exists:
            eight_days_ref.delete()
            print("8일 전 데이터를 삭제했습니다.")
        else:
            print("8일 전 document가 존재하지 않습니다.")
        
        # 페이지 로드 기다리기
        wait = WebDriverWait(driver, 10)

    # WebDriver 종료
    driver.quit()
    # except Exception as e:
    #     # 에러가 발생한 경우 로그에 기록
    #     logging.error(e)

film_crawler()