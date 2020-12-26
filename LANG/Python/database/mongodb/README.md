# mongodb
## ■ Install
```
# pip3 install pymongo
```
## ■ mongodbの起動
```
### mongodbのデータディレクトリを作成する
# mkdir -p ./data/db
```
```
### mondodbを起動
# mongod --dbpath ./data/db
```
## ■ mongodbの使い方
```
# vi mongo_test.py
```
```py
import datetime

from pymongo import MongoClient

### (ローカルの)MongoDBに接続する
client = MongoCleient('mongodb://localhost:27017/')

### DBの作成
db = client['test_datebase']

### MongoDBに登録するデータの例
stack1 = {
    'name': 'thetaru',
    'gender': 'male',
    'age': 23,
    'data': datetime.datetime.utcnow()
}

stack2 = {
    'name': 'thetakun',
    'gender': 'female',
    'age': 25,
    'data': datetime.datetime.utcnow()
}

### stack1をDBに挿入する
db_stacks = db.stacks
db_stacks.insert_one(stack1).inserted_id
print(db_stacks.find_one({'_id': stack_id}))
```
