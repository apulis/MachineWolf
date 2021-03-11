数据标注（CVAT）并发压力测试方案
--------------------------------------------------------------------

* 文档说明

|属性  |信息  |
|---------|---------|
|产品版本  |Apulis Platform v1.6.0-rcx|
|更新时间  |2021-03-10         |
|创建者    | thomas        |

---

## 测试需求

客户现场可能至少有20人的并行/发标注数据集的压力场景；综合考虑对影响到平台响应的接口做100人的并发压力测试。如果标注员是通过Internet访问平台，则还需对经客户环境Internet请求的时延、吞吐量进行验证。

数据（图片）标注，标注操作主要在用户本地完成，对平台的影响在于客户端向平台请求，主要有跳转cvat,创建任务，拉取数据集(图片),上传手工/半自动标注数据集，自动标注数据集，推送到AI平台等接口请求。


* 数据标注的业务流

    *其中橙色节点都有向平台、DB、存储的请求；操作频繁但数据块小的是手工或半自动预览图片；不太频繁但数据比较大的是上传数据集和导出请求。*

    :::image type="content" source="./img/label_images.png" alt-text="流程图":::

## CVAT测试调研

* 主要参考链接
1. [cvat-test](https://github.com/openvinotoolkit/cvat/tree/develop/tests)
2. [cvat-action-nightly](https://github.com/openvinotoolkit/cvat/runs/2081412856?check_suite_focus=true)
3. [cvat-gitter](https://gitter.im/opencv-cvat/public?at=5c85a33f1c597e5db6b80a86)
4. [cvat-issues]()


* Annotations Format Supported



Annotation format	Import	Export
CVAT for images	X	X
CVAT for a video	X	X
Datumaro	 	X
PASCAL VOC	X	X
Segmentation masks from PASCAL VOC	X	X
YOLO	X	X
MS COCO Object Detection	X	X
TFrecord	X	X
MOT	X	X
LabelMe 3.0	X	X

* Github CI testsuites

* Open issues

* Thirdpart conminute instance performance


> [!IMPORTANT]
> * 5G+AI 工业视觉应用 SLA 
>检测准确度仍然以 99.99% 为目标，99.99% 是指 10000 次图像视觉检测中因传输不稳定导致图像异常而出现一次检测异常。
以 500W 工业相机为例，分辨率为 2448x2048，8Bit 位深时，单张原始图像 BMP 格式的文件大小为 5013504Bytes，一个 Byte 表示一个像素点。通过 5G 网络传输时，图像文件按照 MTU 1500Byte 的限制拆分为 3406 个 UDP 数
据包，如果因网络传输不稳定导致在传输过程中丢失一个数据包，则会导致 1472 个像素，丢失的像素数据系统在处理时一般会自动填充黑色数值；当图像因丢包出现黑线条时，会导致误检、漏检，因此，单帧图像丢一个数据包，即认为会导致检测异常；则满足 99.99% 的检测成功率要求 10000 次图像传输出现一次数据包丢失，对传输网络要求的可靠性
为：1-1/(3406*10000)≈ 0.9999999。

> [!TIP]
> 《5G+AI 智能工业视觉解决方案白皮书 V1.0》虽然是华为和百度合作出的，但是从百度《AI助力中国智造白皮书.pdf》来看他只是出了概念设想；实际数据是华为

## 并发压力测试方案

了解到数据（图片）标注，标注操作主要在用户本地完成，对平台的影响在于客户端向平台请求，主要有跳转cvat,创建任务，拉取数据集(图片),上传手工/半自动标注数据集，自动标注数据集，推送到AI平台的接口请求。

* 测试场景或用例

    1. 由平台跳转cvat
    2. 在cvat创建任务
    3. 批量数据标注测试
    4. 数据集、模型的增（创建）删改查
    5. 模型转换测试
    6. 数据集转换测试
    7. 10x32x6个分布式推理任务调度和运行稳定性
    8. 推送64mpbs，128Mbps图片流量到推理服务的负载测试
    9. rabbitmq在测试（客户）环境吞吐量
    10. 1000次/s的HTTP推理请求失败率
    11. 1000次/s的HTTP推理结果请求失败率（上传到平台数据库）
    12. 10/10000的告警请求响应测试
    13. master节点在模型转换、数据集转换时CPU,MEM的使用率
    14. master节点在A3010满载推理业务时的网络负载，IO,CPU,MEM占用率

* 测试环境

    + 办公室 1*x86Master + 2*x86-GPU 测试环境(192.168.1.18:admin/Cbmt9Y)
    + 松山湖环境

    1. 1x86 Master + 1xStorage

    * Master

    |资源  |规格  |
    |---------|---------|
    |CPU     |  64核       |
    |内存     |  128GB       |
    |系统盘     |   1TB SSDB      |
    |存储盘     |   10T HDD      |

    * Storage

    |资源  |规格  |
    |---------|---------|
    |CPU     |  128核       |
    |内存     |  128GB       |
    |系统盘     |   1TB SSDB      |
    |存储盘     |   500T HDD      |

* 测试数据

    + 数据集：为标注的图片数据集
    + 模型：待定
    + 数据标注格式：
        - 文本检测: ICDAR2013，样例见附件
        - 文字识别: mjsynth，样例见附件
        - 图像分类: imagenet
        - 目标检测: coco
        - 语义分割: ISBI格式：即xx_image.png, xx_mask.png，image为原图，mask为像素级标注图片，mask矩阵大小与image一致。


* 测试流或计划

    |任务         |预估时间       |备注     |
    |-------------|--------------|---------|
    |原型测试      | 2人/天       |调试脚本和定位适配问题 |
    |迭代测试      | 0.5人/天       |例行测试  |
    |发布验收测试  | 0.5人/天       |问题回归  |


* 风险预估和待定事项

    + 平台遗留上传数据和下载数据的问题，只能采用SCP上传到存储目录，但HTTP方式下载5G以上文件任存在中断风险
    + 中心推理没有实现过分布式pod，可能不支持多流水线，多终端的场景
    + 办公室测试环境与客户环境差异较大，需要协调客户环境验证
    + 客户环境是5G 

## 测试用例和脚本（待完善）

   `perfboard/testhub/testsuites/label_images/`

## 理论性能指标分析

1. 检测准确度达到 99.99% =》推理请求的成功率要达到 99.99%
2. 图片上传包的成功率要达到 99.99999%

*以 500W 工业相机为例，分辨率为 2448x2048，8Bit 位深时，单张原始图像 BMP 格式的文件大小为 5013504Bytes，一个 Byte 表示一个像素点。通过 5G 网络传输时，图像文件按照 MTU 1500Byte 的限制拆分为 3406 个 UDP 数据包，如果因网络传输不稳定导致在传输过程中丢失一个数据包，则会导致 1472 个像素，丢失的像素数据系统在处理时一般会自动填充黑色数值；当图像因丢包出现黑线条时，会导致误检、漏检，因此，单帧图像丢一个数据包，即认为会导致检测异常；则满足 99.99% 的检测成功率要求 10000 次图像传输出现一次数据包丢失，对传输网络要求的可靠性为：1-1/(3406*10000)≈ 0.9999999。*

3. 单个PCB检测流水线上，检测图像数据实时传输的上行速率>40Mbps，低时延(uRLLC)10ms 网络可靠性99.9999 或丢包率 0.00001%；检测结果实时反馈下行速率>2Mbps 低时延(uRLLC)10ms 网络可靠性99.9999 或丢包率 0.00001%
4. 由上，RabbitMQ 吞吐量在38MB/s,且99%的延时在1ms内，但超过40MB/s时，延时超过1s
5. 目前由10个流水线，每条流水线上有6个检测点（摄像头）；拍摄照片是2k为主, 2~3M,平均1M,最大10M
6. 类似PCB流水线的质检合格率（率），单个流水线上的生产率（单位时间内能生产多少产品）；合格率多少？ =》影响到告警的频次
7. 任务分布：流水线串行多步操作，10个流水线并行，每个流水线一个推理终端
8. 主机资源和磁盘IO： we went with the i3en.2xlarge (with 8 vCores, 64 GB RAM, 2 x 2,500 GB NVMe SSDs) for its high 25 Gbps network transfer limit that ensures that the test setup is not network bound. This means that the tests measure the respective maximum server performance measures, not simply how fast the network is. i3en.2xlarge instances support up to ~655 MB/s of write throughput across two disks, which is plenty to stress the servers. See the full instance type definition for details. Per the general recommendation and also per the original OMB setup, Pulsar uses one of the disks for journaling and one for ledger storage. No changes were made to the disk setups of Kafka and RabbitMQ.

## 附录（参考）

*相关参考：*
1. [AI助力中国智造白皮书.pdf](./refer/AI助力中国智造白皮书.pdf)
2. [5G边缘计算安全白皮书.pdf](./refer/5G边缘计算安全白皮书.pdf)
3. [RabbitMQ Best Practice for High Performance (High Throughput)](https://www.cloudamqp.com/blog/2018-01-08-part2-rabbitmq-best-practice-for-high-performance.html)
