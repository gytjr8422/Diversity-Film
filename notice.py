import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import datetime


cred = credentials.Certificate('./serviceAccountKey.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

# title = "박스오피스 순위 업데이트 시간 안내"
title = "14"
contents = "박스오피스 순위 정보는 1위부터 10위까지 제공되며, 매일 오전 01시 30분에 업데이트 됩니다."

data = {
    "title": title,
    "contents": contents 
}

current_time = datetime.datetime.now().strftime('%Y.%m.%d. %H:%M:%S')
doc_ref = db.collection("Notice").document(current_time)

doc_ref.set(data)

print(current_time)
# print(datetime.datetime.now().strftime('%Y-%m-%d, %H:%M:%S'))