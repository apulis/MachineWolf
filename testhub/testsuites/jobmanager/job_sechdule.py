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



""" 接口详情
inferInfo.json
{
         "status":
         {
                   "AIServer":"running/failed",
         },
       "datetime":"year-month-day hh:mm:ss",
}


{2021-03-03 22:54:28} {INFO} {ai_server.py} {/infer} {POST} {{"INFO": "Inference finished"}} {image_name:16117973292.jpeg} {model_name:lightcnn} {type_name:cls1} {model_config:{"model_name": "lightcnn", "type_name": "cls1", "config_path": "config/models/lightcnn/cls1/1/params.config", "infer_scene": "classification"}} {time_used:0.020795822143554688} {model_result:{"class0": ["0", 0.999511719]}}


{2021-01-21 03:12:28} {INFO} {ai_server.py} {/infer} {POST} {{"INFO": "Inference finished"}} {image_name:016b4c52-9e2e-11ea-b131-0242c0a81f1d_AITest_5G_line10_bm_5g_aoi_assm6_20200525101730__NG.jpg} {model_name:ssd_vgg16} {type_name:det1} {model_config:{"model_name": "ssd_vgg16", "type_name": "det1", "config_path": "config/models/ssd_vgg16/det1/1/params.config", "infer_scene": "detection", "default_device_id": 0}} {time_used:0.18546605110168457} {model_result:{"det0": ["attach2", "[1474, 3398, 2828, 3535]", 1], "det1": ["attach3", "[684, 1357, 2743, 3206]", 1], "det2": ["attach3", "[3500, 4312, 2971, 3423]", 1], "det3": ["attach4", "[1715, 3259, 1311, 2579]", 1], "det4": ["attach5", "[1368, 2444, 1107, 2864]", 0.999511719], "det5": ["attach6", "[2356, 3462, 1111, 2862]", 0.994628906]}}

 """