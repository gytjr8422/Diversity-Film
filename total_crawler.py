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


# Use a service account
cred = credentials.Certificate('./serviceAccountKey.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

options = webdriver.ChromeOptions()
options.add_argument('headless') # 화면 출력 안함

# WebDriver로 크롬 브라우저 열기
# driver = webdriver.Chrome(options=options)
driver = webdriver.Chrome()

driver.get('https://kobis.or.kr/kobis/business/mast/mvie/findDiverMovList.do')


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

api_key = KOBIS_API_KEY
film_info_url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?"

is_page_exists = True

while is_page_exists:
    list_page = driver.find_element(By.CSS_SELECTOR, "ul.list_page")
    # 페이지 버튼 찾아서 클릭
    list_page_elements = list_page.find_elements(By.TAG_NAME, "li")
    for i in range (len(list_page_elements)):
        page = driver.find_element(By.CSS_SELECTOR, "ul.list_page")
        elements = page.find_elements(By.TAG_NAME, "li")
        button = elements[i].find_element(By.TAG_NAME, "a")
        button.send_keys(Keys.RETURN)
        # button.click()

        # 영화 하나씩 클릭
        li_elements = driver.find_elements(By.CSS_SELECTOR, "li.item")
        for li_element in li_elements:
            li_element.find_element(By.TAG_NAME, "a").click()
            time.sleep(2)

            ovf_cont = driver.find_element(By.CLASS_NAME, "ovf.cont")
            dds = ovf_cont.find_elements(By.TAG_NAME, "dd")
            movieCd = dds[0].text
            print(movieCd)
            doc_refer = db.collection("AllFilms").document(movieCd)
            docu = doc_refer.get()
            if docu.exists:
                driver.find_element(By.CSS_SELECTOR, "a.close").click()
                continue

            tit = li_element.find_element(By.CLASS_NAME, "tit.ellip.multi")
            movieNm = tit.find_element(By.TAG_NAME, 'a').text
            print(movieNm)

            # 포스터 이미지 URL 가져오기
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

            try:
                driver.find_element(By.NAME, "button1")
                if driver.find_element(By.NAME, "button1"):
                    # button1을 순서대로 클릭
                    buttons = driver.find_elements(By.NAME, "button1")
                    current_theater_dict, coming_theater_dict = {}, {}
                    for button in buttons:
                        # print(f'Button: {button}')
                        button.send_keys(Keys.ENTER)
                        time.sleep(2)

                        if driver.find_elements(By.XPATH, "//th[contains(text(), '과거 상영내역')]"):
                            break
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
            except:
                print("Element with ID 'button1' not found.")
            
            
            # 영화 정보 api 활용
            response = requests.get(film_info_url + f"key={api_key}&movieCd={movieCd}")
            film_info_result = response.json()
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

            data = {
                    "movieNm": movieNm,
                    "nations": nations_data,
                    "genres": genres_data,
                    "directors": director_data,
                    "actors": actor_data,
                    "imgURL": url,
                    "synopsis": synopsis,
                    "current_theater": current_theater_dict,
                    "coming_theater": coming_theater_dict
                    }

            print(data)

            # 데이터 저장하기
            doc_ref = db.collection("AllFilms").document(movieCd)
            doc = doc_ref.get()
            # if doc.exists:
                # doc_ref.update({f'{"allFilms"}': firestore.ArrayUnion(data["allFilms"])})
                # doc_ref.update(firestore.ArrayUnion(data))
            # else:
                # doc_ref.set(data)
            
            doc_ref.set(data)
            
            driver.find_element(By.CSS_SELECTOR, "a.close").click() # 영화 상세정보 창 닫기

    # 다음 10개 페이지 보기
    if driver.find_element(By.CLASS_NAME, "btn.next"):
        driver.find_element(By.CLASS_NAME, "btn.next").click()
        time.sleep(2)
    else:
        is_page_exists = False


driver.quit()