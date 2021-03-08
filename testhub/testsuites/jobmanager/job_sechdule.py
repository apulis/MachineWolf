""" 
资源调度，job sechdule、nni SLI/SLO

1. 中等规模（1500pod,100node）下jobmanager调度多用户任务的可靠性
2. 批量用户在线的负载情况下任务调度的sechdule过程的响应效率
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


class Jobmanager(TaskSet):
    """ 并发搜索testsuite
    1. 1000次/s的HTTP搜索请求失败率
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

class SiteUserWithUniqueAccount(FastHttpUser):
    global TEST_DATAS  
    sock = None
    wait_time = between(0.5, 5) 
    TEST_DATAS = read_test_datas(conf_file=TEST_CONF)
    tasks = [Jobmanager]


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
    # locust -f ./testhub/testsuites/jobmanager/job_sechdule.py --conf ./testhub/testsuites/jobmanager/host.conf



