import sqlite3

DB = 'sample.db'
TABLE_DATA = [
    (2021325, "Sato"     ),
    (2021411, "Takahashi"),
    (2019124, "Suzuki"   )
]

db = sqlite3.connect(DB)
com = db.cursor()

com.execute("DROP TABLE IF EXISTS table1")
com.execute("CREATE TABLE table1 (NUMBER integer, NAME varchar(50))")

for r in TABLE_DATA:
    com.execute("INSERT INTO table1 VALUES (?, ?)", r)

db.commit()

for r in com.execute("SELECT * FROM table1"):
    print(r)

com.close()


# $ python sqlite3-sample.py
# (2021325, u'Sato')
# (2021411, u'Takahashi')
# (2019124, u'Suzuki')
#
# $ sqlite3 sample.db
# sqlite> .headers ON
# sqlite> .mode column
# sqlite> .tables
# table1
# sqlite> select * from table1;
# NUMBER      NAME
# ----------  ----------
# 2021325     Sato
# 2021411     Takahashi
# 2019124     Suzuki
# sqlite> .quit
