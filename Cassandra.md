Let's create a database for an Instragram-like, family oriented
album application: Instafam.


##### Create Keyspace

```python
from cassandra.cluster import Cluster
clstr = Cluster()
session = clstr.connect()

# Use to reset the cluster in case a mistake is made during 
# the tutorial.
session.execute("DROP KEYSPACE IF EXISTS instafam")

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
list(session.execute("SELECT * FROM profiles WHERE firstName = 'Eileen'"))
```
This throws an error because we are not use the appropriate index/partition:

    cassandra.InvalidRequest: Error from server: code=2200 [Invalid query] me
    ssage="Cannot execute this query as it might involve data filtering and 
    thus may have unpredictable performance. If you want to execute this query
    despite the performance unpredictability, use ALLOW FILTERING"

```python
list(session.execute("SELECT * FROM profiles WHERE firstName = 'Eileen' ALLOW FILTERING"))
```

##### Find single record and single column


```python
list(session.execute("SELECT id FROM profiles WHERE firstName = 'Eileen' ALLOW FILTERING"))
```

##### Sorting returned results

```python
list(session.execute("""
    SELECT firstName FROM profiles
    ORDER BY firstName;
"""))
```

Fails because Cassandra knows this could be VERY expensive. Should have partitioned
on firstName if we wanted to select/order/etc based on that.
Could have also create the table with built in ordering.

Eg. 
```python
   PRIMARY KEY (id, firstName)
) WITH CLUSTERING ORDER BY (firstName ASC);
```

"id" would be the partitioning key and would indicate which node the data
will be saved on. "firstName" would be the clustering key and it would help with
sorting. Together the would make a compound primary key.

A best long term solution to fetching this data in a sorted way would be to
copy the table into a new table with correct key definitions.

What would be a good partitioning key for an based on getting family data all at once?[^1]

##### Limit returned results

```python
list(session.execute("SELECT id FROM profiles LIMIT 1"))
```

##### Update a record

```python
rows = list(session.execute("SELECT id FROM profiles WHERE firstName = 'Eileen' ALLOW FILTERING"))
row = rows[0]
session.execute("UPDATE profiles SET familyStatus = ['mom', 'sister'] WHERE id = %s", (row.id,))
# Check the change
list(session.execute("SELECT * FROM profiles WHERE id = %s", (row.id,)))
```

##### Delete a column in a record

```python
session.execute("DELETE familyStatus FROM profiles WHERE id = %s", (row.id,))
list(session.execute("SELECT * FROM profiles WHERE id = %s", (row.id,)))
```

##### Delete a record

```python
session.execute("DELETE FROM profiles WHERE id = %s", (row.id,))
list(session.execute("SELECT * FROM profiles WHERE id = %s", (row.id,)))
```

##### Drop a table

```python
session.execute("DROP TABLE profiles")
```

[^1]: lastName
