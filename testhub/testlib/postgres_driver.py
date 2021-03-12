# coding=UTF-8
""" Postgres_client
# INFO:    连接和管理Postgres Server
# VERSION: 0.0.1
# EDITOR:  thomas
# TIMER:   2020-06-10
"""

import psycopg2
from psycopg2 import Error


class PostgresClient:
    connection = ""
    cursor = ""
    def psg_connect(self, user="postgres",password="aN2RXC7WXOl27BT5",host="192.168.1.18",port="5432",database="postgres"):
        """ Connect to the PostgreSQL database server """
        try:
            self.connection = psycopg2.connect(user=user, 
                                                password=password, 
                                                host=host, 
                                                port=port, 
                                                database=database)
            self.cursor = self.connection.cursor()
            # Print PostgreSQL details
            print("PostgreSQL server information: ",self.connection.get_dsn_parameters(), "\n")
            self.cursor.execute("SELECT version();")
            record = self.cursor.fetchone()
            print("You are connected to - ", record, "\n")

        except (Exception, Error) as error:
            print("Error while connecting to PostgreSQL", error)
        finally:
            return self.cursor

    def close(self):
        if (self.connection):
            self.cursor.close()
            self.connection.close()
            print("PostgreSQL connection is closed")

if __name__ == '__main__':
    pc = PostgresClient()
    pc.psg_connect()
    pc.close()