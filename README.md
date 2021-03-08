PerfBoard
============================================================================

Apulis AiOps平台


快速使用
----------------------------------------------------------------------------

* 在本使用locust执行并发测试脚本

```bash
sudo chmod +x init_dev.sh
bash ./init_dev.sh
cd example
locust -f ./example/test_http.py --conf ./example/host.conf
```

* [使用 docker 或 k8s 执行测试](https://docs.locust.io/en/stable/running-locust-docker.html)

使用 pytest 执行测试计划



* [Jmeter常用方法](./docs/jmeter脚本常用配置方法.md)
* [Locust常用方法]()
* [测试套件设计](./docs/测试【表情】套件设计.md)

安装说明
----------------------------------------------------------------------------

|组件         |版本|
|:------------|:------------|
|windows 10   | 1909        |
|Python       |3.8          |
|locust       |1.0.3        |
|JDK          |1.8.0_251    |
|Jmeter       |5.3          |

### 参考文档

有关安装指南、教程和API的更多详细信息，请参阅[Diamod wiki](https://github.com/apulis/Diamond/wiki)


### 发布

* [0.5-gpu-jmeter-perf](https://github.com/apulis/PerfBoard/releases/tag/v0.5)

    版本说明详情请参阅[RELEASE](./RELEASE.md)。

### 贡献


* [编码规范](./docs/编码规范.md)

    欢迎参与贡献。更多详情，请参阅我们的[贡献者Wiki](./CONTRIBUTING.md)。

### 许可证


[Mozilla Public License 2.0](LICENSE)

### 联系我们


[Apulis QA&OPS Team](http://www.apulis.cn/index.php?s=/sys/cate/5.html)
