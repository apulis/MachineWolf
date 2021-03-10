# coding=UTF-8
""" FAKE_USER
# 连接和管理Postgres Server
# VERSION: 0.0.1
# EDITOR:  haiyuan
# TIMER:   2020-06-10

"""
""" 
use `DLWSCluster-a8534d24-4316-43ed-bd2d-62c3d54cb3a8`;
SELECT * FROM `DLWSCluster-a8534d24-4316-43ed-bd2d-62c3d54cb3a8`.account;
INSERT INTO account  values ("30004", "yunxia@apulis.com", "Microsoft", "yunxia.chu", "yunxia.chu", "tryme2020", "","", 1, 1,"2020-06-11 08:57:18");
 """

"""configuration example database.ini
[postgresql]
host=localhost
database=suppliers
user=postgres
password=SecurePas$1
"""

#!/usr/bin/python
import psycopg2
from config import config

def psg_connect():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config()

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)
		
        # create a cursor
        cur = conn.cursor()
        
	# execute a statement
        print('PostgreSQL database version:')
        cur.execute('SELECT version()')

        # display the PostgreSQL database server version
        db_version = cur.fetchone()
        print(db_version)
       
	# close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')


if __name__ == '__main__':
    psg_connect()