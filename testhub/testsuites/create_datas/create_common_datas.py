# coding=UTF-8
""" create_datas
# INFO:    在被测试平台创建基础数据
# VERSION: 2.0.0
# EDITOR:  thomas
# TIMER:   2021-03-11
"""

from testhub.testlib import fake_users
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

TEST_CONF = os.path.join(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + os.path.sep  ), "test_datas.yaml")
TEST_DATAS = {}

def read_test_datas(conf_file=TEST_CONF):
    stream = {}
    with open(conf_file,'r') as cf:
        stream =cf.read()
    conf = yaml.safe_load(stream)
    return conf

class CreateDatas(TaskSet):
    global TEST_DATAS
    def on_start(self):
        print("======================= A new test is starting, user will login {} ! =======================".format(TEST_DATAS["ENV"]["HOST"]))
        self.client.get(TEST_DATAS["RESTFULAPI"]["homepage"])
        self.client.header = TEST_DATAS["RESTFULAPI"]["header"]
        data=TEST_DATAS["ACCOUNT"]["testuser"]
        data["password"] = fake_users.security_passwd(data["password"])
        response = self.client.post(url=TEST_DATAS["RESTFULAPI"]["login"]["path"], data=data)
        result = response.json()
        # pdb.set_trace()
        try:
            if result["success"]:
                TEST_DATAS["ACCOUNT"]["token"] = result["token"]
                TEST_DATAS["ACCOUNT"]["currentRole_id"] = result["currentRole"][0]["id"]
                TEST_DATAS["RESTFULAPI"]["header"]["Authorization"] = {"Authorization":"Bearer " + TEST_DATAS["ACCOUNT"]["token"]}
                TEST_DATAS["RESTFULAPI"]["header"]["cookie"] = {"cookie":"language=en-US;token={}".format(result["token"])}
                # TEST_DATAS["RESTFULAPI"]["Authorization"] = "Bearer " + result["token"]
                # TEST_DATAS["RESTFULAPI"]["cookie"] = "language=en-US;token={token}".format(result["token"])
                print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ header {} ".format(TEST_DATAS["RESTFULAPI"]["header"]))
        except KeyError: 
            response.raise_for_status()

    def on_stop(self):
        print("======================= A  test is ending, user will logout! ")
        response = self.client.get(TEST_DATAS["RESTFULAPI"]["logout"]["path"])
        # self.admin_client = HttpSession(base_url=self.client.base_url)
        # self.admin_client.delete( TEST_DATAS["RESTFULAPI"]["login"]["path"]) # , auth=(self.adminUserName, self.adminUserName)


    @task(1)
    def test_create_user(self):
        # global TEST_DATAS
        user_datas = TEST_DATAS["RESTFULAPI"]["create_user"]["datas"]
        user_datas["userMessage"][0] = fake_users.new_user()
        user_datas["userRole"] = fake_users.new_role()
        self.client.header = TEST_DATAS["RESTFULAPI"]["header"]
        # self.client.cookie = TEST_DATAS["RESTFULAPI"]["cookie"]
        print("======================= test_create_user {} ++++++ {}".format(user_datas,self.client.header))
        # response = self.client.post(TEST_DATAS["RESTFULAPI"]["create_user"]["path"], data=user_datas, headers=TEST_DATAS["RESTFULAPI"]["header"])
        response = self.client.post(TEST_DATAS["RESTFULAPI"]["create_user"]["path"], data=user_datas)

class BasicalDatas(HttpUser):
    """ 
    创建基础测试数据

        1. 注册1000个用户、10个用户组、10个其他role
        2. 上传10个模型和数据集
        3. 创建10条全流程示例
        4. 读取初始系统存储空间和内存、CPU使用状态
        5. 单机多卡，多机多卡，场景project等模板
    """
    global TEST_DATAS
    sock = None
    wait_time = between(0.5, 2) 
    TEST_DATAS = read_test_datas(conf_file=TEST_CONF)
    host = TEST_DATAS["ENV"]["HOST"]
    tasks = [CreateDatas]

        # result = response.json()
        # if result["success"]:
        #     pass
        # elif response.status_code == 401:
        #     print("account error")
        # else:
        #     response.raise_for_status()
"""
    @task(1)
    def test_create_group(self):
        group_datas = fake_users.new_group()
        with self.client.post(self.TEST_DATAS["RESTFULAPI"]["create_group"]["path"], 
                            headers=self.TEST_DATAS["RESTFULAPI"]["header"], 
                            params=json.dumps(group_datas)) as response:
            if response.status_code == 200:
                response.success()
            elif response.status_code == 401:
                print("account error")
            else:
                response.raise_for_status()

    @task(1)
    def test_create_role(self):
        role_datas = fake_users.new_role()
        with self.client.post(self.TEST_DATAS["RESTFULAPI"]["create_role"]["path"], 
                            headers=self.TEST_DATAS["RESTFULAPI"]["header"], 
                            params=json.dumps(role_datas)) as response:
            if response.status_code == 200:
                response.success()
            elif response.status_code == 401:
                print("account error")
            else:
                response.raise_for_status()
"""
if __name__ == "__main__":
    pass
    # Run in cmd
    # locust -f ./testhub/testsuites/create_datas/create_common_datas.py --conf ./testhub/testsuites/create_datas/host.conf

