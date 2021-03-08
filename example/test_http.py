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

TEST_CONF = os.path.join(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + os.path.sep  ), "datas.yaml")
TEST_DATAS = {}

def read_test_datas(conf_file=TEST_CONF):
    # 读取配置文件中的datasets, modelsets
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


class SearchQ(TaskSet):
    """ 并发搜索testsuite
    1. 1000次/s的HTTP搜索请求失败率
    """
    global TEST_DATAS

    @task(1)
    def test_search_news(self):
        """ testcase 
        HTTP请求baidu news
         """
        with self.client.get(TEST_DATAS["RESTFULAPI"]["news"]["path"], catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.raise_for_status()

class SiteUser(FastHttpUser):
    global TEST_DATAS 
    tasks = [SearchQ]
    wait_time = between(0.5, 5)  # 等待时间,单位为s，任务执行间隔时间
    TEST_DATAS = read_test_datas(conf_file=TEST_CONF)
    def setup(self):
        print('locust setup')
 
    def teardown(self):
        print('locust teardown')

 

if __name__ == "__main__":
    cmd = 'locust -f locust_demo.py'
    os.system(cmd)
    # Run in cmd
    # locust -f ./example/test_http.py --conf ./example/host.conf



