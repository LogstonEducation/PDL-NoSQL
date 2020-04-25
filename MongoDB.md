Let's create a database for an Instragram-like, family oriented
album application: Instafam.


- Create Database

  Database is created on the fly if one does not exist!

```python
import pymongo
client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["instafam"]
```

- Create a Collection

```python
cn = db["profiles"]
```

- Insert a record into the collection


    data = {
        "FirstName": "Eileen",
        "LastName": "Jetson",
        "FamilyStatus": ["mom", "daughter"],
        "FavoriteColor": "Deep Blue",
    }

    result = cn.insert_one(data)

    result

    result.inserted_id


- Insert a bunch of data


    data = [
        {"FirstName": "Paul", "LastName": "Jetson", "FamilyStatus": ["brother", "son"]},
        {"FirstName": "Chris", "LastName": "Jetson", "FavoriteColor": "Hot Pink"},
    ]

    result = cn.insert_many(data)

    result


- Find a record


    cn.find_one()


- Find several records


    cn.find()

- Find a record by an attribute value


    cn.find({"FirstName": "Eileen"})

- Find a record by an attribute value


    cn.find({"FamilyStatus": ["brother"]})

- Find several records with a single field removed


    cn.find({}, {"FavoriteColor": 0})

- Sorting returned results


    cn.find().sort("FirstName")
    cn.find().sort("FirstName", 1)
    cn.find().sort("FirstName", -1)

- Limit returned results

    cn.find().sort("FirstName").limit(2)

- Update a record

    q = {"FirstName": "Eileen"}
    v = {"$set": {"FamilyStatus": ["mom", "daughter", "sister"]}}
    cn.update_one(q, v)

- Update several records

    q = {"LastName": "Jetson"}
    v = {"$set": {"LastName": "Hsieh"}}
    cn.update_many(q, v)

- Delete a record

    q = {"FirstName": "Paul"}
    cn.delete_one(q)

- Delete several records

    q = {"LastName": "Hsieh"}
    cn.delete_many(q)

- Drop a collection

    cn.drop()
