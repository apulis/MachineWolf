# coding=UTF-8
""" create_datas
# INFO:    在被测试平台创建基础数据
# VERSION: 2.0.0
# EDITOR:  thomas
# TIMER:   2021-03-11
"""

from testhub.testlib import fake_users
import locust.stats
locust.stats.CONSOLE_STATS_INTERVAL_SEC = 3

from locust import TaskSet, task, between, User
from locust.contrib.fasthttp import FastHttpUser
from locust import events
import logging
import json
import os
import yaml
import pdb

 
TEST_CONF = os.path.join(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + os.path.sep  ), "test_datas.yaml")

def read_test_datas(conf_file=TEST_CONF):
    stream = {}
    with open(conf_file,'r') as cf:
        stream =cf.read()
    conf = yaml.safe_load(stream)
    return conf

# @events.quitting.add_listener
# def _(environment, **kw):
#     if environment.stats.total.fail_ratio > 0.001:
#         logging.error("Test failed due to failure ratio > 1%")
#         environment.process_exit_code = 1
#     elif environment.stats.total.avg_response_time > 200:
#         logging.error("Test failed due to average response time ratio > 200 ms")
#         environment.process_exit_code = 2
#     elif environment.stats.total.get_response_time_percentile(0.99) > 800:
#         logging.error("Test failed due to 95th percentile response time > 800 ms")
#         environment.process_exit_code = 3
#     else:
#         environment.process_exit_code = 0

class BasicalDatas(FastHttpUser):
    """ 
    创建基础测试数据

        1. 注册1000个用户、10个用户组、10个其他role
        2. 上传10个模型和数据集
        3. 创建10条全流程示例
        4. 读取初始系统存储空间和内存、CPU使用状态
        5. 单机多卡，多机多卡，场景project等模板
    """

    sock = None
    wait_time = between(0.5, 5) 
    testdatas = read_test_datas(conf_file=TEST_CONF)

    print("======================= {} =======================".format(testdatas))

    @events.test_start.add_listener
    def on_test_start(self, environment, **kwargs):
        print("======================= A new test is starting, user will login! =======================")
        pdb.set_trace()
        FastHttpUser.client.get(self.testdatas["RESTFULAPI"]["homepage"])
        print("======================= {} =======================".format(TEST_DATAS))
        with FastHttpUser.client.post(path=self.testdatas["RESTFULAPI"]["login"]["path"], 
                                headers=self.testdatas["RESTFULAPI"]["header"], 
                                data=json.dumps(self.testdatas["ACCOUNT"]["admin"])) as response:
            if response.status_code == 200:
                token = response.json["token"]
                self.testdatas["token"] = token
                response.success()

    @events.test_stop.add_listener
    def on_test_stop(self, environment, **kwargs):
        print("======================= A  test is ending, user will logout! =======================")
        responses = FastHttpUser.client.get(url=self.testdatas["RESTFULAPI"]["logout"]["path"])
        if responses.status_code == 200:
            rst = json.loads(responses.text, strict=False)
            if rst['success'] == '200':
                responses.success() 

    @task(1)
    def test_create_user(self):
        user_datas = self.testdatas["RESTFULAPI"]["create_user"]["datas"]
        user_datas["userMessage"][0] = fake_users.new_user()
        user_datas["userRole"] = fake_users.new_role()
        with self.client.get(path=self.testdatas["RESTFULAPI"]["create_user"]["path"], 
                              headers=self.testdatas["RESTFULAPI"]["header"], 
                              params=json.dumps(self.testdatas["RESTFULAPI"]["create_user"]["datas"])) as response:
            if response.status_code == 200:
                response.success()
            elif response.status_code == 401:
                print("account error")
            else:
                response.raise_for_status()

    @task(1)
    def test_create_group(self):
        group_datas = fake_users.new_group()
        with self.client.get(path=self.testdatas["RESTFULAPI"]["create_group"]["path"], 
                            headers=self.testdatas["RESTFULAPI"]["header"], 
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
        with self.client.get(path=self.testdatas["RESTFULAPI"]["create_role"]["path"], 
                            headers=self.testdatas["RESTFULAPI"]["header"], 
                            params=json.dumps(role_datas)) as response:
            if response.status_code == 200:
                response.success()
            elif response.status_code == 401:
                print("account error")
            else:
                response.raise_for_status()

if __name__ == "__main__":
    cmd = 'locust -f locust_demo.py'
    os.system(cmd)
    # Run in cmd
    # locust -f ./testhub/testsuites/create_datas/create_common_datas.py --conf ./testhub/testsuites/create_datas/host.conf

