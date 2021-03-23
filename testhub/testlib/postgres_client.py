# coding=UTF-8
""" Postgres_client
# INFO:    连接和管理Postgres Server
# VERSION: 0.0.1
# EDITOR:  thomas
# TIMER:   2020-06-10
"""
import logging
import json
import os
import yaml
import pdb
import psycopg2
from psycopg2 import Error


DBCONFIGURATION = os.path.join(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + os.path.sep  ), "host.yaml")

def read_db_conf(conf_file=DBCONFIGURATION):
    stream = {}
    with open(conf_file,'r') as cf:
        stream =cf.read()
    conf = yaml.safe_load(stream)
    return conf


class PostgresClient:
    connection = ""
    cursor = ""
    conf = read_db_conf(conf_file=DBCONFIGURATION)
    def psg_connect(self, conf=conf):
        """ Connect to the PostgreSQL database server """
        try:
            self.connection = psycopg2.connect(user=self.conf["test_env"]["user"],
                                                password=self.conf["test_env"]["user"],
                                                host=self.conf["test_env"]["host"],
                                                port=self.conf["test_env"]["port"],
                                                database=self.conf["test_env"]["defaultDB"])
            self.cursor = self.connection.cursor()
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

    def backup_all_databases(self):
        conn = self.psg_connect(self.conf)
        each_db = backup_database(backupdir=self.conf["backup"]["dir"], 
                                    host=self.conf["test_env"]["host"],
                                    post=self.conf["test_env"]["port"],
                                    dbname="postgres")
if __name__ == '__main__':
    pc = PostgresClient()
    pc.psg_connect()
    pc.close()
