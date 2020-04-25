Let's create a database for an Instragram-like, family oriented
album application: Instafam.


##### Create Keyspace

Database is created on the fly if one does not exist!

```python
from cassandra.cluster import Cluster
clstr = Cluster()
session = clstr.connect()

session.execute(
    """
    CREATE KEYSPACE profiles
    WTH REPLICATION={'class': 'SimpleStrategy', 'replication_factor' : 3};
    """
)
```


```python
cn = db["profiles"]
```

##### Insert a record into the collection

```python
data = {
    "FirstName": "Eileen",
    "LastName": "Jetson",
    "FamilyStatus": ["mom", "daughter"],
    "FavoriteColor": "Deep Blue",
}

result = cn.insert_one(data)

result

result.inserted_id
```

##### Insert a bunch of data

```python
data = [
    {"FirstName": "Paul", "LastName": "Jetson", "FamilyStatus": ["brother", "son"]},
    {"FirstName": "Chris", "LastName": "Jetson", "FavoriteColor": "Hot Pink"},
]

result = cn.insert_many(data)

result
```


##### Find a record

```python
cn.find_one()
```


##### Find several records


```python
cn.find()
```

```python
list(cn.find())
```

##### Find a record by an attribute value


```python
list(cn.find({"FirstName": "Eileen"}))
```

##### Find a record by an attribute value


```python
list(cn.find({"FamilyStatus": "brother"}))
```

##### Find several records with a single field removed


```python
list(cn.find({}, {"FavoriteColor": 0}))
```

##### Sorting returned results

```python
list(cn.find().sort("FirstName"))
list(cn.find().sort("FirstName", 1))
list(cn.find().sort("FirstName", -1))
```

##### Limit returned results

```python
list(cn.find().sort("FirstName").limit(2))
```

##### Update a record

```python
q = {"FirstName": "Eileen"}
v = {"$push": {"FamilyStatus": "sister"}}
cn.update_one(q, v)
```

##### Update several records

```python
q = {"LastName": "Jetson"}
v = {"$set": {"LastName": "Hsieh"}}
cn.update_many(q, v)
```

##### Delete a record

```python
q = {"FirstName": "Paul"}
cn.delete_one(q)
cn.find().count()
```

##### Delete several records

```python
q = {"LastName": "Hsieh"}
cn.delete_many(q)
```

##### Drop a collection

```python
cn.drop()
```
