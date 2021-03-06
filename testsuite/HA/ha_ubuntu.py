
""" 高可用性测试单（场景）

各客户环境下的高可用性

1. 基础电路、网络路由、机器故障等因素导致的节点故障
2. 系统OS,k8s，数据库和存储组件服务异常导致的业务故障
3. 用户数据或任务处理（如训练脚本有死循环、内存泄漏）出现僵死导致的平台故障
4. 存储空间（驱动、组件日志和缓存）、MEM，CPU使用量超过负载导致的平台故障
5. 多个用户多次更新驱动日志配置或清理公共存储目录导致的平台故障
6. 批量的反复使用相同字符串注册、注销用户导致的平台数据被破坏的故障

# ScriptType：performance test 
# UpdateDate: 2021.03-4
# Matainer: thomas
# Env: Win10 64bit, python3.8
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


class HA(TaskSet):
    """ testsuite
    2. 系统OS,k8s，数据库和存储组件服务异常导致的业务故障
    3. 用户数据或任务处理（如训练脚本有死循环、内存泄漏）出现僵死导致的平台故障
    4. 存储空间（驱动、组件日志和缓存）、MEM，CPU使用量超过负载导致的平台故障
    """
    global TEST_DATAS
    @events.test_start.add_listener
    def on_test_start_get_homepage(self, environment, **kwargs):
        print("A new test is starting, user will login")
        # pdb.set_trace()
        # print("+++++++++++++++++++++++", TEST_DATAS["RESTFULAPI"]["homepage"])
        self.client.get(TEST_DATAS["RESTFULAPI"]["Homepage"])

    @events.test_stop.add_listener
    def on_test_stop_logout(self, environment, **kwargs):
        print("A  test is ending, user will logout !")
        responses = self.client.get(url=TEST_DATAS["RESTFULAPI"]["Logout"]["path"])
        if responses.status_code == 200:
            rst = json.loads(responses.text, strict=False)
            if rst['success'] == '200':
                responses.success() 

    @task
    def test_sys_idle(self):
        """ testcase 
        
         """
        pass


    @task
    def test_service_idle(self):
        """ testcase 
        1000次/s的HTTP推理请求失败率
         """
        pass



class WebsiteUser(FastHttpUser):
    global TEST_DATAS 
    task_set = HA
    wait_time = between(0.5, 5)  # 等待时间,单位为s，任务执行间隔时间
    TEST_DATAS = read_test_datas(conf_file=TEST_CONF)
    # pdb.set_trace()
    # print("+++++++++++++++++++++++", TEST_DATAS["RESTFULAPI"]["homepage"])


if __name__ == "__main__":
    cmd = 'locust -f locust_demo.py'
    os.system(cmd)
    # locust -f ./testsuite/songshanhu/inference_perf.py --conf ./testsuite/songshanhu/songshanhu.conf



