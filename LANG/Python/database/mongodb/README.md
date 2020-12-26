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

from pymongo imprt MongoClient

### (ローカルの)MongoDBに接続する
client = MongoCleient('mongodb://localhost:27017/')

### MongoDBに登録するデータの例
stack1 = {
    'name': 'thetaru',
    'gender': 'male',
    'age': 23,
    'data': datetime.datetime.utcnow()
}
```
