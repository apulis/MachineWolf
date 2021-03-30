# coding=UTF-8
""" create_datas
# INFO:    在被测试平台创建基础数据
# VERSION: 2.0.0
# EDITOR:  thomas
# TIMER:   2021-03-11
"""

from locust import HttpUser, TaskSet, task, between
from locust.contrib.fasthttp import FastHttpUser
from locust import events
from locust.clients import HttpSession
import logging
import json
import os
import yaml
import pdb
import hashlib
from testhub.testlib import fake_users
from testhub.testlib import csv_client

TEST_CONF = os.path.join(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + os.path.sep  ), "datas.yaml")
TEST_DATAS = {}

def read_test_datas(conf_file=TEST_CONF):
    stream = {}
    with open(conf_file,'r') as cf:
        stream =cf.read()
    conf = yaml.safe_load(stream)
    return conf

class CreateUsers(TaskSet):
    """ 
    创建用户数据

    1. 注册新用户
    2. 注册新用户组
    3. 注册新role
    """
    global TEST_DATAS
    def on_start(self):
        print("======================= A new test is starting, user will login {} ! =======================".format(TEST_DATAS["ENV"]["HOST"]))
        self.client.request("get",TEST_DATAS["RESTFULAPI"]["homepage"])
        self.client.header = TEST_DATAS["RESTFULAPI"]["header"]
        data=TEST_DATAS["ACCOUNT"]["web_admin"]
        data["password"] = fake_users.security_passwd(data["password"])
        response = self.client.request("post", url=TEST_DATAS["RESTFULAPI"]["login"]["path"], data=data)
        result = response.json()
        # pdb.set_trace()
        try:
            if result["success"]:
                TEST_DATAS["ACCOUNT"]["token"] = result["token"]
                TEST_DATAS["ACCOUNT"]["currentRole_id"] = result["currentRole"][0]["id"]
                TEST_DATAS["RESTFULAPI"]["header"]["Authorization"] = "Bearer " + TEST_DATAS["ACCOUNT"]["token"]
                TEST_DATAS["RESTFULAPI"]["cookie"] = response.cookies
        except KeyError: 
            response.raise_for_status()

    def on_stop(self):
        print("======================= A  test is ending, user will logout {} ! =======================".format(TEST_DATAS["ENV"]["HOST"]))
        response = self.client.request("get", url=TEST_DATAS["RESTFULAPI"]["logout"]["path"])
        # self.admin_client = HttpSession(base_url=self.client.base_url)
        # self.admin_client.delete( TEST_DATAS["RESTFULAPI"]["login"]["path"]) # , auth=(self.adminUserName, self.adminUserName)


    @task(10)
    def test_create_user(self):
        """ testcase
        1. 注册新用户
         """
        user_filename = "fake_user.csv"
        user_datas = fake_users.new_user()
        print("======================= test_create_user DATAS: {} ".format(user_datas))
        print("======================= test_create_user HEADER: {}".format(self.client.header))
        print("======================= test_create_user COOKIES: {} ".format(TEST_DATAS["RESTFULAPI"]["cookie"]))
        self.client.request("post", url=TEST_DATAS["RESTFULAPI"]["create_user"]["path"], 
                                                headers=TEST_DATAS["RESTFULAPI"]["header"], 
                                                json=user_datas, 
                                                cookies=TEST_DATAS["RESTFULAPI"]["cookie"]) 
        csv_client.csv_json_writer(csv_path=os.path.join(TEST_DATAS["ENV"]["DATA_PATH"], user_filename), mode="a", datas=user_datas["userMessage"][0])

    @task(2)
    def test_create_group(self):
        """ testcases
        2. 注册新用户组
         """
        group_filename = "fake_group.csv"
        group_datas = fake_users.new_group()
        self.client.request("post",url=TEST_DATAS["RESTFULAPI"]["create_group"]["path"], 
                            headers=TEST_DATAS["RESTFULAPI"]["header"], 
                            json=group_datas)
        csv_client.csv_json_writer(csv_path=os.path.join(TEST_DATAS["ENV"]["DATA_PATH"],group_filename), mode="a", datas=group_datas)
    
    @task(2)
    def test_create_role(self):
        """ 
        3. 注册新role
         """
        role_filename = "fake_role.csv"
        role_datas = fake_users.new_role()
        self.client.request("post",url=TEST_DATAS["RESTFULAPI"]["create_role"]["path"], 
                            headers=TEST_DATAS["RESTFULAPI"]["header"], 
                            json=role_datas)
        csv_client.csv_json_writer(csv_path=os.path.join(TEST_DATAS["ENV"]["DATA_PATH"],role_filename), mode="a", datas=role_datas)

class BasicalDatas(HttpUser):
    global TEST_DATAS
    sock = None
    wait_time = between(0.5, 2) 
    TEST_DATAS = read_test_datas(conf_file=TEST_CONF)
    host = TEST_DATAS["ENV"]["HOST"]
    tasks = [CreateUsers]

if __name__ == "__main__":
    pass
    # Run in cmd
    # locust -f ./testhub/testsuites/create_datas/create_accounts.py --conf ./testhub/testsuites/create_datas/host.conf

