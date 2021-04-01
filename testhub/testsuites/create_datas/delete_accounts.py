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
DATA_PREFIX = "songshanhu"
def read_test_datas(conf_file=TEST_CONF):
    stream = {}
    with open(conf_file,'r') as cf:
        stream =cf.read()
    conf = yaml.safe_load(stream)
    return conf

class DeleteAccount(TaskSet):
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

    @task(0)
    def test_delete_user(self):
        """ testcase
        1. 删除用户
         """
        user_list = self.client.request(TEST_DATAS["RESTFULAPI"]["get_userlist"]["mothed"], 
                                        url=TEST_DATAS["RESTFULAPI"]["get_userlist"]["path"], 
                                        headers=TEST_DATAS["RESTFULAPI"]["header"], 
                                        cookies=TEST_DATAS["RESTFULAPI"]["cookie"]) 
        user_id = [userid["id"] for userid in user_list["list"] ]
        self.client.request(TEST_DATAS["RESTFULAPI"]["delete_user"]["mothed"], url=TEST_DATAS["RESTFULAPI"]["delete_user"]["path"], 
                            headers=TEST_DATAS["RESTFULAPI"]["header"], 
                            json=user_id, 
                            cookies=TEST_DATAS["RESTFULAPI"]["cookie"]) 

    @task(0)
    def test_delete_group(self):
        """ testcases
        2. 删除用户组
         """
        group_list = self.client.request(TEST_DATAS["RESTFULAPI"]["get_grouplist"]["mothed"], 
                                        url=TEST_DATAS["RESTFULAPI"]["get_grouplist"]["path"], 
                                        headers=TEST_DATAS["RESTFULAPI"]["header"], 
                                        cookies=TEST_DATAS["RESTFULAPI"]["cookie"])
        group_id = [groupid["id"] for groupid in group_list["list"] ]
        self.client.request(TEST_DATAS["RESTFULAPI"]["delete_group"]["mothed"], 
                            url=TEST_DATAS["RESTFULAPI"]["delete_group"]["path"], 
                            headers=TEST_DATAS["RESTFULAPI"]["header"], 
                            json=group_id)
    
    @task(0)
    def test_delete_role(self):
        """ 
        3. 删除role
         """
        role_list = self.client.request(TEST_DATAS["RESTFULAPI"]["get_rolelist"]["mothed"], 
                                        url=TEST_DATAS["RESTFULAPI"]["get_rolelist"]["path"], 
                                        headers=TEST_DATAS["RESTFULAPI"]["header"], 
                                        cookies=TEST_DATAS["RESTFULAPI"]["cookie"])
        role_id = [groupid["id"] for groupid in group_list["list"] ]
        self.client.request(TEST_DATAS["RESTFULAPI"]["delete_role"]["mothed"], 
                            url=TEST_DATAS["RESTFULAPI"]["delete_role"]["path"], 
                            headers=TEST_DATAS["RESTFULAPI"]["header"], 
                            json=role_id)

class BasicalDatas(HttpUser):
    global TEST_DATAS
    sock = None
    wait_time = between(0.5, 2) 
    TEST_DATAS = read_test_datas(conf_file=TEST_CONF)
    host = TEST_DATAS["ENV"]["HOST"]
    tasks = [DeleteAccount]

if __name__ == "__main__":
    # global DATA_PREFIX
    DATA_PREFIX = "songshanhu"
    # Run in cmd
    # locust -f ./testhub/testsuites/create_datas/create_accounts.py --conf ./testhub/testsuites/create_datas/host.conf

