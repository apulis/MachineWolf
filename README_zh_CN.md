
<p align="center">
<img src="docs/img/perfboard_logo.png" width="250"/>
</p>

-----------

[![Mozilla 2.0 licensed](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![Build Status](https://msrasrg.visualstudio.com/NNIOpenSource/_apis/build/status/full%20test%20-%20linux?branchName=master)](https://msrasrg.visualstudio.com/NNIOpenSource/_build/latest?definitionId=62&branchName=master)
[![Issues](https://img.shields.io/github/issues-raw/Microsoft/nni.svg)](https://github.com/Microsoft/nni/issues?q=is%3Aissue+is%3Aopen)
[![Bugs](https://img.shields.io/github/issues/Microsoft/nni/bug.svg)](https://github.com/Microsoft/nni/issues?q=is%3Aissue+is%3Aopen+label%3Abug)
[![Pull Requests](https://img.shields.io/github/issues-pr-raw/Microsoft/nni.svg)](https://github.com/Microsoft/nni/pulls?q=is%3Apr+is%3Aopen)
[![Version](https://img.shields.io/github/release/Microsoft/nni.svg)](https://github.com/Microsoft/nni/releases) [![Join the chat at https://gitter.im/Microsoft/nni](https://badges.gitter.im/Microsoft/nni.svg)](https://gitter.im/Microsoft/nni?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Documentation Status](https://readthedocs.org/projects/nni/badge/?version=latest)](https://nni.readthedocs.io/en/latest/?badge=latest)

[PerfBoard Doc](README.md) | [简体中文](README_zh_CN.md)

**PerfBoard** is a AiOps Performance Enhancements Suite .


### Quick Start


* Execute locust scripts at local station

```bash
sudo chmod +x init_dev.sh
bash ./init_dev.sh
cd example
locust -f ./example/test_http.py --conf ./example/host.conf
```

* Within dockers container run testsuites

[使用 docker 或 k8s 执行测试](https://docs.locust.io/en/stable/running-locust-docker.html)

* Execute locust testsuite by taurus

* Execute Jmeter scripts by taurus

* Execute pure yaml scenarios by taurus

* Execute Non-Http test by pytest



### How to use branch


| Branch name |info|
| ----------- | -------------------------------------------------------------------- |
| Master      | 主分支，维护发布产品的最新发布代码，从Release 或 Feature 合并为正式发布的历史|
| Feature     | 开自Master分支，主要用于开发新功能和专项测试集，根据负责模块自行维护；命名规范为：feature/#...，每一个功能都应对应一个issue，...即为issue号. |
| Hotfix      |	开自Master分支，主要用于修复当前已发布版本的已知bug；解决bug时注意事项参考Bugfix。命名规范为：hotfix/#... |
| Release	  | 开自Master分支，主要用于发布版本，一旦develop分支上有了做一次发布（或者说快到了既定的发布日）的足够功能，就从develop分支上fork一个发布分支。新建的分支用于开始发布循环，这个分支只应该做Bug修复、文档生成和其它面向发布任务。一旦对外发布的工作都完成了，执行以下三个操作：合并Release分支到Master； 给Master打上对应版本的标签tag； Release回归，这些从新建发布分支以来的做的修改要合并回Master分支。 命名规范为：release/...，...为版本号|
| ngihtly     |

> [!IMPORTANT]
> Master tag 为测试代码库自身的版本号
> Releas tag 同步与待测试产品的release/-x-tag;如被测产品为2.0.0-rc1，则可以拉取出来一个release/2.0.0-rc1
> Hotfix tag 也同被测产品的hostfix一样，测试时可以拉取出来一个hotfix/#窗口卡顿
> Feature tag 独立开发、调研的feature原型验证可以拉取一个如feature/#需求或bug

* 系统测试、迭代测试可直接拉取Master分支最新代码（tag）
* 所有经过调试，完成验证的 Feature、Hotfix、Release 都要合并到 Master


### Testsuites design

* [测试套件设计](./docs/测试【表情】套件设计.md)

### Documents and Refer 

有关安装指南、教程和API的更多详细信息，请参阅[Diamod wiki](https://github.com/apulis/Diamond/wiki)

### Release version

* Latest

1. 完整的套件架构
2. 安装和环境准备
3. 执行示例
4. 基础测试用例集

**版本说明详情请参阅[RELEASE](./RELEASE.md)。**

### License

[Mozilla Public License 2.0](LICENSE)

### Communit

[Apulis Aiops Team](http://www.apulis.cn/index.php?s=/sys/cate/5.html)
