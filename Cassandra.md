Let's create a database for an Instragram-like, family oriented
album application: Instafam.


##### Create Keyspace

```python
from cassandra.cluster import Cluster
clstr = Cluster()
session = clstr.connect()

session.execute(
    "CREATE KEYSPACE instafam "
    "WITH REPLICATION={'class': 'SimpleStrategy', 'replication_factor' : 3};"
)
```

##### Create Table

```python
session = clstr.connect('instafam')
session.execute("""
CREATE TABLE profiles (
    id varchar,
    firstName text,
    lastName text,
    favoriteColor varchar,
    familyStatus list<text>,
    primary key (id)
);
""")
```

##### Insert a record into the collection

```python
import uuid
session.execute(
    """
    INSERT INTO profiles (id, firstName, lastName, favoriteColor, familyStatus)
    VALUES (%s, %s, %s, %s, %s)
    """,
    (str(uuid.uuid1()), "Eileen", "Jetson", "Deep Blue", ['mom'])
)
```

##### Insert a bunch of data

```python
from cassandra.query import SimpleStatement, BatchStatement
from cassandra import ConsistencyLevel

batch = BatchStatement(consistency_level=ConsistencyLevel.ONE)
batch.add(
    SimpleStatement("INSERT INTO profiles (id, firstName, lastName, familyStatus) VALUES (%s, %s, %s, %s)"),
    (str(uuid.uuid1()), "Paul", "Jetson", ['brother', 'son'])
)
batch.add(
    SimpleStatement("INSERT INTO profiles (id, firstName, lastName, favoriteColor) VALUES (%s, %s, %s, %s)"),
    (str(uuid.uuid1()), "Chris", "Jetson", "Hot Pink")
)
session.execute(batch)
```

##### Find several records


```python
list(session.execute("SELECT * FROM profiles"))
```

##### Find a record by an attribute value


```python
list(session.execute("SELECT * FROM profiles WHERE firstName = 'Eileen'")
```
This throws an error because we are not use the appropriate index/partition:

    cassandra.InvalidRequest: Error from server: code=2200 [Invalid query] me
    ssage="Cannot execute this query as it might involve data filtering and t
    hus may have unpredictable performance. If you want to execute this query
     despite the performance unpredictability, use ALLOW FILTERING"

```python
list(session.execute("SELECT * FROM profiles WHERE firstName = 'Eileen' ALLOW FILTERING")
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
user_id = 
query = SimpleStatement(
    "UPDATE profiles SET familyStatus = ['mom', 'sister'] WHERE id = %s";
    is_idempotent=True
)
session.execute(query, (user_id,))
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
