import requests
from datetime import date, timedelta
import re
from api_keys import KOBIS_API_KEY, TMDB_API_KEY

current_theater_dict = []
coming_theater_dict = []

kobis_api_key = KOBIS_API_KEY
kobis_boxoffice_url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?multiMovieYn=Y"
kobis_info_url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?"

tmdb_api_key = TMDB_API_KEY
tmdb_search_url = "https://api.themoviedb.org/3/search/movie?language=ko-KR"
tmdb_info_url = "https://api.themoviedb.org/3/movie" # 마지막에 영화id 넣고, 쿼리 작성

yesterday_date = date.today() - timedelta(days=1)
yesterday = yesterday_date.strftime("%Y%m%d") # 기준일 전날

boxoffice_response = requests.get(kobis_boxoffice_url + f"&key={kobis_api_key}&targetDt={yesterday}")
kobis_boxoffice_result = boxoffice_response.json()

for movie in kobis_boxoffice_result['boxOfficeResult']['dailyBoxOfficeList']:
    # print(movie['movieNm'])
    movieNm = movie['movieNm']
    rank = movie['rank'] # 랭킹 데이터
    rankOldAndNew = movie['rankOldAndNew'] # 새로 진입 여부 데이터

    # 영화 정보 api 활용
    kobis_info_response = requests.get(kobis_info_url + f"key={kobis_api_key}&movieCd={movie['movieCd']}")
    kobis_info_result = kobis_info_response.json()
    

    prdtYear = kobis_info_result['movieInfoResult']['movieInfo']['prdtYear']

    director = ""
    director_data = [] # 감독 데이터
    director_english = ""
    director_english_data = []
    if len(kobis_info_result['movieInfoResult']['movieInfo']['directors']) != 0:
        director = kobis_info_result['movieInfoResult']['movieInfo']['directors'][0]['peopleNm']
        director_english = kobis_info_result['movieInfoResult']['movieInfo']['directors'][0]['peopleNmEn']
        for dir in kobis_info_result['movieInfoResult']['movieInfo']['directors']:
            director_data.append(dir['peopleNm'])
            director_name_english = dir['peopleNmEn'].lower()
            director_name_english = re.sub(r"[^a-z]", "", director_name_english)
            director_english_data.append(director_name_english)

    actor_data = [] # 배우 데이터
    actor_data_english = []
    if len(kobis_info_result['movieInfoResult']['movieInfo']['actors']) != 0:
        count = 0
        for actor in kobis_info_result['movieInfoResult']['movieInfo']['actors']:
            actor_data.append(actor['peopleNm'])
            actor_name_english = actor['peopleNmEn'].lower()
            actor_name_english = re.sub(r"[^a-z]", "", actor_name_english)
            actor_data_english.append(actor_name_english)
            count += 1
            if count >= 5:
                break

    nations_data = []
    if len(kobis_info_result['movieInfoResult']['movieInfo']['nations']) != 0:
        for i in range (len(kobis_info_result['movieInfoResult']['movieInfo']['nations'])):
            nation = kobis_info_result['movieInfoResult']['movieInfo']['nations'][i]['nationNm']
            nations_data.append(nation)

    genres_data = []
    if len(kobis_info_result['movieInfoResult']['movieInfo']['genres']) != 0:
        for i in range (len(kobis_info_result['movieInfoResult']['movieInfo']['genres'])):
            genre = kobis_info_result['movieInfoResult']['movieInfo']['genres'][i]['genreNm']
            genres_data.append(genre)
    
    # print(director_data, director_english_data, actor_data, actor_data_english, nations_data, genres_data)


    tmdb_search_response = requests.get(tmdb_search_url + f"&api_key={tmdb_api_key}&query={movieNm}")
    tmdb_search_result = tmdb_search_response.json()

    for result in tmdb_search_result["results"]:
        is_matched_actor = False
        is_matched_director = False

        movie_id = result["id"]
        # print(result["id"])
        tmdb_info_response = requests.get(tmdb_info_url + f"/{movie_id}?api_key={tmdb_api_key}&append_to_response=credits&language=ko-KR")
        tmdb_info_result = tmdb_info_response.json()
        for cast in tmdb_info_result['credits']['cast']:
            actor_name = cast['name'].lower()
            actor_name = re.sub(r"[^a-z]", "", actor_name)
            if actor_name in actor_data_english:
                synopsis = tmdb_info_result["overview"]
                poster_url = "https://image.tmdb.org/t/p/w300" + tmdb_info_result["poster_path"]
                
                if len(director_data) == 0:
                    for crew in tmdb_info_result['credits']['crew']:
                        director_data.append(crew['name'])
                        break
                is_matched_actor = True
                break

        for crew in tmdb_info_result['credits']['crew']:
            dir_name = crew['name'].lower()
            dir_name = re.sub(r"[^a-z]", "", dir_name)
            if dir_name in director_english_data:
                synopsis = tmdb_info_result["overview"]
                poster_url = "https://image.tmdb.org/t/p/w300" + tmdb_info_result["poster_path"]

                if len(actor_data) == 0:
                    cnt = 0
                    for cast in tmdb_info_result['credits']['cast']:
                        actor_data.append(cast['name'])
                        cnt += 1
                        if cnt >= 5:
                            break
                is_matched_director = True
                break
        
        if is_matched_actor == True or is_matched_director == True:
            print("matched")

    data = {
        "movieNm": movieNm,
        "nations": nations_data,
        "genres": genres_data,
        "directors": director_data,
        "actors": actor_data,
        "imgURL": poster_url,
        "synopsis": synopsis,
        "current_theater": current_theater_dict,
        "coming_theater": coming_theater_dict
    }

    print(data)

