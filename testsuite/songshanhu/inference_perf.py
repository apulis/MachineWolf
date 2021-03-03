
""" 测试单（场景）

松山湖AI制造业推理平台性能测试

    1. 批量原始数据集的并发操作（上传，增删改查）
    2. 多用户标注数据集的并发操作
    3. 1000次/s的推理请求失败率
    4. 不同编码，码率的图像打包上传
    5. 最大上行带宽，下行带宽验证
    6. rabbitmq在测试（客户）环境吞吐量
    7. 告警接口响应
    8. 10x32x6个分布式推理任务运行稳定性
 """

PLATFORM_VERSION = "v1.0.0"
TEST_TAG = "rc0"


from locust import TaskSet, task, between

class MyUser(TaskSet):
    """ testsuite
    测试接口响应 
    """
    @task
    def my_task(TaskSet):
        """ testcase 
        测试用例
         """
        print("executing my_task")

    wait_time = between(0.5, 10)

