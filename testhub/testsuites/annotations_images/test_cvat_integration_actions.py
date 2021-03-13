# coding=UTF-8
""" FAKE_USER
# 数据集标注基础测试集
# VERSION: 0.0.1
# EDITOR:  thomas
# TIMER:   2021-03-11
"""

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
TEST_DATAS = {}

def read_test_datas(conf_file=TEST_CONF):
    stream = {}
    with open(conf_file,'r') as cf:
        stream =cf.read()
    conf = yaml.safe_load(stream)
    return conf

@events.quitting.add_listener
def _(environment, **kw):
    if environment.stats.total.fail_ratio > 0.001:
        logging.error("Test failed due to failure ratio > 1%")
        environment.process_exit_code = 1
    elif environment.stats.total.avg_response_time > 200:
        logging.error("Test failed due to average response time ratio > 200 ms")
        environment.process_exit_code = 2
    elif environment.stats.total.get_response_time_percentile(0.99) > 800:
        logging.error("Test failed due to 95th percentile response time > 800 ms")
        environment.process_exit_code = 3
    else:
        environment.process_exit_code = 0


class Annotations(TaskSet):
    """ 
    数据标注测试集

        1. 单用户并发10个task的基础操作请求
        2. 单用户持续标注1000以上图标的响应和时延
        3. 100用户并发的基础操作
        4. 20用户并发的upload/dump 500M文件的操作（数据集导入，导出）。
        5. 存储空间的耗用和回收
        6. 内存空间的耗用和系统整体的响应
        7. 内网环境、Internet下响应时延
    """
    global TEST_DATAS
    testdatas = {}

    @task(1)
    def test_new_user_login(self):
        self.testdatas = TEST_DATAS
        with self.client.post(path=self.testdatas["RESTFULAPI"]["Login"]["path"], headers=self.testdatas["RESTFULAPI"]["Header"], data=json.dumps(self.testdatas["ACCOUNT"]["admin"])) as response:
            if response.status_code == 200:
                print("====================",response.json,"====================")
                token = response.json["token"]
                self.testdatas["token"] = token
                response.success()
            elif response.status_code == 401:
                print("account error")
            else:
                response.raise_for_status()

class BaseAcrions(FastHttpUser):
    global TEST_DATAS  
    sock = None
    wait_time = between(0.5, 5) 
    TEST_DATAS = read_test_datas(conf_file=TEST_CONF)
    tasks = [Annotations]


    # def __init__(self):
    #     super(SiteUserWithUniqueAccount, self).__init__()
 
 
    def setup(self):
        print('locust setup')
 
    def teardown(self):
        print('locust teardown')

 

if __name__ == "__main__":
    cmd = 'locust -f locust_demo.py'
    os.system(cmd)
    # Run in cmd
    # locust -f ./testhub/testsuites/annotations_images/test_cvat_integration_actions.py.py --conf ./testhub/testsuites/annotations_images/host.conf



