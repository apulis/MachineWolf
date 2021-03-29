# Locust压力测试方法

* 通过docker执行locust

    `docker run -p 8089:8089 -v $PWD:/mnt/locust locustio/locust -f /mnt/locust/locustfile.py`

    + `/mnt/locust` 本地locust脚本目录
    + `/mnt/locust/locustfile.py` 即将执行的脚本

* Use docker image as a base image

    ```dockerfile
    FROM locustio/locust
    RUN pip3 install some-python-package
    ```

* CI执行locust，不启用WEBUI的执行方式

    `locust -f locust_files/my_locust_file.py --headless -u 1000 -r 100  --run-time 1h30m  --stop-timeout 99`
    + `--headless` without the web UI
    + `-u` 并发用户数
    + `-r` 每秒发出100用户
    + `--run-time` 脚本执行时间，到时间会立刻结束
    + `--stop-timeout` 脚本执行停止的时间

* 分布式执行locust
    + 参考：https://docs.locust.io/en/stable/running-locust-distributed.html#running-locust-distributed

    ```
    locust -f my_locustfile.py --worker --master-host=192.168.0.14 --master-port=5557
    locust -f locust_files/my_locust_file.py --headless -u 1000 -r 100  --run-time 1h30m  --stop-timeout 99 --expect-workers X
    ```

* 监听locust执行,设置执行进程返回的状态码

    ```python
    import logging
    from locust import events

    @events.quitting.add_listener
    def _(environment, **kw):
        if environment.stats.total.fail_ratio > 0.01:
            logging.error("Test failed due to failure ratio > 1%")
            environment.process_exit_code = 1
        elif environment.stats.total.avg_response_time > 200:
            logging.error("Test failed due to average response time ratio > 200 ms")
            environment.process_exit_code = 1
        elif environment.stats.total.get_response_time_percentile(0.95) > 800:
            logging.error("Test failed due to 95th percentile response time > 800 ms")
            environment.process_exit_code = 1
        else:
            environment.process_exit_code = 0

    ```

* 使用配置文件

    `locust -f example.py --config ./locust.conf`

* [Response Methods – Python requests](https://www.geeksforgeeks.org/response-methods-python-requests/)
