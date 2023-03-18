import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use a service account
cred = credentials.Certificate('./serviceAccountKey.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

yesterday = "230308"

data = {
    yesterday: [
        {
            "rank": "1",
            "movieNm": "제목",
            "directors": ["감독1", "감독2"],
            "actors": ["배우1", "배우2"],
            "synopsis": "시놉시스",
            "current_theater": ["현재상영관"],
            "coming_theater": ["상영예정관"]
        },
        {
            "rank": "2",
            "movieNm": "제목",
            "directors": ["감독1", "감독2"],
            "actors": ["배우1", "배우2"],
            "synopsis": "시놉시스",
            "current_theater": ["현재상영관"],
            "coming_theater": ["상영예정관"]
        }
    ]
}

# 데이터 저장
# doc_ref = db.collection("movies").document(yeseterday)
# doc_ref.set(data)

eight_days_doc = db.collection("films").document("20220529")
delete_doc = eight_days_doc.get()
if delete_doc.exists:
    delete_doc.delete()
else:
    print("존재하지 않음")

print("Data added to Firestore")